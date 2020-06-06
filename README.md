# EPSKit

A lightweight EPS builder for your* Swift projects

```swift
import EPSKit

let eps = EPS.Board(configuration: .init(precision: .integer))

// High-level drawing
eps.draw(line: .init(points: p1, p2, p3))
eps.draw(circle: .init(center: p1, radius: r))

let hexagon = RegularPolygon(points: 6, around: p1, radius: r)
eps.draw(line: hexagon.border)

// Standard commands
eps.move(to: p1)
eps.line(to: p2)
eps.arc(around: p3, radius: r, start: 0, end: a)

// Efficiency helpers - e.g. make sure no two line segments are the same/overlapping
let uniqueSegments = EPS.Line.segmentsByRemovingDuplicateSegments(from: [line1, line2])
let joinedSegmentsWherePossible = EPS.Line.linesByJoiningSegments(uniqueSegments)

// Save your EPS
let data = eps.contents.data(using: .utf8)!
data.write(to: ...)

```


*my projects, I doubt anyone else actually needs this 🤷‍♂️
