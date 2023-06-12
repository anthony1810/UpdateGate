//
//  RemoteConfigurationFetcher.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation
import Combine

struct RemoteConfigurationFetcher: ConfigurationsFetcherProtocol {
    
    let url: URL
    var configurations: UpdateGateConfiguration?
    
    init(url: URL) {
        self.url = url
    }
    
    func fetch() -> AnyPublisher<UpdateGateConfiguration, Error> {
        URLSession(configuration: .ephemeral).dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: UpdateGateConfiguration.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


