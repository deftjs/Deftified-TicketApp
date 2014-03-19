Ext.define "Ticket.view.dashboard.DashboardController",
  extend: "Ext.app.ViewController"
  alias: "controller.dashboard"
  onGridEditClick: (btn) ->
    @fireEvent "edituser", this, btn.getWidgetRecord()
    return

  onTicketClick: (view, rowIdx, colIdx, item, e, rec) ->
    @fireEvent "viewticket", this, rec
    return

  onActiveTicketRefreshClick: ->
    @getReference("activeTickets").getStore().load()
    return

  renderTicketStatus: (v) ->
    Ticket.model.Ticket.getStatusName v

