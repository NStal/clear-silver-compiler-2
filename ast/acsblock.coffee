Type = require "./acsblock-type.coffee"
_parseACSClauseBlock = (csString,index)->
    parseCSBlockStart = (csString,index)->
        return csString.indexOf("<?cs",index)
    parseCSBlockEnd = (csString,index)->
        return csString.indexOf("?>",index)
    start = parseCSBlockStart(csString,index)
    if start < 0
        return null
    end = parseCSBlockEnd(csString,start+2)
    if end < 0
        return null
    csRawContentString = csString.substring(start+4,end)
    csContentString = csRawContentString.trim()
    
    return {
        start:start
        ,end:end+2
        ,content:csContentString
        ,source:csString
        ,blockType:"clause"
    }
parseACSBlocks = (csString)->
    blocks = []
    index = 0
    while csBlock = _parseACSClauseBlock(csString,index)
        # add echo blocks between clauses
        blocks.push {
            content:csString.substring(index,csBlock.start),
            index:blocks.length,
            start:index,
            end:csBlock.start,
            blockType:"text",
            source:csString
            }
        csBlock.index = blocks.length
        blocks.push csBlock
        index = csBlock.end
    if index < csString.length
        blocks.push {
            content:csString.substring(index),
            start:index,
            end:csString.length,
            index:blocks.length,
            blockType:"text",
            source:csString
        }
    if not Type
        return blocks
    for block in blocks
        Type.attachBlockType(block)
    return blocks
exports.parseACSBlocks = parseACSBlocks