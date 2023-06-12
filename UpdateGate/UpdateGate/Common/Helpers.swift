//
//  Helpers.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation

struct Helpers {
    static var existingVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static func compareAppVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        let components1 = version1.components(separatedBy: ".")
        let components2 = version2.components(separatedBy: ".")

        // Ensure both versions have the same number of components
        guard components1.count == components2.count else {
            return .orderedSame
        }

        for (index, component1) in components1.enumerated() {
            let component2 = components2[index]

            // Convert components to integers for comparison
            guard let number1 = Int(component1), let number2 = Int(component2) else {
                return .orderedSame
            }

            if number1 < number2 {
                return .orderedAscending
            } else if number1 > number2 {
                return .orderedDescending
            }
        }

        return .orderedSame
    }

    static func markdown(from text: String?) -> AttributedString {
        return (try? AttributedString(markdown: text ?? "")) ?? AttributedString(stringLiteral: "")
    }
}
