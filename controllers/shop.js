const Product = require("../models/product");

exports.getIndex = (req, res, next) => {
  res.render("shop/index");
};

exports.getProducts = (req, res, next) => {
  Product.getAll()
    .then((products) => {
      res.render("shop/products", {
        products: products,
      });
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getAddProduct = (req, res, next) => {
  res.render("shop/add-product");
};

exports.postAddProduct = (req, res, next) => {
  const product = new Product();

  product.name = req.body.name;
  product.price = req.body.price;
  product.description = req.body.description;

  product
    .saveProduct()
    .then(() => {
      res.redirect("/products");
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getEditProduct = (req, res, next) => {
  Product.getById(req.params.productid)
    .then((product) => {
      res.render("shop/edit-product", {
        product: product[0],
      });
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.postEditProduct = (req, res, next) => {
  const product = new Product();
  product.id = req.body.id;
  product.name = req.body.name;
  product.price = req.body.price;
  product.description = req.body.description;

  Product.Update(product)
    .then(() => {
      res.redirect("/products");
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.postDeleteProduct = (req, res, next) => {
  Product.DeleteById(req.body.productid)
    .then(() => {
      res.redirect("/products");
    })
    .catch((err) => {
      console.log(err);
    });
};
