reg = require "./reg.coffee"
Token = require "./token.coffee"
Operators = ["+","-","*","/","^","|","&","||","&&","==","<=",">=","$",".","[","#"]
Level = {
    "||":1
    ,"&&":1.1
    ,"==":1.2
    ,"!=":1.2
    ,">":1.3
    ,">=":1.3
    ,"<":1.3
    ,"<=":1.3
    ,"&":2
    ,"|":2
    ,"+":3
    ,"-":3
    ,"*":4
    ,"/":4
    ,"%":5
    ,"^":6
    ,"#":7
    ,"!":7
    ,"?":7
    ,"$":7
    ,"#":7
    ,".":8
    ,"[":8
}
parenthesises = ["[","]","(",")"]
multiOperators = ["+","-"]
isMulti = (op)->
    return op in multiOperators
isUnary = (op)->
    return op.toString() in ["+","-","$","#"]
isOperater = (op)->
    return op.toString() in Operators
isValue = (token)->
    return token not in Operators and token not in parenthesises
isSymbol = (token)->
    # symbol means an HDF refer or an variable/function name
    return /[a-z_][0-9a-z_.]*/i.test(token.toString())
isWord = (token)->
    return reg.word.test(token.toString())
isHDFRefer = (token)->
    # Symbols consist of word split by "."
    blocks = token.toString().split(".")
    for block in blocks
        if not isWord(block)
            return false
    return true
compareOperator = (a,b)->
    console.assert typeof Level[a] is "number"
    console.assert typeof Level[b] is "number"
    a = Level[a]
    b = Level[b]
    if a > b
        return 1
    else if a < b
        return -1
    return 0

class Node
    constructor:(token)->
        @children = []
        @setToken(token)
        @__defineGetter__ "length",()=>
            return @children.length
    clone:()->
        # clone will deep clone the children
        # but not the relation to parent
        node = new Node(@token)
        for child in  @children
            node.add child.clone()
        return node
    setToken:(token)->
        @token = token
        @string = token.string
        # is it an number?
        if reg.number.test @string
            @isNumber = true
            @value = parseInt(@string)
        if reg.string.test @string
            @isString = true
            @value = @string.substring(1,@string.length-1)
        if reg.hdfQuery.test @string
            @isHdfQuery = true
            @value = @string
    
    print:(indent)->
        createIndent = (num)->
            ("  " for _ in [0..num]).join("")
        indent = indent or 0
        indents = createIndent(indent)
        if @isFunction
            console.log indents + "function-"+@string
        else
            console.log indents + @string
        for child in @children
            child.print(indent+1)
    switchWith:(node)->
        _token = @token
        @setToken(node.token)
        node.setToken(_token)
        return
        _parent = @parent
        nodeParent = node.parent
        _children = @children
        nodeChildren = node.children
        if _parent
            _parent.remove this
        if nodeParent
            nodeParent.remove node
        if _parent
            _parent.add node
        if nodeParent
            nodeParent.add this
        for item in _children
            item.parent = node
        for item in nodeChildren
            item.parent = this
        @children = nodeChildren
        node.children = _children
        
    insertParentOf:(node)->
        # throw Error in many ways because
        # the usage of this method is under limited situation
        if node.parent is this
            throw new Error "already the parent of node"
        if @parent
            throw new Error "insert Parent should be an orphan"
        _nodeParent = null
        if node.parent
            _nodeParent = node.parent
            node.parent.remove(node)
        if _nodeParent
            _nodeParent.add this
        @add node
    replaceBy:(node)->
        if not @parent
            return false
        for item,index in @parent.children
            if item is this
                @parent.children[index] = node
                node.parent = @parent
                @parent = null
                return true
        return false
    insertChildrenOf:(node)->
        if @parent
            throw new Error "already has the parent"
        if this in node.children
            throw new Error "already the children"
        # this should be an orphan node
        console.assert @children.length is 0
        _nodeChildren = node.children
        for item in _nodeChildren
            item.parent = this
        @children = _nodeChildren
        node.children = [] # which should be []
        node.add this
        
        
    add:(node)->
        console.assert node not in @children
        node.parent = this
        @children.push node
    remove:(node)->
        index = @children.indexOf node
        console.assert index >= 0
        @children.splice index,1
        node.parent = null
        return true
    isOperater:()->
        return isOperater(@string)
    isValue:()->
        return isValue(@string)
    isSymbol:()->
        return isSymbol(@string)
    isWord:()->
        return isWord(@string)
    equal:(op)->
        return op is @string
    oneOf:(ops...)->
        return @string in ops
    isUnary:()->
        return isUnary(@string)
    toString:()->
        return @string
    isMulti:()->
        return isMulti @string
    isComplete:()->
        if @closed
            return true
        if @isOperater()
            if @isUnary() and @length is 1 and not @isMulti()
                return true
            else if @length is 2
                return true
            return false
        return true
    higherThan:(op)->
        if this.toString() is "["
            return false
        if op.toString() is "["
            return false
                
        if not @isOperater()
            console.trace()
            throw new Error "This Is Not Operator "+this
        if not isOperater(op)
            throw new Error "Not Operator "+op
        if compareOperator(this,op) > 0
            return true
        else
            return false
    sameLevelAs:(op)->
        if not @isOperater()
            console.trace()
            throw new Error "This Is Not Operator "+this
        if not isOperater(op)
            throw new Error "Not Operator "+op
        if compareOperator(this,op) == 0
            return true
        return false
