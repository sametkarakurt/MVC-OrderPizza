const client = require("../utility/database");

client.connect();

module.exports = class Product {
  constructor(name, price, description) {
    this.id = (Math.floor(Math.random() * 99999) + 1).toString();
    this.name = name;
    this.price = price;
    this.description = description;
  }

  saveProduct() {
    console.log(this.id);
    return client
      .query(
        "INSERT INTO products (id, name, price, description) VALUES ($1, $2, $3, $4)",
        [this.id, this.name, this.price, this.description]
      )
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getAll() {
    return client
      .query("SELECT * FROM products")
      .then((result) => {
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getById(id) {
    return client
      .query("SELECT * FROM products WHERE products.id=$1", [id])
      .then((result) => {
        console.log(result.rows);
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static Update(product) {
    return client
      .query(
        "UPDATE products SET name=$1,price=$2,description=$3 WHERE id=$4",
        [product.name, product.price, product.description, product.id]
      )
      .then((result) => {
        console.log(result.rows);
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static DeleteById(id) {
    return client
      .query("DELETE FROM products WHERE id=$1", [id])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }
};
