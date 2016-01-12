if Meteor.isServer
  Meteor.startup ->
    if not process.env.elasticsearchHost? and not Meteor.settings.elasticsearchHost?
      throw log.error("elasticsearch host was not set, you must set it up!!!")
    else
      Meteor.settings.elasticsearchHost = process.env.elasticsearchHost or Meteor.settings.elasticsearchHost

    if not process.env.logitHost? and not Meteor.settings.logit?
      log.warn "logit host wasn't set. Logging into console only"
    else
      Meteor.settings.logit =
        host: process.env.logitHost or Meteor.settings.logit.host
        port: process.env.logitPort or Meteor.settings.logit.port

  Meteor.startup ->
    ESresponse = Mongo2ES::getStatusForES({ host: Meteor.settings.elasticsearchHost })
    if ESresponse.statusCode isnt 200
      throw log.error(new Meteor.Error("bad ES response, exiting...", null, JSON.stringify(ESresponse)))
