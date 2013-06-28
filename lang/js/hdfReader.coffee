InitHDFReader = ()->
    reg = {}
    reg.space = /\s/i
    reg.hdfQuery = /[a-z0-9_.]/i
    parseHDFDict = (string,start,hdfDict,current)->
        index = start
        while true
            while reg.space.test string[index]
                index++
            if not string[index] or string[index] is "}"
                return index
            queryStart = index
            while reg.hdfQuery.test string[index]
                index++
            if not string[index]
                throw new Error "Unexpect HDF End"
            subQuery = string.substring(queryStart,index)
            while new RegExp(" ","i").test string[index]
                index++
            #console.log string.substr(index,10)
            if string[index] is "="
                index++
                while new RegExp(" ","i").test string[index]
                    index++
                valueStart = index
                valueEnd = string.indexOf "\n",index
                value = string.substring(valueStart,valueEnd)
                index = valueEnd+1
                hdfDict.push {
                    path:[current,subQuery].join(".")
                    ,value:value
                }
                continue
            else if string[index] is "{"
                index++
                index = parseHDFDict string,index+1,hdfDict,[current,subQuery].join(".")
                if string[index] isnt "}"
                    throw new Error "unclosed {"
                index++
                continue
            else if string[index] is ":"
                while new RegExp(" ","i").test string[index]
                    index++
                valueStart = index
                valueEnd = string.indexOf "\n",index
                value = string.substring(valueStart,valueEnd)
                index = valueEnd+1
                hdfDict.push {
                    path:[current,subQuery].join(".")
                    ,value:value.trim()
                    ,refer:true
                }
                continue
            else
                throw new Error "Unexpect Token at index "+index+":"+string[index]
    
    hdfToJson = (string)->
        dict = []
        parseHDFDict string,0,dict,"root"
        json = {}
        for item in dict
            routes = item.path.split(".")
            _refer = json
            for route in routes
                if route.indexOf("____")  is 0
                    console.warn "hdf query path can't start with ____"
                    
                    return null
                if not _refer[route]
                    _refer[route] = {}
                _refer = _refer[route]
            if item.refer
                console.warn "current not support refering"
                continue
            _refer.____value = item.value
        return json.root
    if exports
        exports.parseHDFDict = parseHDFDict
        exports.hdfToJson = hdfToJson
InitHDFReader()