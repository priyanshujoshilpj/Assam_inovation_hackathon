from flask import Flask, render_template, url_for, request
import pyrebase

config={
    "apiKey": "AIzaSyANcgKu1GITWijowWXfb_glqrpamVVCT4c",
    "authDomain": "assam-hackathon.firebaseapp.com",
    "databaseURL": "https://assam-hackathon.firebaseio.com",
    "projectId": "assam-hackathon",
    "storageBucket": "assam-hackathon.appspot.com",
    "messagingSenderId": "980155445581",
    "appId": "1:980155445581:web:8cf17a943a9a9f9308c704",
    "measurementId": "G-8JSKR6S171"
}

firebase = pyrebase.initialize_app(config)
db=firebase.database()


app=Flask(__name__)

@app.route("/")

def home():
    return render_template("login.html")

@app.route("/login",methods=['POST','GET'])
def login():
    user=request.args['username']
    pw=request.args['pass']

    try:
        stuser=db.child('User').child(user).child('Password').get()
        headuser=db.child('User').shallow().get()
        if user not in headuser.val():
            info="Invalid User"
            return render_template("home.html",info=info)
        elif (stuser.val())!=pw:
            info="Wrong Password"
            return render_template("home.html",info=info)
        elif stuser.val()==pw:
            info="Welcome "+user
            return render_template("home.html",info=info)
    except:
        info="Invalid User"
        return render_template("home.html",info=info)
    return render_template("login.html")



@app.route("/signup",methods=['POST','GET'])
def signup():
    username=request.args['User']
    email=request.args['email']
    password=request.args['pw']
    users=db.child('User').shallow().get()
    try:
        if username not in users.val():
            data={"Username":username,"Email":email,"Password":password}
            db.child("User").child(str(username)).set(data)
            return render_template("home.html",info="Welcome!")
        else:
            return render_template("login.html")
    except:
        data={"Username":username,"Email":email,"Password":password}
        db.child("User").child(str(username)).set(data)
        return render_template("home.html",info="Welcome!")



app.run(debug=True)