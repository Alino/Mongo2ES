Package.describe({
   name: 'alino:logit',
   summary: 'A Meteor package which uses winston and logstash to get logs into elasticsearch over tcp',
   version: '0.0.2',
   git: 'https://github.com/jonboylailam/logit.git'
});

Package.onUse(function (api) {
   api.versionsFrom('METEOR@1.1.0.3');
   api.use(["underscore"]);
   api.addFiles('./src/logit.js', ['server']);
   api.export('Logit', ['server']);
   api.export('log', ['server']);
});

Package.onTest(function (api) {
   api.use('tinytest');
   api.use('jonlailam:logit');
   api.addFiles('./test/logit-tests.js', ['server']);
});

Npm.depends({
   "winston": "1.0.1",
   "winston-logstash": "0.2.11"
});