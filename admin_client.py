import pygame
import socket
import protocol
from aes_encryption import *
from rsa_encryption import *


class Client:
    """
    A class to handle client-side operations including connecting to the server,
    registering, starting encryption, and managing files.

    Attributes:
        aes_key (str): The AES key for encryption.
        AESC (AESCipher): The AES encryption cipher instance for secure communication.
        admin_socket (socket.socket): The socket for communication with the server.

    Methods:
        register_with_server(code: str): Registers the client with the server using a secret code.
        run(): Starts the encryption process.
        start_encryption(): Sets up encryption with the server.
        get_users(): Retrieves a list of users from the server.
        choose_user(username: str): Sends a request to the server to choose a user.
        delete_file(filename: str): Sends a request to the server to delete a file.
        close(): Closes the connection to the server.
    """
    def __init__(self, ip, port):
        """
        Initializes the Client with the given server IP address and port, and connects to the server.

        Args:
            ip (str): The IP address of the server.
            port (int): The port on which the server is listening for connections.
        """
        self.aes_key = 'roee'
        self.AESC = AESCipher(self.aes_key)
        self.admin_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            self.admin_socket.connect((ip, port))
        except socket.error as e:
            print(f"Connection error: {e}")
            exit()
        self.run()

    def register_with_server(self, code) -> bool:
        """
        Registers the client with the server using a secret code.

        Args:
            code (str): The secret code for registration.

        Returns:
            bool: True if registration is successful, False otherwise.
        """
        try:
            self.admin_socket.send(self.AESC.encrypt(protocol.encode_msg("register", code)).encode())
            request, response = protocol.decode_msg(self.AESC.decrypt(self.admin_socket.recv(1024).decode('utf-8')))
            print(response)
            return response == "accepted"
        except Exception as e:
            print(f"Registration error: {e}")
            return False

    def run(self):
        """
        Starts the encryption process.
        """
        self.start_encryption()

    def start_encryption(self):
        """
        Sets up encryption with the server using RSA and AES encryption.
        """
        try:
            self.admin_socket.send('start admin chat'.encode('utf-8'))
            server_hello = self.admin_socket.recv(1024).decode()
            pubKey = self.admin_socket.recv(1024)
            self.admin_socket.send(encrypt(RSA.import_key(pubKey), self.aes_key))
            self.admin_socket.send(self.AESC.encrypt('Finished').encode('utf-8'))
            server_finished = self.admin_socket.recv(1024).decode('utf-8')
        except Exception as e:
            print(f"Encryption start error: {e}")

    def get_users(self):
        """
        Retrieves a list of users from the server.

        Returns:
            list: A list of usernames received from the server.
        """
        try:
            request, response = protocol.decode_msg(self.AESC.decrypt(self.admin_socket.recv(1024).decode('utf-8')))
            return response
        except Exception as e:
            print(f"Get users error: {e}")
            return []

    def choose_user(self, username):
        """
        Sends a request to the server to choose a user.

        Args:
            username (str): The username to choose.

        Returns:
            str: The server's response.
        """
        try:
            self.admin_socket.send(self.AESC.encrypt(protocol.encode_msg("choose", username)).encode())
            request, response = protocol.decode_msg(self.AESC.decrypt(self.admin_socket.recv(1024).decode('utf-8')))
            return response
        except Exception as e:
            print(f"Choose user error: {e}")
            return []

    def delete_file(self, filename):
        """
        Sends a request to the server to delete a file.

        Args:
            filename (str): The name of the file to delete.

        Returns:
            str: The server's response.
        """
        # try:
        self.admin_socket.send(self.AESC.encrypt(protocol.encode_msg("choose", filename)).encode())
        request, response = protocol.decode_msg(self.AESC.decrypt(self.admin_socket.recv(1024).decode('utf-8')))
        return response
        # except Exception as e:
        #     print(f"Delete file error: {e}")
        #     return []

    def close(self):
        """
        Closes the connection to the server.
        """
        self.admin_socket.close()


