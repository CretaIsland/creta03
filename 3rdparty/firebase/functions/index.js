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

// exports.deltaChanged = functions.database.ref('/hycop_delta/{id}/delta')
//     .onWrite((change, context) => {
//         var old_delta = change.before.val();
//         var new_delta = change.after.val();
//         var mid = context.params.id;
//         database.ref('/creta_log/text').set('skpark changed =' + mid);
//         functions.logger.log('skpark changed =' + mid);
//         return null;
// });

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

exports.cleanBin_schedule = functions.runWith({ timeoutSeconds: 300 }).pubsub.schedule('every 24 hours').onRun((context) => {
    _cleanBin('creta_book');
    _cleanBin('creta_book_published');
    _cleanBin('creta_channel');
    _cleanBin('creta_comment');
    _cleanBin('creta_connected_user');
    _cleanBin('creta_contents_published');
    _cleanBin('creta_depot');
    _cleanBin('creta_enterprise');
    _cleanBin('creta_favorites');
    _cleanBin('creta_filter');
    _cleanBin('creta_frame');
    _cleanBin('creta_frame_published');
    _cleanBin('creta_page');
    _cleanBin('creta_page_published');
    _cleanBin('creta_playlist');
    _cleanBin('creta_subscription');
    _cleanBin('creta_team');
    _cleanBin('creta_user_property');
    return _cleanBin('creta_watch_history');
   
});

exports.cleanBin_contents_schedule = functions.runWith({ timeoutSeconds: 300 }).pubsub.schedule('every 24 hours').onRun((context) => {
    return _cleanBin('creta_contents');
});

exports.cleanBin_req = functions.https.onRequest(async (req, res) => {
    var retval = _cleanBin(req.query.id);
    res.json({result: `${req.query.id} ${retval}`});
 }); 
 

exports.cleanBin = functions.https.onCall((data) => {
    return _cleanBin(data);
});

function _getDaysAgoAsString() {
    const daysAgo = new Date();
    daysAgo.setDate(daysAgo.getDate() - 2);
    
    const YYYY = daysAgo.getFullYear();
    const MM = String(daysAgo.getMonth() + 1).padStart(2, '0');  // January is 0!
    const DD = String(daysAgo.getDate()).padStart(2, '0');
    const HH = String(daysAgo.getHours()).padStart(2, '0');
    const MI = String(daysAgo.getMinutes()).padStart(2, '0');
    const SS = String(daysAgo.getSeconds()).padStart(2, '0');
    const SSS = String(daysAgo.getMilliseconds()).padStart(3, '0');
    
    return `${YYYY}-${MM}-${DD} ${HH}:${MI}:${SS}.${SSS}`;
}

async function  _cleanBin(collectionId) {
    functions.logger.info('skpark _deleteRecycleBin invoked ' + collectionId);
    // let now = new Date();
    // now.setDate(now.getDate() - 3);
    // let yesterday = now.toISOString().replace(/T/, ' ').replace(/\..+/, '.000Z');

    const daysAgoString = _getDaysAgoAsString();

    const db = getFirestore();
    const querySnapshot = await db.collection(collectionId)
    .where('isRemoved' , '=', true)
    .where('updateTime', '<=', daysAgoString)
    .get();
    
    var retval = '';

    const commitBatch = async (batch, count) => {
        await batch.commit();
        totalDeleted += count;
        functions.logger.info(`Deleted ${count} documents in this batch.`);
        return db.batch();  // Create and return a new batch for the next set of deletions.
    };
    
    let batch = db.batch();
    let counter = 0;
    let totalDeleted = 0;
    
    for (const doc of querySnapshot.docs) {
        batch.delete(doc.ref);
        counter++;
    
        if (counter >= 500) {
            batch = await commitBatch(batch, counter);
            counter = 0;
        }
    }
    
    if (counter > 0) {  // If there are remaining documents in the batch, commit them.
        await commitBatch(batch, counter);
        totalDeleted += counter;
    }

    // querySnapshot.forEach((doc) => {
    //     //functions.logger.info(doc.id, ' => ', doc.data());
    //     doc.ref.delete();
    //     counter++;
    // });
    functions.logger.info('{result: '+ collectionId + ' (' + totalDeleted + ') deleted');
    return '{result: '+ collectionId + ' (' + totalDeleted + ') deleted';
}