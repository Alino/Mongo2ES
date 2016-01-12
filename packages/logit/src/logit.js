
Logit = {};

Logit.createLogger = function (options) {
   options = options || {};
   var defaultMetaData = _.defaults(options.defaultMetaData || {},  { app_name: 'logit' });
   var logstashOptions = _.defaults(options.logstashOptions || {}, {
      level: 'info',
      port: logitSettings.port,
      node_name: logitSettings.node_name,
      host: logitSettings.host,
      max_connect_retries: -1
   });

   var winston = Npm.require('winston');
   Npm.require('winston-logstash');

   var logger = new (winston.Logger)({
      transports: [
         new (winston.transports.Console)( {level: 'silly'}),
         new (winston.transports.Logstash)(logstashOptions)
      ]
   });

   logger.transports.logstash.on('error', function(err){
      console.error(err);
   });

   var log = {
      options: {
         defaultMetaData: defaultMetaData,
         logstashOptions: logstashOptions
      }
   };

   var addDefaultMetaData = function (args, f) {
      var argsLength = args.length;

      if (typeof args[argsLength - 1] !== 'object' ) {
         args.push(defaultMetaData);
      } else {
         _.extend(args[argsLength - 1], defaultMetaData);
      }
      f.apply(null, args);
   };

   log.silly = function () {
      var args = [].slice.apply(arguments);
      addDefaultMetaData(args, logger.silly);
   };

   log.verbose = function () {
      var args = [].slice.apply(arguments);
      addDefaultMetaData(args, logger.verbose);
   };

   log.info = function () {
      var args = [].slice.apply(arguments);
      addDefaultMetaData(args, logger.info);
   };

   log.warn = function () {
      var args = [].slice.apply(arguments);
      addDefaultMetaData(args, logger.warn);
   };

   log.error = function () {
      var args = [].slice.apply(arguments);
      addDefaultMetaData(args, logger.error);
   };

   return log;
};

NoESLog = function(options) {
   options = options || {};

   var log = {};

   log.silly = function () {
      var args = [].slice.apply(arguments);
      for(var x = 0; x <= args.length; x++ ) {
         console.log(args[x]);
      }
   };

   log.verbose = function () {
      var args = [].slice.apply(arguments);
      for(var x = 0; x < args.length; x++ ) {
         console.log(args[x]);
      }
   };

   log.info = function () {
      var args = [].slice.apply(arguments);
      for(var x = 0; x < args.length; x++ ) {
         console.info(args[x]);
      }
   };

   log.warn = function () {
      var args = [].slice.apply(arguments);
      for(var x = 0; x < args.length; x++ ) {
         console.warn(args[x]);
      }
   };

   log.error = function () {
      var args = [].slice.apply(arguments);
      for(var x = 0; x < args.length; x++ ) {
         console.error(args[x]);
      }
   };

   return log;
};

var ref, ref1, ref2;

if ((((ref = Meteor.settings) != null ? (ref1 = ref.logit) != null ? ref1.host : void 0 : void 0) != null) && ((ref2 = Meteor.settings.logit) != null ? ref2.port : void 0) && Meteor.settings.logit.node_name) {
   logitSettings = Meteor.settings.logit;
   log = Logit.createLogger();
} else {
   log = NoESLog();
}