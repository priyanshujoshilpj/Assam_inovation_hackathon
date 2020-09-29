from flask import Flask, redirect, render_template, g, request,session,url_for
import pyrebase
import os
import yagmail

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
app.secret_key=os.urandom(25)

@app.route("/")
def home():
    return render_template("login.html")

@app.route("/login", methods=["POST","GET"])
def login():
    user=request.args['username']
    pw=request.args['pass']
    session["user"]=user
    session["password"]=pw
    return redirect(url_for("inventory"))


@app.route("/inventory")
def inventory():
    if ("user" and "password") in session:
        user=session["user"]
        pw=session["password"]
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
                    info=user
                    return render_template("home.html",info=info,t1=t1,t2=t2,t3=t3,t4=t4,t5=t5,t6=t6,t7=t7,t8=t8)
        except:
            info="Invalid User"
            return render_template("home.html",info=info)
    return render_template("login.html")
@app.route("/signup")
def signup():
    username=request.args['User']
    email=request.args['email']
    password=request.args['pw']
    users=db.child('User').shallow().get()
    try:
        if username not in users.val():
            data={"Username":username,"Email":email,"Password":password}
            db.child("User").child(str(username)).set(data)
            return render_template("login.html",info="Successfully Signed Up! Try Login!")
        else:
            return render_template("login.html",info="Already have an account! Try Login!")
    except:
        data={"Username":username,"Email":email,"Password":password}
        db.child("User").child(str(username)).set(data)
        return render_template("login.html",info="Successfully Signed Up! Try Login!")

@app.route("/logout")
def logout():
    session.pop("user",None)
    session.pop("password",None)
    return render_template("login.html")
@app.route('/orders')
def orders():
    if ("user" and "password") in session:
        t1='Blankets'
        t2='Canned_Food'
        t3='Drinking_Water'
        t4='Emergency_Flashlight'
        t5='First_Aid_Kit'
        t6='Shelter_Available'
        t7='Food_for_Infants_and_the_Elderly'
        t8='Clothes'
        return render_template('request.html',info=session['user'],t1=t1,t2=t2,t3=t3,t4=t4,t5=t5,t6=t6,t7=t7,t8=t8)
    else:
        return redirect(url_for('logout'))
    

@app.route('/contact')
def contact():
    if ("user" and "password") in session:
        return render_template('contact.html',info=session['user'])
    else:
        return redirect(url_for('logout'))

@app.route('/add')
def add():
    if ("user" and "password") in session and (session["user"]=="Anurag Porel" and session["password"]=="bug@123"):
        return render_template('edit_inv.html')
    elif ("user" and "password") in session and (session["user"]!="Anurag Porel" or session["password"]!="bug@123"):
        return render_template("404.html")
    else:
        return redirect(url_for('logout'))
    

@app.route('/pending')
def pending():
    if ("user" and "password") in session and (session["user"]=="Anurag Porel" and session["password"]=="bug@123"):
        r1=dict((db.child('Requests').child('G Shalom Shreyan').child('Request 1').get()).val())
        r2=dict((db.child('Requests').child('G Shalom Shreyan').child('Request 2').get()).val())
        r3=dict((db.child('Requests').child('Passionate Bong').child('Request 1').get()).val())
        
        
        t1=('Request 1: '+'Item: '+str(r1['Item'])+', Quantity: '+str(r1['Quantity'])+', Status: '+str(r1['Status'])+', Destination: '+str(r1['Address'])+' , User: G Shalom Shreyan')
        t2=('Request 2: '+'Item: '+str(r2['Item'])+', Quantity: '+str(r2['Quantity'])+', Status: '+str(r2['Status'])+', Destination: '+str(r2['Address'])+' , User: G Shalom Shreyan')
        t3=('Request 2: '+'Item: '+str(r3['Item'])+', Quantity: '+str(r3['Quantity'])+', Status: '+str(r3['Status'])+', Destination: '+str(r3['Address'])+' , User: Passionate Bong')
        
        return render_template('request_action.html',t1=t1,t2=t2,t3=t3)
    elif ("user" and "password") in session and (session["user"]!="Anurag Porel" or session["password"]!="bug@123"):
        return render_template("404.html")
    else:
        return redirect(url_for('logout'))

