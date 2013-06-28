// Generated by CoffeeScript 1.6.3
var InitHDFReader;

InitHDFReader = function() {
  var hdfToJson, parseHDFDict, reg;
  reg = {};
  reg.space = /\s/i;
  reg.hdfQuery = /[a-z0-9_.]/i;
  parseHDFDict = function(string, start, hdfDict, current) {
    var index, queryStart, subQuery, value, valueEnd, valueStart;
    index = start;
    while (true) {
      while (reg.space.test(string[index])) {
        index++;
      }
      if (!string[index] || string[index] === "}") {
        return index;
      }
      queryStart = index;
      while (reg.hdfQuery.test(string[index])) {
        index++;
      }
      if (!string[index]) {
        throw new Error("Unexpect HDF End");
      }
      subQuery = string.substring(queryStart, index);
      while (new RegExp(" ", "i").test(string[index])) {
        index++;
      }
      if (string[index] === "=") {
        index++;
        while (new RegExp(" ", "i").test(string[index])) {
          index++;
        }
        valueStart = index;
        valueEnd = string.indexOf("\n", index);
        value = string.substring(valueStart, valueEnd);
        index = valueEnd + 1;
        hdfDict.push({
          path: [current, subQuery].join("."),
          value: value
        });
        continue;
      } else if (string[index] === "{") {
        index++;
        index = parseHDFDict(string, index + 1, hdfDict, [current, subQuery].join("."));
        if (string[index] !== "}") {
          throw new Error("unclosed {");
        }
        index++;
        continue;
      } else if (string[index] === ":") {
        while (new RegExp(" ", "i").test(string[index])) {
          index++;
        }
        valueStart = index;
        valueEnd = string.indexOf("\n", index);
        value = string.substring(valueStart, valueEnd);
        index = valueEnd + 1;
        hdfDict.push({
          path: [current, subQuery].join("."),
          value: value.trim(),
          refer: true
        });
        continue;
      } else {
        throw new Error("Unexpect Token at index " + index + ":" + string[index]);
      }
    }
  };
  hdfToJson = function(string) {
    var dict, item, json, route, routes, _i, _j, _len, _len1, _refer;
    dict = [];
    parseHDFDict(string, 0, dict, "root");
    json = {};
    for (_i = 0, _len = dict.length; _i < _len; _i++) {
      item = dict[_i];
      routes = item.path.split(".");
      _refer = json;
      for (_j = 0, _len1 = routes.length; _j < _len1; _j++) {
        route = routes[_j];
        if (route.indexOf("____") === 0) {
          console.warn("hdf query path can't start with ____");
          return null;
        }
        if (!_refer[route]) {
          _refer[route] = {};
        }
        _refer = _refer[route];
      }
      if (item.refer) {
        console.warn("current not support refering");
        continue;
      }
      _refer.____value = item.value;
    }
    return json.root;
  };
  if (exports) {
    exports.parseHDFDict = parseHDFDict;
    return exports.hdfToJson = hdfToJson;
  }
};

InitHDFReader();