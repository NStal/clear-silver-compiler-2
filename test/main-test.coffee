require("coffee-script")
acsblock = require "../ast/acsblock.coffee"
acsblockTree = require "../ast/acsblock-tree.coffee"
acsblockTree
fs = require "fs"
csString = (fs.readFileSync "./test/case/comprehensive.cs").toString()
acsblockList = null
describe "Abstract Block Parser",()->
    it "acsblock test",(done)-> 
        blocks = acsblock.parseACSBlocks(csString)
        console.log "blocks",blocks
        acsblockList = blocks
        done()
    it "ACSBTree Build",()->
        tree = acsblockTree.parseACSBTree(acsblockList)
        console.log "tree",tree
        ACSBTree = tree
        done()
    









