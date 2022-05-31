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

// create router
const router = express.Router();

// init data storage

// read all tasks

// read single task
router.get("/", (req, res) => {
  const identifier = req.body.identifier;
  if (!identifier) {
    res.sendStatus(BAD_REQUEST);
    return;
  }

  const history = getUserHistory(identifier);

  if (!history) {
    res.sendStatus(NOT_FOUND);
    return;
  }

  res.status(OK).json(history);
});

// create task
router.post("/", (req, res) => {
  const identifier = req.body.identifier;
  const match = req.body.match;

  if (!identifier || !match) {
    res.sendStatus(BAD_REQUEST);
    return;
  }

  const result = addMatch(identifier, match);

  if (!result) {
    res.sendStatus(NOT_FOUND);
    return;
  }

  res.status(CREATED).send();
});

router.post("/addUser", (req, res) => {
  const identifier = req.body.identifier;
  if (!identifier) {
    res.sendStatus(BAD_REQUEST);
    return;
  }
  const result = addUser(identifier);
  if (!result) {
    res.sendStatus(CONFLICT);
    return;
  }
  res.status(CREATED).send();
});

// export router
module.exports = router;
