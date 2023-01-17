from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return '<h1>My cute project!</h1><img src="https://cataas.com/cat/gif" alt="cat">'


app.run(debug=True, host='0.0.0.0')