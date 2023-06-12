//
//  ReadMode.swift
//  UpdateGate
//
//  Created by Anthony Tran on 11/06/2023.
//

import Foundation

public enum UpdateGateReadMode {
    case local(fileURL: URL)
    case remote(apiURL: URL)
}
