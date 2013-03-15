_ = require 'underscore'
async = require 'async'
mustache = require 'mustache'

class AiEngine

  constructor: (@topics, botData) ->
    throw "Topics not found" if not @topics
    @currentTopic = null
    @view = {bot: botData}

  getCurrentTopic: () ->
    _.find @topics, (topic) => topic.name is @currentTopic

  findTemplate: (message) ->
    topic = @getCurrentTopic()
    category = _.find topic.categories, (category) -> category.pattern is message
    category.templates[0]

  reply: (author, message, cb) ->
    template = @findTemplate message
    responce = mustache.render template, @view
    cb null, responce

module.exports = AiEngine
