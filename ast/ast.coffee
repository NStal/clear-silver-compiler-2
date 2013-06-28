Expression = (require "../common/expression.coffee").Expression
expand = (str)->
    hdfRefer = "[0-9_a-z]+(\\.[0-9_a-z]+)*"
    #word = "[a-z_]+[0-9_a-z]*"
    word = "[0-9_a-z\"]+"
    tokens = ["\\+","-","\\*","\\\\",">","<",">=","<=","==","!=","\\.","\\s","#","\\$","\\[","\\]","\""]
    exps = ["(",word,")"]
    for token in tokens
        
        exps.push "|","(",token,")"
    expression = ["(",exps.join(""),")","+"].join("")
    macroName = ".*"
    str = str.replace /{expression}/g,expression
    str = str.replace /{macroName}/g,macroName
    name = word
    str = str.replace /{name}/g,word
    str = str.replace /{hdf}/g,hdfRefer
    return new RegExp(str,"ig")
extractAndAttachExpression = (node)->
    if node.type is "if"
        #if:{expression}
        reg = expand("^if:{expression}$")
        if not reg.test node.content
            throw new Error "Unexpect If Expression:"+node.content 
        str = node.content.substring(node.content.indexOf("if:")+3).trim()
        node.expressions = [new Expression(str)]
    else if node.type is "elseIf"
        reg = expand("^elseif:{expression}$")
        if not reg.test node.content
            throw new Error "Unexpect ElseIf Expression:"+node.content 
        str = node.content.substring(node.content.indexOf("elseif:")+7).trim()
        node.expressions = [new Expression(str)]
    else if node.type is "each"
        #each"{name}={hdf}
        reg = expand("^each:({name})\\s*=\\s*({expression})$") 
        if not reg.test node.content
            throw new Error "Unexpect Each Expression"
        splitIndex = (node.content.indexOf "=")
        start = (node.content.indexOf("each"))+"each:".length
        node.names = [node.content.substring(start,splitIndex).trim()]
        node.expressions = [new Expression(node.content.substring(splitIndex+1).trim())]
    else if node.type is "var"
        reg = expand("^var:{expression}$")
        if not reg.test node.content.trim()
            throw new Error "Unexpect Var Expression:"+node.content
        str = node.content.substring("var:".length)
        node.expressions = [new Expression(str)]
    else if node.type is "set"
        reg = expand("^set:{expression}\\s*=\\s*{expression}$")
        if not reg.test node.content.trim()
            throw new Error "Unexpect Set Expression:"+node.content
        splitIndex = (node.content.indexOf "=")
        start = (node.content.indexOf("set:"))+"set:".length
        hdf = node.content.substring(start,splitIndex).trim()
        node.expressions = [new Expression(hdf),new Expression(node.content.substring(splitIndex+1))]
    else if node.type is "echo"
        node.validString = node.content.replace(/\n/g,"\\n")
        node.validString = node.validString.replace(/\r/g,"\\r")
    else if node.type is "call"
        reg = expand("^call:{macroName}\(({expression})*(,{expression})*\)$")
        if not reg.test node.content
            throw new Error "Unexpect Call Expression:"+node.content 
        str = node.content.substring(node.content.indexOf("call:")+5).trim()
        node.macroName = str.substring(0,str.indexOf("("))
        node.names = [node.macroName]
        paramstr = str.substring(str.indexOf("("))
        exp = new Expression("macro"+paramstr)
        node.paramstr = paramstr
        node.expressions = []
        for item in exp.root.children
            _ = new Expression()
            _.fromNode(item)
            node.expressions.push _
    else if node.type is "else"
        # donothing
        true
    else if node.type is "def"
        reg = expand("^def:{macroName}\(({name})*(,{name})*\)$")
        if not reg.test node.content
            throw new Error "Unexpect Def Expression:"+node.content 
        str = node.content.substring(node.content.indexOf("def:")+4).trim()
        
        node.macroName = str.substring(0,str.indexOf("("))
        paramstr = str.substring(str.indexOf("("))
        exp = new Expression("macro"+paramstr)
        if not exp.root.isFunction
            console.log str,"def not function?"
        
        console.assert exp.root.isFunction
        node.params = []
        for param in exp.root.children
            node.params.push param.string
    else
        console.error "Unknow AST Node",node
        throw new Error "Unknow AST Node"

exports.extractAndAttachExpression = extractAndAttachExpression








