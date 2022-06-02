// import module
const express = require("express");

// import router
const userRouter = require("./routes/user");

// specify http port
const port = 3100;

// create express application
const app = express();

// mount middleware
app.use(express.json());

// mount router
app.use("/api/user", userRouter);

// start http server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
