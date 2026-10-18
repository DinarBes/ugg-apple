//
//  UggSegmentedControl.swift
//  ugg-kit
//

import SwiftUI

public struct UggSegment: Hashable, Sendable {
    public let title: String
    public let subtitle: String?

    public init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
}

/// Option switch on a cream track; the selected option is a raised white tile. Unlike the system
/// segmented picker it fits a second line («Стандарт / 22 см»).
public struct UggSegmentedControl: View {
    private let segments: [UggSegment]
    private let selectedIndex: Int?
    private let onSelect: (Int) -> Void

    public init(_ segments: [UggSegment], selectedIndex: Int?, onSelect: @escaping (Int) -> Void) {
        self.segments = segments
        self.selectedIndex = selectedIndex
        self.onSelect = onSelect
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                let isSelected = index == selectedIndex

                Button { onSelect(index) } label: {
                    VStack(spacing: 0) {
                        Text(segment.title)
                            .uggFont(.label)
                            .foregroundStyle(isSelected ? UggColors.content : UggColors.contentSecondary)
                        if let subtitle = segment.subtitle {
                            Text(subtitle).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, UggSpacing.s)
                    .padding(.vertical, 10)
                    .background {
                        if isSelected {
                            RoundedRectangle(cornerRadius: UggRadius.small, style: .continuous)
                                .fill(UggColors.surfaceElevated)
                                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(4)
        .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
        .animation(.easeOut(duration: 0.2), value: selectedIndex)
    }
}
