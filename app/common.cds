/*
 Common Annotations shared by all apps
*/
using {sap.capire.bookshop as my} from '../db/schema';
using {RiskService} from '../srv/cat-service.cds';
using RiskService as service from '../srv/risk-analysis-service';
using {
  sap.common,
  sap.common.Currencies
} from '@sap/cds/common';

////////////////////////////////////////////////////////////////////////////
//
//	Books Lists
//
annotate my.Books with @(
  Common.SemanticKey: [ID],
  UI                : {
    Identification : [{Value: title}],
    SelectionFields: [
      ID,
      author_ID,
      price,
      currency_code
    ],
    LineItem       : [
      {
        Value: ID,
        Label: '{i18n>Title}'
      },
      {
        Value: author.ID,
        Label: '{i18n>Author}'
      },
      {Value: genre.name},
      {Value: stock},
      {Value: price},
      {Value: currency.symbol},
    ]
  }
) {
  ID     @Common          : {
    SemanticObject : 'Books',
    Text           : title,
    TextArrangement: #TextOnly
  };
  author @ValueList.entity: 'Authors';
};

annotate Currencies with {
  symbol @Common.Label: '{i18n>Currency}';
}

////////////////////////////////////////////////////////////////////////////
//
//	Books Details
//
annotate my.Books with @(UI: {HeaderInfo: {
  TypeName      : '{i18n>Book}',
  TypeNamePlural: '{i18n>Books}',
  Title         : {Value: title},
  Description   : {Value: author.name}
}, });


////////////////////////////////////////////////////////////////////////////
//
//	Books Elements
//
annotate my.Books with {
  ID      @title: '{i18n>ID}';
  title   @title: '{i18n>Title}';
  genre   @title: '{i18n>Genre}'        @Common              : {
    Text           : genre.name,
    TextArrangement: #TextOnly
  };
  author  @title: '{i18n>Author}'       @Common              : {
    Text           : author.name,
    TextArrangement: #TextOnly
  };
  price   @title: '{i18n>Price}'        @Measures.ISOCurrency: currency_code;
  stock   @title: '{i18n>Stock}';
  descr   @title: '{i18n>Description}'  @UI.MultiLineText;
  image   @title: '{i18n>Image}';
}

////////////////////////////////////////////////////////////////////////////
//
//	Genres List
//
annotate my.Genres with @(
  Common.SemanticKey: [name],
  UI                : {
    SelectionFields: [name],
    LineItem       : [
      {Value: name},
      {
        Value: parent.name,
        Label: 'Main Genre'
      },
    ],
  }
);

annotate my.Genres with {
  ID  @Common.Text: name  @Common.TextArrangement: #TextOnly;
}

////////////////////////////////////////////////////////////////////////////
//
//	Genre Details
//
annotate my.Genres with @(UI: {
  Identification: [{Value: name}],
  HeaderInfo    : {
    TypeName      : '{i18n>Genre}',
    TypeNamePlural: '{i18n>Genres}',
    Title         : {Value: name},
    Description   : {Value: ID}
  },
  Facets        : [{
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>SubGenres}',
    Target: 'children/@UI.LineItem'
  }, ],
});

////////////////////////////////////////////////////////////////////////////
//
//	Genres Elements
//
annotate my.Genres with {
  ID   @title: '{i18n>ID}';
  name @title: '{i18n>Genre}';
}

////////////////////////////////////////////////////////////////////////////
//
//	Authors List
//
annotate my.Authors with @(
  Common.SemanticKey: [ID],
  UI                : {
    Identification : [{Value: name}],
    SelectionFields: [name],
    LineItem       : [
      {Value: ID},
      {Value: dateOfBirth},
      {Value: dateOfDeath},
      {Value: placeOfBirth},
      {Value: placeOfDeath},
    ],
  }
) {
  ID @Common: {
    SemanticObject : 'Authors',
    Text           : name,
    TextArrangement: #TextOnly,
  };
};

