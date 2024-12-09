//
//  BPMViewModel.swift
//  BPMViewModel
//
//  Created by Liam on 18/08/21.
//

import SwiftUI
import Combine

/// A representation of the different modes the BPM view can be in. This primarily defines
/// what text is displayed on-screen.
enum BPMDisplayMode {
    case inactive
    case first
    case active(bpm: Float)

    /// The `Text` form of this display mode.
    var asText: Text {
        switch self {
        case .inactive:
            return Text("Tap to start")
                .font(.custom(.ralewayRegular, size: 24))
        case .first:
            return Text("First beat")
                .font(.custom(.ralewayRegular, size: 32))
        case .active(let bpm):
            let tokens = String(format: "%.1f", bpm).split(separator: ".").map { String($0) }
            return Text(tokens[0])
                .font(.custom(.ralewayRegular, size: 56))
            +
            Text(".\(tokens[1])")
                .font(.custom(.ralewayRegular, size: 32))
        }
    }

    var roundedActiveBPM: Text? {
        guard case .active(let bpm) = self else {
            return nil
        }
        return Text("\(Int(bpm.rounded()))")
            .font(.custom(.ralewayRegular, size: 32))
    }
}

class BPMViewModel: ObservableObject {

    /// The current display mode for the BPM view.
    @Published var bpmDisplay: BPMDisplayMode = .inactive

    /// The current background color for the BPM view. This is informed by
    /// the current display mode and the BPM value.
    @Published var backgroundColor: Color = .white

    var averageBPM: Float = 0
    var lastTapTime: TimeInterval = 0
    var reducedBPMs: Double = 0
    var taps: Int = 0

    var tapsLabel: Text? {
        guard taps > 0 else {
            return nil
        }
        var tapsText = "\(taps) tap"
        if taps > 1 {
            tapsText += "s"
        }
        return Text(tapsText)
            .font(.custom(.ralewayRegular, size: 24))
    }

    /// Notifies the view model that a tap was received that should be counted against the BPM calculation.
    func tapReceived() {
        // if there was no last tap time, this must be the first
        if lastTapTime == 0 {
            lastTapTime = Date.timeIntervalSinceReferenceDate
            bpmDisplay = .first
            return
        }

        let tapTime = Date.timeIntervalSinceReferenceDate
        let currentBPM = 60 / (tapTime - lastTapTime)
        reducedBPMs += currentBPM // reduce current BPM into overall sum of BPMs
        taps += 1

        averageBPM = Float(reducedBPMs) / Float(taps) // get average BPM by dividing reduced BPMs over number of taps
        bpmDisplay = .active(bpm: averageBPM)

        lastTapTime = tapTime

        updateBackgroundColor()
    }

    /// Resets the values used to calculate the BPM to zero.
    func reset() {
        bpmDisplay = .inactive
        averageBPM = 0
        reducedBPMs = 0
        lastTapTime = 0
        taps = 0

        updateBackgroundColor()
    }

    private func updateBackgroundColor() {
        func animateBackgroundColor(_ color: Color) {
            withAnimation {
                backgroundColor = color
            }
        }

        guard case .active(let bpm) = bpmDisplay else {
            animateBackgroundColor(.white)
            return
        }

        let lowestBPM: Double = 60 // red end of the spectrum
        let highestBPM: Double = 200 // blue end of the spectrum

        let multiplier: Double = Double(bpm)
            .percentage(between: lowestBPM, and: highestBPM)
            .clamped(between: 0, and: 0.75) // limit this to prevent a full rotation of the hue wheel

        animateBackgroundColor(Color(hue: multiplier, saturation: 1, brightness: 1))
    }

}
