
import Foundation
import CoreGraphics

public extension EPS {

    struct Line {
        
        public let points: [CGPoint]
        
        public init(points: CGPoint...) {
            self.init(points: points)
        }
        
        public init(points: [CGPoint]) {
            guard points.count > 1 else { fatalError("Lines must have more than one point") }
            self.points = points
        }

    }

}

// MARK: - Public Functions

public extension EPS.Line {

    func translated(by value: CGPoint) -> EPS.Line {
        EPS.Line(points: points.map { $0 + value })
    }

    func rotated(around point: CGPoint, by degrees: CGFloat) -> EPS.Line {
        fatalError("TODO")
    }

}


// MARK: - Static Helpers

public extension EPS.Line {

    /// Creates a new collection of lines by ensure that no two segments are the same
    /// This is a potentially expensive operation!
    static func segmentsByRemovingDuplicateSegments(from lines: [EPS.Line]) -> [EPS.Line] {
        var allSegments: [EPS.Line] = []

        for line in lines {
            for segment in line.segments {
                if !allSegments.contains(segment) {
                    allSegments.append(segment)
                }
            }
        }

        return allSegments
    }

    /// Given `segments` (lines containing only two points), join segments that touch eachother into single lines
    static func linesByJoiningSegments(_ segments: [EPS.Line]) -> [EPS.Line] {
        var result: [EPS.Line] = []

        for segment in segments {
            if let segmentStart = segment.points.first, let segmentEnd = segment.points.last, segmentStart == result.last?.points.last {
                // If this segment starts at the same place as the end of `result`,
                // append the segment to the last line in `result`
                let existingLine = result.removeLast()
                let updatedLine = EPS.Line(points: existingLine.points + [segmentEnd])
                result.append(updatedLine) // Replace existingLine with updatedLine
            } else {
                // Add the segment to `result`
                result.append(segment)
            }
        }

        return result
    }

}

// MARK: - Computed Helpers

public extension EPS.Line {

    var segments: [EPS.Line] {
        var points = self.points
        let first = points.removeFirst()
        var segments: [EPS.Line] = []

        _ = points.reduce(first) { (previous, next) in
            let segment = EPS.Line(points: previous, next)
            segments.append(segment)
            return next
        }

        return segments
    }

}

// MARK: - Conformance

extension EPS.Line: Equatable {

    public static func ==(a: EPS.Line, b: EPS.Line) -> Bool {
        a.points == b.points
    }

}
