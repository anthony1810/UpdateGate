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
            Group {
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
            .opacity(viewModel.isLoading ? 0.0 : 1.0)
            
            HStack {
                Button(action: {
                    viewModel.checkLocalUpdateGateStatus()
                }, label: {
                    Text("Check Local")
                })
                
                Button(action: {
                    viewModel.checkRemoteUpdateGateStatus()
                }, label: {
                    Text("Check Remote")
                })
            }
            .padding(.vertical)
        }
        .padding()
        .overlay(
            ProgressView()
                .opacity(viewModel.isLoading ? 1.0 : 0.0)
        )
        .onAppear {
            viewModel.checkLocalUpdateGateStatus()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
