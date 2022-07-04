const express = require("express");
const router = new express.Router();
const auth = require("../authentication/auth");
const income = require("../model/incomeModel");

router.post("/income/add", auth.verifyUser, (req, res) => {
  const name = req.body.name;
  const amount = req.body.amount;
  const category = req.body.category;

  const nameRegex = /^[a-zA-Z\s]*$/;
  const amountRegex = new RegExp("^[0-9]+$");

  if (name.trim() === "" || amount.trim() === "" || category.trim() === "") {
    return res.status(400).send({ resM: "Provide all information." });
  } else if (!nameRegex.test(name)) {
    return res.status(400).send({ resM: "Invalid income name." });
  } else if (name.length <= 2 || name.length >= 16) {
    return res
      .status(400)
      .send({ resM: "Income name most contain 3 to 15 characters." });
  } else if (!amountRegex.test(amount)) {
    return res.status(400).send({ resM: "Invalid amount." });
  } else if (amount.length >= 8) {
    return res
      .status(400)
      .send({ resM: "Income amount most be less than one crore" });
  }

  const newIncome = new income({
    user: req.userInfo._id,
    name: name,
    amount: amount,
    category: category,
  });

  newIncome.save().then(() => {
    res.status(201).send({ resM: "Income added." });
  });
});

