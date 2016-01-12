# TODO - consider using collection hooks instead of observe
# https://atmospherejs.com/matb33/collection-hooks

class @Mongo2ES
  constructor: (@options, @transform, @copyAlreadyExistingData = false) ->
    self = @
    self.options.collectionName = self.getCollection(self.options.collectionName)
    self.watcher = self.options.collectionName.find().observe(
      added: (newDocument) ->
        if self.copyAlreadyExistingData
          newDocument = self.transform(newDocument) if self.transform?
          self.addToES(self.options.collectionName, self.options.ES, newDocument)

      changed: (newDocument, oldDocument) ->
        newDocument = self.transform(newDocument) if self.transform?
        self.updateToES(self.options.collectionName, self.options.ES, newDocument, oldDocument)

      removed: (oldDocument) ->
        self.removeESdocument(self.options.ES, oldDocument._id)
    )
    self.copyAlreadyExistingData = true

  getCollection: (collectionName) ->
    if _.isString(collectionName) then return new Mongo.Collection collectionName
    else return collectionName

  stopWatch: ->
    self = @
    self.watcher.stop()
    self.watcher

  getStatusForES: (ES) ->
    try
      response = HTTP.get(ES.host, { data: '/' })
    catch e
      log.error(e)
      return error =
        e
    return response

  addToES: (collectionName, ES, newDocument) ->
    log.info("adding doc #{newDocument._id} to ES")
    url = "#{ES.host}/#{ES.index}/#{ES.type}/#{newDocument._id}"
    console.log url
    console.log newDocument
    query =
      newDocument
    try
      response = HTTP.post(url, { data: query })
    catch e
      log.error(e)
      return e
    return response

  updateToES: (collectionName, ES, newDocument, oldDocument) ->
    if newDocument._id isnt oldDocument._id
      log.info "document ID #{oldDocument._id} was changed to #{newDocument._id}"
      @removeESdocument(ES, oldDocument._id)
    log.info "updating doc #{newDocument._id} to ES"
    url = "#{ES.host}/#{ES.index}/#{ES.type}/#{newDocument._id}"
    query =
      newDocument
    try
      response = HTTP.put(url, { data: query })
    catch e
      log.error(e)
      return e
    return response

  removeESdocument: (ES, documentID) ->
    log.info "removing doc #{documentID} from ES"
    url = "#{ES.host}/#{ES.index}/#{ES.type}/#{documentID}"
    try
      response = HTTP.del(url)
    catch e
      log.error(e)
      return e
    return response
