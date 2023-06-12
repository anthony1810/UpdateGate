//
//  ResultFetcherProtocol.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation
import Combine

protocol ResultFetcherProtocol {
    
    var configurations: UpdateConfigurationProtocol { get }
    
    func fetchWith(configurationFetcher: some ConfigurationsFetcherProtocol) -> AnyPublisher<UpdateGateResult, Error>
}
