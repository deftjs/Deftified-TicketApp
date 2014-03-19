###
This controller manages the User details view which are added as tabs (so multiple
instances are created). Each instance of the view creates an instance of this class to
control its behavior.
###
Ext.define "Ticket.view.ticket.DetailController",
  extend: "Ext.app.ViewController"
  alias: "controller.ticketdetail"
  onSaveClick: ->
    form = @getReference("form")
    rec = undefined
    session = undefined
    batch = undefined
    if form.isValid()
      session = @getSession()
      rec = @getViewModel().getData().theTicket
      session.add rec  unless session.contains(rec)
      batch = session.getSaveBatch()
      if batch
        
        #TODO Use Ext.Msg.progress to display something while the Batch is saving.
        batch.start()
      else
        Ext.Msg.show
          title: "Save"
          message: "No changes to save"
          icon: Ext.Msg.INFO
          buttons: Ext.Msg.OK

    return

