<img alt="Orthogonal" src="https://cdn.rawgit.com/davidchambers/orthogonal/0.1.0/lib/svg/orthogonal.svg" width="528" height="108" />

Orthogonal is a DSL for describing simple vector graphics. It can be used in
JavaScript or any compiles-to-JavaScript language. The following examples are
written in [CoffeeScript][1].

Here’s “Hello, world” in Orthogonal:

```coffeescript
orthogonal = require 'orthogonal'

square = (orthogonal.R 2)(orthogonal.D 2)(orthogonal.L 2)(orthogonal.U 2)
```

Right two, down two, left two, up two. This “draws” a 2×2 square.

It’s possible to extend the global object to make the R, D, L, and U functions
(and their lower-case counterparts) easier to reference:

```coffeescript
require('orthogonal').extend(global)

square = (R 2)(D 2)(L 2)(U 2)
```

Now for something a bit more advanced:

<img alt="Octocat" src="https://cdn.rawgit.com/davidchambers/orthogonal/dd0a9cb447754bdff9ecfc6bc1c5d0e6b3273c9c/lib/svg/octocat.svg" width="728" height="656" />

The source code is in [octocat.coffee][2].

### API

#### orthogonal.{R,D,L,U}(magnitude)

“Draw” a line in the direction determined by the function (e.g. right in the
case of orthogonal.R). A filled region can be described by “drawing” several
line segments in succession.

#### orthogonal.{r,d,l,u}(magnitude)

Move in the direction determined by the function (e.g. right in the case of
orthogonal.r). These functions reposition the “pen”, making it possible to
describe multiple filled regions.

#### orthogonal.extend(object)

Attach orthogonal.{R,D,L,U,r,d,l,u} to the provided object. Extending the
global object is recommended.

#### orthogonal.bounds([[x0,y0],[x1,y1],...,[xN,yN]])

Determine the bounds &mdash; expressed as [left,top,right,bottom] &mdash; for
the provided array of coordinates.

#### orthogonal.formatters.svg(path, scale = 1)

Get the SVG representation of the provided path.

```coffeescript
orthogonal.formatters.svg (r 8)(d 8)(R 2)(D 2)
# => 'm 8,8 l 2,0 l 0,2'
```


[1]: http://coffeescript.org/
[2]: https://github.com/davidchambers/orthogonal/blob/master/src/svg/octocat.coffee
