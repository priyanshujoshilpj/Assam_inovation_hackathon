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
    blanket=db.child('Inventory-User').child('Blanket').get()
    t1=('Blanket: '+str(blanket.val()))
    cf=db.child('Inventory-User').child('Canned Food').get()
    t2=('Canned Food: '+str(cf.val()))
    dw=db.child('Inventory-User').child('Drinking Water').get()
    t3=('Drinking Water: '+str(dw.val()))
    el=db.child('Inventory-User').child('Emergency Light').get()
    t4=('Emergency Light: '+str(el.val()))
    fak=db.child('Inventory-User').child('First Aid Kit').get()
    t5=('First Aid Kit: '+str(fak.val()))
    pp=db.child('Inventory-User').child('Paper Plates').get()
    t6=('Paper Plates: '+str(pp.val()))
    sa=db.child('Inventory-User').child('Shelter-Available').get()
    t7=('Shelter-Available: '+str(sa.val()))
    so=db.child('Inventory-User').child('Shelter-Occupied').get()
    t8=('Shelter-Occupied: '+str(so.val()))
    fie=db.child('Inventory-User').child('food for infants and the elderly').get()
    t9=('Food for Infants and the Elderly: '+str(fie.val()))

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
            info="Welcome "+user+'!'
            return render_template("home.html",info=info,t1=t1,t2=t2,t3=t3,t4=t4,t5=t5,t6=t6,t7=t7,t8=t8,t9=t9)
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

@app.route('/logout')
def logout():
    return render_template('login.html')





app.run(debug=True)