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
    blanket=(db.child('Inventory').child('User').child('Blankets').get()).val()
    food=(db.child('Inventory').child('User').child('Canned Food').get()).val()
    dw=(db.child('Inventory').child('User').child('Drinking Water').get()).val()
    el=(db.child('Inventory').child('User').child('Emergency Flashlight').get()).val()
    fak=(db.child('Inventory').child('User').child('First Aid Kit').get()).val()
    sa=(db.child('Inventory').child('User').child('Shelter Available').get()).val()
    so=(db.child('Inventory').child('User').child('Shelter Occupied').get()).val()
    fie=(db.child('Inventory').child('User').child('Food for Infants and the Elderly').get()).val()

    bfh=(db.child('Inventory').child('Admin').child('Bullet-Proof Helmets').get()).val()
    bfj=(db.child('Inventory').child('Admin').child('Bullet-Proof Jackets').get()).val()
    d=(db.child('Inventory').child('Admin').child('Doctors').get()).val()
    lj=(db.child('Inventory').child('Admin').child('Life Jackets').get()).val()
    n=(db.child('Inventory').child('Admin').child('Nurses').get()).val()
    rb=(db.child('Inventory').child('Admin').child('Rescue Boat').get()).val()
    rc=(db.child('Inventory').child('Admin').child('Rescue Chopper').get()).val()
    rt=(db.child('Inventory').child('Admin').child('Rescue Team').get()).val()

    t1=('Blanket: '+str(blanket))
    t2=('Canned Food: '+str(food))
    t3=('Drinking Water: '+str(dw))
    t4=('Emergency Light: '+str(el))
    t5=('First Aid Kit: '+str(fak))
    t6=('Shelter-Available: '+str(sa))
    t7=('Shelter-Occupied: '+str(so))
    t8=('Food for Infants and the Elderly: '+str(fie))
    t9=('Bullet-Proof Helmets: '+str(bfh))
    t10=('Bullet-Proof Jackets: '+str(bfj))
    t11=('Doctors: '+str(d))
    t12=('Life Jackets: '+str(lj))
    t13=('Nurses: '+str(n))
    t14=('Rescue Boat: '+str(rb))
    t15=('Rescue Chopper: '+str(rc))
    t16=('Rescue Team: '+str(rt))


    try:
        stuser=db.child('User').child(user).child('Password').get()
        headuser=db.child('User').shallow().get()
        if (user=='Anurag Porel' and pw=='bug@123'):
            return render_template("admin.html",t1=t1,t2=t2,t3=t3,t4=t4,t5=t5,t6=t6,t7=t7,t8=t8,t9=t9,t10=t10,t11=t11,t12=t12,t13=t13,t14=t14,t15=t15,t16=t16)
        else:
            if user not in headuser.val():
                info="Invalid User"
                return render_template("login.html",info=info)
            elif (stuser.val())!=pw:
                info="Wrong Password"
                return render_template("login.html",info=info)
            elif stuser.val()==pw:
                info="Welcome "+user+'!'
                return render_template("home.html",info=info,t1=t1,t2=t2,t3=t3,t4=t4,t5=t5,t6=t6,t7=t7,t8=t8)
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


@app.route('/orders')
def orders():
    return render_template('request.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')
    

app.run(debug=True)