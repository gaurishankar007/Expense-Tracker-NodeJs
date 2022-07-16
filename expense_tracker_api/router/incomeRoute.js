const express = require("express");
const router = new express.Router();
const { verifyUser } = require("../middleware/authMiddleware");
const {
  addIncome,
  getDWMIncomes,
  getSpecificIncomes,
  removeIncome,
  editIncome,
  getCategorizedIncomes,
  getSpecificallyCategorizedIncomes,
  getCategorizedIncomeStartDate,
} = require("../controller/incomeController");

router.post("/add", verifyUser, addIncome);

router.get("/getDWM", verifyUser, getDWMIncomes);

router.post("/getSpecific", verifyUser, getSpecificIncomes);

router.delete("/remove", verifyUser, removeIncome);

router.put("/edit", verifyUser, editIncome);

router.post("/categorized", verifyUser, getCategorizedIncomes);

router.post(
  "/categorizedSpecific",
  verifyUser,
  getSpecificallyCategorizedIncomes
);

router.post(
  "/getCategoryStartDate",
  verifyUser,
  getCategorizedIncomeStartDate
);

module.exports = router;
