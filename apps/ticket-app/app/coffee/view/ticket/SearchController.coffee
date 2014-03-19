Ext.define "Ticket.view.ticket.SearchController",
  extend: "Ext.app.ViewController"
  alias: "controller.ticketsearch"
  onTicketClick: (view, rowIdx, colIdx, item, e, rec) ->
    @fireEvent "viewticket", this, rec
    return

  onRefreshClick: ->
    @getView().getStore().load()
    return

  renderAssignee: (v, meta, rec) ->
    rec.getAssignee().get "name"

  renderCreator: (v, meta, rec) ->
    rec.getCreator().get "name"

  renderStatus: (v) ->
    Ticket.model.Ticket.getStatusName v

