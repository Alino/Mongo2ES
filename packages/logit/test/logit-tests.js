Tinytest.add('Test the createLogger function use defaults', function (test) {
   var log = Logit.createLogger();
   log.silly("test silly log 1");
   log.silly("test silly log 2", {module_name: 'authentication'});

   log.verbose("test verbose log 1");
   log.verbose("test verbose log 2", {module_name: 'authentication'});

   log.info("test info log 1");
   log.info("test info log 2", {module_name: 'authentication'});

   log.warn("test warn log 1");
   log.warn("test warn log 2", {module_name: 'authentication'});

   log.error("test error log 1");
   log.error("test error log 2", {module_name: 'authentication'});

   test.equal(log.options.defaultMetaData.app_name, 'logit');
   test.equal(log.options.logstashOptions.level, 'info');
   test.equal(log.options.logstashOptions.port, 28777);
   test.equal(log.options.logstashOptions.node_name, 'logit-node-name');
   test.equal(log.options.logstashOptions.host, '127.0.0.1');
});

Tinytest.add('Test the createLogger function override defaults', function (test) {
   var options = {
      defaultMetaData: {app_name: 'test_app_name'},
      logstashOptions: {
         level: 'silly',
         port: 2000,
         node_name: 'logit',
         host: 'example.com'
      }
   };
   var log = Logit.createLogger(options);
   log.silly("test silly log 1");
   log.silly("test silly log 2", {module_name: 'authentication'});

   log.verbose("test verbose log 1");
   log.verbose("test verbose log 2", {module_name: 'authentication'});

   log.info("test info log 1");
   log.info("test info log 2", {module_name: 'authentication'});

   log.warn("test warn log 1");
   log.warn("test warn log 2", {module_name: 'authentication'});

   log.error("test error log 1");
   log.error("test error log 2", {module_name: 'authentication'});

   test.equal(log.options.defaultMetaData.app_name, 'test_app_name');
   test.equal(log.options.logstashOptions.level, 'silly');
   test.equal(log.options.logstashOptions.port, 2000);
   test.equal(log.options.logstashOptions.node_name, 'logit');
   test.equal(log.options.logstashOptions.host, 'example.com');
});
