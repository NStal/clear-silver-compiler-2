fs = require "fs"
Flatten = require "./flatten.coffee"

class Context
    constructor:()->
        @variableIndex = 0
        @variableIdMapTable = []
        @defineTables = []
        @guidIndex = 0;
    getVariableName:(id,hint)->
        hint = hint or "_"
        if @variableIdMapTable[id]
            return @variableIdMapTable[id]
        @variableIdMapTable[id] = "__CSVar"+hint+id
        return @variableIdMapTable[id]
    createUnconclictId:()->
        return @guidIndex++
Templates = {
    if:"""
while(1){// to simulate if else
    {precalculate}
    if(CSIf({expression0})){
        {body}
        break;
    }
    {elseIfs}
    {elseBody}
    break;
}
"""
    ,elseIf:"""
{precalculate}
if(CSIf({expression0})){
    {body}
    break;
}
    """
    ,each:"""
{precalculate}
CSValue* refer{id} = {expression0};
HdfNode* nodeRefer{id} = ToHDF(refer{id});
for(int index{id}=0;index{id} < nodeRefer{id}->children->length;index{id}++){
    HdfSetReferByChars("{name}",(HdfNode*)cscArrayGet(nodeRefer{id}->children,index{id}));
    {body}
}
"""
    ,var:"""{precalculate}
CSVar({expression0});
"""
    ,"set":"""{precalculate}
HdfSet({expression0},{expression1});
"""
    ,echo:"""CSEcho("{validString}",{strLength});"""
    ,"call-expand":"""
    //call-expand {name}
    {body}
    """
    }
exports.Context = Context
exports.assamble = (ACTree,context)->
    codes = []
    for node in ACTree
        code = translate(node,context)
        codes.push code
    return codes.join "\n"
    
OperaterNameMap = {
    "+":"add"
    ,"-":"minus"
    ,"*":"multiply"
    ,"/":"divide"
    ,"%":"mod"
    ,".":"dotRef"
    ,"[":"dynamicRef"
    ,"==":"isEqual"
    ,"#":"forceNumber"
    ,"$":"forceHDFRef"
}
translateExpression = (flattendExpression,context)->
    results = []
    for action in flattendExpression
        tVarName = context.getVariableName(action.id)
        if action.type is "init"
            # var foo = CSValue(initValue)
            if action.valueType is "string"
                results.push "CSValue* #{tVarName}=newCSString(\"#{action.value}\",#{action.value.replace('\\','').length});"
            else if action.valueType is "number"
                results.push "CSValue* #{tVarName}=newCSNumber(#{action.value});"
            else if action.valueType is "hdfQuery"
                results.push "CSValue* #{tVarName}=newCSRefer(\"#{action.value}\",#{action.value.replace('\\','').length});"
            else
                throw new Error "Unknow Init Value Type"
            
            continue
        else if action.type is "functionEval"
            # var foo = FunctionCall(param1,param2...)
            
            tVarName = context.getVariableName(action.id)
            params = (context.getVariableName(item) for item in action.params).join(",")
            
            results.push ["CSValue* ",tVarName,"=",action.functionName+"(",params,");"].join("")
            continue
        else if action.type is "operater"
            # var foo = OpName(param1,param2)
            console.assert OperaterNameMap[action.operater],"Should be an known operater" + action.operater
            operateName = OperaterNameMap[action.operater]
            params = (context.getVariableName(item.id) for item in action.params).join(",")
            results.push ["CSValue* ",context.getVariableName(action.id),"=","CSOperate_"+operateName+"(",params,");"].join("")
            
            continue
        throw new Error "Unexpect flattend expression "+action.type
    return results.join("\n")
        
