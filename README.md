AIML [![Build Status](https://secure.travis-ci.org/dotCypress/aiml.png?branch=master)](https://travis-ci.org/dotCypress/aiml)
=====

[Artificial Intelligence Markup Language](http://en.wikipedia.org/wiki/AIML "Artificial Intelligence Markup Language") lib for Node.js

## Usage

### Installation

`npm install aiml`

### Parser

* `aiml.parse(xml, callback)` - parse string with AIML Xml.
* `aiml.parseFiles(files, callback)` - parse file or files.
* `aiml.parseDir(dir, callback)` - parse all files in specified directory.

### Engine

Engine constructor: `var engine = new aiml.AiEngine(roomName, topics, botData)`

#### Parameters

* `roomName` - (required) name of chat room.
* `topics` - (required) array of topics(parser results).
* `botData` - (optional) bot metadata (name, version, gender, etc.).

Main awesome function: `engine.reply(authorData, message, callback)`

#### Parameters

* `authorData` - (required) message author metadata (name, age, etc.).
* `message` - (required) just message.
* `callback` - (required) classic js callback, nothing special: ).

#### Sample

```js

var aiml = require('aiml')

aiml.parseFile('sample.aiml', function(err, topics){
  var engine = new aiml.AiEngine('Default', topics, {name: 'Jonny'});
  var responce = engine.reply({name: 'Billy'}, "Hi, dude", function(err, responce){
    console.log(responce);
  });
});
```

## Supported features in current release

* Category patterns
 * `<bot name="*"/>`
 *  `*`
* Ctegory templates
 * `<bot name="*"/>`
 *  `*`
 * `<srai>link</srai>`
 * `<get name="variable"/>`
 * `<set name="variable">value</set>`

## Contribute

You are welcome ;)
