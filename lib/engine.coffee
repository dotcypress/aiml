_ = require 'underscore'
async = require 'async'
mustache = require 'mustache'

class AiEngine

  constructor: (@roomName, @topics, botData) ->
    throw "Topics not found" unless @topics
    throw "Room name is undefined not found" unless @roomName
    @currentTopic = null
    @view = {bot: botData}
    _.each @topics, (topic) =>
      _.each topic.categories, (category) =>
        category["room:#{@roomName}"] = new RegExp (category.pattern.replace '*', '(.*)'), "i"

  getCurrentTopic: () ->
    _.find @topics, (topic) => topic.name is @currentTopic

  findCategory: (message) ->
    topic = @getCurrentTopic()
    _.find topic.categories, (category) => category["room:#{@roomName}"].test message

  reply: (authorData, message, cb) ->
    category = @findCategory message
    return cb null unless category
    match = category["room:#{@roomName}"].exec message
    @view.star = match[1] if match and match.length > 0
    responce = mustache.render category.template, @view
    cb null, responce

module.exports = AiEngine
