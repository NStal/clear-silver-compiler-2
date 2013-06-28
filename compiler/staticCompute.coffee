reg = require "../common/reg.coffee"
operator = require "../interpreter/operator.coffee"
# return value:
# node -> is static computed to an static value
# null -> expression can't be computed to an static value
staticComputeExpression = (node)->
    console.log "!!!!"
    console.assert node
    if node.isNumber
        return node
    if node.isString
        return node
    if node.isWord()
        return node
    if node.string is "#"
        # "#" is unary and the child must be number
        if not node.children or node.children.length isnt 1 
            throw new Error "# should be followed a number"
        if not node.children[0]
            throw new Error "Compiler Error:Meet Empty Node Inside '#'"
        if not node.children[0].isNumber
            # Question:can '#' used to force an HDF value be a number?
            throw new Error "# should be followed a number"
        number = node.children[0]
        node.setToken(number.token)
        node.forceNumber = true
        node.children = 0
        return node
        
    if node.string is "/"
        if node.children.length is 2
            leftParam = staticComputeExpression(node.children[0])
            rightParam = staticComputeExpression(node.children[0])
            if leftParam is null or rightParam is null
                return null
            node.setToken {string:(operator.divide leftParam,rightParam),position:null,from:["/",leftParam,rightParam]}
            node.children.length = 0
            return node
        throw new Error "Invalid / Operator"
    if node.string is "*"
        if node.children.length is 2
            leftParam = staticComputeExpression(node.children[0])
            rightParam = staticComputeExpression(node.children[0])
            if leftParam is null or rightParam is null
                return null
            node.setToken {string:(operator.multiply leftParam,rightParam),position:null,from:["*",leftParam,rightParam]}
            node.children.length = 0
            return node
        throw new Error "Invalid * Operator"
    if node.string is "+"
        # "+ can be unary"
        if node.children.length is 1
            result = staticComputeExpression(node.children[0])
            if result is null
                return null
            node.setToken result.token
            node.children.length = 0
            return node
        if node.children.length is 2
            leftParam = staticComputeExpression(node.children[0])
            rightParam = staticComputeExpression(node.children[0])
            if leftParam is null or rightParam is null
                return null
            node.setToken {string:(operator.add leftParam,rightParam),position:null,from:["+",leftParam,rightParam]}
            node.children.length = 0
            return node
        throw new Error "Invalid + Operator"
    if node.string is "-"
        # "- can be unary"
        if node.children.length is 1
            result = staticComputeExpression(node.children[0])
            if result is null
                return null
            if not result.isNumber
                throw new Error "Invalid - Operator"
            result.token.string = "-"+result.token.string
            node.setToken result.token
            node.value = -result.value
            node.children.length = 0
            return node
        if node.children.length is 2
            leftParam = staticComputeExpression(node.children[0])
            rightParam = staticComputeExpression(node.children[0])
            if leftParam is null or rightParam is null
                return null
            node.setToken {string:(operator.minus leftParam,rightParam),position:null,from:["-",leftParam,rightParam]}
            node.children.length = 0
            return node
        throw new Error "Invalid + Operator"
    if node.string is "."                
        if node.children.length isnt 2
            throw new Error ". Operater expect 2 parameter"
        leftParam = staticComputeExpression(node.children[0])
        rightParam = staticComputeExpression(node.children[0])
        if leftParam is null or rightParam is null
            return null
        if (reg.hdfQuery.test leftParam.string) and (reg.hdfQuery.test rightParam.string)
            node.setToken {string:[leftParam.string,".",rightParam.string].join(""),position:null,from:[".",leftParam,rightParam]}
            node.children.length = 0
            return node
        return null
    





exports.staticComputeExpression