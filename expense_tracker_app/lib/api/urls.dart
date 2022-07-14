class ApiUrls {
  static const routeUrl = "http://10.0.2.2:8848/";
}

class AchievementUrls {
  static const getAllAchievements = "achievement/getAll";
}

class ExpenseUrls {
  static const addExpense = "expense/add";
  static const getExpenseDWM = "expense/getDWM";
  static const getExpenseSpecific = "expense/getSpecific";
  static const removeExpense = "expense/remove";
  static const editExpense = "expense/edit";
  static const getCategorizedExpense = "expense/categorized";
  static const getCategorizedSpecificExpense = "expense/categorizedSpecific";
  static const getCategoryStartDate = "expense/getCategoryStartDate";
}

class IncomeUrls {
  static const addIncome = "income/add";
  static const getIncomeDWM = "income/getDWM";
  static const getIncomeSpecific = "income/getSpecific";
  static const removeIncome = "income/remove";
  static const editIncome = "income/edit";
  static const getCategorizedIncome = "income/categorized";
  static const getCategorizedSpecificIncome = "income/categorizedSpecific";
  static const getCategoryStartDate = "income/getCategoryStartDate";
}

class HomeUrls {
  static const viewHome = "user/getHome";
}

class ProgressUrls {
  static const getUserProgress = "user/getProgress";
  static const topUsersProgress = "users/progresses";
}

class TokenUrls {
  static const generateToken = "generate/token";
  static const verifyToken = "verify/token";
}

class UserUrls {
  static const changePassword = "user/changePassword";
  static const getUser = "user/view";
  static const changeProfilePicture = "user/changeProfilePicture";
  static const changeProfileName = "user/changeProfileName";
  static const changeEmail = "user/changeEmail";
  static const changeGender = "user/changeGender";
  static const publicProgress = "user/progressPublication";
}
