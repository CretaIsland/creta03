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

exports.removeDelta_schedule = functions.pubsub.schedule('* * * * *').onRun((context) => {
    return _removeDelta();
});

exports.removeDelta = functions.https.onCall((data) => {
    return _removeDelta();
});

function _removeDelta()
{
    //let now = new Date();
    //now.setDate(now.getDate() - 1);
    //let yesterday = now.toISOString().replace(/T/, ' ').replace(/\..+/, '.000Z');
    let oneMinuteAgoStr = _formatDate();
    var counter = 0;
    return database.ref('/hycop_delta').orderByChild('updateTime').endBefore(oneMinuteAgoStr).once('value').then((snapshot) => {
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
        functions.logger.log('skpark listed(' + oneMinuteAgoStr + ') = ' + counter);
        return '{result: removeDelta_called(' + counter + ' deleted)';
    });
    
}

function _formatDate() {
    let now = new Date();
    const ago = new Date(now.getTime() + (60000 * 60 * 9) - 60000);   // local time 으로 맞춰주기 위해. localTime 함수가 안먹는다. 이방법 뿐이다.
    const year = ago.getFullYear();
    const month = String(ago.getMonth() + 1).padStart(2, '0');
    const day = String(ago.getDate()).padStart(2, '0');
    const hours = String(ago.getHours()).padStart(2, '0');
    const minutes = String(ago.getMinutes()).padStart(2, '0');
    const seconds = String(ago.getSeconds()).padStart(2, '0');
    const milliseconds = String(ago.getMilliseconds()).padStart(3, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}.${milliseconds}`; 
    
    // const dateOptions = { year: 'numeric', month: '2-digit', day: '2-digit' };
    // const timeOptions = { hour: '2-digit', minute: '2-digit', second: '2-digit', fractionalSecondDigits: 3, hour12: false};
    
    // const formattedDate = currentDateTime.toLocaleDateString('ko-KR', dateOptions).replace('.', '-').replace(' ', '').replace('.', '-').replace(' ', '').replace(/.$/, '');  //제일끝에 한글자 제거
    // const formattedTime = currentDateTime.toLocaleTimeString('ko-KR', timeOptions);
    
    // //console.log(formattedCurrentDateTime); // 예: "2023-07-09 14:30:45.123"
    // return `${formattedDate} ${formattedTime}`;
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