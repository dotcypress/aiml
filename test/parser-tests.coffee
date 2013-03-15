should = require('chai').should()
parse = require('./../index').parse
parseFiles = require('./../index').parseFiles

describe 'AIML parser', () ->

  it 'should not parse empty string', (done) ->
    parse '', (err, topics) ->
      should.exist err
      done()

  it 'should parse simple category', (done) ->
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <aiml version=\"1.0\">
              <category>
                <pattern>WHAT IS YOUR NAME</pattern>
                <template><![CDATA[My name is Jonny.]]></template>
              </category>
            </aiml>"
    parse xml, (err, topics) ->
      should.not.exist err
      topics.should.have.length 1
      topics[0].categories.should.have.length 1
      topics[0].categories[0].pattern.should.equal 'WHAT IS YOUR NAME'
      topics[0].categories[0].templates[0].should.equal 'My name is Jonny.'
      done()

  it 'should parse simple topic', (done) ->
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <aiml version=\"1.0\">
              <category>
                <pattern>WHAT IS YOUR NAME</pattern>
                <that>bot</that>
                <template><![CDATA[My name is Jonny.]]></template>
              </category>
              <topic name=\"Development\">
                <category>
                  <pattern>WHAT IS YOUR PREFFERED PROGRAMMING LANGUAGE</pattern>
                  <template>My name is <bot name=\"name\"/> and i prefer F#.</template>
                </category>
              </topic>
            </aiml>"
    parse xml, (err, topics) ->
      should.not.exist err
      topics.should.have.length 2
      topics[1].name.should.equal 'Development'
      topics[1].categories[0].pattern.should.equal 'WHAT IS YOUR PREFFERED PROGRAMMING LANGUAGE'
      done()
