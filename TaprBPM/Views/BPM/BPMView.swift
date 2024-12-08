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
   - Keyframe: slow growing circle for 1s, then wipe?
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
        .onLongPressGesture(minimumDuration: 1) {
            viewModel.reset()
        }
    }
    
    struct BackgroundView: View {
        struct AnimationValues {
            var opacity = 0.0
            var scale = 1.0
        }
        
        let color: Color
        
        @State var trigger = false
        
        var body: some View {
            ZStack {
                color
                    .onTapGesture {
                        trigger.toggle()
                    }
                Circle()
                    .foregroundStyle(.gray)
                    .keyframeAnimator(
                        initialValue: AnimationValues(),
                        trigger: trigger
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
        }
    }
}

struct BPMView_Previews: PreviewProvider {
    static var previews: some View {
        BPMView(viewModel: BPMViewModel())
    }
}