////////////////////////////////////////////////////////////////////////////
//
//	Author Details
//
annotate my.Authors with @(UI: {
  HeaderInfo: {
    TypeName      : '{i18n>Author}',
    TypeNamePlural: '{i18n>Authors}',
    Title         : {Value: name},
    Description   : {Value: dateOfBirth}
  },
  Facets    : [{
    $Type : 'UI.ReferenceFacet',
    Target: 'books/@UI.LineItem'
  }],
});


////////////////////////////////////////////////////////////////////////////
//
//	Authors Elements
//
annotate my.Authors with {
  ID           @title: '{i18n>ID}';
  name         @title: '{i18n>Name}';
  dateOfBirth  @title: '{i18n>DateOfBirth}';
  dateOfDeath  @title: '{i18n>DateOfDeath}';
  placeOfBirth @title: '{i18n>PlaceOfBirth}';
  placeOfDeath @title: '{i18n>PlaceOfDeath}';
}

////////////////////////////////////////////////////////////////////////////
//
//	Languages List
//
annotate common.Languages with @(
  Common.SemanticKey: [code],
  Identification    : [{Value: code}],
  UI                : {
    SelectionFields: [
      name,
      descr
    ],
    LineItem       : [
      {Value: code},
      {Value: name},
    ],
  }
);

////////////////////////////////////////////////////////////////////////////
//
//	Language Details
//
annotate common.Languages with @(UI: {
  HeaderInfo         : {
    TypeName      : '{i18n>Language}',
    TypeNamePlural: '{i18n>Languages}',
    Title         : {Value: name},
    Description   : {Value: descr}
  },
  Facets             : [{
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>Details}',
    Target: '@UI.FieldGroup#Details'
  }, ],
  FieldGroup #Details: {Data: [
    {Value: code},
    {Value: name},
    {Value: descr}
  ]},
});

////////////////////////////////////////////////////////////////////////////
//
//	Currencies List
//
annotate common.Currencies with @(
  Common.SemanticKey: [code],
  Identification    : [{Value: code}],
  UI                : {
    SelectionFields: [
      name,
      descr
    ],
    LineItem       : [
      {Value: descr},
      {Value: symbol},
      {Value: code},
    ],
  }
);

////////////////////////////////////////////////////////////////////////////
//
//	Currency Details
//
annotate common.Currencies with @(UI: {
  HeaderInfo         : {
    TypeName      : '{i18n>Currency}',
    TypeNamePlural: '{i18n>Currencies}',
    Title         : {Value: descr},
    Description   : {Value: code}
  },
  Facets             : [{
    $Type : 'UI.ReferenceFacet',
    Label : '{i18n>Details}',
    Target: '@UI.FieldGroup#Details'
  }],
  FieldGroup #Details: {Data: [
    {Value: name},
    {Value: symbol},
    {Value: code},
    {Value: descr}
  ]}
});

annotate RiskService.Risks with {
  title  @title: 'Title';
  prio   @title: 'Priority';
  descr  @title: 'Description';
  miti   @title: 'Mitigation';
  impact @title: 'Impact';
}

annotate RiskService.Mitigations with {
  ID          @(
    UI.Hidden,
    Common: {Text: description}
  );
  description @title: 'Description';
  owner       @title: 'Owner';
  timeline    @title: 'Timeline';
  risks       @title: 'Risks';
}

annotate RiskService.Risks with @(UI: {
  HeaderInfo      : {
    TypeName      : 'Risk',
    TypeNamePlural: 'Risks',
    Title         : {
      $Type: 'UI.DataField',
      Value: title
    },
    Description   : {
      $Type: 'UI.DataField',
      Value: descr
    }
  },
  SelectionFields : [prio],
  LineItem        : [
    {Value: title},
    {Value: miti_ID},
    {
      Value      : prio,
      Criticality: criticality
    },
    {
      Value      : impact,
      Criticality: criticality
    }
  ],
  Facets          : [{
    $Type : 'UI.ReferenceFacet',
    Label : 'Main',
    Target: '@UI.FieldGroup#Main'
  }],
  FieldGroup #Main: {Data: [
    {Value: miti_ID},
    {
      Value      : prio,
      Criticality: criticality
    },
    {
      Value      : impact,
      Criticality: criticality
    }
  ]}
}, ) {

};

