Ext.define "Ticket.view.user.GroupController",
  extend: "Ext.app.ViewController"
  alias: "controller.user-group"
  onAddGroup: ->
    me = this
    Ext.Msg.prompt "Add Group", "Group name", (action, value) ->
      if action is "ok"
        session = me.getSession()
        viewModel = me.getViewModel()
        groups = undefined
        group = session.createRecord("Group",
          name: value
        )
        groups = viewModel.getData().currentOrg.groups()
        groups.add group
      return

    return

