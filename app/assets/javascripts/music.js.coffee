require ["dijit/layout/BorderContainer"
  "dijit/layout/TabContainer"
  "dijit/layout/ContentPane"]

require ["dojo/store/JsonRest"
  "dojo/store/Memory"
  "dojo/store/Cache"
  "dojox/grid/DataGrid"
  "dojo/data/ObjectStore"
  "dojo/domReady!"],
  (JsonRest, Memory, Cache, DataGrid, ObjectStore) ->

    @store = new JsonRest({target:"tracks/"})
    @dataStore = new ObjectStore { objectStore: @store }

    @grid = new DataGrid({
      store: @dataStore
      structure: [
        {name: "#", field: "number"}
        {name: "Name", field: "name"}
        {name: "Time", field: "length"} #,formatter: (v)-> dojo.date.locale.format(new Date(v * 1000), {timePattern: "mm:ss", selector: "time"})}
      ]
    }, "track_list")

    #@grid.startup()


    #/t/nm/foo/lg/40/_and/a/nm/bar


