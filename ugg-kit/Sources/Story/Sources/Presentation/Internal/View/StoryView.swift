//
//  StoryView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

struct StoryView: View {
    var state: StoryState
    var onRetry: () -> Void
    var onChooseModel: () -> Void

    var body: some View {
        Group {
            if let story = state.story {
                content(story)
            } else if let error = state.error {
                VStack(spacing: UggSpacing.m) {
                    Text(error)
                        .uggFont(.body)
                        .foregroundStyle(UggColors.contentSecondary)
                        .multilineTextAlignment(.center)
                    UggButton("Повторить", variant: .secondary, showsArrow: false, action: onRetry).fixedSize()
                }
                .padding(.horizontal, UggSpacing.screenHorizontal)
            } else {
                ProgressView().tint(UggColors.accent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }

    private func content(_ story: Story) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: UggSpacing.s) {
                    Text(story.kicker.uppercased()).uggFont(.overline).foregroundStyle(UggColors.accent)
                    Text(story.title).uggFont(.displayXL).foregroundStyle(UggColors.content)
                    Text(story.intro).uggFont(.body).foregroundStyle(UggColors.contentSecondary)
                }
                .padding(.vertical, UggSpacing.s)

                UggPhotoPlaceholder()
                    .frame(height: 280)
                    .padding(.vertical, UggSpacing.s)

                if !story.steps.isEmpty {
                    Text(story.stepsTitle)
                        .uggFont(.displayM)
                        .foregroundStyle(UggColors.content)
                        .padding(.top, UggSpacing.m)
                        .padding(.bottom, 18)

                    ForEach(Array(story.steps.enumerated()), id: \.element.id) { index, step in
                        StepRow(step: step, isLast: index == story.steps.count - 1)
                    }
                }

                if let highlight = story.highlight {
                    HighlightCard(highlight: highlight)
                        .padding(.vertical, UggSpacing.xs)
                }

                UggButton("Выбрать свою пару", action: onChooseModel)
                    .padding(.vertical, UggSpacing.xl)
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
    }
}

/// A timeline row: a numbered dot on a rail that runs down to the next step.
private struct StepRow: View {
    var step: Story.Step
    var isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: UggSpacing.m) {
            VStack(spacing: 0) {
                Text(step.number)
                    .uggFont(.caption)
                    .foregroundStyle(UggColors.accentStrong)
                    .frame(width: 36, height: 36)
                    .background(UggColors.surface, in: Circle())
                if !isLast {
                    Rectangle()
                        .fill(UggColors.outline)
                        .frame(width: 1.5)
                        .frame(maxHeight: .infinity)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(step.title).uggFont(.heading).foregroundStyle(UggColors.content)
                Text(step.description).uggFont(.bodySmall).foregroundStyle(UggColors.contentSecondary)
                UggPhotoPlaceholder(radius: UggRadius.medium)
                    .frame(height: 150)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, UggSpacing.xxl)
        }
    }
}

/// «Почему Байкал»: Baikal blue, deepening towards the bottom.
private struct HighlightCard: View {
    var highlight: Story.Highlight

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(highlight.kicker.uppercased())
                .uggFont(.overline)
                .foregroundStyle(UggColors.contentInverse.opacity(0.8))
            Text(highlight.title).uggFont(.displayL).foregroundStyle(UggColors.contentInverse)
            Text(highlight.body)
                .uggFont(.bodySmall)
                .foregroundStyle(UggColors.contentInverse.opacity(0.85))
        }
        .padding(UggSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            ZStack {
                UggColors.info
                LinearGradient(colors: [.clear, UggColors.surfaceInverse.opacity(0.35)], startPoint: .top, endPoint: .bottom)
            }
            .clipShape(RoundedRectangle(cornerRadius: UggRadius.extraLarge, style: .continuous))
        }
    }
}
