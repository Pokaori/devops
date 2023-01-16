from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Semonova Polina Devops Project!</p>"


app.run(debug=True, host='0.0.0.0')