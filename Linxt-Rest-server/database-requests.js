const { MongoClient } = require("mongodb");
const {OAuth2Client} = require('google-auth-library');

require("dotenv").config();

const client = new MongoClient(process.env.DB_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const authClient = new OAuth2Client(process.env.CLIENT_ID);

export async function verify(token) {
  const ticket = await authClient.verifyIdToken({
      idToken: token,
      audience: process.env.CLIENT_ID,  // Specify the CLIENT_ID of the app that accesses the backend
      // Or, if multiple clients access the backend:
      //[CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3]
  },
  (err, result) => {
      if (err) {
          return {
              success: false
          }
      }
      return {
        success: true,
        result: result.getPayload()["sub"]
      };
  }
  );

  const payload = ticket.getPayload();
  const userid = payload['sub'];
  // If request specified a G Suite domain:
  // const domain = payload['hd'];
}



export async function getUserHistory(identifier) {
  try {
    await client.connect();
    const database = client.db("linxt");
    const linxt = database.collection("linxt");
    // Query for the user history if user exists
    const query = { user: identifier };
    const history = await linxt.findOne(query);
    console.log(history);
    return history;
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}

export async function userExists(identifier) {
  try {
    await client.connect();
    const database = client.db("linxt");
    const linxt = database.collection("linxt");
    // Query for the user history if user exists
    const query = { user: identifier };
    const history = await linxt.findOne(query);
    console.log(history);
    if (!history) {
      const newUser = {
        user: identifier,
        matches: [],
      };
      await linxt.insertOne(newUser);
      return false;
    }
    return true;
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}

export async function addMatch(identifier, match) {
  try {
    await client.connect();

    const database = client.db("linxt");

    const linxt = database.collection("linxt");

    // create a document to insert

    const result = await linxt.updateOne(
      { user: identifier },
      { $push: { matches: match } }
    );

    return result.acknowledged;
  } finally {
    await client.close();
  }
}
