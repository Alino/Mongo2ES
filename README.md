about:
------------
Mongo2ES syncs data from mongodb to elasticsearch.

example how to install as a docker container:
------------
```shell
git clone https://github.com/Alino/Mongo2ES.git && cd Mongo2ES
docker build -t kuknito/mongo2es .
docker run --name Mongo2ES -d \
  -e ROOT_URL=http://localhost:3001 \
  -e MONGO_URL="mongodb://127.0.0.1:27017/dbname?replicaSet=rs&readPreference=primaryPreferred&w=majority&connectTimeoutMS=60000&socketTimeoutMS=60000" \
  -e MONGO_OPLOG_URL=mongodb://127.0.0.1:27017/local \
  -e elasticsearchHost="127.0.0.1:9200" \
  -p 3001:80 \
  kuknito/mongo2es
```

------------
watching collections (tailing mongodb oplog and moving all data to ES)
------------
If you want to watch collections, you have to write your watchers.

To add your watchers, modify file ```Mongo2ES/packages/kuknito-mongo2es-watchers/watchersExample.coffee```
or create/rename the file to ```watchers.coffee```
(all coffee files in this directory are automatically executed when mongo2es is running)

example collection watchers:
------------
watching collection and start copying mongodb data to ES from the moment mongo2es runs :
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
