//
//  BPMView.swift
//  BPMView
//
//  Created by Liam on 18/08/21.
//

import SwiftUI

struct BPMView: View {
    @ObservedObject var viewModel: BPMViewModel
    
    var body: some View {
        ZStack {
            viewModel.backgroundColor
                .transition(.opacity)
            viewModel.bpmDisplay.asText
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.tapReceived()
        }
        .onLongPressGesture {
            viewModel.reset()
        }
    }
}

struct BPMView_Previews: PreviewProvider {
    static var previews: some View {
        BPMView(viewModel: BPMViewModel())
    }
}