@app.route('/track')
def track():
    if ("user" and "password") in session and (session["user"]=="Anurag Porel" and session["password"]=="bug@123"):
        r1=dict((db.child('Tracking').child('Order 1').get()).val())
        
        
        t1=('Order 1: '+'Item: '+ str(r1['Item'])+', Origin: '+str(r1['Origin']))
        return render_template('track.html',t1=t1)
    elif ("user" and "password") in session and (session["user"]!="Anurag Porel" or session["password"]!="bug@123"):
        return render_template("404.html") 
    else:
        return redirect(url_for('logout'))

@app.route("/support", methods=["POST","GET"])
def support():
    if ("user" and "password") in session:
        name=request.form['name']
        mail=request.form['email']
        ph=request.form['ph']
        msg=request.form['msg']

        content="We have received your query. Will get back to you soon. Do not reply!"
        fm="Message: "+str(msg)+" , Name: "+str(name)+" , Ph: "+str(ph)+" , Email: "+str(mail)

        with yagmail.SMTP('thebugslayers007@gmail.com','thebugslayers') as yag:
            yag.send('thebugslayers007@gmail.com','Query',fm)
            yag.send(str(mail),'Query',content)
        return redirect(url_for('contact'))
    else:
        return redirect(url_for('logout'))

@app.route("/book",methods=["POST","GET"])
def book():
    if ("user" and "password") in session:
        item=request.args['types']
        quantity=request.args['tentacles']
        destiny=request.args['fname']
        u=(session['user'])

        data={"Address":destiny,"Item":item, "Quantity":quantity, "Status":"Pending"}
        temp=db.child("Requests").shallow().get()
        if u in temp.val():
            re=db.child("Requests").child(session['user']).shallow().get()
            for i in range(1,1000):
                brh="Request "+str(i)
                if brh not in re.val():
                    db.child("Requests").child(session['user']).child(brh).set(data)
                    break
                else:
                    continue
        else:
            db.child("Requests").child(session['user']).child('Request 1').set(data)
        return redirect(url_for("orders"))
    else:
        return redirect(url_for('logout'))

@app.route("/details",methods=["POST","GET"])
def details():
    if ("user" and "password") in session and (session["user"]=="Anurag Porel" and session["password"]=="bug@123"):
        inv_type=request.args['types']
        item=request.args['fname1']
        quantity=request.args['tentacles']
        item_user=db.child('Inventory').child('User').shallow().get()
        item_admin=db.child('Inventory').child('Admin').shallow().get()
        if inv_type=='Admin':
            origin=request.args['fname3']
            data1={"Item":item,"Origin":origin}
            re=db.child("Tracking").shallow().get()
            for i in range(1,1000):
                brh="Order "+str(i)
                if brh not in re.val():
                    db.child('Tracking').child(brh).set(data1)
                    break
                else:
                    continue
            if item in item_admin.val():
                temp=(db.child('Inventory').child('Admin').child(item).get()).val()
                old=int(temp)
                new=(old+int(quantity))
                db.child('Inventory').child('Admin').child(item).set(new)
            else:
                db.child('Inventory').child('Admin').child(item).set(quantity)
        elif inv_type=='User':
            if item in item_user.val():
                temp=(db.child('Inventory').child('User').child(item).get()).val()
                old=int(temp)
                new=(old+int(quantity))
                db.child('Inventory').child('User').child(item).set(new)
            else:
                db.child('Inventory').child('User').child(item).set(quantity)
        return redirect(url_for("add"))

    elif ("user" and "password") in session and (session["user"]!="Anurag Porel" or session["password"]!="bug@123"):
        return render_template("404.html")
    else:
        return redirect(url_for('logout'))



app.run(debug=True)

