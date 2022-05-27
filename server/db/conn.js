const mongoose = require("mongoose");

const DB = process.env.ATLAS_URI;

mongoose
  .connect(DB)
  .then(() => {
    console.log(`Connected to DB`);
  })
  .catch((err) => {
    console.log(err);
  });
