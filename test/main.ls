require! <[../src/offset]>

d = "M23.76-1.20L10.72 11.84L4.32-4.56L23.76-1.20"
ret = offset d, {x: 10, y: 10}
console.log d
console.log ret
