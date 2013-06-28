fs = require "fs"
reader = require "../lang/js/hdfReader.coffee"
test = "test/test.hdf"
hdfString = (fs.readFileSync test).toString()
json = reader.hdfToJson hdfString
console.log json
    