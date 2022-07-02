const express = require("express");
const app = express();
const cors = require("cors");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(express.static(__dirname + "/upload"));

require("./database/connectDB");

const userRoute = require("./router/userRoute");
app.use(userRoute);

const token = require("./router/tokenRoute");
app.use(token);

const expense = require("./router/expenseRoute");
app.use(expense);

const income = require("./router/incomeRoute");
app.use(income);

const home = require("./router/homeRoute");
app.use(home);

const badge = require("./router/badgeRoute");
app.use(badge);

const achievement = require("./router/achievementRoute");
app.use(achievement);

app.listen(8848, () => {
  console.log("Server running on port: 8848...");
});
