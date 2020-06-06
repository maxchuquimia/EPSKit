
import Foundation
import CoreGraphics

public extension EPS {

    struct RegularPolygon {

        public let border: EPS.Line

        public init(points count: Int, around center: CGPoint, radius: CGFloat) {
            guard count > 2 else { preconditionFailure("RegularPolygon must have 3 or more points") }
            border = EPS.Line(
                points: (0..<count).map({ idx in
                    let angle = 360.0 / CGFloat(count) * CGFloat(idx)
                    return CGPoint(x: (radius * sin(angle)) + center.x, y: (radius * cos(angle)) + center.y)
                })
            )
        }

    }

}
