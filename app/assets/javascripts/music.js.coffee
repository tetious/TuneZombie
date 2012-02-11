require ["dijit/layout/BorderContainer",
  "dijit/layout/TabContainer",
  "dijit/layout/ContentPane",
  "dojo/parser",
  "dojo/store/JsonRest",
  "dojox/grid/DataGrid",
  "dojo/data/ObjectStore",
  "dojo/domReady!"
]

jquery ->
  @store = new JsonRest target: "tracks/"

  @grid = new DataGrid  {
    store: dataStore = @store
    structure: [
      {name: "#", field: "number"}
      {name: "Name", field: "name"}
      {name: "Name", field: "name"}
    ]
  }



