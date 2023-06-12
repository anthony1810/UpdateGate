//
//  ContentViewModel.swift
//  UpdateGate
//
//  Created by Anthony Tran on 12/06/2023.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    @Published var updateStatus: UpdateGateResult? = nil {
        didSet {
            isUpdateAvailable = updateStatus != nil
            if let updateStatus = updateStatus {
                if case let .available(type, title, message) = updateStatus {
                    self.updateType = type.rawValue
                    self.title = Helpers.markdown(from: title)
                    self.message = Helpers.markdown(from: message)
                }
                if case let .none(reason) = updateStatus {
                    self.updateType = "Nothing to update"
                    self.title = Helpers.markdown(from: "You can go inside the app")
                    self.message = Helpers.markdown(from: reason)
                }
            }
        }
    }
    @Published var isUpdateAvailable: Bool = false
    @Published var title: AttributedString = ""
    @Published var message: AttributedString = ""
    @Published var updateType: String = ""

    @Published var isLoading = false
    
    var cancellables = Set<AnyCancellable>()
    
    func checkLocalUpdateGateStatus() {
        guard let url = Bundle.main.url(forResource: "updates", withExtension: "json")
        else { return }
        let localReadMode = UpdateGateReadMode.local(fileURL: url)
        callUpdateGate(mode: localReadMode)
    }
    
    func checkRemoteUpdateGateStatus() {
        guard let url = URL(string: "https://develop.api.dev.rkme.io/v1/playVersion.json")
        else { return }
        let localReadMode = UpdateGateReadMode.remote(apiURL: url)
        callUpdateGate(mode: localReadMode)
    }
    
    private func callUpdateGate(mode: UpdateGateReadMode) {
        isLoading = true
        UpdateGate.readUpdateGateConfigurations(mode: mode)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            debugPrint(completion)
            self?.isLoading = false
        }, receiveValue: { [weak self] result in
            self?.updateStatus = result
        })
        .store(in: &cancellables)
    }
}
