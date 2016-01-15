[![Circle CI](https://circleci.com/gh/Alino/Mongo2ES/tree/master.svg?style=svg)](https://circleci.com/gh/Alino/Mongo2ES/tree/master)
# Mongo2ES:
- Mongo2ES syncs data from MongoDB to ElasticSearch.
- Also automatically removes documents from ElasticSearch if they are removed in MongoDB
- Mongo2ES is built with MeteorJs.


Why does this exist?
- ElasticSearch rivers are deprecated
- [Transporter by compose](https://github.com/compose/transporter) is kind of stuck and unable to remove ES documents when they are removed in MongoDB.

## Installation
### install without docker
Mongo2ES runs as a Meteor application, so you need to have Meteor installed, first.
```shell
curl https://install.meteor.com/ | sh
```
then clone and run it
```shell
git clone https://github.com/Alino/Mongo2ES.git
cd Mongo2ES
elasticsearchHost="127.0.0.1:9200" meteor --port 3001
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

### install as a Meteor package
```
meteor add alino:mongo2es
```

https://github.com/Alino/alino-mongo2es

## environment variables
env variable          | description
----------------------|---------------------
**MONGO_URL**         | MongoDB url
**MONGO_OPLOG_URL**   | <a href="https://docs.mongodb.org/manual/core/replica-set-oplog/" target="_blank">MongoDB oplog</a> url
**elasticsearchHost** | URL which defines your ES host. (including port)
logitHost             | URL of your logstash host (optional)
logitPort             | logstash port (optional)


## Syncing data from MongoDB to ElasticSearch
If you want to sync MongoDB to ElasticSearch, you must define which collections you want to watch.
For that, you have to write your watchers.

You can get inspired from this example file
[```Mongo2ES/packages/kuknito-mongo2es-watchers/watchersExample.coffee```](https://github.com/Alino/Mongo2ES/blob/master/packages/kuknito-mongo2es-watchers/watchersExample.coffee)

If you are ready to write your own watchers,
go and create new file ```watchers.coffee```
in ```Mongo2ES/packages/kuknito-mongo2es-watchers/``` directory.
(all coffee files in this directory are automatically run when Mongo2ES starts up.)

## logging
there are currently 2 options for logging in Mongo2ES.

1. **Default behavior** - simply shows up the logs, like ```console.log()``` does
2. **logging to ElasticSearch with logstash** - to enable this feature, you must set *logitHost* and *logitPort* environment variables.

Both logging options are using Meteor package <a href="https://github.com/Alino/logit/" target="_blank">```alino:logit```</a>

## limitations:
- only one mongo database can be synced to ES, because we are tailing single MONGO_OPLOG_URL