router.get("/income/getDWM", auth.verifyUser, async (req, res) => {
  const currentDateTime = new Date();

  const today =
    (currentDateTime.getHours() * 60 * 60 +
      currentDateTime.getMinutes() * 60 +
      currentDateTime.getSeconds()) *
      1000 +
    currentDateTime.getMilliseconds();

  const currentDate = parseInt(
    currentDateTime.toISOString().split("T")[0].split("-")[2]
  );
  var weekFirstDate;
  var weekLastDate;

  if (currentDate <= 7) {
    weekFirstDate = "01";
    weekLastDate = "07";
  } else if (currentDate <= 14) {
    weekFirstDate = "08";
    weekLastDate = "14";
  } else if (currentDate <= 21) {
    weekFirstDate = "15";
    weekLastDate = "21";
  } else if (currentDate <= 28) {
    weekFirstDate = "22";
    weekLastDate = "28";
  } else if (currentDate < 35) {
    weekFirstDate = "29";
    weekLastDate = "31";
  }

  weekFirstDate = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-" +
        weekFirstDate
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  weekLastDate = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-" +
        weekLastDate
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const thisMonth = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-01"
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const todayIncomes = await income
    .find({
      user: req.userInfo._id,
      createdAt: { $gte: new Date(Date.now() - today) },
    })
    .sort({ amount: -1 });

  var todayIncomeAmount = 0;
  for (let i = 0; i < todayIncomes.length; i++) {
    todayIncomeAmount = todayIncomeAmount + parseInt(todayIncomes[i].amount);
  }

  const thisWeekIncomes = await income
    .find({
      user: req.userInfo._id,
      createdAt: {
        $gte: weekFirstDate,
        $lte: weekLastDate,
      },
    })
    .sort({ amount: -1 });

  var thisWeekIncomeAmount = 0;
  for (let i = 0; i < thisWeekIncomes.length; i++) {
    thisWeekIncomeAmount =
      thisWeekIncomeAmount + parseInt(thisWeekIncomes[i].amount);
  }

  const thisMonthIncomes = await income
    .find({ user: req.userInfo._id, createdAt: { $gte: thisMonth } })
    .sort({ amount: -1 });

  var thisMonthIncomeAmount = 0;
  for (let i = 0; i < thisMonthIncomes.length; i++) {
    thisMonthIncomeAmount =
      thisMonthIncomeAmount + parseInt(thisMonthIncomes[i].amount);
  }

  const todayIncomeCategories = await income.aggregate([
    {
      $match: {
        user: req.userInfo._id,
        createdAt: { $gte: new Date(Date.now() - today) },
      },
    },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const thisWeekIncomeCategories = await income.aggregate([
    {
      $match: {
        user: req.userInfo._id,
        createdAt: { $gte: weekFirstDate, $lte: weekLastDate },
      },
    },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const thisMonthIncomeCategories = await income.aggregate([
    { $match: { user: req.userInfo._id, createdAt: { $gte: thisMonth } } },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  const firstIncome = await income
    .findOne({ user: req.userInfo._id })
    .sort({ createdAt: 1 });

  const firstIncomeDate =
    firstIncome === null
      ? currentDateTime.toISOString().split("T")[0]
      : firstIncome.createdAt.toISOString().split("T")[0];

  res.send({
    profilePicture: req.userInfo.profilePicture,
    firstIncomeDate: firstIncomeDate,
    todayIncomes: todayIncomes,
    thisWeekIncomes: thisWeekIncomes,
    thisMonthIncomes: thisMonthIncomes,
    todayIncomeAmount: todayIncomeAmount,
    thisWeekIncomeAmount: thisWeekIncomeAmount,
    thisMonthIncomeAmount: thisMonthIncomeAmount,
    todayIncomeCategories: todayIncomeCategories,
    thisWeekIncomeCategories: thisWeekIncomeCategories,
    thisMonthIncomeCategories: thisMonthIncomeCategories,
  });
});

router.post("/income/getSpecific", auth.verifyUser, async (req, res) => {
  const sDate = req.body.startDate;
  const eDate = req.body.endDate;

  if (sDate.trim() === "" || eDate.trim() === "") {
    return res.status(400).send({ resM: "Provide both start and end date." });
  }

  const currentDateTime = new Date();

  const startDate = new Date(
    new Date(sDate).getTime() + currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const endDate = new Date(
    new Date(eDate).getTime() +
      24 * 60 * 60 * 1000 +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const incomes = await income
    .find({
      user: req.userInfo._id,
      createdAt: {
        $gte: startDate,
        $lte: endDate,
      },
    })
    .sort({ amount: -1 });

  var incomeAmount = 0;
  for (let i = 0; i < incomes.length; i++) {
    incomeAmount = incomeAmount + parseInt(incomes[i].amount);
  }

  const incomeCategories = await income.aggregate([
    {
      $match: {
        user: req.userInfo._id,
        createdAt: {
          $gte: startDate,
          $lte: endDate,
        },
      },
    },
    {
      $group: { _id: "$category", amount: { $sum: "$amount" } },
    },
  ]);

  res.send({
    incomes: incomes,
    incomeAmount: incomeAmount,
    incomeCategories: incomeCategories,
  });
});

router.delete("/income/remove", auth.verifyUser, (req, res) => {
  income.findOneAndDelete({ _id: req.body.incomeId }).then(() => {
    res.send({ resM: "Income removed." });
  });
});

router.put("/income/edit", auth.verifyUser, (req, res) => {
  const incomeId = req.body.incomeId;
  const name = req.body.name;
  const amount = req.body.amount;
  const category = req.body.category;

  const nameRegex = /^[a-zA-Z\s]*$/;
  const amountRegex = new RegExp("^[0-9]+$");

  if (name.trim() === "" || amount.trim() === "" || category.trim() === "") {
    return res.status(400).send({ resM: "Provide all information." });
  } else if (!nameRegex.test(name)) {
    return res.status(400).send({ resM: "Invalid income name." });
  } else if (name.length <= 2 || name.length >= 16) {
    return res
      .status(400)
      .send({ resM: "Income name most contain 3 to 15 characters." });
  } else if (!amountRegex.test(amount)) {
    return res.status(400).send({ resM: "Invalid amount." });
  } else if (amount.length >= 8) {
    return res
      .status(400)
      .send({ resM: "Income amount most be less than one crore" });
  }

  income
    .updateOne(
      { _id: incomeId },
      {
        name: name,
        amount: amount,
        category: category,
      }
    )
    .then(() => {
      res.send({ resM: "Income edited." });
    });
});

router.post("/income/categorized", auth.verifyUser, async (req, res) => {
  const category = req.body.category;

  if (category.trim() === "") {
    return res.send({ resM: "Provide income category." });
  }

  const currentDateTime = new Date();

  const thisMonth = new Date(
    new Date(
      currentDateTime.toISOString().split("T")[0].split("-")[0] +
        "-" +
        currentDateTime.toISOString().split("T")[0].split("-")[1] +
        "-01"
    ).getTime() +
      currentDateTime.getTimezoneOffset() * 60 * 1000
  );

  const thisMonthIncomes = await income
    .find({
      user: req.userInfo._id,
      category: category,
      createdAt: { $gte: thisMonth },
    })
    .sort({ amount: -1 });

  res.send(thisMonthIncomes);
});

router.post(
  "/income/categorizedSpecific",
  auth.verifyUser,
  async (req, res) => {
    const category = req.body.category;
    const sDate = req.body.startDate;
    const eDate = req.body.endDate;

    if (category.trim() === "" || sDate.trim() === "" || eDate.trim() === "") {
      return res
        .status(400)
        .send({ resM: "Provide both start and end date along with category." });
    }

    const currentDateTime = new Date();

    const startDate = new Date(
      new Date(sDate).getTime() +
        currentDateTime.getTimezoneOffset() * 60 * 1000
    );

    const endDate = new Date(
      new Date(eDate).getTime() +
        24 * 60 * 60 * 1000 +
        currentDateTime.getTimezoneOffset() * 60 * 1000
    );

    const thisMonthIncomes = await income
      .find({
        user: req.userInfo._id,
        category: category,
        createdAt: {
          $gte: startDate,
          $lte: endDate,
        },
      })
      .sort({ amount: -1 });

    res.send(thisMonthIncomes);
  }
);

router.post(
  "/income/getCategoryStartDate",
  auth.verifyUser,
  async (req, res) => {
    const category = req.body.category;

    if (category.trim() === "") {
      return res.send({ resM: "Provide income category." });
    }

    const firstExpenseCategory = await income
      .findOne({
        user: req.userInfo._id,
        category: category,
      })
      .sort({ createdAt: 1 });

    const currentDateTime = new Date();

    const startDate =
      firstExpenseCategory === null
        ? currentDateTime.toISOString().split("T")[0]
        : firstExpenseCategory.createdAt.toISOString().split("T")[0];

    res.send(startDate);
  }
);

module.exports = router;
