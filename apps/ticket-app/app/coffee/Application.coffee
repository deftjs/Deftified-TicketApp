###
The Application class just links up the main controller and our simulated data.
###
Ext.define "Ticket.Application",
  extend: "Ext.app.Application"
  controllers: ["Root@Ticket.controller"]
  onBeforeLaunch: ->
    
    # All smoke-and-mirrors with data happens in SimData. This is a fake server that
    # runs in-browser and intercepts the various Ajax requests a real app would make
    # to a real server.
    Ticket.SimData.init()
    @callParent()
    return

