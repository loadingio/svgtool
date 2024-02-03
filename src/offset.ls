if !svgtool? => svgtool = {}
# offset a SVG Path command. by {dx, dy}
# we can support linear transformation in the future and port this to that function in the future.
svgtool.offset = (str, o={}) ->
  cmd = str.split /(?=[MLHVCSQTAZ])/ig
  obj = {ps: [], px: 0, py: 0}
  ret = []
  _ = (v) -> v.toFixed(2).replace(/\.00$/,'')
  add = (l,s,d) -> d.map (v,i) -> _(l[s + i] + v)
  cmd.map (c) ->
    cn = c.substring(0,1)
    CN = cn.toUpperCase!
    rel = (cn != CN)
    v = c.substring(1).split(/(?=[, -])/ig).map -> +it.trim!replace(/,/,'')
    ret.push cn
    [dx,dy] = if rel => [0, 0] else [o.dx, o.dy]
    switch cn.toUpperCase!
    | <[H V]>
      t = if CN == \H => \x else \y
      for i from 0 til v.length => ret ++= add(v, i, d[t])
    | <[M L T]> =>
      for i from 0 til v.length by 2 => ret ++= add v, i, [dx, dy]
    | <[S Q]> =>
      for i from 0 til v.length by 4 => ret ++= add v, i, [dx, dy, dx, dy]
    | <[C]> =>
      for i from 0 til v.length by 6 => ret ++= add v, i, [dx, dy, dx, dy, dx, dy]
    | <[A]> =>
      for i from 0 til v.length by 7 => ret ++= add v, i, [0,0,0,0,0, dx, dy]
  ret = ret.join(' ').replace(/ *([ZMLTSQCAHV-]) */g,'$1').replace(/ +/,' ')
  return ret

if module? => module.exports = svgtool;
else if window? => window.svgtool = svgtool;
