const dotenv = require("dotenv");
const mongoose = require("mongoose");
const express = require("express");
const app = express();
const cors = require("cors");

dotenv.config({ path: "./config.env" });
require("./db/conn");
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use("/api/users", require("./routes/userRouter"));
app.use("/api/books", require("./routes/bookRouter"));
app.use("/api/categories", require("./routes/categoryRouter"));
app.use("/api/carts", require("./routes/cartRouter"));

app.listen(port, () => {
  console.log(`Server is running at port ${port}`);
});
