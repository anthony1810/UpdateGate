import Foundation

struct UpdateGateConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case appStoreId = "app-store-id"
        case minOptionalAppVersion = "min-optional-app-version"
        case minRequiredAppVersion = "min-required-app-version"
        case notificationMode = "notify"
        case releaseNotes = "version-notes"
        case latestVersion = "version"
        case minRequiredNotes = "min-required-app-notes"
        case minOptionalNotes = "min-optional-app-notes"
        case title
        case isMaintenance = "is-maintenance"
        case maintenanceReason = "reason-maintenance"
    }
    
    var id: String { return appStoreId ?? UUID().uuidString }
    let title: String?
    let appStoreId: String?
    let minOptionalAppVersion: String?
    let minRequiredAppVersion: String?
    let releaseNotes: String?
    let latestVersion: String?
    let notificationMode: UpdateNotifcationMode?
    let minRequiredNotes: String?
    let minOptionalNotes: String?
    let isMaintenance: Int?
    let maintenanceReason: String?

    init(
        title: String?,
        appStoreId: String?,
        minRequiredNotes: String?,
        minOptionalNotes: String?,
        minOptionalAppVersion: String?,
        minRequiredAppVersion: String?,
        notifying: UpdateNotifcationMode?,
        releaseNotes: String?,
        latestVersion: String?,
        isMaintenance: Int?,
        maintenanceReason: String?
    ) {
        self.title = title
        self.appStoreId = appStoreId
        self.minOptionalAppVersion = minOptionalAppVersion
        self.minRequiredAppVersion = minRequiredAppVersion
        notificationMode = notifying
        self.releaseNotes = releaseNotes
        self.latestVersion = latestVersion
        self.minOptionalNotes = minOptionalNotes
        self.minRequiredNotes = minRequiredNotes
        self.isMaintenance = isMaintenance
        self.maintenanceReason = maintenanceReason
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        minOptionalAppVersion = try? container.decode(String.self, forKey: .minOptionalAppVersion)
        minRequiredAppVersion = try? container.decode(String.self, forKey: .minRequiredAppVersion)
        appStoreId = try? container.decode(String.self, forKey: .appStoreId)
        minOptionalNotes = try? container.decode(String.self, forKey: .minOptionalNotes)
        minRequiredNotes = try? container.decode(String.self, forKey: .minRequiredNotes)
        notificationMode = (try? container.decode(UpdateNotifcationMode.self, forKey: .notificationMode))
        releaseNotes = try? container.decode(String.self, forKey: .releaseNotes)
        latestVersion = (try? container.decode(String.self, forKey: .latestVersion))
        isMaintenance = try? container.decode(Int.self, forKey: .isMaintenance)
        maintenanceReason = try? container.decode(String.self, forKey: .maintenanceReason)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(minOptionalAppVersion, forKey: .minOptionalAppVersion)
        try container.encode(minRequiredAppVersion, forKey: .minRequiredAppVersion)
        try container.encode(appStoreId, forKey: .appStoreId)
        try container.encode(notificationMode, forKey: .notificationMode)
        try container.encode(releaseNotes, forKey: .releaseNotes)
        try container.encode(latestVersion, forKey: .latestVersion)
        try container.encode(isMaintenance, forKey: .isMaintenance)
        try container.encode(maintenanceReason, forKey: .maintenanceReason)
    }
}

extension UpdateGateConfiguration: UpdateConfigurationProtocol {
    var isUnderMaintenance: Bool {
        (isMaintenance ?? 0) == 1
    }

    var isMandatory: Bool {
        guard let minRequiredAppVersion else { return false }
        return Helpers.compareAppVersions(minRequiredAppVersion, Helpers.existingVersion) == .orderedDescending
    }

    var isRecommended: Bool {
        guard let minOptionalAppVersion else { return false }
        return Helpers.compareAppVersions(minOptionalAppVersion, Helpers.existingVersion) == .orderedDescending
    }

    var isUpdated: Bool {
        guard Helpers.existingVersion == latestVersion ?? "" else {
            return false
        }

        let showCounter = UpdateConfigurationShowCounter.read(counterId: Helpers.existingVersion)?.showCounter ?? 0
        if showCounter == 0 {
            return true
        }
        return false
    }
    
    var isLimitedByNotificationMode: Bool {
        let notificationMode = self.notificationMode ?? .never
        guard notificationMode != .never else { return true }

        let showCounter = UpdateConfigurationShowCounter
            .read(
                counterId: latestVersion ?? Helpers.existingVersion
            )?.showCounter ?? 0

        if notificationMode == .once && showCounter == 1 { return true }
        
        return false
    }
}


extension UpdateGateConfiguration {
    private var isNewVersionAvailable: Bool {
        Helpers.compareAppVersions(Helpers.existingVersion, latestVersion ?? "") == .orderedAscending
    }
}
