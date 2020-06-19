
import Foundation
import CoreGraphics

extension CGFloat {

    func rounded(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }

}

func +(a: CGPoint, b: CGPoint) -> CGPoint {
    CGPoint(x: a.x + b.x, y: a.y + b.y)
}

func -(a: CGPoint, b: CGPoint) -> CGPoint {
    CGPoint(x: a.x - b.x, y: a.y - b.y)
}

extension CGPoint {

    // Pretty much https://stackoverflow.com/a/2259502/1153630
    func rotated(around center: CGPoint, by degress: CGFloat) -> CGPoint {
        // Multiplying by -1 to make it clockwise (?)
        let angle = (-1 * degress) * .pi / 180
        let s = sin(angle)
        let c = cos(angle)
        var p = self

        p.x -= center.x
        p.y -= center.y

        let xnew = p.x * c - p.y * s
        let ynew = p.x * s + p.y * c

        p.x = xnew + center.x
        p.y = ynew + center.y

        return p
    }

}
