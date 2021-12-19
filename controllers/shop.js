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

exports.getPizza = (req, res, next) => {
  Product.getPizza(req.params.productid)
    .then((pizza) => {
      res.render("shop/pizza", {
        pizza: pizza[0],
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
  product.telefonNo = req.body.telefonNo;
  product.adres = req.body.adres;
  product.pizzaTercihi = req.body.pizzaSecenek;
  product.hamurTuru = req.body.hamurId;
  product.sosTuru = req.body.sosId;
  product.boyut = req.body.boyutId;
  product.peynirMiktari = req.body.peynirId;
  product.kenarTuru = req.body.kenarId;
  product.odemeTuru = req.body.odemeId;
  product.teslimatTuru = req.body.teslimatId;
  product.sube = req.body.subeId;
  product.personelId = req.body.personelId;
  product.ucret = req.body.ucret;

  product
    .saveCustomer()
    .then(() => {
      product
        .savePizza()
        .then(() => {
          product
            .saveOrder()
            .then(() => {
              res.redirect("/products");
            })
            .catch((err) => {
              console.log(err);
            });
        })
        .catch((err) => {
          console.log(err);
        });
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
  product.musteriId = req.body.musteriId;
  product.name = req.body.name;
  product.telefonNo = req.body.telefonNo;
  product.adres = req.body.adres;

  Product.Update(product)
    .then(() => {
      res.redirect("/products");
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.postDeleteProduct = (req, res, next) => {
  Product.DeleteOrder(req.body.productid)
    .then(() => {
      Product.DeletePizza(req.body.productid)
        .then(() => {
          Product.DeleteCustomer(req.body.musteriId)
            .then(() => {
              res.redirect("/products");
            })
            .catch((err) => {
              console.log(err);
            });
        })
        .catch((err) => {
          console.log(err);
        });
    })
    .catch((err) => {
      console.log(err);
    });
};
