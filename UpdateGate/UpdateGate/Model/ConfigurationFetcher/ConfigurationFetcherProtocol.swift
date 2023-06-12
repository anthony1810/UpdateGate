//
//  ConfigurationFetcherProtocol.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation
import Combine

public protocol ConfigurationsFetcherProtocol<T> {
    associatedtype T: UpdateConfigurationProtocol
    
    var url: URL { get }
    var configurations: T? { get set }
    
    func fetch() -> AnyPublisher<T, Error>
}

public struct ConfigurationsFetchersFactory {
    public static func configurationFetcher(for mode: UpdateGateReadMode) -> any ConfigurationsFetcherProtocol {
        switch mode {
        case .local(let url):
            return LocalConfigurationFetcher(url: url)
        case .remote(let url):
            return RemoteConfigurationFetcher(url: url)
        }
    }
}
