//
//  Localization.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/20/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import Foundation

fileprivate let authStringTable = "Auth"
fileprivate let noLocalizedStringKey = "NoLocalizedStringKey"

// Good practice to localize UI strings to a single source and helps to handle multilingual UI
private struct Localization {
    static func localizedString(forKey key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: noLocalizedStringKey, table: authStringTable)
    }
}

func LocalizedString(_ key: String) -> String {
    return Localization.localizedString(forKey: key)
}
