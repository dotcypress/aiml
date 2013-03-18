should = require('chai').should()
parse = require('./../index').parse
parseFiles = require('./../index').parseFiles
parseDir = require('./../index').parseDir

xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <aiml version=\"1.0\">
              <category>
                <pattern>what is your name</pattern>
                <that>bot</that>
                <template><![CDATA[My name is Jonny.]]><unknowntag>88888</unknowntag></template>
              </category>
              <topic name=\"Development\">
               <category>
                  <pattern><bot name=\"name\"/>, what is your preffered programming language</pattern>
                  <template>My name is <bot name=\"name\"/> and i prefer F#.</template>
                </category>
                <category>
                  <pattern><bot name=\"name\"/>, what is best programming language</pattern>
                  <template>
                    <random>
                      <li>
                        <random>
                          <li>Only</li>
                          <li>Maybe</li>
                          <li>Not</li>
                        </random>
                      </li>
                      <li>C#</li>
                      <li>F#</li>
                      <li>js</li>
                    </random>
                    <think></think>
                  </template>
                </category>
              </topic>
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
            </aiml>"

describe 'AIML parser', () ->

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
      topics[0].categories.should.have.length 7
      should.not.exist topics[0].name
      topics[1].name.should.equal 'Development'
      done()

  it 'should parse simple category', (done) ->
    parse xml, (err, topics) ->
      topic = topics[0]
      category = topic.categories[0]
      category.pattern.should.equal 'what is your name'
      category.that.should.equal 'bot'
      category.template.text.should.equal 'My name is Jonny.'
      done()

  it 'should parse bot predicate in pattern', (done) ->
    parse xml, (err, topics) ->
      category = topics[1].categories[0]
      category.pattern.should.equal '{{bot.name}}, what is your preffered programming language'
      done()

  it 'should parse bot predicate in templates', (done) ->
    parse xml, (err, topics) ->
      category = topics[1].categories[0]
      category.template.text.should.equal 'My name is {{bot.name}} and i prefer F#.'
      done()

  it 'should parse stars', (done) ->
    parse xml, (err, topics) ->
      category = topics[0].categories[1]
      category.pattern.should.equal 'do you like *'
      category.template.text.should.equal '{{star}}? Maybe.'
      done()

  it 'should parse catergory reference', (done) ->
    parse xml, (err, topics) ->
      category = topics[0].categories[3]
      category.pattern.should.equal 'how old are you'
      category.template.link.should.equal 'you age'
      done()

  it 'should parse setters', (done) ->
    parse xml, (err, topics) ->
      category = topics[0].categories[4]
      category.pattern.should.equal 'lets chainge topic to Dev'
      category.template.text.should.equal 'ok'
      should.exist category.template.do
      category.template.do.should.be.a 'function'
      done()

  it 'should parse setters with star', (done) ->
    parse xml, (err, topics) ->
      category = topics[0].categories[5]
      category.pattern.should.equal 'lets talk about *'
      category.template.text.should.equal 'ok'
      should.exist category.template.do
      category.template.do.should.be.a 'function'
      done()

  it 'should parse getters', (done) ->
    parse xml, (err, topics) ->
      category = topics[0].categories[6]
      category.pattern.should.equal 'what the subject'
      category.template.text.should.equal 'Subject is {{subject}}'
      done()