annotate RiskService.Risks with {
  miti @(Common: {
    //show text, not id for mitigation in the context of risks
    Text           : miti.description,
    TextArrangement: #TextOnly,
    ValueList      : {
      Label         : 'Mitigations',
      CollectionPath: 'Mitigations',
      Parameters    : [
        {
          $Type            : 'Common.ValueListParameterInOut',
          LocalDataProperty: miti_ID,
          ValueListProperty: 'ID'
        },
        {
          $Type            : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'description'
        }
      ]
    }
  });
}

annotate service.RisksAnalysis with {
  ID        @ID   : 'ID';
  title     @title: 'Title';
  descr     @title: 'Description';
  createdAt @title: 'Creation Date';
  prio      @title: 'Priority';
  impact    @title: 'Impact';
  riskyear  @title: 'Year';
};

annotate service.RisksAnalysis with @(
  Common.SemanticKey: [ID],
  UI.LineItem       : {$value: [
    {
      $Type             : 'UI.DataField',
      Value             : title,
      ![@UI.Importance] : #High,
    },
    {
      $Type             : 'UI.DataField',
      Value             : descr,
      ![@UI.Importance] : #High,
    },
    {
      $Type             : 'UI.DataField',
      Value             : createdAt,
      ![@UI.Importance] : #High,
    },
    {
      $Type             : 'UI.DataField',
      Value             : prio,
      ![@UI.Importance] : #High,
    },
    {
      $Type             : 'UI.DataField',
      Value             : impact,
      ![@UI.Importance] : #High,
    },
  ], },
);

annotate service.RisksAnalysis with @(Aggregation.ApplySupported: {
  Transformations       : [
    'aggregate',
    'topcount',
    'bottomcount',
    'identity',
    'concat',
    'groupby',
    'filter',
    'expand',
    'top',
    'skip',
    'orderby',
    'search'
  ],
  Rollup                : #None,
  PropertyRestrictions  : true,
  GroupableProperties   : [
    title,
    descr,
    createdAt,
    impact,
    prio,
    riskyear,
  ],
  AggregatableProperties: [
    {Property: prio, },
    {Property: impact, },
    {Property: createdAt, },
    {Property: ID, }
  ],
});

annotate service.RisksAnalysis with @(Analytics.AggregatedProperties: [
  {
    Name                : 'minAmount',
    AggregationMethod   : 'min',
    AggregatableProperty: 'impact',
    ![@Common.Label]    : 'Minimal Impact'
  },
  {
    Name                : 'maxAmount',
    AggregationMethod   : 'max',
    AggregatableProperty: 'impact',
    ![@Common.Label]    : 'Maximal Impact'
  },
  {
    Name                : 'avgAmount',
    AggregationMethod   : 'average',
    AggregatableProperty: 'impact',
    ![@Common.Label]    : 'Average Impact'
  },
  {
    Name                : 'sumImpact',
    AggregationMethod   : 'sum',
    AggregatableProperty: 'impact',
    ![@Common.Label]    : 'Total Cost Impact'
  },
  {
    Name                : 'countRisk',
    AggregationMethod   : 'countdistinct',
    AggregatableProperty: 'ID',
    ![@Common.Label]    : 'Number of Risks'
  },
  {
    Name                : 'countRiskYear',
    AggregationMethod   : 'countdistinct',
    AggregatableProperty: 'riskyear',
    ![@Common.Label]    : 'Number of Risks Per Year'
  },
], );

