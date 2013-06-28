expression = require "../common/expression.coffee"
cases = [
    "a[b].c",
    "a.b.c+x.y['z']",
    "a[b]",
    "a[b[c[d[e]]]]",
    "a[b[c]].d",
    "m[x['n']].z",
    "a.b.c+x.y['z']+m[x['n']].z"
    "4+Foo(test)+5",
    "x.y[z]+5",
    "x.y[z][m]+5",
    "x.y[a[z]+'3'][m]+5",
    "fooName(#5,100)",
    "abc.def.xyz == '123'"
]
for test in cases
    console.log "test",test
    x = new expression.Expression(test)
    x.print()
