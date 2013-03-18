fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'
DomJS = require("dom-js").DomJS
mustache = require 'mustache'
engine = require './engine'

parse = (xml, cb) ->
  return cb 'Xml is not defined' unless xml
  domjs = new DomJS()
  domjs.parse xml, (err, dom) ->
    return cb err if err
    return cb 'Unsupported file' if dom.name is not 'aiml'
    topics = parseTopics dom
    topCategories = parseCategories dom
    topics.unshift { name: null, categories: topCategories } if topCategories.length > 0
    cb null, topics

parseFiles = (files, cb) ->
  files = [files] unless _.isArray files

  parseTasks = _.map files, (file) ->
    (cb) ->
      fs.readFile file, 'utf8', (err, data) ->
        return cb err if err
        parse data, cb

  async.parallel parseTasks, (err, results) ->
    return cb err if err
    all = _.flatten results, true
    merged = _.groupBy all, 'name'
    result = _.map merged, (arr) ->
      name: arr[0].name
      categories: _.reduce arr, ((acc, next) ->  acc.concat next.categories), []
    cb null, result

parseDir = (dir, cb) ->
  fs.readdir dir, (err, files) ->
    return cb err if err
    files = _.map files, (file) -> path.join dir, file
    parseFiles files, cb

parseTopics = (node) ->
  topics = _.filter node.children, (child) -> child.name is 'topic'
  _.map topics, parseTopic

parseTopic = (node) ->
  name: node.attributes.name
  categories: parseCategories node

parseCategories = (node) ->
  categories = _.filter node.children, (child) -> child.name is 'category'
  _.map categories, parseCategory

parseCategory = (node) ->
  pattern = _.find node.children, (child) -> child.name is 'pattern'
  that = _.find node.children, (child) -> child.name is 'that'
  template = _.find node.children, (child) -> child.name is 'template'
  pattern: parseMixedPatternExpression pattern
  that: parseMixedPatternExpression that if that
  template: parseMixedTemplateContentContainer template

parseMixedPatternExpression = (node) ->
  return undefined unless node
  _.reduce node.children, ((acc, next) -> "#{acc}#{parsePatternExpression next}"), ''

parsePatternExpression = (node) ->
  return "{{bot.#{node.attributes.name}}}" if node.name is 'bot'
  node.text

parseMixedTemplateContentContainer = (node) ->
  return undefined unless node
  linkNode =  _.find node.children, (subNode) -> subNode.name is 'srai'
  return link: linkNode.children[0].text if linkNode
  setterNode =  _.find node.children, (subNode) -> subNode.name is 'set'
  simpleNodes = _.filter node.children, (subNode) ->
    subNode.name is 'bot' or subNode.name is 'star' or subNode.text
  text: trim _.reduce simpleNodes, ((acc, next) -> "#{acc}#{parseTemplateExpression next}"), ''
  do:   processSetter setterNode if setterNode

parseTemplateExpression = (node) ->
  if node.name
    return "{{bot.#{node.attributes.name}}}" if node.name is 'bot'
    return "{{star}}" if node.name is 'star'
    return "{{#{node.attributes.name}}}" if node.name is 'get'
    return ''
  node.text

processSetter = (node) ->
  value = parseMixedTemplateContentContainer node
  content = value.text
  if (content.indexOf '{{star}}') != -1
    return (state, star) -> state[node.attributes.name] = mustache.render content, {star: star}
  (state) -> state[node.attributes.name] = content

trim = (string) -> string.replace /^\s+|\s+$/g, ''

module.exports.parse = parse
module.exports.parseFiles = parseFiles
module.exports.parseDir = parseDir
