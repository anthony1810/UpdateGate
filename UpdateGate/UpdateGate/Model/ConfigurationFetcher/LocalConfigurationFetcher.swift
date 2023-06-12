//
//  LocalConfigurationFetcher.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation
import Combine

struct LocalConfigurationFetcher: ConfigurationsFetcherProtocol {
    
    let url: URL
    var configurations: UpdateGateConfiguration?
    
    init(url: URL) {
        self.url = url
    }
    
    func fetch() -> AnyPublisher<UpdateGateConfiguration, Error> {
        Future<UpdateGateConfiguration, Error> { promise in
            do {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()

                // Decode JSON data into the struct
                let updateConfig = try decoder.decode(UpdateGateConfiguration.self, from: jsonData)
                // Access other properties as needed
                return promise(.success(updateConfig))
            } catch {
                return promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
