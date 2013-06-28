class UnknownBlockType extends Error
    constructor:(block)->
        super("Unknow Block Type:"+block.content)
TraceErrorByBlock = (block)->
    console.error block.content
    console.error "at",block.start,"~",block.end
    console.error "at line",LineCountTill(block.source,block.start)
LineCountTill = (string,position)->
    if position >= string.length
        position = string.length
    index = 0
    count = 0
    while index < position
        if string[index] is "\n"
            count++
        index++
    return count
exports.TraceErrorByBlock = TraceErrorByBlock
exports.UnknownBlockType = UnknownBlockType
    