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
 -- Keyframe: slow growing circle for 1s, then wipe?
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
            LongPressGesture(minimumDuration: 1).onEnded { _ in
                viewModel.reset()
            }
        )
    }

    struct BackgroundView: View {
        struct AnimationValues {
            var opacity = 0.0
            var scale = 1.0
        }

        let color: Color

        @State var feedbackAnimationTrigger = false
        @State var resetAnimationTrigger = false
        @GestureState var isShowingResetAnimation = false

        var body: some View {
            ZStack {
                color
                    .onTapGesture {
                        feedbackAnimationTrigger.toggle()
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                resetAnimationTrigger.toggle()
                            }
                            .updating($isShowingResetAnimation) { currentState, gestureState, _ in
                                gestureState = currentState
                            }
                    )
                feedbackAnimationView
                resetAnimationView
                    .opacity(isShowingResetAnimation ? 1 : 0)
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
                        LinearKeyframe(0.0, duration: 0.3)
                    }
                    KeyframeTrack(\.scale) {
                        LinearKeyframe(3.0, duration: 0.3)
                        LinearKeyframe(1.0, duration: 0.1)
                    }
                }
        }

        enum ResetAnimationPhase: CaseIterable {
            case start, expand, end

            var scale: Double {
                switch self {
                case .start:
                    1.0
                case .expand:
                    4.0
                case .end:
                    1.0
                }
            }
        }

        private var resetAnimationView: some View {
            Circle()
                .foregroundStyle(.white)
                .phaseAnimator(
                    ResetAnimationPhase.allCases,
                    trigger: resetAnimationTrigger
                ) { content, phase in
                    content
                        .scaleEffect(phase.scale)
                } animation: { phase in
                    switch phase {
                    case .start: nil
                    case .expand: .linear(duration: 1)
                    case .end: nil
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
