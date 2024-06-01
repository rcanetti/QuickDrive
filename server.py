import json
import os
import shutil
import socket
import sqlite3
import threading
import secrets
import string
from hashlib import md5

from fastapi import FastAPI, Query, File, UploadFile, Form
from fastapi.responses import FileResponse
from pydantic import BaseModel
from uvicorn import Config, Server as serv

import admin_socket

connected_names = {}


def generate_random_code(length=8):
    """Generate a secret random code."""
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for _ in range(length))


class PostMsg(BaseModel):
    data: str
    len: str
    key: str


class SocketServer:
    """
        A class to handle a socket server for client registration and login.

        Attributes:
            ip (str): The IP address of the server.
            server_socket (socket.socket): The main server socket for accepting connections.

        Methods: connect_client_register(): Continuously listens for incoming client connections and spawns a new
        thread to handle each. get_registration_msg(client_socket: socket) -> Tuple[str, str]: Receives and processes
        a registration message from a client. handle_registration(client_socket: socket, client_address: str):
        Handles the registration and login process for connected clients.
    """

    def __init__(self, ip: str, register_port: int):
        """
        Initializes the SocketServer with the given IP address and port for registration.

        Args:
            ip (str): The IP address of the server.
            register_port (int): The port on which the server listens for registration connections.
        """
        self.ip = ip

        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind((ip, register_port))

        self.server_socket.listen()
        print("servers up")

        threading.Thread(target=self.connect_client_register).start()

    def connect_client_register(self):
        """
        Listens for incoming client connections and spawns a new thread for each connection to handle registration.
        """
        while True:
            (client_socket, client_address) = self.server_socket.accept()

            threading.Thread(target=self.handle_registration, args=[client_socket, client_address]).start()

    def get_registration_msg(self, client_socket: socket) -> tuple[str, str]:
        """
        Receives a registration message from a client socket and processes it.

        Args:
            client_socket (socket): The client socket from which to receive the message.

        Returns:
            Tuple[str, str]: A tuple containing the request type and the payload.
        """
        data = client_socket.recv(1024).decode()
        if data == 'start admin chat':
            admin_socket.AdminSocket(client_socket)
            return "admin", "admin"

        else:
            data = json.loads(data)
            request_type = data.get('type')
            payload = data.get('payload')

            return request_type, payload

    def handle_registration(self, client_socket: socket, client_address: str):
        """
        Handles the registration or login process for a connected client.

        Args:
            client_socket (socket): The client socket for communication.
            client_address (str): The address of the connected client.
        """
        global connected_names
        print("connection established")

        request, data = self.get_registration_msg(client_socket)
        print(f"regular socket msg: {request} ,{data}")

        if type(data) is not str:
            pass

        elif request == 'signup':
            data = str(data)
            list_data = data.split('|')[1:]
            conn = sqlite3.connect('database.db')
            c = conn.cursor()
            # Execute a SELECT query to check if the username exists in the database
            c.execute("SELECT COUNT(*) FROM users WHERE username=?", (data[0],))
            count = c.fetchone()[0]  # Get the count of rows returned
            conn.close()

            if count == 0:
                connected_names[list_data[0]] = generate_random_code()
                print(list_data)
                client_socket.send(connected_names[list_data[0]].encode())
                insert_to_database(list_data[0], list_data[1], list_data[2], list_data[3])

                # Get the directory of the current script
                current_directory = os.path.dirname(os.path.abspath('__file__')) + "//user_files"

                # Combine the current directory with the folder name
                folder_path = os.path.join(current_directory, f"{list_data[0]}")
                os.makedirs(folder_path)
                print("made directory in:" + folder_path)

                client_socket.close()

            else:
                client_socket.send("false".encode())

                client_socket.close()

        elif request == 'login':
            data = str(data)
            list_data = data.split('|')[1:]
            conn = sqlite3.connect('database.db')
            c = conn.cursor()
            # Execute a SELECT query to check if the username exists in the database
            c.execute("SELECT * FROM users WHERE username=?", (list_data[0],))
            row = c.fetchone()  # Get the count of rows returned
            conn.close()

            if (row is not None) and row[3] == md5(list_data[1].encode()).hexdigest():
                connected_names[list_data[0]] = generate_random_code()
                client_socket.send(connected_names[list_data[0]].encode())

                client_socket.close()
            else:
                client_socket.send("false".encode())

                client_socket.close()


def insert_to_database(username, email, phone, password):
    password = md5(password.encode()).hexdigest()
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('INSERT INTO users VALUES (?, ?, ?, ?)',
              (username, email, phone, password))
    conn.commit()
    conn.close()


