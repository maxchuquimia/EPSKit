
import Foundation
import CoreGraphics

public extension EPS {

    struct Style {

        public typealias Color = (r: CGFloat, g: CGFloat, b: CGFloat)

        public let stroke: Color?
        public let fill: Color?

        public init(fill: Color? = nil, stroke: Color? = nil) {
            self.fill = fill
            self.stroke = stroke
        }

    }

}
