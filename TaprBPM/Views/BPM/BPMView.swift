//
//  BPMView.swift
//  BPMView
//
//  Created by Liam on 18/08/21.
//

import SwiftUI

/*
 TODO
 - Long-press fullscreen wipe animation
 -- Combine long press gestures
 -- Prevent tap while resetting
 -- Fade text out and in on reset
 - Pulse for current BPM
 - Enter BPM
 - Metronome sound/setting
 */

struct BPMView: View {
    @ObservedObject var viewModel: BPMViewModel

    var body: some View {
        ZStack {
            BackgroundView(
                color: viewModel.backgroundColor
            )
            VStack {
                viewModel.bpmDisplay.asText
                viewModel.bpmDisplay.roundedActiveBPM
                Spacer()
                    .frame(height: 8)
                viewModel.tapsLabel
            }
            .foregroundStyle(viewModel.backgroundColor.isLight() ? .black : .white)
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    viewModel.tapReceived()
                }
        )
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3).onEnded { _ in
                Task {
                    try await Task.sleep(for: .seconds(0.7))
                    viewModel.reset()
                }
            }
        )
    }

    struct BackgroundView: View {
        struct AnimationValues {
            var opacity = 0.0
            var scale = 0.2
        }

        let color: Color

        @State var feedbackAnimationTrigger = false
        @State var resetAnimationTrigger = false

        var body: some View {
            ZStack {
                color
                    .onTapGesture {
                        feedbackAnimationTrigger.toggle()
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.3)
                            .onEnded { _ in
                                resetAnimationTrigger.toggle()
                            }
                    )
                feedbackAnimationView
                resetAnimationView
            }
        }

        private var feedbackAnimationView: some View {
            Circle()
                .foregroundStyle(.gray)
                .keyframeAnimator(
                    initialValue: AnimationValues(),
                    trigger: feedbackAnimationTrigger
                ) { content, value in
                    content
                        .opacity(value.opacity)
                        .scaleEffect(value.scale)
                } keyframes: { _ in
                    KeyframeTrack(\.opacity) {
                        LinearKeyframe(0.1, duration: 0.1)
                        LinearKeyframe(0.0, duration: 0.4)
                    }
                    KeyframeTrack(\.scale) {
                        LinearKeyframe(3.0, duration: 0.4)
                        LinearKeyframe(1.0, duration: 0.1)
                    }
                }
        }

        private var resetAnimationView: some View {
            Circle()
                .foregroundStyle(.white)
                .keyframeAnimator(
                    initialValue: AnimationValues(),
                    trigger: resetAnimationTrigger
                ) { content, value in
                    content
                        .opacity(value.opacity)
                        .scaleEffect(value.scale)
                } keyframes: { _ in
                    KeyframeTrack(\.opacity) {
                        LinearKeyframe(0.5, duration: 0.1)
                        LinearKeyframe(1.0, duration: 1.0)
                        LinearKeyframe(0.0, duration: 0.1)
                    }
                    KeyframeTrack(\.scale) {
                        LinearKeyframe(1.0, duration: 0.1)
                        LinearKeyframe(4.0, duration: 1.0)
                        LinearKeyframe(1.0, duration: 0.1)
                    }
                }
        }
    }
}

struct BPMView_Previews: PreviewProvider {
    static var previews: some View {
        BPMView(viewModel: BPMViewModel())
    }
}
