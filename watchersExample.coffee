Meteor.startup ->
  console.log 'running watchers'
  
# watching collection:
# --------------------
#  new Mongo2ES({
#      collectionName: 'manufacturers'
#      ES:
#      host: Meteor.settings.elasticsearchHost
#  index: 'manufacturers'
#  type: 'suggestions'
#  })

#watching collection and copy all already existing data:
#  new Mongo2ES({
#    collectionName: 'manufacturers'
#    ES:
#      host: Meteor.settings.elasticsearchHost
#      index: 'manufacturers'
#      type: 'suggestions'
#  }, undefined, true)

# watching collection and using transformation (transforming data before sending it to ElasticSearch):
#  transform = (doc) ->
#    doc.fullName = doc.firstName + " " + doc.lastName
#    return doc
#  new Mongo2ES({
#    collectionName: 'manufacturers'
#    ES:
#      host: Meteor.settings.elasticsearchHost
#      index: 'manufacturers'
#      type: 'suggestions'
#  }, transform)
