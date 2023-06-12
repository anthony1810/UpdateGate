import Foundation

public protocol UpdateConfigurationProtocol {
    var isMandatory: Bool { get }
    var isRecommended: Bool { get }
    var isUpdated: Bool { get }
    var isUnderMaintenance: Bool { get }
    var isLimitedByNotificationMode: Bool { get }
    
    var title: String? { get }
    var minOptionalAppVersion: String? { get }
    var minRequiredAppVersion: String? { get }
    var releaseNotes: String? { get }
    var latestVersion: String? { get }
    var notificationMode: UpdateNotifcationMode? { get }
    var minRequiredNotes: String? { get }
    var minOptionalNotes: String? { get }
    var isMaintenance: Int? { get }
    var maintenanceReason: String? { get }
}
