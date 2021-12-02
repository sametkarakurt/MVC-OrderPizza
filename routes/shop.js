const express = require("express");
const router = express.Router();

const shopController = require("../controllers/shop");

router.get("/", shopController.getIndex);

router.get("/products", shopController.getProducts);

router.get("/add-product", shopController.getAddProduct);

router.post("/add-product", shopController.postAddProduct);

router.get("/editproduct/:productid", shopController.getEditProduct);

router.post("/products", shopController.postEditProduct);

router.post("/delete-product", shopController.postDeleteProduct);
module.exports = router;
