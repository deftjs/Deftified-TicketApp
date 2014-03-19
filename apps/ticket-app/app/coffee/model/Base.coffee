###
This class is the base class for all entities in the application.
###
Ext.define "Ticket.model.Base",
  extend: "Ext.data.Model"
  fields: [
    name: "id"
    type: "int"
  ]
  schema:
    api:
      fetchEntityUrlTpl: "{prefix}/{entityName:uncapitalize}"
      proxy:
        pageParam: ""
        startParam: ""
        limitParam: ""

