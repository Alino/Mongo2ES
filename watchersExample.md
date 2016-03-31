```javascript
if (Meteor.isServer) {

  Meteor.startup(function () {
    console.log('running watchers');

    // simple watching of collection:
    new Mongo2ES({
      collectionName: 'manufacturers',
      ES: {
        host: Meteor.settings.elasticsearchHost,
        index: 'manufacturers',
        type: 'suggestions'
      }
    });


    // watching collection and copy all already existing data:
    new Mongo2ES({
      collectionName: 'manufacturers',
      ES: {
        host: Meteor.settings.elasticsearchHost,
        index: 'manufacturers',
        type: 'suggestions'
      }
    }, undefined, true);


    // watching collection and using transform function (transforming data before sending it to ElasticSearch):
    var transform = function (doc) {
      doc.fullName = doc.firstName + " " + doc.lastName;
      return doc;
    };

    new Mongo2ES({
      collectionName: 'manufacturers',
      ES: {
        host: Meteor.settings.elasticsearchHost,
        index: 'manufacturers',
        type: 'suggestions'
      }
    }, transform);


  });

}
```
