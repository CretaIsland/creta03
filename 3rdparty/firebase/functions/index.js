const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const admin = require("firebase-admin");
const { getFirestore, Timestamp, FieldValue } = require('firebase-admin/firestore');

admin.initializeApp();
const database = admin.database();

exports.deltaChanged = functions.database.ref('/hycop_delta/{id}/delta')
    .onWrite((change, context) => {
        var old_delta = change.before.val();
        var new_delta = change.after.val();
        var mid = context.params.id;
        database.ref('/creta_log/text').set('skpark changed =' + mid);
        functions.logger.log('skpark changed =' + mid);
        return null;
});

exports.removeDelta_schedule = functions.pubsub.schedule('every 24 hours').onRun((context) => {
    return _removeDelta();
});

exports.removeDelta = functions.https.onCall((data) => {
    return _removeDelta();
});

function _removeDelta()
{
    let now = new Date();
    //now = now - 60000;
    now.setDate(now.getMinutes() - 2);
    //now.setDate(now.getDate() - 1);
    //let yesterday = now.toISOString().replace(/T/, ' ').replace(/\..+/, '.000Z');
    let oneMinuteAgo = now.toISOString().replace(/T/, ' ').replace(/\..+/, '.000Z');
    var counter = 0;
    return database.ref('/hycop_delta').orderByChild('updateTime').endBefore(oneMinuteAgo).once('value').then((snapshot) => {
        snapshot.forEach((childSnapshot) => {
            const childKey = childSnapshot.key;
            const childData = childSnapshot.val();
            counter++;  

            var key = '/hycop_delta/' + childKey +'/';
            functions.logger.log('skpark start remove =' + key);
            database.ref(key).remove((error) => {
                if(error) {
                    functions.logger.log('skpark removed =' + key + ' failed : ' + error);
                } else {
                    functions.logger.log('skpark removed =' + key + ' succeed');
                }
            });  
        });
        functions.logger.log('skpark listed(' + oneMinuteAgo + ') = ' + counter);
        return '{result: removeDelta_called(' + counter + ' deleted)';
    });
    
}

exports.cleanBin_schedule = functions.pubsub.schedule('every 24 hours').onRun((context) => {
    _cleanBin('creta_book');
    return _cleanBin('creta_page');
});

exports.cleanBin_req = functions.https.onRequest(async (req, res) => {
    var retval = _cleanBin(req.query.id);
    res.json({result: `${req.query.id} ${retval}`});
 }); 
 

exports.cleanBin = functions.https.onCall((data) => {
    return _cleanBin(data);
});

async function  _cleanBin(collectionId) {
    functions.logger.info('skpark _deleteRecycleBin invoked');
    // let now = new Date();
    // now.setDate(now.getDate() - 3);
    // let yesterday = now.toISOString().replace(/T/, ' ').replace(/\..+/, '.000Z');

    const db = getFirestore();
    const querySnapshot = await db.collection(collectionId).where('isRemoved' , '=', true).get();
    var retval = '';
    var counter = 0;
    querySnapshot.forEach((doc) => {
        functions.logger.info(doc.id, ' => ', doc.data());
        doc.ref.delete();
        counter++;
    });
    return '{result: deleteRecycleBin(' + counter + ' deleted)';
}