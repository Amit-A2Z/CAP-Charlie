const cds = require("@sap/cds");
const { Books } = cds.entities("sap.capire.bookshop");

class CatalogService extends cds.ApplicationService {
  init() {
    // Reduce stock of ordered books if available stock suffices
    this.on("submitOrder", async (req) => {
      const { book, quantity } = req.data;
      let { stock } = await SELECT`stock`.from(Books, book);
      if (stock >= quantity) {
        await UPDATE(Books, book).with(`stock -=`, quantity);
        await this.emit("OrderedBook", { book, quantity, buyer: req.user.id });
        return { stock };
      } else
        return req.error(409, `${quantity} exceeds stock for book #${book}`);
    });

    // Add some discount for overstocked books
    this.after("READ", "ListOfBooks", (each) => {
      if (each.stock > 111) each.title += ` -- 11% discount!`;
    });

    return super.init();
  }
}

class RiskService extends cds.ApplicationService {
  init() {
    this.after("READ", "Risks", (risksData) => {
      const risks = Array.isArray(risksData) ? risksData : [risksData];
      risks.forEach((risk) => {
        if (risk.impact >= 100000) {
          risk.criticality = 1;
        } else {
          risk.criticality = 2;
        }
      });
    });

    return super.init();
  }
}

module.exports = { CatalogService, RiskService };
