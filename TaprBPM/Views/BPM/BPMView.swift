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
 - On-screen counter for taps, rounded figure
 - Long-press fullscreen wipe animation
 - Pulse for current BPM
 - Enter BPM
 - Metronome sound/setting
 */

struct BPMView: View {
    @ObservedObject var viewModel: BPMViewModel
    @GestureState var tapState: Bool = false
    
    var body: some View {
        ZStack {
            viewModel.backgroundColor
                .transition(.opacity)
            Circle()
                .foregroundColor(.gray)
                .opacity(0.2)
                .scaleEffect(tapState ? 4.0 : 1.0, anchor: .center)
            VStack {
                viewModel.bpmDisplay.asText
                viewModel.bpmDisplay.roundedActiveBPM
                Spacer().frame(height: 8)
                viewModel.tapsLabel
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onTapGesture {
            viewModel.tapReceived()
        }
//        .gesture(LongPressGesture(minimumDuration: 1.0).updating($tapState) { value, state, transaction in
//            state = value
//        })
        .onLongPressGesture(minimumDuration: 1) {
            viewModel.reset()
        }
    }
}

struct BPMView_Previews: PreviewProvider {
    static var previews: some View {
        BPMView(viewModel: BPMViewModel())
    }
}
