should = require('chai').should()
parse = require('./../index').parse
parseFiles = require('./../index').parseFiles

describe 'AIML parser', () ->
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <aiml version=\"1.0\">
              <category>
                <pattern>what is your name</pattern>
                <that>bot</that>
                <template><![CDATA[My name is Jonny.]]></template>
              </category>
              <topic name=\"Development\">
               <category>
                  <pattern><bot name=\"name\"/>, what is your preffered programming language</pattern>
                  <template>My name is <bot name=\"name\"/> and i prefer F#.</template>
                </category>
                <category>
                  <pattern><bot name=\"name\"/>, what is your preffered programming language</pattern>
                  <template>
                    <random>
                      <li>My name is <bot name=\"name\"/> and i prefer F#.</li>
                      <li>Only Haskell</li>
                      <li>Maybe OCaml</li>
                    </random>
                  </template>
                </category>
              </topic>
            </aiml>"

  it 'should not parse empty string', (done) ->
    parse '', (err, topics) ->
      should.exist err
      done()

  it 'should not parse non aiml xmls', (done) ->
    parse '<?xml version=\"1.0\" encoding=\"UTF-8\"?><atom>/<atom>', (err, topics) ->
      should.exist err
      done()

  it 'should parse topics', (done) ->
    parse xml, (err, topics) ->
      should.not.exist err
      topics.should.have.length 2
      should.not.exist topics[0].name
      topics[1].name.should.equal 'Development'
      done()

  it 'should parse simple category', (done) ->
    parse xml, (err, topics) ->
      topic = topics[0]
      topic.categories.should.have.length 1
      category = topic.categories[0]
      category.pattern.should.equal 'what is your name'
      category.that.should.equal 'bot'
      category.templates[0].should.equal 'My name is Jonny.'
      done()

  it 'should parse bot predicate in pattern', (done) ->
    parse xml, (err, topics) ->
      category = topics[1].categories[0]
      category.pattern.should.equal '{{bot.name}}, what is your preffered programming language'
      done()

  it 'should parse bot predicate in templates', (done) ->
    parse xml, (err, topics) ->
      category = topics[1].categories[0]
      category.templates[0].should.equal 'My name is {{bot.name}} and i prefer F#.'
      done()
