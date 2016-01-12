Package.describe({
    name: 'kuknito:mongo2es-watchers',
    summary: 'configuration to watch mondodb collections for moving them to ES via mongo2es.',
    version: '0.0.1'
});

var path = Npm.require('path');
var base = path.resolve('.');
var packagePath = path.join(base, '/packages/kuknito-mongo2es-watchers');
var fs = Npm.require('fs');
var packageFiles = fs.readdirSync(packagePath);
var coffeeFiles = [];
for (var i = 0; i <= packageFiles.length - 1; i++) {
    if(packageFiles[i].split('.').pop() === 'coffee')
        coffeeFiles.push(packageFiles[i]);
}

Package.onUse(function (api) {
    api.versionsFrom(['METEOR@1.2']);

    var packages = [
        "coffeescript"
    ];

    api.addFiles(coffeeFiles, 'server');

    api.use(packages);
});
