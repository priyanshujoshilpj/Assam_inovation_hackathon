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

bfh=(db.child('Inventory').child('Admin').child('Bullet-Proof Helmets').get()).val()
bfj=(db.child('Inventory').child('Admin').child('Bullet-Proof Jackets').get()).val()
d=(db.child('Inventory').child('Admin').child('Doctors').get()).val()
lj=(db.child('Inventory').child('Admin').child('Life Jackets').get()).val()

print(str(bfh))
print(str(bfj))
print(str(d))
print(str(lj))




