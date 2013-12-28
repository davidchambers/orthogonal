orthogonal = require '../orthogonal'
orthogonal.extend global


path = (r 1)(d 0)(R 2)(D 7)(L 2)(U 7)(l 1)(d 1)(R 4)(D 5)(L 4)(U 5) \
       (r 6)(d 0)(R 2)(D 1)(L 3)(D 5)(R 1)(U 6)(r 3)(u 1)(R 1)(D 1) \
       (R 1)(D 1)(L 1)(D 5)(R 1)(U 1)(L 2)(U 6)(r 3)(d 0)(R 1)(D 1) \
       (R 2)(D 6)(R 1)(U 5)(L 3)(D 5)(L 1)(U 7)(r 6)(d 1)(R 2)(D 6) \
       (L 2)(U 6)(l 1)(d 1)(R 4)(D 4)(L 4)(U 4)(r 6)(u 1)(R 2)(D 5) \
       (L 3)(U 4)(R 4)(D 6)(L 3)(D 1)(R 2)(U 2)(L 2)(U 6)(r 5)(d 0) \
       (R 2)(D 6)(L 2)(U 6)(l 1)(d 1)(R 4)(D 4)(L 4)(U 4)(r 6)(u 1) \
       (R 2)(D 6)(R 1)(U 5)(L 4)(D 5)(R 1)(U 6)(r 5)(d 0)(R 2)(D 2) \
       (L 2)(D 4)(R 2)(U 3)(L 3)(D 2)(R 5)(D 1)(L 1)(U 5)(L 3)(U 1) \
       (r 4)(u 1)(R 2)(D 7)(L 1)(U 6)(L 1)(U 1)


module.exports = (opts) ->
  [...,w,h] = (orthogonal.bounds path, opts.scale)
  """
  <?xml version="1.0" standalone="no"?>
  <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
  <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="#{w}px" height="#{h}px">
    <path fill-rule="evenodd" d="#{orthogonal.formatters.svg path, opts.scale}" />
  </svg>
  """


if process.argv[1] is __filename
  console.log module.exports scale: 12
