//
//  ResultFetcher.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation
import Combine

struct ResultFetcher: ResultFetcherProtocol  {
    
    var configurations: UpdateConfigurationProtocol
    
    typealias T = UpdateGateConfiguration
    
    init(configurations: some UpdateConfigurationProtocol) {
        self.configurations = configurations
    }
    
    func fetch() -> AnyPublisher<UpdateGateResult, Error> {
        Future<UpdateGateResult, Error> { promise in
            guard !configurations.isLimitedByNotificationMode
            else {
                return promise(.success(.none(reason: "limited by notification mode")))
            }
            
            if configurations.isUnderMaintenance {
                return promise(.success(.available(type: .maintenance, title: title, message: message)))
            }
            
            if configurations.isMandatory {
                return promise(.success(.available(type: .mandatory, title: title, message: message)))
            }
            
            if configurations.isRecommended {
                return promise(.success(.available(type: .recommended, title: title, message: message)))
            }

            if configurations.isUpdated {
                return promise(.success(.available(type: .updated, title: title, message: message)))
            }
            
            return promise(.success(.none(reason: "Not fall into any cases")))
        }
        .eraseToAnyPublisher()
    }
    
    func fetchWith(configurationFetcher: some ConfigurationsFetcherProtocol) -> AnyPublisher<UpdateGateResult, Error>  {
        configurationFetcher.fetch()
            .map { configurations  in
                guard !configurations.isLimitedByNotificationMode
                else {
                    return .none(reason: "limited by notification mode")
                }
                
                if configurations.isUnderMaintenance {
                    return .available(type: .maintenance, title: title, message: message)
                }
                
                if configurations.isMandatory {
                    return .available(type: .mandatory, title: title, message: message)
                }
                
                if configurations.isRecommended {
                    return .available(type: .recommended, title: title, message: message)
                }

                if configurations.isUpdated {
                    return .available(type: .updated, title: title, message: message)
                }
                
                return .none(reason: "Not fall into any cases")
            }
            .eraseToAnyPublisher()
    }
}

extension ResultFetcher {
    var isAvailable: Bool {
        
        if !configurations.isLimitedByNotificationMode{ return true }
        
        if configurations.isUnderMaintenance { return true }

        if configurations.isUpdated { return true }

        if configurations.isMandatory { return true }
        
        if configurations.isRecommended { return true }

        return false
    }
    
    var title: String {
        guard let title = configurations.title else {
            switch type {
            case .maintenance:
                return "System Under Maintenance"
            case .mandatory:
                return "Update Required"
            case .recommended:
                return "Update Available"
            case .updated:
                return "Update Notes"
            }
        }
        return title
    }
    
    var message: String {
        switch type {
        case .maintenance:
            return configurations.maintenanceReason ?? ""
        case .mandatory:
            return configurations.minRequiredNotes ?? ""
        case .recommended:
            return configurations.minRequiredNotes ?? ""
        case .updated:
            return configurations.releaseNotes ?? ""
        }
    }
    
    var type: UpdateGateResultType {
        if configurations.isUnderMaintenance {
            return .maintenance
        } else if configurations.isMandatory {
            return .mandatory
        } else if configurations.isRecommended {
            return .recommended
        } else {
            return .updated
        }
    }
}
