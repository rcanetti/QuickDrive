import os
import socket
import sqlite3

import protocol
import rsa_encryption
from aes_encryption import *
from rsa_encryption import *


class AdminSocket:
    """
    A class to handle the administrative tasks for a socket connection, including registration,
    encryption setup, and file management for users.

    Attributes:
        AESC (AESCipher): The AES encryption cipher instance for secure communication.
        admin_secret_code (str): The secret code for admin authentication.
        client_socket (socket.socket): The client socket for communication.
        pubKey (RSA.PublicKey): The RSA public key for encryption.
        priKey (RSA.PrivateKey): The RSA private key for decryption.

    Methods:
        handle_admin_encryption(): Sets up encryption with the client.
        handle_admin_registration(): Handles the registration process for the admin client.
        handle_admin(): Handles administrative tasks including file management for users.
        delete_file(directory: str, filename: str): Deletes a specified file from the given directory.
    """

    def __init__(self, client_socket: socket):
        """
        Initializes the AdminSocket with the given client socket and sets up RSA keys.

        Args:
            client_socket (socket.socket): The client socket for communication.
        """
        self.AESC = None
        self.admin_secret_code = 'abcd'

        self.client_socket = client_socket

        # admin client encryption
        self.pubKey, self.priKey = rsa_encryption.get_keys(1024)
        self.handle_admin_registration()

    def handle_admin_encryption(self):
        """
        Sets up encryption with the client using RSA and AES encryption.
        """
        self.client_socket.send('ServerHello'.encode('utf-8'))
        self.client_socket.send(self.pubKey.export_key())

        enc_aes_key = self.client_socket.recv(1024)
        aes_key = decrypt(self.priKey, enc_aes_key).decode('utf-8')
        self.AESC = AESCipher(aes_key)

        client_finished = self.client_socket.recv(1024).decode('utf-8')
        self.client_socket.send(self.AESC.encrypt('Finished').encode('utf-8'))

    def handle_admin_registration(self):
        """
        Handles the registration process for the admin client, authenticating with a secret code.
        """
        self.handle_admin_encryption()
        while True:
            client_info = self.client_socket.recv(1024)
            print(self.AESC.decrypt(client_info.decode('utf-8')))
            request, msg = protocol.decode_msg(self.AESC.decrypt(client_info.decode('utf-8')))
            if msg == self.admin_secret_code:
                self.client_socket.send(self.AESC.encrypt(protocol.encode_msg("register", "accepted")).encode('utf-8'))
                self.handle_admin()
            else:
                self.client_socket.send(self.AESC.encrypt(protocol.encode_msg("register", "denied")).encode('utf-8'))

    def handle_admin(self):
        """
        Handles administrative tasks including managing user files and interacting with the database.
        """
        while True:
            conn = sqlite3.connect('database.db')
            c = conn.cursor()
            c.execute("SELECT username FROM users")

            # Fetch all the usernames
            usernames = c.fetchall()
            usernames = [username[0] for username in usernames]

            # Close the cursor and connection
            c.close()
            conn.close()

            self.client_socket.send(self.AESC.encrypt(protocol.encode_msg("get", usernames)).encode('utf-8'))
            client_info = self.client_socket.recv(1024)
            request, username = protocol.decode_msg(self.AESC.decrypt(client_info.decode('utf-8')))

            if username in usernames:
                while True:
                    directory_path = os.path.abspath(
                        f"user_files\\{username}")
                    # Initialize an empty list to store file names
                    file_names = []

                    # Iterate over all files in the directory
                    for filename in os.listdir(directory_path):
                        # Check if the entry is a file
                        file_names.append(filename)
                    self.client_socket.send(
                        self.AESC.encrypt(protocol.encode_msg("user_files", file_names)).encode('utf-8'))
                    client_info = self.client_socket.recv(1024)
                    request, msg = protocol.decode_msg(self.AESC.decrypt(client_info.decode('utf-8')))
                    print(msg)
                    print(file_names)
                    if msg in file_names:
                        self.delete_file(directory_path, msg)
                    elif msg == 'back':
                        self.client_socket.send(
                            self.AESC.encrypt(protocol.encode_msg("choose", "returning")).encode('utf-8'))
                        break
                    else:
                        print(f"request: {request}, msg: {msg}")

    def delete_file(self, directory, filename):
        """
        Deletes a specified file from the given directory.

        Args:
            directory (str): The directory path where the file is located.
            filename (str): The name of the file to be deleted.
        """
        # Construct the full file path
        file_path = os.path.join(directory, filename)

        # Check if the file exists
        if os.path.exists(file_path):
            # Delete the file
            os.remove(file_path)
            print(f"The file '{filename}' has been deleted successfully.")
        else:
            print(f"The file '{filename}' does not exist.")