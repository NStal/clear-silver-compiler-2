acsblock = require "../ast/acsblock.coffee"
acsblockTree = require "../ast/acsblock-tree.coffee"
acsblockTree
fs = require "fs"
csString = (fs.readFileSync "./test/case/comprehensive.cs").toString()
describe "Abstract Block Parser",()->
    it "acsblock test",(done)-> 
        blocks = acsblock.parseACSBlocks(csString)
        console.log "done",blocks
        done()
