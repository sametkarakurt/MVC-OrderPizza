const express = require("express");
const app = express();

const bodyParser = require("body-parser");
const path = require("path");

app.set("view engine", "pug");
app.set("views", "./views");

const userRoutes = require("./routes/shop");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "public")));

// routes
app.use(userRoutes);

app.listen(3000, () => {
  console.log("listening on port 3000");
});


