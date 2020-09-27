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

blanket=(db.child('Inventory').child('User').child('Blankets').get()).val()
food=(db.child('Inventory').child('User').child('Canned Food').get()).val()
c=(db.child('Inventory').child('User').child('Drinking Water').get()).val()
d=(db.child('Inventory').child('User').child('Blankets').get()).val()

print(str(blanket))
print(str(food))
print(str(c))
print(str(d))




