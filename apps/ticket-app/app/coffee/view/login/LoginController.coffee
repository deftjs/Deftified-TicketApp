###
This View Controller is associated with the Login view.
###
Ext.define "Ticket.view.login.LoginController",
  extend: "Ext.app.ViewController"
  alias: "controller.login"
  loginText: "Logging in..."
  constructor: ->
    @callParent arguments_
    @loginManager = new Ticket.LoginManager(
      session: @session
      model: "User"
    )
    return

  onSpecialKey: (field, e) ->
    @doLogin()  if e.getKey() is e.ENTER
    return

  onLoginClick: ->
    @doLogin()
    return

  doLogin: ->
    form = @getReference("form")
    if form.isValid()
      Ext.getBody().mask @loginText
      @loginManager.login
        data: form.getValues()
        scope: this
        success: "onLoginSuccess"
        failure: "onLoginFailure"

    return

  onLoginFailure: ->
    
    # Do something
    Ext.getBody().unmask()
    return

  onLoginSuccess: (user) ->
    Ext.getBody().unmask()
    org = @getReference("organization").getSelectedRecord()
    
    ###
    @event login
    @param {Ticket.view.login.LoginController} sender The controller firing the event.
    @param {Ticket.model.User} user The record for the logged in User.
    @param {Ticket.model.Organization} organization The Organization for the User.
    @param {Ticket.LoginManager} loginManager The instance managing the login.
    ###
    @fireEvent "login", this, user, org, @loginManager
    return

