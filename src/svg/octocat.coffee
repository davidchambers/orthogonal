_ = require 'underscore'

orthogonal = require '../orthogonal'
orthogonal.extend global


octocat = [
  # water
  ['#62e3ff', (r 2)(d 13) \
              (R 1)(D 1)(L 1)(U 1) \
              (r 4)(d 4) \
              (R 8)(D 1)(R 1)(D 2)(L 1)(D 1)(L 8)(U 1)(L 1)(U 2)(R 1)(U 1)]
  # hoodie
  ['#000000', (r 5)(d 2) \
              (R 1)(D 1)(R 1)(D 1)(R 6)(U 1)(R 1)(U 1)(R 1)(D 3)(R 1)(D 5) \
              (L 1)(D 1)(L 1)(D 1)(L 2)(D 1)(R 1)(D 6)(R 1)(U 1)(L 8)(D 1) \
              (R 1)(U 4)(L 2)(U 1)(L 1)(U 2)(L 2)(D 1)(R 4)(D 1)(R 1)(U 1) \
              (R 1)(U 1)(L 2)(U 1)(L 1)(U 1)(L 1)(U 5)(R 1)(U 3) \
              (r 3)(d 14) \
              (R 1)(D 3)(L 1)(U 3) \
              (r 3) \
              (R 1)(D 3)(L 1)(U 3)]
  # face
  ['#ffc09f', (r 7)(d 7) \
              (R 6)(D 1)(R 1)(D 2)(L 1)(D 1)(L 6)(U 1)(L 1)(U 2)(R 1)(U 1)]
  # features
  ['#b1423a', (r 7)(d 8)(R 1)(D 2)(L 1)(U 2) \
              (r 5)(d 0)(R 1)(D 2)(L 1)(U 2) \
              (l 3)(d 2)(R 2)(D 1)(L 2)(U 1)]
  # reflection
  ['#43afff', (r 6)(d 19) \
              (R 1)(D 2)(R 1)(U 2)(R 1)(D 2)(R 2)(U 2)(R 1)(D 2)(R 1)(U 2) \
              (R 1)(D 1)(L 8)(U 1)]
]


module.exports = (opts) ->

  smallOctocatWidth = opts.octocatWidth * opts.octocatScale[0]
  smallOctocatHeight = opts.octocatHeight * opts.octocatScale[0]
  numRows = opts.numBorderRows + opts.numHexRows + opts.numBorderRows
  numColsToSplit = (opts.width - opts.numHexCols * smallOctocatWidth) // smallOctocatWidth
  numCols = opts.numHexCols + switch numRows % 4
    when 1 then numColsToSplit - numColsToSplit % 2
    when 3 then numColsToSplit + numColsToSplit % 2 - 1
  padding = (opts.width - smallOctocatWidth * numCols) // 2
  height = padding + numRows * smallOctocatHeight + padding

  toPathElement = (fill, path, scale) ->
    """  <path fill-rule="evenodd" fill="#{fill}" d="#{orthogonal.formatters.svg path, scale}" />"""

  """
  <?xml version="1.0" standalone="no"?>
  <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
  <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="#{opts.width}px" height="#{height}px">
  #{(_.chain numCols + numRows // 2)
      .range()
      .map((x) ->
        ys = if x < numRows / 2
          (_.range 2 * x + 1)
        else if x > numCols - 1
          (_.range 2 * (x - (numCols - 1)), numRows)
        else
          (_.range numRows)
        ys.map (y) -> [x,y]
      )
      .flatten(shallow = yes)
      .reject(([x,y]) ->
        -opts.numHexRows <= 2 * y - numRows < opts.numHexRows and
        -opts.numHexCols <= 2 * (x - numRows // 4) - numCols < opts.numHexCols and
        0 <= x - y - ((numCols - opts.numHexCols - opts.numHexRows // 2) - opts.numBorderRows) // 2 < opts.numHexCols
      )
      .map(([x,y]) ->
        offset = (r padding + (x - y / 2) * smallOctocatWidth) \
                 (d padding + y * smallOctocatHeight)
        octocat
          .map(([fill,path]) -> (toPathElement fill, (offset)(path), opts.octocatScale[0]))
          .join('\n')
      )
      .value()
      .join('\n')}
  #{octocat
      .map(([fill,path]) ->
        offset = (r (opts.width / opts.octocatScale[1] - opts.octocatWidth) / 2) \
                 (d (height / opts.octocatScale[1] - opts.octocatHeight) / 2)
        (toPathElement fill, (offset)(path), opts.octocatScale[1])
      )
      .join('\n')}
  </svg>
  """


if process.argv[1] is __filename then console.log module.exports
  width: 728  # GitHub README width
  octocatWidth: 20
  octocatHeight: 24
  octocatScale: [1, 12]
  numHexCols: 17
  numHexRows: 13
  numBorderRows: 7
