describe 'Mongo2ES', ->
  testCollection1 = new Mongo.Collection('testCollection1')
  testCollection2 = new Mongo.Collection('testCollection2')
  testCollection3 = new Mongo.Collection('testCollection3')
  testCollection4 = new Mongo.Collection('testCollection4')
  testCollection5 = new Mongo.Collection('testCollection5')
  testCollection6 = new Mongo.Collection('testCollection6')
  testCollection7 = new Mongo.Collection('testCollection7')
#  testCollection8 = new Mongo.Collection('testCollection8') # this line must remain disabled
  testCollection9 = new Mongo.Collection('testCollection9')
#  testCollection10 = new Mongo.Collection('testCollection10')
  testCollection11 = new Mongo.Collection('testCollection11')
  testCollection12 = new Mongo.Collection('testCollection12')

  ESdefault = host: "http://192.168.59.103:9500"
  optionsDefault =
    collectionName: testCollection1
    ES:
      host: ESdefault.host
      index: 'admin'
      type: 'test'

  beforeEach ->
    testCollection1.remove({})
    testCollection2.remove({})
    testCollection3.remove({})
    testCollection4.remove({})
    testCollection5.remove({})
    testCollection6.remove({})
    testCollection7.remove({})
#    testCollection8.remove({})
    testCollection9.remove({})
#    testCollection10.remove({})
    testCollection11.remove({})
    testCollection12.remove({})

  describe 'getCollection', ->
    it 'should return meteor collection if it receives string', ->
      options = optionsDefault
      options.collectionName = 'testCollection10'
      x = new Mongo2ES(optionsDefault)
      collection = x.getCollection('testCollection8')
      expect(collection._collection).toBeDefined()
      expect(collection._name).toBe 'testCollection8'

    it 'should return meteor collection if it receives meteor collection', ->
      options = optionsDefault
      options.collectionName = testCollection9
      x = new Mongo2ES(optionsDefault)
      collection = x.getCollection(testCollection9)
      expect(collection._collection).toBeDefined()
      expect(collection._name).toBe 'testCollection9'

  describe 'getStatusForES', ->
    it 'should return ES statusCode 200', ->
      x = new Mongo2ES(optionsDefault)
      response = x.getStatusForES(optionsDefault.ES)
      expect(response.statusCode).toBeDefined
      expect(response.statusCode).toEqual 200

    it 'should return an error if ES host unreachable', ->
      options =
        collectionName: testCollection2
        ES:
          host: "http://192.168.666.666:9200"
          index: 'admin'
          type: 'test'
      x = new Mongo2ES(options)
      response = x.getStatusForES(options.ES)
      expect(response.error).toBeDefined

  describe 'addToES', ->
    it 'should save document to ES', (done) ->
      options = optionsDefault
      options.collectionName = testCollection3
      x = new Mongo2ES(options)
      spyOn(x, 'addToES')
      testCollection3.find().observe(
        added: (newDocument) ->
          expect(x.transform).toBeUndefined()
          expect(x.addToES).toHaveBeenCalled()
          expect(newDocument._id).toBe 'tvoj tatko'
          done()
      )
      testCollection3.insert({ _id: 'tvoj tatko', query: 'jebem' })

    it 'should save TRANSFORMED document to ES', (done) ->
      options = optionsDefault
      options.collectionName = testCollection7
      transform = (doc) ->
        doc.trans_query = "#{doc.query}_TRANSFORMED"
        return doc
      x = new Mongo2ES(options, transform)
      spyOn(x, 'addToES')
      spyOn(x, 'transform').and.callThrough()
      testCollection7.find().observe(
        added: (newDocument) ->
          expect(x.transform).toBeDefined()
          expect(x.transform).toHaveBeenCalled()
          expect(x.addToES).toHaveBeenCalled()
          expect(x.addToES.calls.mostRecent().args[2].trans_query).toBe 'jebem_TRANSFORMED'
          expect(newDocument._id).toBe 'transexual pojebany'
          expect(newDocument.query).toBe 'jebem'
          done()
      )
      testCollection7.insert({ _id: 'transexual pojebany', query: 'jebem' })

    it 'should copy already existing mongo data to ES if third parameter is true', (done) ->
      testCollection11.insert({ _id: 'toto tu uz bolo', query: 'jebem' })
      options = optionsDefault
      options.collectionName = testCollection11
      spyOn(Mongo2ES.prototype, 'addToES')
      x = new Mongo2ES(options, undefined, true)
      testCollection11.find().observe(
        added: (newDocument) ->
          expect(x.transform).toBeUndefined()
          expect(Mongo2ES.prototype.addToES).toHaveBeenCalled()
          expect(x.copyAlreadyExistingData).toBe true
          expect(newDocument._id).toBe 'toto tu uz bolo'
          done()
      )

    it 'should not copy already existing mongo data to ES if third parameter is not defined', (done) ->
      testCollection12.insert({ _id: 'toto by tam nemalo byt', query: 'jebem' })
      options = optionsDefault
      options.collectionName = testCollection12
      spyOn(Mongo2ES.prototype, 'addToES')
      x = new Mongo2ES(options)
      testCollection12.find().observe(
        added: (newDocument) ->
          expect(x.transform).toBeUndefined()
          expect(Mongo2ES.prototype.addToES).not.toHaveBeenCalled()
          done()
      )

  describe 'updateToES', ->
    it 'should update document version in ES', (done) ->
      options = optionsDefault
      options.collectionName = testCollection6
      x = new Mongo2ES(options)
      spyOn(x, 'updateToES')
      testCollection6.insert({ _id: "42", query: 'jebem' })
      testCollection6.find().observe(
        changed: (newDocument, oldDocument) ->
          expect(x.updateToES).toHaveBeenCalled()
          expect(newDocument._id).toBe '42'
          expect(newDocument.query).toBe 'nejebem'
          expect(oldDocument._id).toBe '42'
          expect(oldDocument.query).toBe 'jebem'
          done()
      )
      testCollection6.update({ _id: "42" }, { $set: { query: 'nejebem' } })

  describe 'removeESdocument', ->
    it 'should remove document from ES', (done) ->
      options = optionsDefault
      options.collectionName = testCollection4
      x = new Mongo2ES(options)
      spyOn(x, 'removeESdocument')
      testCollection4.insert({ _id: 'jebem ja tvojho boha', query: 'jebem' })
      testCollection4.find().observe(
        removed: (oldDocument) ->
          expect(x.removeESdocument).toHaveBeenCalled()
          expect(oldDocument._id).toBe 'jebem ja tvojho boha'
          done()
      )
      testCollection4.remove({ _id: 'jebem ja tvojho boha', query: 'jebem' })

  describe 'stopWatch', ->
    it 'should stop watching the collection', (done) ->
      options = optionsDefault
      options.collectionName = testCollection5
      x = new Mongo2ES(options)
      spyOn(x, 'addToES')
      watcher = x.stopWatch()
      expect(watcher._stopped).toBe true
      testCollection5.find().observe(
        added: (newDocument) ->
          expect(x.addToES).not.toHaveBeenCalled()
          expect(newDocument._id).toBe 'tvoja mamka'
          done()
      )
      testCollection5.insert({ _id: 'tvoja mamka', query: 'jebem' })