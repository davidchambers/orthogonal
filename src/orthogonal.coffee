_ = require 'underscore'


exports.$ = $ = {}

# transformWith :: (m a -> m a) -> a -> m a
transformWith = (f) -> (val) ->
  (x) -> if x is $ then val else (f x)

# unit :: a -> m a
unit = transformWith _.identity

# bind :: m a -> (a -> m b) -> m b
bind = ($val) -> (transform) -> transform ($val $)

# concat :: [(Number,Number,String)] -> m [(Number,Number,String)]
concat = (list) ->
  (bind unit list) transformWith ($list) ->
    [initial..., last] = list
    [first, rest...] = ($list $)
    [xs, ys, types] = _.zip last, first
    if _.every types, (_.partial _.isEqual, 'move')
      # Combine consecutive move directives.
      concat [initial..., [xs[0] + xs[1], ys[0] + ys[1], 'move'], rest...]
    else
      concat [initial..., last, first, rest...]

directions =
  U: (n) -> [0,-n]
  D: (n) -> [0,n]
  L: (n) -> [-n,0]
  R: (n) -> [n,0]

_.each directions, (f, chr) ->
  exports[chr.toLowerCase()] = (n) -> concat [[(f n)..., 'move']]
  exports[chr.toUpperCase()] = (n) -> concat [[(f n)..., 'line']]

exports.extend = (o) ->
  _.each directions, (f, chr) ->
    o[chr.toLowerCase()] = exports[chr.toLowerCase()]
    o[chr.toUpperCase()] = exports[chr.toUpperCase()]


unwrap = (f) -> (path, args...) ->
  f (if _.isFunction path then (path $) else path), args...


# bounds :: [(Number,Number)] -> (Number,Number,Number,Number)
exports.bounds = unwrap (path, scale = 1) ->
  [xs,ys] = _.reduce path, ([xs,ys,x0,y0], [dx,dy]) ->
    [[xs..., x1 = x0 + dx], [ys..., y1 = y0 + dy], x1, y1]
  , [[0],[0],0,0]
  _.map [(_.min xs), (_.min ys), (_.max xs), (_.max ys)], (n) -> n * scale


# svg :: [(Number,Number,String)] -> String
#
# Return the SVG description of the given path or monadic value.
#
#   > svg [[4,0,'line'], [0,2,'line'], [-4,0,'line'], [0,-2,'line']], 5
#   'l 20,0 l 0,10 l -20,0 l 0,-10'
#
# Consecutive move directives are combined:
#
#   > svg (exports.r 8)(exports.d 8)(exports.R 2)(exports.D 2)
#   'm 8,8 l 2,0 l 0,2'
svg = unwrap (path, scale = 1) ->
  (_.map path, ([x,y,t]) ->
    "#{t[0]} #{[x,y].map((n) -> (n * scale).toFixed()).join(',')}").join(' ')


exports.formatters = {svg}
