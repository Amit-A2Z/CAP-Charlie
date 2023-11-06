using {sap.capire.bookshop as my} from '../db/schema';

service CatalogService {

  /**
   * For displaying lists of Books
   */
  @readonly
  entity ListOfBooks as projection on Books excluding {
    descr
  };

  /**
   * For display in details pages
   */
  @readonly
  entity Books       as projection on my.Books {
    *,
    author.name as author
  } excluding {
    createdBy,
    modifiedBy
  };

  @requires: 'authenticated-user'
  action submitOrder(book : Books:ID, quantity : Integer) returns {
    stock : Integer
  };

  event OrderedBook : {
    book     : Books:ID;
    quantity : Integer;
    buyer    : String
  };
};

@protocol: 'none' // Domain services are internal and not exposed
service BookDomainService {
  entity Book        as projection on my.Books;
};

service RiskService {
  entity Risks       as projection on my.Risks;
  annotate Risks with @odata.draft.enabled;
  entity Mitigations as projection on my.Mitigations;
  annotate Mitigations with @odata.draft.enabled;
};
