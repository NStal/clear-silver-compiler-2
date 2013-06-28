exports.add = (a,b)->
    if a.string.isNumber and b.string.isNumber
        return a.value+b.value
    return a.string + b.string
exports.minus = (a,b)->
    if a.isNumber and b.isNumber
        return a.value-b.value
    throw new Error "minus only accept number"  
exports.multiply = (a,b)->
    if a.isNumber and b.isNumber
        return a.value*b.value
    throw new Error "minus only accept number"
exports.divide = (a,b)->
    if a.isNumber and b.isNumber
        return a.value/b.value
    throw new Error "minus only accept number"
              