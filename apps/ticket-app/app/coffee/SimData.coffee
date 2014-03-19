Ext.define "Ticket.EntitySimlet",
  extend: "Ext.ux.ajax.JsonSimlet"
  alias: "simlet.entity"
  doPost: (ctx) ->
    result = @callParent(arguments_)
    o = @processData(Ext.decode(ctx.xhr.body))
    item = @getById(@data, o.id, true)
    key = undefined
    for key of o
      item[key] = o[key]
    result.responseText = Ext.encode(item)
    result

  processData: Ext.identityFn
  getData: (ctx) ->
    params = ctx.params
    return @getById(@data, params.id)  if "id" of params
    delete @currentOrder

    @callParent arguments_

  getById: (data, id) ->
    len = data.length
    i = undefined
    item = undefined
    i = 0
    while i < len
      item = data[i]
      return item  if item.id is id
      ++i
    null

Ext.define "Ticket.SimData",
  requires: ["Ext.ux.ajax.*"]
  singleton: true
  dateFormat: "Y-m-d\\TH:i:s\\Z"
  words: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.".replace(/[,\.]/g, "").split(" ")

  ###
  We have our own "random" method because we need consistency (for testing).
  ###
  random: (->
    modulus = 0x80000000 # 2^31
    multiplier = 1664525
    increment = 1013904223
    seed = 1103515245

    # simple LCG
    (min, max) ->
      seed = (multiplier * seed + increment) % modulus
      x = seed / (modulus - 1) # [0, 1]
      Math.floor x * (max - min + 1) + min
  ).call(@)
  sentence: (min, max) ->
    length = @random((if Ext.isDefined(min) then min else 10), max or 30)
    words = @words
    description = Ext.String.capitalize(words[@random(0, words.length - 1)])
    while length--
      description += " "
      description += words[@random(0, words.length - 1)]
    description += "."
    description

  paragraph: (count) ->
    length = count or @random(2, 5)
    ret = ""
    while length--
      ret += " "  if ret
      ret += @sentence()
    ret

  essay: (count) ->
    length = count or @random(1, 4)
    ret = ""
    while length--
      ret += "\n\n"  if ret
      ret += @paragraph()
    ret

  minDate: Ext.Date.subtract(new Date(), Ext.Date.MONTH, 6)
  maxDate: (+new Date())
  MILLIDAY: 60 * 60 * 24 * 1000
  randomDate: (maxDays) ->
    maxDays = maxDays or 180
    time = 1000 * @random(1, maxDays * @MILLIDAY / 1000)
    new Date(@minDate + time)

  nextDate: (date, scale) ->
    scale = scale or (2 / 3)
    time = date.getTime()
    remaining = @maxDate - time
    new Date(time + 1000 * @random(1, remaining * scale / 1000))

  init: ->
    # 5 days
    makeSim = (data) ->
      type: "entity"
      data: data
    makeMatrixFilter = (members) ->
      map = Ext.Array.toMap(members, "id")
      (r) ->
        r.id of map
    me = this
    dateFormat = me.dateFormat
    comments = []
    organizations = []
    projects = []
    tickets = []
    users = []
    groups = []
    groupNames = [
      "Admins"
      "Development"
      "QA"
      "Support"
      "Sales"
    ]
    groupsByUserId = {}
    usersByGroupId = {}
    usersByKey = {}
    data = Sencha:
      SDK: "Don,Alex,Ben,Evan,Kevin,Nige,Phil,Pierre,Ross,Tommy"
      IT: "Len,Ian,Mike,Ryan"

    Ext.Object.each data, (organizationName, projectsUsers) ->
      organizationId = organizations.length + 1
      organizations.push
        id: organizationId
        name: organizationName

      Ext.each groupNames, (name) ->
        groups.push
          id: groups.length + 1
          name: name
          organizationId: organizationId

        return

      Ext.Object.each projectsUsers, (projectName, projectUsers) ->
        projectId = projects.length + 1
        firstUserId = users.length + 1
        project =
          id: projectId
          name: projectName
          organizationId: 1
          leadId: firstUserId

        projectDate = me.randomDate(20)
        projects.push project
        Ext.Array.forEach projectUsers.split(","), (userName) ->
          id = users.length + 1
          user =
            id: id
            name: userName
            projectId: projectId
            organizationId: organizationId

          users.push user
          usersByKey[id] = user
          return

        count = me.random(100, 200)

        while count-- > 0
          projectDate = me.nextDate(projectDate, 0.03)
          ticketId = tickets.length + 1
          date = projectDate
          modified = Ext.Date.add(date, Ext.Date.MINUTE, me.random(30, 7200))
          creatorId = me.random(firstUserId, users.length)
          assigneeId = me.random(firstUserId, users.length)
          tickets.push
            id: ticketId
            title: me.sentence(5, 15)
            description: me.essay()
            projectId: project.id
            creatorId: creatorId
            creator: Ext.apply({}, usersByKey[creatorId])
            assigneeId: assigneeId
            assignee: Ext.apply({}, usersByKey[assigneeId])
            created: Ext.Date.format(date, dateFormat)
            modified: Ext.Date.format(modified, dateFormat)
            status: me.random(1, 3)

          n = me.random(0, 3)

          while n-- > 0
            date = me.nextDate(date)
            userId = me.random(firstUserId, users.length)
            comments.push
              id: comments.length + 1
              text: me.paragraph()
              ticketId: ticketId
              userId: userId
              user: Ext.apply({}, usersByKey[userId])
              created: Ext.Date.format(date, dateFormat)

        return

      Ext.Array.forEach users, (user) ->
        all = groupsByUserId[user.id] = []
        totalGroups = groups.length
        numGroups = me.random(1, 3)
        group = undefined
        while all.length < numGroups
          group = groups[me.random(0, totalGroups - 1)]
          if Ext.Array.indexOf(all, group) is -1
            all.push group
            (usersByGroupId[group.id] or (usersByGroupId[group.id] = [])).push user
        return

      return

    Ext.ux.ajax.SimManager.init().register
      "/organization": makeSim(organizations)
      "/group": Ext.apply(
        processFilters: (filters) ->

          # User/Groups is a Many-to-many so Group does not have a field
          # to get groups by userId so we have to look in our internal
          # structure to provide this.
          Ext.each filters, (filter, index) ->
            filters[index] = makeMatrixFilter(groupsByUserId[filter.value])  if filter.property is "userId"
            return

          @self::processFilters.call this, filters
      , makeSim(groups))
      "/project": makeSim(projects)
      "/comment": makeSim(comments)
      "/ticket": Ext.apply(
        processData: (data) ->
          data.modified = Ext.Date.format(new Date(), dateFormat)
          data

        processFilters: (filters) ->
          status = Ext.Array.findBy(filters, (filter) ->
            filter.property is "status"
          )
          assignee = Ext.Array.findBy(filters, (filter) ->
            filter.property is "assigneeId"
          )
          Ext.Array.remove filters, status  if status and status.value is -1
          assignee.exactMatch = true  if assignee
          filters
      , makeSim(tickets))
      "/ticketStatusSummary":
        type: "json"
        data: (ctx) ->
          project = Ext.decode(ctx.params.filter)[0].value
          data = []
          totals = {}
          Ext.Array.forEach tickets, (ticket) ->
            status = undefined
            if ticket.projectId is project
              status = ticket.status
              totals[status] = 0  unless totals.hasOwnProperty(status)
              totals[status] += 1
            return

          Ext.Object.each totals, (key, value) ->
            data.push
              status: key
              total: value

            return

          data

      "/ticketOpenSummary":
        type: "json"
        data: (ctx) ->
          project = Ext.decode(ctx.params.filter)[0].value
          eDate = Ext.Date
          now = eDate.clearTime(new Date(), true)
          min = eDate.subtract(now, eDate.MONTH, 1)
          data = []
          totals = {}
          Ext.Array.forEach tickets, (ticket) ->
            created = undefined
            key = undefined
            if ticket.projectId is project
              created = Ext.Date.parse(ticket.created, "c")
              if created >= min
                key = Ext.Date.format(created, "Y-m-d")
                totals[key] = 0  unless totals.hasOwnProperty(key)
                totals[key] += 1
            return

          Ext.Object.each totals, (key, value) ->
            data.push
              id: project + key
              date: key
              total: value

            return

          data

      "/user": Ext.apply(
        processFilters: (filters) ->

          # User/Groups is a Many-to-many so User does not have a field
          # to get users by groupId so we have to look in our internal
          # structure to provide this.
          Ext.each filters, (filter, index) ->
            filters[index] = makeMatrixFilter(usersByGroupId[filter.value])  if filter.property is "groupId"
            return

          @self::processFilters.call this, filters
      , makeSim(users))
      "/authenticate":
        type: "json"
        data: (ctx) ->
          userName = ctx.params.username
          user = Ext.Array.findBy(users, (item) ->
            item.name is userName
          ) or users[0]
          Ext.apply {}, user

    return

