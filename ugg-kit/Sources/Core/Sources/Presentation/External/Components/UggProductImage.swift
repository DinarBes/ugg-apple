//
//  UggProductImage.swift
//  ugg-kit
//

import SwiftUI

/// Cut-out photo of the model on a transparent background. There is one photo, in the sand
/// sheepskin; `tint` previews another shade — the photo goes grey and takes the color, keeping its
/// light and shade (like the color matrix on Android). A tint close to sand leaves it untouched.
public struct UggProductImage: View {
    private let tint: Color?

    public init(tint: Color? = nil) {
        self.tint = tint
    }

    public var body: some View {
        let image = Image("uggs", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)

        if let tint, !tint.isClose(to: Self.photoColor) {
            image.grayscale(1).colorMultiply(tint.lighter())
        } else {
            image
        }
    }

    /// Sheepskin tone of the photo itself.
    private static let photoColor = Color(hex: 0xD7BF9C)
}

private extension Color {
    func components() -> (Double, Double, Double) {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b))
    }

    func isClose(to other: Color) -> Bool {
        let (r1, g1, b1) = components()
        let (r2, g2, b2) = other.components()
        return abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2) < 0.12
    }

    /// Multiplying darkens; lifting the tint keeps the suede from turning muddy.
    func lighter() -> Color {
        let (r, g, b) = components()
        return Color(.sRGB, red: min(1, r * 1.35), green: min(1, g * 1.35), blue: min(1, b * 1.35))
    }
}
