
import Foundation
import CoreGraphics

public extension EPS {

    struct Circle {

        public let center: CGPoint
        public let radius: CGFloat

        public init(center: CGPoint, radius: CGFloat) {
            self.center = center
            self.radius = radius
        }
    }

}
