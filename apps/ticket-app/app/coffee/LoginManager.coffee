###
This class manages the login process.
###
Ext.define "Ticket.LoginManager",
  config:
    
    ###
    @cfg {Class} model
    The model class from which to create the "user" record from the login.
    ###
    model: null
    
    ###
    @cfg {Ext.data.session.Session} session
    ###
    session: null

  constructor: (config) ->
    @initConfig config
    return

  applyModel: (model) ->
    model and Ext.data.schema.Schema.lookupEntity(model)

  login: (options) ->
    Ext.Ajax.request
      url: "/authenticate"
      method: "GET"
      params: options.data
      scope: this
      callback: @onLoginReturn
      original: options

    return

  onLoginReturn: (options, success, response) ->
    options = options.original
    session = @getSession()
    resultSet = undefined
    if success
      resultSet = @getModel().getProxy().getReader().read(response,
        recordCreator: (if session then session.recordCreator else null)
      )
      if resultSet.getSuccess()
        Ext.callback options.success, options.scope, [resultSet.getRecords()[0]]
        return
    Ext.callback options.failure, options.scope, [
      response
      resultSet
    ]
    return

