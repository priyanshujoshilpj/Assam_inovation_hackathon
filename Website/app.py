from flask import Flask, render_template, url_for, request

app=Flask(__name__)

@app.route("/")
@app.route("/login")

def home():
    return render_template("login.html")

app.run(debug=True)