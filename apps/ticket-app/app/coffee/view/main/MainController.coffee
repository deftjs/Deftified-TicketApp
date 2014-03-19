Ext.define "Ticket.view.main.MainController",
  extend: "Ext.app.ViewController"
  alias: "controller.main"
  listen:
    controller:
      dashboard:
        edituser: "onEditUser"
        viewticket: "onViewTicket"

      ticketsearch:
        viewticket: "onViewTicket"

  createTab: (prefix, rec, cfg) ->
    tabs = @getReference("main")
    id = prefix + "_" + rec.getId()
    tab = tabs.items.getByKey(id)
    unless tab
      cfg.itemId = id
      cfg.closable = true
      tab = tabs.add(cfg)
    tabs.setActiveTab tab
    return

  editUser: (userRecord) ->
    win = new Ticket.view.user.User(viewModel:
      data:
        theUser: userRecord
    )
    win.show()
    return

  onClickUserName: ->
    data = @getViewModel().getData()
    @editUser data.currentUser
    return

  onEditUser: (ctrl, rec) ->
    @editUser rec
    return

  onProjectSelect: ->
    tabs = @getReference("main")
    tabs.setActiveTab 0
    return

  onProjectSearchClick: (view, rowIdx, colIdx, item, e, rec) ->
    @createTab "project", rec,
      xtype: "ticketsearch"
      viewModel:
        data:
          theProject: rec

    return

  onViewTicket: (ctrl, rec) ->
    @createTab "ticket", rec,
      xtype: "ticketdetail"
      session: new Ext.data.session.Session(data: [rec])
      viewModel:
        data:
          theTicket: rec

    return

