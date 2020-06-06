
import Foundation
import CoreGraphics

public extension EPS {

    struct Configuration {

        public enum Precision {

            case integer
            case decimalPlaces(Int)
            case custom((CGFloat) -> String)

            internal var format: (CGFloat) -> String {
                return { value -> String in
                    switch self {
                    case .integer: return String(format: "%i", Int(round(value)))
                    case let .decimalPlaces(places): return String(format: "%.\(places)f", value.rounded(to: places))
                    case let .custom(function): return function(value)
                    }
                }
            }

        }

        let boundingBox: CGRect?
        let precision: Precision
        let header: String
        let delimiter: String

        public init(boundingBox: CGRect? = nil, precision: Precision = .decimalPlaces(2), header: String = "%!PS-Adobe-3.0 EPSF-3.0", delimiter: String = "\r\n") {
            self.boundingBox = boundingBox
            self.precision = precision
            self.header = header
            if delimiter.isEmpty {
                self.delimiter = " "
            } else {
                self.delimiter = delimiter
            }
        }

    }

}
