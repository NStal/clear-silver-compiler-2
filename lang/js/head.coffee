fs = require "fs"
HDFPath = process.argv[2]
if not HDFPath
    console.log "need an hdf path"
    process.exit(0)
hdfString = (fs.readFileSync(HDFPath).toString())
json = exports.hdfToJson(hdfString)
outputBuffers = []
class _CSValue
    constructor:(value,type)->
        if not type
            type = "None"
        @type = type
        @value = value
    toPrimitive:()->
        if @type is "number" or @type is "string"
            return @value or 0
        if @type is "hdfQuery"
            if not @hdfNode or ""
                @hdfNode = Dataset.get @value
            return @hdfNode.____value.toPrimitive() or ""
        if @type is "None"
            return ""
        throw new Error "Unknow value type"

CSValue = (v,t)->
    return new _CSValue(v,t)

class HDF
    constructor:(json)->
        @data = json
        @regulize(@data)
    regulize:(json)->
        if typeof json.____value isnt "undefined" and not json.____value.type
            json.____value = CSValue(json.____value,"string")
        for item of json
            if item is "____value"
                continue
            if typeof json[item] is "string" or typeof json[item] is "number"
                json[item] = {____value:CSValue(json[item],"string")}
            else
                @regulize(json[item])
                
    get:(path,root)->
        if not path
            throw new Error "get empty hdf"
        pathes = path.split(".")
        if not root
            cur = @data
        else
            cur = root
        while pathes.length > 0
            route = pathes.shift()
            if not cur[route]
                cur[route] = {}
            if not cur[route].____value
                cur[route].____value = new _CSValue()
            cur = cur[route]
        return cur
    set:(path,value)->
        if not path
            throw new Error "get empty hdf"
        pathes = path.split(".")
        cur = @data
        while pathes.length > 0
            route = pathes.shift()
            if not cur[route]
                cur[route] = {}
            if not cur[route].____value
                cur[route].____value = new _CSValue()
            cur = cur[route]
        cur.____value = value
        return cur
    getNode:(path)->
        if not path
            throw Error "get empty hdf"
        pathes = path.split(".")
        cur = @data
        while pathes.length > 0
            route = pathes.shift()
            if not cur[route]
                cur[route] = {}
            if not cur[route].____value
                cur[route].____value = new _CSValue()
            cur = cur[route]
        nodes = []
        for item of cur
            if item isnt "____value"
                if not cur[item].____value
                    cur[item].____value = new _CSValue()
                nodes.push cur[item]
        return {nodes:nodes,____value:cur.____value or CSValue("","string")}
Dataset = new HDF(json)
CSVar = (value)->
    outputBuffers.push value.toPrimitive().toString()
CSEcho = (string)->
    outputBuffers.push string

CSIf = (v)->
    if v is true
        return true
    if v is false
        return false
    if v and v.value
        return true
    return false
HdfSet = (path,value)->
    if typeof value.toPrimitive is "function"
        Dataset.set(path,value)
        
HdfGet = (path)->
    return Dataset.get(path)
HdfRef = (ref,node)->
    Dataset.data[ref] = node

ToHDF = (v)->
    console.assert v.type is "hdfQuery"
    node = Dataset.getNode(v.value)
CSOperate_dynamicRef = (v1,v2)->
    console.assert v1.type is "hdfQuery"
    path = v2.toPrimitive()
    if not v1.hdfNode
        v1.hdfNode = Dataset.get v1.value
    hdfNode = Dataset.get path,v1.hdfNode
    v3 = CSValue(v1.value+"."+path,"hdfQuery")
    v3.hdfNode = hdfNode
    return v3
CSOperate_dotRef = (v1,v2)->
    try
        console.assert v1.type is "hdfQuery"
        console.assert v2.type is "hdfQuery"
    catch e
        throw new Error "Invalid DotRef"
    path = v2.value
    if not v1.hdfNode
        v1.hdfNode = Dataset.get v1.value
    hdfNode = Dataset.get path,v1.hdfNode
    v3 = CSValue(v1.value+"."+path,"hdfQuery")
    v3.hdfNode = hdfNode
    return v3

CSOperate_forceNumber = (v)->
    if v.type is "number"
        return v
    else 
        return CSValue(parseInt(v.value) or 0,"number")
CSOperate_add = (v1,v2)->
    if not v2
        return v1
    result = (v1.toPrimitive()+v2.toPrimitive()) or ""
    if typeof result is "number"
        return CSValue(result,"number")
    else
        return CSValue(result.toString(),"string")
CSOperate_isEqual = (v1,v2)->
    return v1.toPrimitive().toString() is v2.toPrimitive().toString()

CSOperate_forceHDFRef = (v)->
    return v