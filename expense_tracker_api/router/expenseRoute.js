const express = require("express");
const router = new express.Router();
const { verifyUser } = require("../middleware/authMiddleware");
const {
  addExpense,
  getDWMExpenses,
  getSpecificExpenses,
  removeExpense,
  editExpense,
  getCategorizedExpenses,
  getSpecificallyCategorizedExpenses,
  getCategorizedExpenseStartDate,
} = require("../controller/expenseController");

router.post("/add", verifyUser, addExpense);

router.get("/getDWM", verifyUser, getDWMExpenses);

router.post("/getSpecific", verifyUser, getSpecificExpenses);

router.delete("/remove", verifyUser, removeExpense);

router.put("/edit", verifyUser, editExpense);

router.post("/categorized", verifyUser, getCategorizedExpenses);

router.post(
  "/categorizedSpecific",
  verifyUser,
  getSpecificallyCategorizedExpenses
);

router.post(
  "/getCategoryStartDate",
  verifyUser,
  getCategorizedExpenseStartDate
);

module.exports = router;
