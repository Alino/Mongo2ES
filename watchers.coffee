MasterProducts = new Mongo.Collection('masterProducts')
EshopProducts = new Mongo.Collection('eshopProducts')

Meteor.startup ->
  console.log 'creating watchers'
  #  new Mongo2ES({
  #    collectionName: 'eshops'
  #    ES:
  #      host: Meteor.settings.elasticsearchHost
  #      index: 'eshops'
  #      type: 'eshops'
  #  }, undefined, true)
  #
  new Mongo2ES({
    collectionName: EshopProducts
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'eshopproducts'
      type: 'eshopproducts'
  }, (doc) ->
    if not doc? then return true
    masterProduct = MasterProducts.findOne({ _id: doc.masterProduct_id })
    if not masterProduct then return doc
    masterProduct.eshopProducts = []
    eshopProducts = EshopProducts.find({ masterProduct_id: doc.masterProduct_id }).fetch()
    _.each(eshopProducts, (eshopProduct) ->
      masterProduct.eshopProducts.push(_.pick(eshopProduct, [
        'delivery_date'
        'eshop_id'
        'item_id'
        'price'
        'price_vat'
        'url'
      ]))
    )
    ES_masterProduct =
      host: Meteor.settings.elasticsearchHost
      index: 'masterproducts'
      type: 'product'
    response = Mongo2ES::updateToES(MasterProducts, ES_masterProduct, masterProduct, masterProduct)
    return doc
  , true)
  #
  #  new Mongo2ES({
  #    collectionName: 'masterCategories'
  #    ES:
  #      host: Meteor.settings.elasticsearchHost
  #      index: 'mastercategories'
  #      type: 'suggestions'
  #  }, undefined, true)
  #
  #  new Mongo2ES({
  #    collectionName: 'manufacturers'
  #    ES:
  #      host: Meteor.settings.elasticsearchHost
  #      index: 'manufacturers'
  #      type: 'suggestions'
  #  }, undefined, true)

  new Mongo2ES({
    collectionName: MasterProducts
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'masterproducts'
      type: 'product'
  }, (masterProduct) ->
    if not masterProduct? then return true
    eshopProducts = EshopProducts.find({ masterProduct_id: masterProduct._id }).fetch()
    masterProduct.eshopProducts = []
    _.each(eshopProducts, (eshopProduct) ->
      masterProduct.eshopProducts.push(_.pick(eshopProduct, [
        'delivery_date'
        'eshop_id'
        'item_id'
        'price'
        'price_vat'
        'url'
      ]))
    )
    return masterProduct
  , true)

  #  new Mongo2ES({
  #    collectionName: 'paramsForES'
  #    ES:
  #      host: Meteor.settings.elasticsearchHost
  #      index: 'paramvalues'
  #      type: 'suggestions'
  #  }, undefined, true)
  #
  #  new Mongo2ES({
  #    collectionName: 'paramNamesForES'
  #    ES:
  #      host: Meteor.settings.elasticsearchHost
  #      index: 'paramnames'
  #      type: 'suggestions'
  #  }, undefined, true)

  new Mongo2ES({
    collectionName: 'searchedQueries'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'searchedqueries'
      type: 'suggestions'
  }, undefined, true)