###
This class is the View Model for the ticket search view.
###
Ext.define "Ticket.view.ticket.SearchModel",
  extend: "Ext.app.ViewModel"
  alias: "viewmodel.ticketsearch"
  data:
    defaultStatus: 2

  formulas:
    defaultUser: (data) ->
      if data.currentUser.get("projectId") is data.theProject.getId()
        data.currentUser.getId()
      else
        data.theProject.get "leadId"

  stores:
    tickets:
      model: "Ticket"
      autoLoad: true
      remoteFilter: true
      filters: [
        {
          property: "status"
          value: "{statusField.value}"
        }
        {
          property: "assigneeId"
          value: "{assigneeField.value}"
        }
        {
          property: "projectId"
          value: "{theProject.id}"
        }
      ]

    statuses:
      fields: [
        "id"
        "name"
      ]
      data: [
        {
          id: -1
          name: "-- All --"
        }
        {
          id: 1
          name: "Pending"
        }
        {
          id: 2
          name: "Open"
        }
        {
          id: 3
          name: "Closed"
        }
      ]

