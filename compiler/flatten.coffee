# flatten expression tree to
# 1 dimension action + declare(init)
# and CHECK action validity
idIndex = 0
createId = ()->
    return idIndex++

flattenExpressionNode = (node,results)->
    if not results
        results = []
    # final value
    if node.children.length is 0
        id = createId()
        if node.isNumber and node.forceNumber 
            results.push {type:"init",id:id,value:node.value,valueType:"number"}
            
        else if node.isString
            results.push {type:"init",id:id,value:node.value,valueType:"string"}
        else if node.isHdfQuery or node.isNumber
            results.push {type:"init",id:id,value:node.value.toString(),valueType:"hdfQuery"}
        else
            throw new Error "Unknow end point expression value "+node.string
        
        return {id:id}

    if node.isFunction
        params = []
        for paramNode in node.children
            paramInfo = flattenExpressionNode(paramNode,results)
            params.push paramInfo
        functionEvalResultId = createId()
        results.push {type:"functionEval",id:functionEvalResultId,functionName:node.string,params:params}
        return {id:functionEvalResultId}
    if node.isOperater()
        console.assert node.isComplete(),"operater node should be complete",node
        
        resultId = createId()
        if node.isUnary() and node.children.length is 1
            console.assert node.children.length is 1,"unary operater should has one children"
            value = flattenExpressionNode(node.children[0],results)
            results.push {type:"operater",operater:node.string,params:[value],id:resultId}
            return {id:resultId}
        else
            console.assert node.children.length > 1,"normal operater shuold has at least 2 children"
            params = []
            for paramNode in node.children
                paramInfo = flattenExpressionNode(paramNode,results)
                params.push paramInfo
            results.push {type:"operater",operater:node.string,params:params,id:resultId}
            return {id:resultId}
    if node.equal("(")
        console.assert node.children.length is 1,"( node should have and only have one children"
        return flattenExpressionNode(node.children[0],results)
    throw new Error "Unexpect expression node"+node
exports.staticCompute = ()->
    
exports.flatten = (expression)->
    results = []
    output = flattenExpressionNode(expression.root,results)
    return {actions:results,finalValue:output}
exports.reset = ()->
    idIndex = 0