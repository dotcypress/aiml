should = require('chai').should()
AiEngine = require('./../index').AiEngine
parse = require('./../index').parse

xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <aiml version=\"1.0\">
              <category>
                <pattern>what is your name</pattern>
                <that>bot</that>
                <template>My name is <bot name=\"name\"/></template>
              </category>
              <category>
                <pattern>do you like *</pattern>
                <template><star/>? Maybe.</template>
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

  it 'should throw error without topics', (done) ->
    should.throw () -> new AiEngine()
    done()

  describe '#reply', () ->

    engine = null

    beforeEach (done) ->
      parse xml, (err, topics) ->
        engine = new AiEngine topics, {name: 'Jonny'}
        done()

    it 'should not responce for unknown message', (done) ->
      engine.reply {name: 'Lisa'}, 'LOL', (err, reply) ->
        should.not.exist err
        should.not.exist reply
        done()

    it 'should responce to exact message', (done) ->
      engine.reply {name: 'Lisa'}, 'what is your name', (err, reply) ->
        should.exist reply
        reply.should.to.be.equal 'My name is Jonny'
        done()

    it 'should responce to not exact message', (done) ->
      engine.reply {name: 'Lisa'}, 'Hey, what is your name?', (err, reply) ->
        should.exist reply
        reply.should.to.be.equal 'My name is Jonny'
        done()

    it 'should responce with context', (done) ->
      engine.reply {name: 'Lisa'}, 'Dude, do you like bananas', (err, reply) ->
        should.exist reply
        reply.should.to.be.equal 'bananas? Maybe.'
        done()
