_ = require 'underscore'
async = require 'async'
mustache = require 'mustache'

class AiEngine

  constructor: (@roomName, @topics, botData) ->
    throw "Topics not found" if not @topics
    throw "Room name is undefined not found" if not @roomName
    @currentTopic = null
    @view = {bot: botData}
    _.forEach @topics, (topic) =>
      _.forEach topic.categories, (category) =>
        category["room:#{@roomName}"] = new RegExp (category.pattern.replace '*', '(.+)'), "i"


  getCurrentTopic: () ->
    _.find @topics, (topic) => topic.name is @currentTopic

  findCategory: (message) ->
    topic = @getCurrentTopic()
    _.find topic.categories, (category) => category["room:#{@roomName}"].test message

  reply: (author, message, cb) ->
    category = @findCategory message
    return cb null if not category
    match = category["room:#{@roomName}"].exec message
    @view.star = match[1]
    responce = mustache.render category.templates[0], @view
    cb null, responce

module.exports = AiEngine
