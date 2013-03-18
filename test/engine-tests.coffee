should = require('chai').should()
AiEngine = require('./../index').AiEngine
parse = require('./../index').parse

xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <aiml version=\"1.0\">
              <category>
                <pattern>what is your Name</pattern>
                <that>bot</that>
                <template>My name is <bot name=\"name\"/></template>
              </category>
              <category>
                <pattern>do you like *</pattern>
                <template><star/>? Maybe.</template>
              </category>
              <category>
                <pattern>you age</pattern>
                <template><bot name=\"age\"/></template>
              </category>
              <category>
                <pattern>how old are you</pattern>
                <template><srai>you age</srai></template>
              </category>
              <category>
                <pattern>lets chainge topic to Dev</pattern>
                <template><set name=\"topic\">Development</set>ok</template>
              </category>
              <category>
                <pattern>lets talk about *</pattern>
                <template><set name=\"subject\"><star/> stuff</set>ok</template>
              </category>
              <category>
                <pattern>what the subject</pattern>
                <template>Subject is <get name=\"subject\"/></template>
              </category>
              <topic name=\"Development\">
               <category>
                  <pattern><bot name=\"name\"/>, how are yoy</pattern>
                  <template>awesome</template>
                </category>
                <category>
                  <pattern><bot name=\"name\"/>, what is your preffered programming language</pattern>
                  <template>
                    <random>
                      <li>My name is <bot name=\"name\"/> and i prefer F#.</li>
                      <li>Only Haskell, <get name=\"dude\"/></li>
                      <li>Maybe OCaml</li>
                    </random>
                  </template>
                </category>
              </topic>
            </aiml>"

describe 'AIML engine', () ->

  it 'should throw error without room name', (done) ->
    should.throw () -> new AiEngine()
    done()

  it 'should throw error without topics', (done) ->
    should.throw () -> new AiEngine 'Default'
    done()

  describe '#reply', () ->

    engine = null

    beforeEach (done) ->
      parse xml, (err, topics) ->
        engine = new AiEngine 'Default', topics, {name: 'Jonny', age: 21}
        done()

    it 'should not responce for unknown message', (done) ->
      engine.reply {name: 'Lisa'}, 'LOL', (err, reply) ->
        should.not.exist err
        should.not.exist reply
        done()

    it 'should responce to exact message', (done) ->
      engine.reply {name: 'Lisa'}, 'what is your name', (err, reply) ->
        should.exist reply
        reply.should.be.equal 'My name is Jonny'
        done()

    it 'should responce to not exact message', (done) ->
      engine.reply {name: 'Lisa'}, 'Hey, what is your name?', (err, reply) ->
        should.exist reply
        reply.should.be.equal 'My name is Jonny'
        done()

    it 'should responce with context', (done) ->
      engine.reply {name: 'Lisa'}, 'Dude, do you like bananas', (err, reply) ->
        should.exist reply
        reply.should.be.equal 'bananas? Maybe.'
        done()

    it 'should work with references', (done) ->
      engine.reply {name: 'Lisa'}, 'how old are you?', (err, reply) ->
        should.exist reply
        reply.should.be.equal '21'
        done()

    it 'should work with references', (done) ->
      engine.reply {name: 'Lisa'}, 'how old are you?', (err, reply) ->
        should.exist reply
        reply.should.be.equal '21'
        done()

    it 'should work with setters ang getters', (done) ->
      engine.reply {name: 'Lisa'}, 'lets chainge topic to Dev?', (err, reply) ->
        should.exist reply
        reply.should.be.equal 'ok'
        should.exist engine.view.topic
        engine.view.topic.should.be.equal 'Development'
        done()

    it 'should work with setters ang getters (with star)', (done) ->
      engine.reply {name: 'Lisa'}, 'lets talk about js?', (err, reply) ->
        should.exist reply
        reply.should.be.equal 'ok'
        engine.reply {name: 'Lisa'}, 'what the subject?', (err, reply) ->
          should.exist reply
          reply.should.be.equal 'Subject is js stuff'
          done()
