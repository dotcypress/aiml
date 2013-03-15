fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'
DomJS = require("dom-js").DomJS
engine = require './engine'

parse = (xml, cb) ->
  return cb 'Xml not defined' if not xml
  domjs = new DomJS()
  domjs.parse xml, (err, dom) ->
    return cb err if err
    return cb 'Unsupported file' if dom.name is not 'aiml'
    topics = parseTopics dom
    topCategories = parseCategories dom
    topics.unshift { name: 'Default', categories: topCategories } if topCategories.length > 0
    cb null, topics

parseFile = (file, cb) ->
  cb null, null

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
  templates = _.filter node.children, (child) -> child.name is 'template'
  pattern: parseMixedPatternExpression pattern
  that: parseMixedPatternExpression that if that
  templates: _.map templates, parseMixedTemplateContentContainer

parseMixedPatternExpression = (node) ->
  return undefined if not node
  trim _.reduce node.children, ((acc, next) -> "#{acc}#{parsePatternExpression next} "), ''

parseMixedTemplateContentContainer = (node) ->
  return undefined if not node
  trim _.reduce node.children, ((acc, next) -> "#{acc}#{parseTemplateExpression next} "), ''

parsePatternExpression = (node) ->
  # TODO: implement
  node.text

parseTemplateExpression = (node) ->
  # TODO: implement
  node.text

trim = (string) -> string.replace /^\s+|\s+$/g, ''

module.exports.parse = parse
module.exports.parseFile = parseFile
