import  sdk from 'node-appwrite';


function addZero(num) {
    if (num < 10) {
        num = "0" + num;
    }
    return num;
}

function getToday() {

let now = new Date();

    var year = now.getFullYear();
    var month = addZero(now.getMonth() + 1);
    var day = addZero(now.getDate());
    var hour = addZero(now.getHours());
    var minute = addZero(now.getMinutes());
    var second = addZero(now.getSeconds());

    var retval  = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second + ".000";
    return retval;
}


async function pingDelta (req,res) {
//module.exports.removeDelta = async function (req, res) {
  const client = new sdk.Client();

  let database = new sdk.Databases(client);

  var projectId = "";
  var databaseId = "";
  var apiKey = "";
  var endPoint = "";

	projectId = "65362b549aa9f85f813d";
	databaseId = "653b10ed3629614bbd48";
	apiKey = "c678dbd28dab6380d868a774ebe5f7e6048753723146e6a9cda85450a02ddb2f5a7988ae088e7168722aaf0c50d977acc3ea7e8807730ded495ee8fea9d5c5fac238945b89bb1c084e441b0692af78e91895928405b2c4dd42dfc7b7b147d002192833b84ec70ed38dccc6ef616791b7861d6cac0289946e30b2ef6e0d0eb5db";
	endPoint = "https://devcreta.com:663/v1";

  client
    .setEndpoint(endPoint)
    .setProject(projectId)
    .setKey(apiKey)
    .setSelfSigned(true);

  //strftime('%Y-%m-%d %I:%M:%S.000', tm)
  //let yesterdayStr = '2022-09-27 15:41:31.621';

  try {
    var response = await database.listDocuments(databaseId, 'hycop_delta', 
	[
		sdk.Query.equal('directive', 'ping')
	]);

	let total = response.total;
	let todayStr = getToday();
	const newData = { 'directive' : 'ping', 'updateTime': todayStr };

	 if (total > 0) {
		const documentId = response.documents[0].$id;
		const updateResponse = await database.updateDocument(databaseId, 'hycop_delta', documentId, newData);
	 }else{
		const documentId = 'ping';
		const createResponse = await database.createDocument(databaseId, 'hycop_delta', documentId, newData);
	 }


    return {
      'ping': todayStr
    };
  } catch (error) {
    return {
      'error?': error.message
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
	let val  = await pingDelta(req,res);
  	log(val);
    	return res.send(val);
  }


	log('scheduled');
	let val  = await pingDelta(req,res);
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
