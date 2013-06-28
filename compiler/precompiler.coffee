# according to lespeng's idea
# clear silver's macro has no scope and always be declare no matter when and where it's written
#
# say:
# if true
#    donothing()
# else
#    def:(...)
#
# though def:(..) will never be excuted
# the macro is defined
acsblockTree = require "../ast/acsblock-tree.coffee"
exports.staticCompute  = (require "./staticCompute.coffee").staticComputeExpression
expandMacro = (tree,macros)->
    if not macros
        macros = []
    if not tree or not tree.length or tree.length <= 0
        return tree
    filter = []
    for node,index in tree
        if not node
            true
            #console.log "undefined",index,tree.length,tree
        if node.type is "def"
            expandMacro(node.body,macros)
            macros.push node
            tree[index] = null
        if node.type is "call"
            expandCall node,macros
        if node.type is "if"
            # find macro in else if node
            if node.elseIfList and node.elseIfList.length > 0
                for elseIfNode in node.elseIfList
                    expandMacro(elseIfNode.body,macros)
            if node.elseNode
                expandMacro(node.elseNode.body,macros)
        if node.body and node.body.length > 0
            expandMacro(node.body,macros)
    length = tree.length
    cursor = 0
    testCursor = 0
    for _ in [0...length]
        if tree[testCursor]
            tree[cursor] = tree[testCursor]
            cursor++
        testCursor++
    tree.length = cursor
    return macros
expandCall = (callNode,macros)->
    #console.log callNode.macroName,callNode.content
    for item in macros 
        if callNode.macroName is item.macroName
            macro = item
            params = callNode.expressions
            if params.length isnt macro.params.length
                throw new Error ["Invalid Call Param Count",macro.macroName,"Should Be",macro.params.length,"But Get",params.length,params].join(" ")
            macroTemplate = macro.clone()
            macroList = []
            for param,index in params
                macroList.push {name:macro.params[index],replacement:param.root}
            # replace expression macros
            acsblockTree.traverse [macroTemplate],(astNode)->
                if not astNode.expressions
                    return
                for exp in astNode.expressions
                    exp.root = expandExpressionNode exp.root,macroList
            resultAST = macroTemplate
            callNode.type = "call-expand"
            callNode.body = resultAST.body
            return
    throw new Error "Undefined Macro "+callNode.macroName
expandExpressionNode = (node,macroList)->
    if not node
        throw new Error "Invalid Expand Exp Node" 
    for macroPair in macroList
        name = macroPair.name
        replacement = macroPair.replacement
        if node.string is name and node.children.length is 0
            # expand it
            replacement = replacement.clone()
            if not node.parent
                return replacement
            else
                node.replaceBy replacement
                return node
        else if node.children.length > 0
            for child in node.children
                expandExpressionNode(child,macroList)
            return node
    return node
exports.expandMacro = expandMacro
