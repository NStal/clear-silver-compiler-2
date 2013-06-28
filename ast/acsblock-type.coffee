# unsafe replace
# not escape any reg special chars
error = require "../error/error.coffee"
TypeMaps = [
    {type:"var" ,tag:"var"}
    ,{type:"if",tag:"if"}
    ,{type:"elseIf",tag:"elseif"}
    ,{type:"else",tag:"else"}
    ,{type:"endIf",tag:"/if"}
    ,{type:"set" ,tag:"set"}
    ,{type:"each",tag:"each"}
    ,{type:"endEach",tag:"/each"}
    ,{type:"def",tag:"def"}
    ,{type:"endDef",tag:"/def"}
    ,{type:"call",tag:"call"}
    ,{type:"loop",tag:"loop"}
    ,{type:"endLoop",tag:"/loop"}
    ]
# build clauesMap
for item in TypeMaps
    TypeMaps[item.type] = item.tag
exports.TypeMaps = TypeMaps
exports.attachBlockType = (block)->
    if block.blockType is "text"
        block.type = "echo"
        return true
    for type in TypeMaps
        if block.content.trim().indexOf(type.tag) is 0
            block.type = type.type
            return
    throw new error.UnknownBlockType(block)