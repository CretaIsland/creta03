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
    let yesterday = new Date(today.setDate(today.getDate() -1));

    var year = yesterday.getFullYear();
    var month = addZero(yesterday.getMonth() + 1);
    var day = addZero(yesterday.getDate());
    var hour = addZero(yesterday.getHours());
    var minute = addZero(yesterday.getMinutes());
    var second = addZero(yesterday.getSeconds());

    var retval  = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second + ".000";
    return retval;
}


async function removeDelta (req,res) {
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

  try {
    var response = await database.listDocuments(databaseId, 'hycop_delta', 
	[
		sdk.Query.lessThan('updateTime', yesterdayStr),
		sdk.Query.orderAsc('updateTime')
	]);

    let total = response.total;
    let documentList = response.documents;
    let deleted = 0;
    for(var i=0;i<total;i++) {
      await database.deleteDocument(databaseId, 'hycop_delta', documentList[i].$id);
      deleted = deleted + 1;
    }
    //let velog = JSON.parse(response);
	  
    //res.json({
    //  'deleted': deleted
    //});
    return {
      'deleted': deleted
    };
  } catch (error) {
    //res.json({
    //  'error': error
    //});
    return {
      'error': error
    };
  }
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
	let val  = await removeDelta(req,res);
  	log(val);
    	return res.send(val);
  }


	log('scheduled');
	let val  = await removeDelta(req,res);
	log(val);
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