translate = (node,context)->
    # flatten node expressions
    
    node.flattendExpressions = []
    if node.expressions
        for item in node.expressions 
            node.flattendExpressions.push Flatten.flatten(item)
    template = Templates[node.type]
    if not template
        throw new Error "Missing template:"+node.type
    body = []
    for child in node.body
        body.push translate(child,context)
    bodyCode = body.join("\n")
    elseIfs = []
    if node.elseIfList and node.elseIfList.length > 0
        for elseIfNode in node.elseIfList
            elseIfs.push translate(elseIfNode,context)
    elseIfCodes = elseIfs.join("\n")
    elseBody = []
    if node.elseNode 
        for child in node.elseNode.body
            elseBody.push translate(child,context)
    elseBodyCode = elseBody.join("\n")
    precalculate = []
    expressions = []
    # current only has 1 expression
    for exp in node.flattendExpressions
        precalculate.push translateExpression(exp.actions,context)
        
        expressions.push context.getVariableName(exp.finalValue.id)
    precalculateCode = precalculate.join("\n")
    #console.log precalculateCode
    name = node.names and node.names[0] or null
    hdf = node.hdfRefs and node.hdfRefs[0] or null
    if typeof node.validString is "string"
        validString = node.validString
        strLength = validString.replace(/\\/g,"").length
    else
        validString = null
        strLength = 0
    id = context.createUnconclictId().toString();
    code = fillTemplate(template,{body:bodyCode,expression:expressions,precalculate:precalculateCode,name:name,hdf:hdf,validString:validString,elseBody:elseBodyCode,elseIfs:elseIfCodes,id:id,strLength:strLength.toString()})
    
    #console.log "start",code,"end"
    return code
        
fillTemplate = (format,data)->
    # It's slow and optimizable
    replacements = []
    safeWord = parseInt(Math.random()*10000000000000).toString()+parseInt(Math.random()*10000000000000).toString()
    safeIndex = 0
    for item of data
        if data[item] instanceof Array
            for itemOfArr,index in data[item] 
                console.assert typeof itemOfArr is "string",data,"fillTemplate only accept objects consist of string and Array of string"
                lastIndex = 0
                if lastIndex = (format.indexOf "{"+item+index+"}",lastIndex) >= 0
                    replacements.push {holder:"{"+item+index+"}",content:itemOfArr.toString(),safeWord:safeWord+(safeIndex++)}
        else if typeof data[item] is "string" or data[item] is null
            if (format.indexOf "{"+item+"}") >= 0
                replacements.push {holder:"{"+item+"}",content:data[item],safeWord:safeWord+(safeIndex++)}
        else
            throw new Error "fillTemplate only accept objects consist of string and Array of string"
    # use safeWord to avoid unwanted replacement in code
    for item in replacements
        format = format.replace(new RegExp(item.holder,"g"),item.safeWord)
    for item in replacements
        if item.content is null
            throw new Error "expect "+item.holder+" but has null"
        format = format.replace(new RegExp(item.safeWord,"g"),item.content)
    return format

printMiddleCode = (tree,indent)->
    indent = indent or 0
    createIndent = (count)->
        ("  " for item in [0..count]).join("")
    string = createIndent(indent)+"|"
    for node in tree
        if node.expressions
            for exp,index in node.expressions
                flattend = Flatten.flatten exp
                expStrings = []
                for item in flattend.actions
                    expStrings.push JSON.stringify(item)
                expStrings.push "Finally"+JSON.stringify(flattend.finalValue)
                console.log string,"exp:",index,expStrings.join("\n")
        if node.type is "if"
            console.log string,"if",node.content
            printMiddleCode node.body,indent+1
            if node.elseIfList and node.elseIfList.length > 0
                for item in node.elseIfList
                    console.log string,"elseif",item.content
                    printMiddleCode item.body,indent+1
            if node.elseNode
                console.log string,"else"
                printMiddleCode node.elseNode.body,indent+1
            console.log string,"end-if"
        else if node.type is "each"
            console.log string,"each",node.content
            printMiddleCode node.body,indent+1
            console.log string,"end-each"
        else if node.type is "def"
            console.log string,"def",node.content
            printMiddleCode node.body,indent+1
        else if node.type is "call-expand"
            console.log string,"call-expand->"
            printMiddleCode node.body,indent+1
            console.log string,"/end call"
        else
            console.log string,node.type,node.content
exports.link = (heads,tails,code)->
    codes = []
    for head in heads
        codes.push fs.readFileSync(head).toString()
    codes.push code
    for tail in tails
        codes.push fs.readFileSync(tail).toString()
    return codes.join("\n")
exports.printMiddleCode = printMiddleCode