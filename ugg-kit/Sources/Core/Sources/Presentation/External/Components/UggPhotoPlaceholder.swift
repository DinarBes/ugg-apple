//
//  UggPhotoPlaceholder.swift
//  ugg-kit
//

import SwiftUI

/// Stand-in for a photo until real images arrive: a warm vertical gradient, light on top and dark
/// at the bottom, so copy over it reads the same way it will over a photo.
public struct UggPhotoPlaceholder<Content: View>: View {
    private let radius: CGFloat
    private let top: Color
    private let bottom: Color
    private let content: Content

    public init(
        radius: CGFloat = UggRadius.large,
        top: Color = UggColors.surfaceVariant,
        bottom: Color = UggColors.accentStrong,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.radius = radius
        self.top = top
        self.bottom = bottom
        self.content = content()
    }

    public var body: some View {
        ZStack {
            LinearGradient(colors: [top, bottom], startPoint: .top, endPoint: .bottom)
            content
        }
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}
