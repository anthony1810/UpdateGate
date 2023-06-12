import Foundation

public enum UpdateGateResultType {
    case maintenance
    case mandatory
    case recommended
    case updated
}

public enum UpdateGateResult {
    case none(reason: String)
    case available(type: UpdateGateResultType, title: String, message: String)
}
