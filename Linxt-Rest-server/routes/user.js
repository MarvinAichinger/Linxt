//import modules
const express = require("express");
const {
  OK,
  CREATED,
  NO_CONTENT,
  BAD_REQUEST,
  NOT_FOUND,
  CONFLICT,
  INTERNAL_SERVER_ERROR,
} = require("http-status-codes");
const {
  verify,
  getUserHistory,
  userExists,
  addMatch,
} = require("../database-requests");

// create router
const router = express.Router();

// read single task
router.post("/auth", async (req, res) => {
  const identifier = req.body.token;
  if (!identifier) {
    res.sendStatus(BAD_REQUEST);
    return;
  }
  const verification = await verify(identifier);

  if (!verification.success) {
    res.sendStatus(BAD_REQUEST).send();
    return;
  }

  const userStatus = await userExists(verification.result);

  if (!userStatus) {
    res.status(CREATED).send();
    return;
  }
});

router.get("/history", async (req, res) => {
  const identifier = req.headers.authorization;

  if (!identifier) {
    res.sendStatus(BAD_REQUEST);
    return;
  }
  const verification = await verify(identifier);

  if (!verification.success) {
    res.sendStatus(BAD_REQUEST).send();
    return;
  }

  const history = await getUserHistory(verification.result);

  if (!history) {
    res.sendStatus(NOT_FOUND);
    return;
  }

  res.status(OK).json(history.matches);
});

// create task
router.post("", async (req, res) => {
  const identifier = req.body.token;
  const match = req.body.match;
  const enemy = req.body.enemy;

  if (!identifier || !match || !enemy) {
    res.sendStatus(BAD_REQUEST);
    return;
  }

  const verification = await verify(identifier);
  if (!verification.success) {
    res.sendStatus(BAD_REQUEST).send();
    return;
  }

  const matchToAdd = {
    result: match,
    enemy: enemy,
  };

  const result = await addMatch(verification.result, matchToAdd);

  if (!result) {
    res.sendStatus(NOT_FOUND);
    return;
  }

  res.status(CREATED).send();
});

// export router
module.exports = router;
