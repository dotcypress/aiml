require('coffee-script');
module.exports.AiEngine = require('./lib/engine');
module.exports.parse = require('./lib/parser').parse;
module.exports.parseFiles = require('./lib/parser').parseFiles;
module.exports.parseDir = require('./lib/parser').parseDir;
