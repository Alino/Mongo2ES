Mongo2ES copies data from mongodb to elasticsearch.


to add your watchers, modify watchers.coffee file

example usage:
------------
```
docker run --name Mongo2ES_TestEnv -d \
  -e ROOT_URL=http://localhost:3001 \
  -e MONGO_URL="mongodb://127.0.0.1:27017/dbname?replicaSet=rs&readPreference=primaryPreferred&w=majority&connectTimeoutMS=60000&socketTimeoutMS=60000" \
  -e MONGO_OPLOG_URL=mongodb://127.0.0.1:27017/local \
  -e METEOR_SETTINGS="$(cat settings.json)" \
  -e elasticsearchHost="127.0.0.1:9200" \
  -p 3001:80 \
  kuknito/mongo2es
```



watching collection:
```
new Mongo2ES({
    collectionName: 'manufacturers'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'manufacturers'
      type: 'suggestions'
  })
```

watching collection and copy all already existing data:
```
new Mongo2ES({
    collectionName: 'manufacturers'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'manufacturers'
      type: 'suggestions'
  }, undefined, true)
```

watching collection and using transformation (transforming data before sending it to ElasticSearch):
```
transform = function(doc) {
  doc.fullName = doc.firstName + " " + doc.lastName;
  return doc;
};

new Mongo2ES({
    collectionName: 'manufacturers'
    ES:
      host: Meteor.settings.elasticsearchHost
      index: 'manufacturers'
      type: 'suggestions'
  }, transform)
```

limitations:
-------------
- only one mongo database can be synced to ES