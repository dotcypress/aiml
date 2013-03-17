_ = require 'underscore'
async = require 'async'
mustache = require 'mustache'

class AiEngine

  constructor: (@roomName, @topics, botData) ->
    throw "Topics not found" unless @topics
    throw "Room name is undefined not found" unless @roomName
    @roomData = { topic: null}
    @view =
      bot: botData
      set: (name, value) => @roomData[name] = value
      get: (name) => @roomData[name] or ''

    _.each @topics, (topic) =>
      _.each topic.categories, (category) =>
        category["room:#{@roomName}"] = new RegExp (category.pattern.replace '*', '(.*)'), "i"

  getCurrentTopic: () ->
    _.find @topics, (topic) => topic.name is @roomData.topic

  findCategory: (message) ->
    topic = @getCurrentTopic()
    return @roomData.topic = null unless topic
    _.find topic.categories, (category) => category["room:#{@roomName}"].test message

  reply: (authorData, message, cb) ->
    category = @findCategory message
    return cb null unless category
    return @reply authorData, category.template.link, cb if category.template?.link
    match = category["room:#{@roomName}"].exec message
    @view.star = match[1] if match and match.length > 0
    responce = mustache.render category.template.text, @view
    cb null, responce

module.exports = AiEngine
