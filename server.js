const express = require("express");
const app = express();
const cors = require("cors");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

require("./database/connectDB");

app.get("/", (req, res) => {
  res.send("Welcome to expense income tracker app.");
});

const userRoute = require("./router/userRoute");
app.use("/user", userRoute);

const tokenRoute = require("./router/tokenRoute");
app.use("/token", tokenRoute);

const expenseRoute = require("./router/expenseRoute");
app.use("/expense", expenseRoute);

const incomeRoute = require("./router/incomeRoute");
app.use("/income", incomeRoute);

const homeRoute = require("./router/homeRoute");
app.use("/home", homeRoute);

const achievementRoute = require("./router/achievementRoute");
app.use("/achievement", achievementRoute);

const progressRoute = require("./router/progressRoute");
app.use("/progress", progressRoute);

const { notFound, errorHandler } = require("./middleware/errorMiddleware");
app.use(notFound);
app.use(errorHandler);

const dotenv = require("dotenv");
dotenv.config();
const port = process.env.PORT || 8848;

app.listen(port, () => {
  console.log("Server running on port: 8848...");
});
