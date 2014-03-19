###
This global controller manages the login view and ensures that view is created when
the application is launched. Once login is complete we then create the main view.
###
Ext.define "Ticket.controller.Root",
  extend: "Ext.app.Controller"
  requires: [
    "Ticket.view.login.Login"
    "Ticket.view.main.Main"
    "Ticket.LoginManager"
  ]
  loadingText: "Loading..."
  listen:
    controller:
      
      # Listen for the LoginController ("controller.login" alias) to fire its
      # "login" event.
      login:
        login: "onLogin"

  onLaunch: ->
    session = @session = new Ext.data.session.Session()
    @login = new Ticket.view.login.Login(
      session: session
      autoShow: true
    )
    return

  
  ###
  Called when the login controller fires the "login" event.
  
  @param loginController
  @param user
  @param organization
  @param loginManager
  ###
  onLogin: (loginController, user, organization, loginManager) ->
    @login.destroy()
    @loginManager = loginManager
    @organization = organization
    @user = user
    @showUI()
    return

  showUI: ->
    @viewport = new Ticket.view.main.Main(
      session: @session
      viewModel:
        data:
          currentOrg: @organization
          currentUser: @user
    )
    return

  getSession: ->
    @session

