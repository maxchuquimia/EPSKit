
import Foundation
import CoreGraphics

public extension EPS {

    struct RegularPolygon {

        public let border: EPS.Line

        public init(points count: Int, around center: CGPoint, radius: CGFloat) {
            guard count > 2 else { preconditionFailure("RegularPolygon must have 3 or more points") }
            var _points: [CGPoint] = (0..<count).map({ idx in
                let angle = 360.0 / CGFloat(count) * CGFloat(idx)
                let r_angle = angle * .pi / 180
                return CGPoint(x: center.x + (radius * cos(r_angle)), y: center.y + (radius * sin(r_angle)))
            })
            _points.append(_points.first!) // Close the loop
            border = EPS.Line(points: _points)
        }

    }

}
