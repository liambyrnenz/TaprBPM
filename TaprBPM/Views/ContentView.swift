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

#Preview {
    ContentView()
}
