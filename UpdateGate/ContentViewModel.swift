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
                if case .available(let type, let title, let message) = updateStatus {
                    self.updateType = type.rawValue
                    self.title = Helpers.markdown(from: title)
                    self.message = Helpers.markdown(from: message)
                }
            }
        }
    }
    @Published var isUpdateAvailable: Bool = false
    @Published var title: AttributedString = ""
    @Published var message: AttributedString = ""
    @Published var updateType: String = ""
    
    var cancellables = Set<AnyCancellable>()
    
    func checkUpdateGateStatus() {
        guard let url = Bundle.main.url(forResource: "updates", withExtension: "json")
        else { return }
            UpdateGate.readUpdateGateConfigurations(mode: .local(fileURL: url))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                debugPrint(completion)
            }, receiveValue: { [weak self] result in
                self?.updateStatus = result
            })
            .store(in: &cancellables)
    }
}
