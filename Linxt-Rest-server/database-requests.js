const { MongoClient } = require("mongodb");

require("dotenv").config();

const client = new MongoClient(process.env.DB_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

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

export async function addUser(identifier) {
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
      return true;
    }
    return false;
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
