require("coffee-script")
acsblock = require "../ast/acsblock.coffee"
acsblockTree = require "../ast/acsblock-tree.coffee"
act = require "../act/act.coffee"
compiler = require "../compiler/compiler.coffee"
precompiler = require "../compiler/precompiler.coffee"
ast = require "../ast/ast.coffee"
acsblockTree
fs = require "fs"
cases = [
    #"./test/case/comprehensive.cs",
    "./test/case/efficient-test.cs",
    "./test/case/test3.cs"
    #"./test/test-ifelse.cs",
]
for testFile in cases
    csString = (fs.readFileSync testFile).toString()
    acsblockList = null
    blocks = acsblock.parseACSBlocks(csString)
    #console.log "blocks",blocks
    acsblockList = blocks
    tree = acsblockTree.parseACSBTree(acsblockList)
    #acsblockTree.printTree(tree)
    ACSBTree = tree
    acsblockTree.traverse(tree,ast.extractAndAttachExpression)
    ##change into actree
    acsblockTree.traverse(tree,act.convertToACTNode)
    precompiler.expandMacro(tree,[])
    #compiler.printMiddleCode(tree)
    code = compiler.assamble(tree,new compiler.Context())
    #console.log "============================================"
    #acsblockTree.printTree(tree)
    #console.log macros.length
    #code = compiler.assamble(tree,new compiler.Context())
    result = compiler.link(["./lang/js/hdfReader.js","./lang/js/head.js","./lang/js/wrapperBegin.js"],["lang/js/wrapperEnd.js","./lang/js/tail.js"],code)
    fs.writeFileSync testFile.substr(0,testFile.length-3)+".js",result
    
    #console.log result
    #
    # 
