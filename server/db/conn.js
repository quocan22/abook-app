const mongoose = require("mongoose");

const DB = process.env.ATLAS_URI;

mongoose
  .connect(DB)
  .then(() => {
    console.log(`Connected to server`);
  })
  .catch((err) => {
    console.log(err);
  });