class Screen:
    """
    A class to handle the graphical user interface for the admin client.

    Attributes:
        screen (pygame.Surface): The display surface.
        clock (pygame.time.Clock): The game clock for managing frame rate.
        font (pygame.font.Font): The font used for rendering text.
        client (Client): The client instance for communication with the server.
        scroll_y (int): The current vertical scroll offset.

    Methods:
        run_game(): Main loop for running the game.
        show_menu(): Displays the main menu.
        handle_menu_events(): Handles events in the main menu.
        connect_to_server(): Connects to the server and initiates registration.
        register_with_server(): Handles the registration process with the server.
        user_selection_screen(): Displays the user selection screen.
        file_deletion_screen(files): Displays the file deletion screen for a selected user.
        get_user_input(): Captures text input from the user.
        draw_text_fill(text, x, y, size, color, max_chars_per_line): Draws multi-line text on the screen.
        draw_text(text, x, y, size, color): Draws single-line text on the screen.
        handle_scroll_events(): Handles scrolling events.
        cleanup(): Cleans up resources before exiting.
    """
    def __init__(self):
        """
        Initializes the Screen, setting up the display, clock, font, and starting the game loop.
        """
        pygame.init()
        self.screen = pygame.display.set_mode((1024, 768))
        pygame.display.set_caption("Admin Client")
        self.clock = pygame.time.Clock()
        self.font = pygame.font.Font(None, 36)
        self.client = None
        self.scroll_y = 0
        self.run_window()

    def run_window(self):
        """
        Main loop for running the window, updating the display, and handling events.
        """
        while True:
            self.screen.fill((45, 45, 45))
            self.show_menu()
            pygame.display.flip()
            self.clock.tick(60)

    def show_menu(self):
        """
        Displays the main menu with options to connect to the server or quit.
        """
        self.draw_text("Admin Client", 512, 100, size=72, color=(0, 204, 204))
        self.draw_text("1. Connect to Server", 512, 300)
        self.draw_text("2. Quit", 512, 400)
        self.handle_menu_events()

    def handle_menu_events(self):
        """
        Handles user input events in the main menu.
        """
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.cleanup()
                pygame.quit()
                exit()
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_1:
                    self.connect_to_server()
                elif event.key == pygame.K_2:
                    self.cleanup()
                    pygame.quit()
                    exit()

    def connect_to_server(self):
        """
        Connects to the server and initiates the registration process.
        """
        self.screen.fill((45, 45, 45))
        self.draw_text("Connecting to Server...", 512, 300, color=(0, 204, 204))
        pygame.display.flip()
        ip = '127.0.0.1'
        port = 8800
        self.client = Client(ip, port)
        self.register_with_server()

    def register_with_server(self):
        """
        Handles the registration process with the server by capturing a secret code from the user.
        """
        self.screen.fill((45, 45, 45))
        self.draw_text("Enter Secret Code:", 512, 100, color=(0, 204, 204))
        code = self.get_user_input()
        if self.client.register_with_server(code):
            self.user_selection_screen()
        else:
            self.draw_text("Registration Failed", 512, 300, color=(255, 0, 0))
            pygame.display.flip()
            pygame.time.wait(2000)

    def user_selection_screen(self):
        """
        Displays the user selection screen, allowing the admin to choose a user.
        """
        users = self.client.get_users()
        while True:
            self.screen.fill((45, 45, 45))
            self.draw_text("Select a User", 512, 50, color=(0, 204, 204))
            self.handle_scroll_events()
            y_offset = 150 - self.scroll_y
            for user in users:
                self.draw_text(user, 512, y_offset)
                y_offset += 50
            pygame.display.flip()
            username = self.get_user_input()
            if username:
                files = self.client.choose_user(username)
                self.file_deletion_screen(files)

    def file_deletion_screen(self, files):
        """
        Displays the file deletion screen, allowing the admin to delete a selected file for the user.

        Args:
            files (list): The list of files for the selected user.
        """
        while True:
            self.screen.fill((45, 45, 45))
            self.draw_text("Select a File to Delete", 512, 50, color=(0, 204, 204))
            self.handle_scroll_events()
            y_offset = 150 - self.scroll_y
            for file in files:
                self.draw_text(file, 512, y_offset)
                y_offset += 50
            self.draw_text("Enter 'back' to return to user selection", 512, 700, color=(255, 255, 0))
            pygame.display.flip()
            filename = self.get_user_input()
            if filename == "back":
                return
            if filename:
                self.client.delete_file(filename)

    def get_user_input(self):
        """
        Captures text input from the user.

        Returns:
            str: The text input entered by the user.
        """
        input_text = ''
        while True:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    self.cleanup()
                    pygame.quit()
                    exit()
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_RETURN:
                        return input_text
                    elif event.key == pygame.K_BACKSPACE:
                        input_text = input_text[:-1]
                    else:
                        input_text += event.unicode
            self.screen.fill((45, 45, 45), (25, 100, 300, 800))
            self.draw_text_fill(input_text, 50, 140, color=(255, 255, 255))
            pygame.display.flip()

    def draw_text_fill(self, text: str, x: int, y: int, size: int = 36, color: tuple = (255, 255, 255), max_chars_per_line: int = 12):
        """
        Draws multi-line text on the screen.

        Args:
            text (str): The text to be drawn.
            x (int): The x-coordinate for the text position.
            y (int): The y-coordinate for the text position.
            size (int): The font size.
            color (tuple): The color of the text.
            max_chars_per_line (int): Maximum number of characters per line.
        """
        font = pygame.font.Font(pygame.font.match_font('segoeui'), size)
        lines = []
        while len(text) > max_chars_per_line:
            split_index = max_chars_per_line
            while split_index > 0 and text[split_index] != ' ':
                split_index -= 1
            if split_index == 0:
                split_index = max_chars_per_line
            lines.append(text[:split_index])
            text = text[split_index:].strip()
        if text:
            lines.append(text)

        y_offset = 0
        for line in lines:
            text_surface = font.render(line, True, color)
            text_rect = text_surface.get_rect(topleft=(x, y + y_offset))
            self.screen.blit(text_surface, text_rect)
            y_offset += text_rect.height  # Update y_offset for next line

    def draw_text(self, text: str, x: int, y: int, size: int = 36, color: tuple = (255, 255, 255)):
        """
        Draws single-line text on the screen.

        Args:
            text (str): The text to be drawn.
            x (int): The x-coordinate for the text position.
            y (int): The y-coordinate for the text position.
            size (int): The font size.
            color (tuple): The color of the text.
        """
        font = pygame.font.Font(pygame.font.match_font('segoeui'), size)
        text_surface = font.render(text, True, color)
        text_rect = text_surface.get_rect(center=(x, y))
        self.screen.blit(text_surface, text_rect)

    def handle_scroll_events(self):
        """
        Handles scrolling events for navigating through lists.
        """
        for event in pygame.event.get():
            if event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 4:
                    self.scroll_y = max(0, self.scroll_y - 20)
                elif event.button == 5:
                    self.scroll_y += 20

    def cleanup(self):
        """
        Cleans up resources before exiting.
        """
        if self.client:
            self.client.close()


def main():
    Screen()


if __name__ == "__main__":
    main()
