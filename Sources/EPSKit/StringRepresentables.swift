
import Foundation

protocol StringRepresentable {
    func converted(using configuration: EPS.Configuration) -> String
}

extension CGFloat: StringRepresentable {

    func converted(using configuration: EPS.Configuration) -> String {
        configuration.precision.format(self)
    }

}

extension CGPoint: StringRepresentable {

    func converted(using configuration: EPS.Configuration) -> String {
        StringRepresentableGroup(x, y).converted(using: configuration)
    }
    
}

extension CGSize: StringRepresentable {

    func converted(using configuration: EPS.Configuration) -> String {
        StringRepresentableGroup(width, height).converted(using: configuration)
    }

}

extension CGRect: StringRepresentable {

    func converted(using configuration: EPS.Configuration) -> String {
        StringRepresentableGroup(origin, size).converted(using: configuration)
    }

}

struct StringRepresentableGroup: StringRepresentable {

    let stringRepresentables: [StringRepresentable]

    init(_ stringRepresentables: StringRepresentable...) {
        self.init(stringRepresentables)
    }

    init(_ stringRepresentables: [StringRepresentable]) {
        self.stringRepresentables = stringRepresentables
    }

    func converted(using configuration: EPS.Configuration) -> String {
        stringRepresentables.map({ $0.converted(using: configuration) }).joined(separator: " ")
    }

}
