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
const { verify } = require("../database-requests");

// create router
const router = express.Router();

// read single task
router.get("/", async (req, res) => {
  const identifier = req.body.token;
  if (!identifier) {
    res.sendStatus(BAD_REQUEST);
    return;
  }
  const verification = await verify(identifier);
  if(!verification.success) {
    res.sendStatus(BAD_REQUEST).send();
    return;
  }

  if(!userExists(verification.result)) {
    res.status(CREATED).send();
    return;
  }

  const history = getUserHistory(verification.result);

  if (!history) {
    res.sendStatus(NOT_FOUND);
    return;
  }

  res.status(OK).json(history);
});

// create task
router.post("/", async (req, res) => {
  const identifier = req.body.token;
  const match = req.body.match;

  if (!identifier || !match) {
    res.sendStatus(BAD_REQUEST);
    return;
  }

  const verification = await verify(identifier);
  if(!verification.success) {
    res.sendStatus(BAD_REQUEST).send();
    return;
  }

  const result = addMatch(verification.result, match);

  if (!result) {
    res.sendStatus(NOT_FOUND);
    return;
  }

  res.status(CREATED).send();
});

// export router
module.exports = router;
