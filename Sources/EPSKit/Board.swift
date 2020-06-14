
import Foundation

public extension EPS {

    class Board {

        public let configuration: Configuration
        public private(set) var contents: String = ""
        private var isAllowingDelimiter: Int = 0

        public init(configuration: Configuration) {
            self.configuration = configuration
            setup()
        }

        internal init(configuration: Configuration, contents: String, isAllowingDelimiter: Int) {
            self.configuration = configuration
            self.contents = contents
            self.isAllowingDelimiter = isAllowingDelimiter
        }

        public func copy() -> Board {
            Board(configuration: configuration, contents: contents, isAllowingDelimiter: isAllowingDelimiter)
        }

    }

}

// MARK: - Basic Functions

public extension EPS.Board {

    /// Appends `x y scale` to EPS
    func scale(by value: CGPoint) {
        append(value, "scale")
    }

    /// Appends `x y translate` to EPS
    func translate(by value: CGPoint) {
        append(value, "translate")
    }

    /// Appends `w setlinewidth` to EPS
    func set(lineWidth value: CGFloat) {
        append(value, "setlinewidth")
    }

    /// Appends `x y moveto` to EPS
    func move(to value: CGPoint) {
        append(value, "moveto")
    }

    /// Appends `x y lineto` to EPS
    func line(to value: CGPoint) {
        append(value, "lineto")
    }

    /// Appends `x y radius start end arc` to EPS, defaulting `start` to `0` and `end` to `360`
    func arc(around center: CGPoint, radius: CGFloat, start: CGFloat = 0, end: CGFloat = 360) {
        append(StringRepresentableGroup(center, radius, start, end), "arc")
    }

    /// Appends `r g b` setrgbcolor` to EPS
    func set(color r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        append(StringRepresentableGroup(r, g, b), "setrgbcolor")
    }

    func fill() {
        append("fill")
    }

    func stroke() {
        append("stroke")
    }

}

// MARK: - Helpers

public extension EPS.Board {

    /// Calls `move(to: line.points[0])` and then `line(to:)` with every other
    /// point above zero, supressing delimiting until the end
    func draw(line: EPS.Line) {
        var points = line.points

        let start = points.removeFirst()
        let end = points.removeLast()

        undelimited {
            move(to: start)

            points.forEach { point in
                self.line(to: point)
            }
        }

        self.line(to: end)
    }

    /// Draws a circle after first moving to the correct point on the arc so as to ensure no
    /// unexpected lines appear
    func draw(circle: EPS.Circle) {
        undelimited {
            let startingPoint = CGPoint(x: circle.center.x + circle.radius, y: circle.center.y)
            move(to: startingPoint)
        }
        arc(around: circle.center, radius: circle.radius, start: 0, end: 360)
    }

    func apply(style: EPS.Style) {
        if let fill = style.fill {
            set(color: fill.r, fill.g, fill.b)
            self.fill()
        }

        if let stroke = style.stroke {
            set(color: stroke.r, stroke.g, stroke.b)
            self.stroke()
        }
    }

    /// Appends `value` to the EPS, then calls `appendDelimiter()`
    func append(_ value: String) {
        contents.append(value)
        appendDelimiter()
    }

    /// Appends `configuration.delimiter` to the EPS if possible
    func appendDelimiter() {
        if isAllowingDelimiter == 0 {
            contents.append(configuration.delimiter)
        } else {
            contents.append(" ")
        }
    }

}

// MARK: - Private

private extension EPS.Board {

    func setup() {
        if !configuration.header.isEmpty {
            append(configuration.header)
        }

        if let boundingBox = configuration.boundingBox {
            append("%%BoundingBox: \(boundingBox.converted(using: configuration))")
        }
    }

    func append(_ value: StringRepresentable, _ command: String) {
        append(value.converted(using: configuration) + " " + command)
    }

    func undelimited(_ commands: () -> Void) {
        isAllowingDelimiter += 1
        commands()
        isAllowingDelimiter -= 1
    }

}
