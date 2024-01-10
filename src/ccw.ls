utils =
  _parse-for-ccw: ({obj, rel, v, step}) ->
    for i from 0 til v.length by step =>
      [x, y] = [+v[i + step - 2], +v[i + step - 1]]
      if rel => [x, y] = [x + obj.px, y + obj.py]
      if obj.ps.length and x == obj.ps[* - 1].0 and y == obj.ps[* - 1].1 => continue
      obj.ps.push [x, y]
      obj <<< px: x, py: y

  # str: SVG Path Command String
  is-ccw: (str) ->
    ret = str.split /(?=[MLHVCSQTAZ])/ig
    obj = {ps: [], px: 0, py: 0}
    ret.map (c) ->
      cn = c.substring(0,1)
      CN = cn.toUpperCase!
      rel = (cn != CN)
      v = c.substring(1).split(/(?=[, -])/ig)
      switch cn.toUpperCase!
      | <[H V]>
        t = if CN == \H => <[px py]> else <[py px]>
        for i from 0 til v.length =>
          v = if rel => v[i] + obj[t.0] else v[i]
          obj.ps.push(if CN == \H => [v, obj[t.1]] else [obj[t.1], v])
          obj[t.0] = x
      | <[M L T]> => utils._parse-for-ccw {obj, rel, v, step: 2}
      | <[S Q]> => utils._parse-for-ccw {obj, rel, v, step: 4}
      | <[C]> => utils._parse-for-ccw {obj, rel, v, step: 6}
      | <[A]> => utils._parse-for-ccw {obj, rel, v, step: 7}
    ret = obj.ps.map (d,i) -> [d,i]
    if ret.length < 3 => return true
    ret.sort (a,b) -> a.0.1 - b.0.1
    idx = ret.1.1
    ps = [
      obj.ps[(idx - 1 + obj.ps.length) % obj.ps.length]
      obj.ps[idx]
      obj.ps[(idx + 1) % obj.ps.length]
    ]
    AB = [ps.1.0 - ps.0.0, ps.1.1 - ps.0.1, 0]
    AC = [ps.1.0 - ps.2.0, ps.1.1 - ps.2.1, 0]
    cp = [
      AB.1 * AC.2 - AC.1 * AB.2
      AB.2 * AC.0 - AC.2 * AB.0
      AB.0 * AC.1 - AC.0 * AB.1
    ]
    dir = Math.sign(cp.2)
    if isNaN(dir) => dir = -1
    # counter clockwise if dir is negative
    return dir == -1

