from flask import Flask, render_template, url_for, request

app=Flask(__name__)

db={'Anurag':"anu256",'Priyanshu':"lpj123"}

@app.route("/")

def home():
    return render_template("login.html")

@app.route("/login",methods=['POST','GET'])
def login():
    user=request.args['username']
    pw=request.args['pass']

    if user not in db:
        info="Invalid User"
        return render_template("home.html",info=info)
    elif db[user]!=pw:
        info="Wrong Password"
        return render_template("home.html",info=info)
    else:
        info="Welcome "+user
        return render_template("home.html",info=info)

app.run(debug=True)