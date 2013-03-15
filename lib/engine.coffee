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

  findCategory: (message) ->
    topic = @getCurrentTopic()
    _.find topic.categories, (category) ->
      # TODO: cache regex
      re = new RegExp (category.pattern.replace '*', '(.+)'), "i"
      re.test message

  reply: (author, message, cb) ->
    category = @findCategory message
    return cb null if not category

    re = new RegExp (category.pattern.replace '*', '(.+)'), "i"
    match = re.exec message
    @view.star = match[1]
    responce = mustache.render category.templates[0], @view
    cb null, responce

module.exports = AiEngine
