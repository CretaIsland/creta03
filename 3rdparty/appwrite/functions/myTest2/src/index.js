const sdk = require("node-appwrite");

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

module.exports = async function (req, res) {
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

  var projectId = "62d79f0b36f4029ce40f";
  var databaseId = "62d79f2e5fda513f4807";
  var apiKey = "163c3964999075adc6b7317f211855832ebb6d464520446280af0f8bbb9e642ffdcd2588a5141ce3ea0011c5780ce10986ed57b742fdb6a641e2ecf7310512cd5349e61385f856eb4789e718d750e2451c1b1519dd20cdf557b5edc1ae066e28430f5cc3e157abc4a13ad6aa112a48b07ce707341edfdc41d2572e95b4728905";
  var endPoint = "http://192.168.10.3/v1";
  try {
    // from command line arguments
    projectId = req.payload["projectId"]
    databaseId = req.payload["databaseId"] 
    apiKey = req.payload["apiKey"] 
    endPoint = req.payload["endPoint"] 
  } catch (e1) {
    console.warn("Payload are not set");
    // from Appwrite console
    try {
      projectId = req.variables["projectId"]
      databaseId = req.variables["databaseId"] 
      apiKey = req.variables["apiKey"] 
      endPoint = req.variables["endPoint"] 
    } catch (e2) {
      console.warn("variables are not set");
   }
  }

  client
    .setEndpoint(endPoint)
    .setProject(projectId)
    .setKey(apiKey)
    .setSelfSigned(true);

  try {
    var response = await database.getDocument(databaseId, 'disk_usage', 'simulator');
    console.log(response);
    //let velog = JSON.parse(response);
    res.json({
      usage: response.usage
    });
  } catch (error) {
    console.log(error);
    res.json({
      usage: error,
    });
  }
  
  
};
