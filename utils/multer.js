const { cloudinary } = require("../utils/cloudinary");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const multer = require("multer");

const storageNavigation = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "ExpenseTracker",
  },
});

const filter = function (req, file, cb) {
  if (
    file.mimetype == "image/png" ||
    file.mimetype == "image/jpeg" ||
    file.mimetype == "application/octet-stream"
  ) {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: storageNavigation,
  fileFilter: filter,
});

module.exports = upload;
