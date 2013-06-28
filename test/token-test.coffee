token = require "../common/token.coffee"
cases = [
    "abc'def'abc\"asdas\""
    ,"abc+123+'a\"'+c+\"b'cd\""
    ,"test.x+b[\"abc\"+i]"
    ,"day[5]+weekend[test+\"test\"]"
]
for test in cases
    console.log "test",test
    console.log token.parseTokens test