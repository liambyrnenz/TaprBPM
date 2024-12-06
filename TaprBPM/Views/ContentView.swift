//
//  ContentView.swift
//  TaprBPM
//
//  Created by Liam on 18/08/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        BPMView(viewModel: BPMViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 TODO
 - Feedback animation when user taps
 - On-screen counter for taps, rounded figure
 - Long-press fullscreen wipe animation
 */
