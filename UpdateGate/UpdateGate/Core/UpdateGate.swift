import Combine
import Foundation

struct UpdateGate {
    
    public static func readUpdateGateConfigurations(mode: UpdateGateReadMode) -> AnyPublisher<UpdateGateResult, Error> {
        let configurationFetcher = ConfigurationsFetchersFactory.configurationFetcher(for: mode)
        return fetchWith(configurationFetcher: configurationFetcher)
    }
    
    private static func fetchWith(configurationFetcher: some ConfigurationsFetcherProtocol) -> AnyPublisher<UpdateGateResult, Error>  {
        configurationFetcher.fetch()
            .flatMap {  configurations  in
               let resultFetcher = ResultFetcher(configurations: configurations)
               return resultFetcher.fetch()
            }
            .eraseToAnyPublisher()
    }
}