def create_database():
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS users (
                    username TEXT PRIMARY KEY,
                    email TEXT,
                    phone_number TEXT,
                    password TEXT
                )''')
    conn.commit()
    conn.close()


class FastAPIServer:
    """
    A class to handle a FastAPI server for file management operations including uploading,
    downloading, renaming, and removing files for authenticated users.

    Attributes:
        app (FastAPI): The FastAPI application instance.
        ip (str): The IP address of the server.
        port (int): The port on which the server listens for connections.

    Methods:
        handle_get_files(username: str, key: str): Handles the retrieval of file lists for a user.
        handle_get_download(username: str, key: str, data: str): Handles file download requests for a user.
        handle_upload(username: str, file: UploadFile, key: str): Handles file upload requests for a user.
        handle_remove(username: str, payload: PostMsg): Handles file removal requests for a user.
        handle_rename(username: str, payload: PostMsg): Handles file rename requests for a user.
    """
    app = FastAPI()

    def __init__(self, ip: str, port: int):
        """
        Initializes the FastAPIServer with the given IP address and port.

        Args:
            ip (str): The IP address of the server.
            port (int): The port on which the server listens for connections.
        """
        self.ip = ip
        self.port = port

        config = Config(app=self.app, port=port, log_level="info", host=ip)  # change log_level to info for debug
        server = serv(config)
        server.run()

    @app.get("/getFiles/{username}")
    def handle_get_files(username: str, key: str = Query(...)):
        """
        Handles the retrieval of file lists for a user.

        Args:
            username (str): The username of the client.
            key (str): The session key for authentication.

        Returns:
            str: A JSON response with the list of files or a message indicating no files.
        """
        print(connected_names)
        if connected_names[username] == key:
            directory_path = os.path.abspath(
                f"user_files\\{username}")
            # Initialize an empty list to store file names
            file_names = []
            count = 0

            # Iterate over all files in the directory
            for filename in os.listdir(directory_path):
                # Check if the entry is a file
                file_names.append(filename)
                count += 1
            print(file_names)
            if count > 0:
                print("sending response get")
                return json.dumps({"data": {"type": "getFiles", "payload": "|".join(file_names)}})
            else:
                return json.dumps({"data": {"type": "getFiles", "payload": "no files"}})

    @app.get("/getDownload/{username}")
    def handle_get_download(username: str, key: str = Query(...), data: str = Query(...)):
        """
        Handles file download requests for a user.

        Args:
            username (str): The username of the client.
            key (str): The session key for authentication.
            data (str): The name of the file to download.

        Returns:
            FileResponse: The file to be downloaded or an error message if the file is not found.
        """
        if connected_names[username] == key:
            file_path = os.path.join(f"user_files//{username}", data)

            # Check if the file exists
            if not os.path.exists(file_path):
                return {"error": f"File {data} not found"}

            # Return the file to the client
            return FileResponse(file_path, filename=data)

    @app.post("/Upload/{username}")
    def handle_upload(username: str, file: UploadFile = File(...), key: str = Form(...)):
        """
        Handles file upload requests for a user.

        Args:
            username (str): The username of the client.
            file (UploadFile): The file to be uploaded.
            key (str): The session key for authentication.
        """
        if connected_names[username] == key:
            directory_path = os.path.abspath(
                f"user_files\\{username}")
            file_path = os.path.join(directory_path, file.filename)

            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(file.file, buffer)

    @app.post("/Remove/{username}")
    def handle_rename(username: str, payload: PostMsg):
        """
        Handles file removal requests for a user.

        Args:
            username (str): The username of the client.
            payload (PostMsg): The payload containing the session key and the file name to remove.
        """
        if connected_names[username] == payload.key:
            file_name = payload.data
            os.remove(f'user_files//{username}//{file_name}')

    @app.post("/Rename/{username}")
    def handle_rename(username: str, payload: PostMsg):
        """
        Handles file rename requests for a user.

        Args:
            username (str): The username of the client.
            payload (PostMsg): The payload containing the session key and the old and new file names.
        """
        if connected_names[username] == payload.key:
            old_name, new_name = payload.data.split('|')
            os.rename(f'user_files//{username}//{old_name}', f'user_files//{username}//{new_name}')


def main():
    create_database()
    my_registration_server = SocketServer("0.0.0.0", 8800)
    my_fastAPI_server = FastAPIServer("0.0.0.0", 8900)


if __name__ == '__main__':
    main()
