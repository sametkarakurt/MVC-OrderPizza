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
      .query("CALL save_pizza($1, $2, $3, $4, $5, $6)", [
        this.pizzaId,
        this.pizzaTercihi,
        this.hamurTuru,
        this.sosTuru,
        this.boyut,
        this.peynirMiktari,
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
      .query("CALL save_order($1, $2, $3, $4, $5, $6, $7)", [
        this.siparisId,
        this.musteriId,
        this.odemeTuru,
        this.teslimatTuru,
        this.sube,
        this.personelId,
        this.ucret,
      ])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  saveOrderPizza() {
    return client
      .query("CALL save_order_pizza($1, $2)", [this.pizzaId, this.siparisId])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  saveSide() {
    return client
      .query("CALL save_side($1, $2)", [this.siparisId, this.kenarTuru])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getAll() {
    return client
      .query(
        "SELECT * FROM musteri JOIN siparis ON musteri.musteri_id = siparis.musteri_id JOIN odeme on odeme.odeme_id = siparis.odeme_id JOIN teslimat on teslimat.teslimat_id = siparis.teslimat_id JOIN sube on sube.sube_id = siparis.sube_id JOIN personel on personel.personel_id = siparis.personel_id"
      )
      .then((result) => {
        console.log(result.rows);
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getById(id) {
    return client
      .query(
        "SELECT * FROM musteri JOIN siparis ON musteri.musteri_id = siparis.musteri_id WHERE siparis.siparis_id = $1",
        [id]
      )
      .then((result) => {
        return result.rows;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static getPizza(id) {
    return client
      .query(
        "SELECT * FROM pizza JOIN pizza_siparis on pizza.pizza_id = pizza_siparis.pizza_id JOIN siparis on siparis.siparis_id = pizza_siparis.siparis_id JOIN kenar_siparisi on kenar_siparisi.siparis_id = siparis.siparis_id JOIN kenar on kenar.kenar_id = kenar_siparisi.kenar_id JOIN hamur on hamur.hamur_id = pizza.hamur_id JOIN sos on sos.sos_id = pizza.sos_id JOIN boyut on boyut.boyut_id = pizza.boyut_id JOIN peynir on peynir.peynir_id = pizza.peynir_id JOIN pizza_secenekleri on pizza_secenekleri.pizza_secenek_id = pizza.pizza_secenek_id WHERE siparis.siparis_id = $1",
        [id]
      )
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

  static DeletePizzaOrder(id) {
    return client
      .query("DELETE FROM pizza_siparis WHERE pizza_siparis.siparis_id=$1", [
        id,
      ])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static DeleteSide(id) {
    return client
      .query("DELETE FROM kenar_siparisi WHERE kenar_siparisi.siparis_id=$1", [
        id,
      ])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static DeleteOrder(id) {
    return client
      .query("DELETE FROM siparis WHERE siparis.siparis_id=$1", [id])
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }

  static DeletePizza(id) {
    return client
      .query(
        "DELETE FROM pizza where pizza_id=(SELECT pizza_id FROM pizza_siparis WHERE siparis_id = $1)",
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
        console.log(id);
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  }
};
