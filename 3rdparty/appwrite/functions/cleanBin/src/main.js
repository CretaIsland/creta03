//import { Client } from 'node-appwrite';
import  sdk from 'node-appwrite';
//impoprt rmDeltaModule from './removeDelta.js';
//const sdk = require("node-appwrite");
/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status)' - function to return text response. Status code defaults to 200
    'json(obj, status)' - function to return JSON response. Status code defaults to 200

  If an error is thrown, a response with code 500 will be returned.
*/


function addZero(num) {
    if (num < 10) {
        num = "0" + num;
    }
    return num;
}

function getYesterday() {
    let today = new Date();
    let yesterday = new Date(today.setDate(today.getDate() -2));

    var year = yesterday.getFullYear();
    var month = addZero(yesterday.getMonth() + 1);
    var day = addZero(yesterday.getDate());
    var hour = addZero(yesterday.getHours());
    var minute = addZero(yesterday.getMinutes());
    var second = addZero(yesterday.getSeconds());

    var retval  = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second + ".000";
    return retval;
}


async function _cleanBin(database, databaseId, yesterdayStr, collectionId)
{

  try {
    var response = await database.listDocuments(databaseId, collectionId, 
	[
		sdk.Query.lessThan('updateTime', yesterdayStr),
		sdk.Query.orderAsc('updateTime')
	]);

    let total = response.total;
    let documentList = response.documents;
    let deleted = 0;
    for(var i=0;i<total;i++) {
      await database.deleteDocument(databaseId, collectionId, documentList[i].$id);
      deleted = deleted + 1;
    }
  let title =  collectionId + ' deleted'; 
    return {
      [title] : deleted
    };
  } catch (error) {
  let title =  collectionId + ' error'; 
    return {
      [title] : error
    };
  }

}

async function cleanBin (req,res,log) {
//module.exports.removeDelta = async function (req, res) {
  const client = new sdk.Client();

  // You can remove services you don't use
  //let account = new sdk.Account(client);
  //let avatars = new sdk.Avatars(client);
  let database = new sdk.Databases(client);
  //let functions = new sdk.Functions(client);
  //let health = new sdk.Health(client);
  //let locale = new sdk.Locale(client);
  //let storage = new sdk.Storage(client);
  //let teams = new sdk.Teams(client);
  //let users = new sdk.Users(client);

  var projectId = "";
  var databaseId = "";
  var apiKey = "";
  var endPoint = "";
  try {
    var payload = JSON.parse(req.payload);
    // from command line arguments
    projectId = payload.projectId;
    databaseId = payload.databaseId; 
    apiKey = payload.apiKey; 
    endPoint = payload.endPoint; 
  } catch (e1) {
    //console.warn("Payload are not set");
    // from Appwrite console
    try {
      var variables = JSON.parse(req.variables);
  
      projectId = variables.projectId;
      databaseId = variables.databaseId;
      apiKey = variables.apiKey;
      endPoint = variables.endPoint;
    } catch (e2) {
      //console.warn("variables are not set");
   }
  }

  if (!projectId || !databaseId || !apiKey || !endPoint ) {
	projectId = "65362b549aa9f85f813d";
	databaseId = "653b10ed3629614bbd48";
	apiKey = "c678dbd28dab6380d868a774ebe5f7e6048753723146e6a9cda85450a02ddb2f5a7988ae088e7168722aaf0c50d977acc3ea7e8807730ded495ee8fea9d5c5fac238945b89bb1c084e441b0692af78e91895928405b2c4dd42dfc7b7b147d002192833b84ec70ed38dccc6ef616791b7861d6cac0289946e30b2ef6e0d0eb5db";
	endPoint = "https://devcreta.com:663/v1";
  }

  client
    .setEndpoint(endPoint)
    .setProject(projectId)
    .setKey(apiKey)
    .setSelfSigned(true);

  let yesterdayStr = getYesterday();
  //strftime('%Y-%m-%d %I:%M:%S.000', tm)
  //let yesterdayStr = '2022-09-27 15:41:31.621';
	const ret1 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_book');
	log(ret1);
	const ret2 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_book_published');
	log(ret2);
	const ret3 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_channel');
	log(ret3);
	const ret4 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_comment');
	log(ret4);
	const ret5 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_connected_user');
	log(ret5);
	const ret6 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_contents_published');
	log(ret6);
	const ret7 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_depot');
	log(ret7);
	const ret8 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_enterprise');
	log(ret8);
	const ret9 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_favorites');
	log(ret9);
	const ret10 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_filter');
	log(ret10);
	const ret11 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_frame');
	log(ret11);
	const ret12 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_frame_published');
	log(ret12);
	const ret13 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_page');
	log(ret13);
	const ret14 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_page_published');
	log(ret14);
	const ret15 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_playlist');
	log(ret15);
	const ret16 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_subscription');
	log(ret16);
	const ret17 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_team');
	log(ret17);
	const ret18 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_user_property');
	log(ret18);
	const ret19 = await _cleanBin(database, databaseId, yesterdayStr, 'creta_watch_history');
	log(ret19);

	return  {...ret1, ...ret2,...ret3, ...ret4, ...ret5,...ret6,...ret7,...ret8,...ret9, ...ret10, 
		...ret11, ...ret12,...ret13, ...ret14, ...ret15,...ret16,...ret17,...ret18,...ret19 };

};


// This is your Appwrite function
// It's executed each time we get a request
export default async ({ req, res, log, error }) => {
  // Why not try the Appwrite SDK?
  //
  // const client = new Client()
  //   .setEndpoint('https://cloud.appwrite.io/v1')
  //   .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
  //   .setKey(process.env.APPWRITE_API_KEY);

  // You can log messages to the console
  //log('Hello, Logs!');

  // If something goes wrong, log an error
  //error('Hello, Errors!');

  // The `req` object contains the request data
  if (req.method === 'GET') {
    // Send a response with the res object helpers
    // `res.send()` dispatches a string back to the client
	let val  = await cleanBin(req,res,log);
    	return res.send(val);
  }

	log('scheduled');
	let val  = await cleanBin(req,res,log);
	return res.send(val);
  // `res.json()` is a handy helper for sending JSON
	/*
  return res.json({
    motto: 'Build like a team of hundreds_',
    learn: 'https://appwrite.io/docs',
    connect: 'https://appwrite.io/discord',
    getInspired: 'https://builtwith.appwrite.io',
  });
	*/
};
