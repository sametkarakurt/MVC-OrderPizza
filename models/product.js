const client = require("../utility/database");

client.connect();

module.exports = class Product {
  constructor(
    name,
    telNo,
    adres,
    pizzaTercihi,
    hamurTuru,
    sosTuru,
    boyut,
    peynirMiktari,
    kenarTuru,
    odemeTuru,
    teslimatTuru,
    sube,
    personelId,
    ucret
  ) {
    this.musteriId = (Math.floor(Math.random() * 9999999) + 1).toString();
    this.name = name;
    this.telefonNo = telNo;
    this.adres = adres;
    this.pizzaId = (Math.floor(Math.random() * 9999999) + 1).toString();
    this.pizzaTercihi = pizzaTercihi;
    this.hamurTuru = hamurTuru;
    this.sosTuru = sosTuru;
    this.boyut = boyut;
    this.peynirMiktari = peynirMiktari;
    this.kenarTuru = kenarTuru;
    this.siparisId = (Math.floor(Math.random() * 9999999) + 1).toString();
    this.odemeTuru = odemeTuru;
    this.teslimatTuru = teslimatTuru;
    this.sube = sube;
    this.personelId = this.personelId;
    this.ucret = ucret;
  }

  saveCustomer() {
    return client
      .query("CALL save_customer($1,$2,$3,$4)", [
        this.musteriId,
        this.name,
        this.telefonNo,
        this.adres,
      ])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  savePizza() {
    return client
      .query("CALL save_pizza($1, $2, $3, $4, $5, $6, $7)", [
        this.pizzaId,
        this.pizzaTercihi,
        this.hamurTuru,
        this.sosTuru,
        this.boyut,
        this.peynirMiktari,
        this.kenarTuru,
      ])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  saveOrder() {
    return client
      .query("CALL save_order($1, $2, $3, $4, $5, $6, $7, $8)", [
        this.siparisId,
        this.musteriId,
        this.odemeTuru,
        this.teslimatTuru,
        this.sube,
        this.personelId,
        this.ucret,
        this.pizzaId,
      ])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getAll() {
    return client
      .query("SELECT * FROM getAll();")
      .then((result) => {
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getById(id) {
    return client
      .query("SELECT * FROM getMusteri($1)", [id])
      .then((result) => {
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getPizza(id) {
    return client
      .query("SELECT * FROM getPizza($1)", [id])
      .then((result) => {
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static Update(product) {
    return client.query("CALL update($1,$2,$3,$4)", [
      product.name,
      product.telefonNo,
      product.adres,
      product.musteriId,
    ]);
  }

  static DeleteOrder(id) {
    return client
      .query("SELECT deleteOrder($1);", [id])
      .then((result) => {
        return result.rows[0];
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static DeletePizza(id) {
    return client
      .query(
        "DELETE FROM pizza where pizza_id=(SELECT pizza_id FROM siparis WHERE siparis_id = $1)",
        [id]
      )
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static DeleteCustomer(id) {
    return client

      .query("DELETE FROM musteri WHERE musteri_id = $1", [id])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }
};