class Expression
    constructor:(string)->
        @tokens = Token.parseTokens string
        @root = null
        @index = 0
        @string = string
        try
            @build()
        catch e
            console.error "current",@positionInHand.string
            console.error "cursor",@positionInTree.string
            console.error e,"source:",string
            throw e
    fromNode:(node)->
        @isFromNode = true
        @root = node
    clone:()->
        _ = new Expression("")
        _.root = @root.clone()
        return _
    print:()->
        @root.print(0)
    forward:()->
        # return the token and forward the index
        # and set positionInHand and positionInHand
        if @index >= @tokens.length
            @positionInHand = null
            return  null
        token =  @tokens[@index]
        if not token
            throw "Invalid Token at"+@index+"of"+@tokens.length
        @index++
        @positionInTree = @positionInHand
        @positionInHand = new Node(token)
        return @positionInHand
    build:()->
        @root = @_parseNode()
        if @positionInHand isnt null
            throw new Error "Unexpect Token "+@positionInHand
        return @root
    _parseNode:()->
        # parse nodes until unmatched ) or , or end of token (EOF)
        # unmatched ) and , IS PARSE AS positionInHand
         
        root = null
        @positionInHand = null
        @positionInTree = null
        while true
            
            result =  @forward()
            
            if not @positionInHand
                return root
            #console.log @index+":"
            if root and false
                root.print(0)
                console.log "c->",@positionInHand.toString()
                console.log "t->",@positionInTree and @positionInTree.toString() or null
                
            # root validate
            if not root
                root = @positionInHand
                if root.oneOf(",","]")
                    throw new Error "Invalid Expression Start:"+root
                if not root or root.equal(")")
                    return null
                if not root.equal("(") 
                    continue
                else
                    # pass 
                    # go over to parse ( body

            
            if @positionInHand.oneOf(",",")","]")
                return root
            if @positionInHand.equal("(") and (!@positionInTree or @positionInTree.isOperater())
                if @positionInTree
                    # if not root
                    @positionInTree.add(@positionInHand)
                anchor = @positionInHand
                parenthesisBody = @_parseNode()
                if not parenthesisBody
                    throw new Error "Empty parenthesis body"
                anchor.add parenthesisBody
                #positionInHand should now be ")"
                if not @positionInHand.equal(")")
                    throw new Error "Unexpected Token:"+@positionInHand.string
                
                anchor.closeNode = @positionInHand
                anchor.closeNode.startNode = anchor
                anchor.closed = true
                @positionInHand = anchor
                continue
            if @positionInHand.equal("[")
                if not @positionInTree or (not @positionInTree.isWord() and not @positionInTree.isOperater())
                    console.error @positionInTree.string
                    throw new Error "token [ can only follow an HDF value" 
                parent = @positionInTree
                while parent.parent and parent.parent.oneOf(".","[")
                    parent = parent.parent
                leftP = @positionInHand
                body = @_parseNode()
                if not body
                    throw new Error "Invalid [ ] Operater Without Value"
                if not @positionInHand.equal("]")
                    throw new Error "Unexpected Token:"+@positionInHand.string+" Unclosed ["
                leftP.closed = true
                leftP.insertParentOf parent
                leftP.add body
                if not leftP.parent
                    root = leftP
                @positionInHand = body
                continue

            if @positionInHand.equal("(") and @positionInTree.isWord()
                fnNode = @positionInTree
                if fnNode.isFunction
                    #like foo()()
                    throw new Error "Unexpect Function"+fnNode
                fnNode.isFunction = true
                functionParameters = @_parseFunctionParameters()
                for node in functionParameters
                    fnNode.add node
                @positionInHand = fnNode
                continue
            if @positionInHand.isValue()
                
                if @positionInTree.equal("(")
                    throw new Error "Unexpect Token: "+@positionInHand
                if @positionInTree.isValue()
                    throw new Error "Unexpect Token: "+@positionInHand
                if @positionInTree.isOperater()
                    if @positionInTree.isComplete()
                        root.print(0)
                        throw new Error "Unexpect Token: "+@positionInHand
                    @positionInTree.add @positionInHand
                    continue
                else
                    throw new Error "Unexpect Token "+@positionInHand
            if @positionInHand.isOperater()
                if @positionInTree.equal("[") and not @positionInTree.closed
                    throw new Error "Unexpected Situation"
                if @positionInTree.isOperater() and not @positionInTree.equal("[")
                    # only in [ operater
                    # the second operater may be an operater "["(another "[")
                    if not @positionInHand.isUnary()
                        throw new Error "Unexpected Token "+@positionInHand
                    @positionInTree.add @positionInHand
                    continue
                if @positionInTree.isValue() or @positionInTree.oneOf("(","[")
                    if not @positionInTree.parent or (@positionInTree.parent.isOperater() and @positionInHand.higherThan(@positionInTree.parent))
                        if @positionInTree.parent and @positionInTree.parent.oneOf("(")
                            @positionInHand.insertChildrenOf @positionInTree
                        else
                            @positionInHand.insertParentOf @positionInTree
                            if not @positionInHand.parent
                                root = @positionInHand
                        continue
                    if !@positionInHand.higherThan(@positionInTree.parent)
                        node = @positionInTree.parent
                        while node.parent and !node.parent.oneOf("[","(")
                           if !@positionInHand.higherThan(node.parent)
                                node = node.parent
                            else
                                break
                        @positionInHand.insertParentOf(node)
                        if root is node
                            root = @positionInHand
                        continue
     
            throw new Error "Unknow Situation"
#    _checkAndFindTopParenthesis:()->
#        console.assert @positionInHand.equal(")")
#        node = @positionInHand
#        while node
#            
#            console.log node.toString()
#            if node.equal("(")
#                return node
#            if not node.isComplete()
#                throw new Error "Unexpected Token )"
#            node = node.parent
#        throw new Error "Un Paired Token )"
    _parseFunctionParameters:()->
        # parse function parameters form until unmatched )
        # throw Error on EOF
        results = []
        node = @_parseNode()
        if not node
            return []
        results.push node
        while @positionInHand.equal(",")
            node = @_parseNode()
            results.push node
        if @positionInHand and @positionInHand.equal(")")
            return results
        throw "Unexpect Function End:"+ @positionInHand
exports.Expression = Expression