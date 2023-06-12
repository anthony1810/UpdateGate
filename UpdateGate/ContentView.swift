//
//  ContentView.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel: ContentViewModel = .init()
    
    var body: some View {
        VStack {
            Text(viewModel.updateType.capitalized)
                .font(.title)
                .foregroundColor(.primary)
            Text(viewModel.title)
                .font(.title2)
                .foregroundColor(.secondary)
            Text(viewModel.message)
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .onAppear {
            viewModel.checkUpdateGateStatus()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
