Meteor.startup ->
  new Mongo2ES({
    collectionName: 'eshops'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'eshops'
      type: 'eshops'
  }, undefined, true)
  new Mongo2ES({
    collectionName: 'eshopProducts'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'eshopproducts'
      type: 'eshopproducts'
  }, undefined, true)
  new Mongo2ES({
    collectionName: 'masterCategories'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'mastercategories'
      type: 'suggestions'
  }, undefined, true)
  new Mongo2ES({
    collectionName: 'manufacturers'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'manufacturers'
      type: 'suggestions'
  }, undefined, true)

  new Mongo2ES({
    collectionName: 'masterProducts'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'masterproducts'
      type: 'product'
  }, undefined, true)

  new Mongo2ES({
    collectionName: 'paramsForES'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'paramvalues'
      type: 'suggestions'
  }, undefined, true)
  new Mongo2ES({
    collectionName: 'paramNamesForES'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'paramnames'
      type: 'suggestions'
  }, undefined, true)
  new Mongo2ES({
    collectionName: 'searchedQueries'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'searchedqueries'
      type: 'suggestions'
  }, undefined, true)