annotate service.RisksAnalysis with @(UI.Chart: {
  Title              : 'Risk Impacts',
  ChartType          : #Column,
  Measures           : [sumImpact],
  Dimensions         : [riskyear],
  MeasureAttributes  : [{
    $Type  : 'UI.ChartMeasureAttributeType',
    Measure: sumImpact,
    Role   : #Axis1
  }],
  DimensionAttributes: [
    {
      $Type    : 'UI.ChartDimensionAttributeType',
      Dimension: riskyear,
      Role     : #Category
    },
    {
      $Type    : 'UI.ChartDimensionAttributeType',
      Dimension: prio,
      Role     : #Category
    },
  ],
}, );

annotate service.RisksAnalysis with @(
  UI.PresentationVariant #pvPrio: {
    SortOrder     : [{
      $Type     : 'Common.SortOrderType',
      Property  : impact,
      Descending: true
    }, ],
    Visualizations: ['@UI.Chart#chartPrio']
  },
  UI.SelectionVariant #svPrio   : {SelectOptions: [{
    $Type       : 'UI.SelectOptionType',
    PropertyName: impact,
    Ranges      : [{
      $Type : 'UI.SelectionRangeType',
      Sign  : #I,
      Option: #GE,
      Low   : 0,
    }, ],
  }, ], },
  UI.Chart #chartPrio           : {
    $Type              : 'UI.ChartDefinitionType',
    ChartType          : #Bar,
    Dimensions         : [prio],
    DimensionAttributes: [{
      $Type    : 'UI.ChartDimensionAttributeType',
      Dimension: prio,
      Role     : #Category
    }],
    Measures           : [sumImpact],
    MeasureAttributes  : [{
      $Type    : 'UI.ChartMeasureAttributeType',
      Measure  : sumImpact,
      Role     : #Axis1,
      DataPoint: '@UI.DataPoint#dpPrio',
    }]
  },
  UI.DataPoint #dpPrio          : {
    Value: impact,
    Title: 'Impact'
  },
) {
  prio @(Common.ValueList #vlPrio: {
    Label                       : 'Priority',
    CollectionPath              : 'RisksAnalysis',
    SearchSupported             : true,
    PresentationVariantQualifier: 'pvPrio',
    SelectionVariantQualifier   : 'svPrio',
    Parameters                  : [{
      $Type            : 'Common.ValueListParameterInOut',
      LocalDataProperty: prio,
      ValueListProperty: 'prio'
    }, ]
  });
};

annotate service.RisksAnalysis with @(
  UI.PresentationVariant #pvPeriod: {
    Text          : 'FilterRisksOverPeriodPV',
    SortOrder     : [{
      $Type     : 'Common.SortOrderType',
      Property  : createdAt,
      Descending: true
    }, ],
    Visualizations: ['@UI.Chart#chartPeriod']
  },
  UI.Chart #chartPeriod           : {
    $Type              : 'UI.ChartDefinitionType',
    Title              : 'Risks Over Period',
    ChartType          : #Line,
    Dimensions         : [createdAt],
    DimensionAttributes: [{
      $Type    : 'UI.ChartDimensionAttributeType',
      Dimension: createdAt,
      Role     : #Category
    }],
    Measures           : [countRisk],
    MeasureAttributes  : [{
      $Type    : 'UI.ChartMeasureAttributeType',
      Measure  : countRisk,
      Role     : #Axis1,
      DataPoint: '@UI.DataPoint#dpPeriod',
    }]
  },
  UI.DataPoint #dpPeriod          : {
    Value: createdAt,
    Title: 'Creation Date'
  },
) {
  createdAt @(Common.ValueList #vlcreatedAt: {
    Label                       : 'Creation Date',
    CollectionPath              : 'RisksAnalysis',
    SearchSupported             : true,
    PresentationVariantQualifier: 'pvPeriod',
    Parameters                  : [{
      $Type            : 'Common.ValueListParameterInOut',
      LocalDataProperty: createdAt,
      ValueListProperty: 'createdAt'
    }, ]
  });
};
