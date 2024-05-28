from flask import Flask, render_template, request
import sqlite3

app = Flask(__name__)


# Function to fetch data from the database
def fetch_data():
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute("SELECT * FROM users")
    data = c.fetchall()
    conn.close()
    return data


@app.route('/')
def index():
    # Fetch data from the database
    data = fetch_data()
    return render_template('index.html', data=data)


@app.route('/refresh', methods=['POST'])
def refresh():
    # Fetch data from the database
    data = fetch_data()
    return render_template('index.html', data=data)


if __name__ == '__main__':
    app.run(debug=True)
