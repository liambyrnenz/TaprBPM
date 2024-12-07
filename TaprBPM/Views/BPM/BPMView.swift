//
//  BPMView.swift
//  BPMView
//
//  Created by Liam on 18/08/21.
//

import SwiftUI

/*
 TODO
 - Feedback animation when user taps
 - Long-press fullscreen wipe animation
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
        enum AnimationPhase: CaseIterable {
            case start, pulse, end
            
            var scale: Double {
                switch self {
                case .start, .pulse:
                    1.0
                case .end:
                    3.0
                }
            }
            
            var opacity: Double {
                switch self {
                case .start, .end:
                    0.0
                case .pulse:
                    0.2
                }
            }
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
                    .foregroundStyle(.black)
                    .phaseAnimator(AnimationPhase.allCases, trigger: trigger) { content, phase in
                        content
                            .opacity(phase.opacity)
                            .scaleEffect(phase.scale)
                    } animation: { phase in
                        switch phase {
                        case .start, .pulse: nil
                        case .end: .easeOut(duration: 0.4)
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
