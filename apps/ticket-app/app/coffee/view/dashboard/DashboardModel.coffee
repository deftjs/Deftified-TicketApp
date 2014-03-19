Ext.define "Ticket.view.dashboard.DashboardModel",
  extend: "Ext.app.ViewModel"
  alias: "viewmodel.dashboard"
  formulas:
    theProject: (data) ->
      data.projects.selection

    projectId: (data) ->
      data.theProject.id

    hasProject: (data) ->
      !!data.theProject

  stores:
    ticketStatusSummary:
      fields: [
        "id"
        "g1"
        "name"
      ]
      data: [
        {
          id: 1
          g1: 2
          name: "Item-1"
        }
        {
          id: 2
          g1: 1
          name: "Item-2"
        }
        {
          id: 3
          g1: 3
          name: "Item-3"
        }
        {
          id: 4
          g1: 5
          name: "Item-4"
        }
        {
          id: 5
          g1: 8
          name: "Item-5"
        }
      ]


    # TODO: fix store binding for charts
    xticketStatusSummary:
      model: "TicketStatusSummary"
      autoLoad: true
      remoteFilter: true
      filters: [
        property: "projectId"
        value: "{projectId}"
      ]

    ticketOpenSummary:
      fields: [
        "total"
        "date"
      ]
      data: (->
        data = []
        eDate = Ext.Date
        start = eDate.subtract(new Date(), eDate.DAY, 20)
        i = undefined
        i = 0
        while i < 20
          data.push
            total: Ext.Number.randomInt(5, 10)
            date: start

          start = eDate.add(start, eDate.DAY, 1)
          ++i
        data
      )()


    # TODO: fix store binding for charts
    xticketOpenSummary:
      model: "TicketOpenSummary"
      autoLoad: true
      remoteFilter: true
      filters: [
        property: "projectId"
        value: "{projectId}"
      ]

    myActiveTickets:
      model: "Ticket"
      autoLoad: true
      remoteFilter: true
      filters: [
        {
          property: "assigneeId"
          value: "{currentUser.id}"
        }
        {
          property: "projectId"
          value: "{projectId}"
        }
        {
          property: "status"
          value: 2
        }
      ]


#
#         * TODO: tethered stores
#        ,
#        sortedUsers: {
#            data: '{projects.selection.users}',
#            sorters: [{
#                property: 'name',
#                direction: 'DESC'
#            }]
#        }
#
