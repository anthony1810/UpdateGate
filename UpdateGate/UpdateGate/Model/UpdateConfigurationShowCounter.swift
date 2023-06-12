//
//  UpdateConfigurationShowCounter.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation

struct UpdateConfigurationShowCounter: Codable, Identifiable {
    var id: String { appVersion ?? "1.0.0" }
    var appVersion: String?
    var showCounter: Int = 0

    static var pathToDiskURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    static func increaseShowCounter(for version: String) {
        var update: UpdateConfigurationShowCounter?
        if let existing = UpdateConfigurationShowCounter.read(counterId: version) {
            update = existing
        } else {
            update = UpdateConfigurationShowCounter()
        }
        update?.appVersion = version
        update?.showCounter += 1
        Self.save(counter: update!)
    }

    static func save(counter: UpdateConfigurationShowCounter) {
        DispatchQueue.global().async {
            do {
                let data = try JSONEncoder().encode(counter)
                try data.write(to: pathToDiskURL.appendingPathComponent("\(counter.id).json"))
                print("Struct saved successfully.")
            } catch {
                print("Error saving struct: \(error)")
            }
        }
    }

    static func read(counterId: String) -> UpdateConfigurationShowCounter? {
        do {
            let data = try Data(contentsOf: pathToDiskURL.appendingPathComponent("\(counterId).json"))
            let decodedStruct = try JSONDecoder().decode(UpdateConfigurationShowCounter.self, from: data)
            return decodedStruct
        } catch {
            print("readUpdateConfiguration: \(error.localizedDescription)")
            return nil
        }
    }
}
