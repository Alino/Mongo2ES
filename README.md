# Mongo2ES:

- Mongo2ES syncs data from MongoDB to ElasticSearch.
- Mongo2ES is built with MeteorJs.

## Installation
### install without docker
Mongo2ES runs as a Meteor application, so you need to have Meteor installed, first.
```shell
curl https://install.meteor.com/ | sh
```
then clone and run it
```shell
$ git clone https://github.com/Alino/Mongo2ES.git
$ cd Mongo2ES
$ meteor --port 3001
```
### install as docker container:
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

## Syncing data from MongoDB to ElasticSearch
If you want to sync MongoDB to ElasticSearch, you must define which collections you want to watch.
For that, you have to write your watchers.

You can get inspired from this example file [```Mongo2ES/packages/kuknito-mongo2es-watchers/watchersExample.coffee```](https://github.com/Alino/Mongo2ES/blob/master/packages/kuknito-mongo2es-watchers/watchersExample.coffee)
If you are ready to write your own watchers go and create new file ```watchers.coffee``` in ```Mongo2ES/packages/kuknito-mongo2es-watchers/``` directory.
(all coffee files in this directory are automatically run when Mongo2ES starts up.)



## limitations:
- only one mongo database can be synced to ES
