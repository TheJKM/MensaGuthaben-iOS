//
//  Settings.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 30.08.19.
//  Copyright © 2019 Johannes Kreutz. All rights reserved.
//
//  This file is part of MensaGuthaben.
//
//  MensaGuthaben is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  MensaGuthaben is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with MensaGuthaben. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

extension UserDefaults {
    
    private struct Keys {
        static let autoScanDisabled = "autoScanDisabled"
        static let myCard = "myCard"
    }
    
    static var autoScanDisabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.autoScanDisabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.autoScanDisabled)
        }
    }
    
    static var myCard: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.myCard) ?? "0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.myCard)
        }
    }
    
}

class SettingsStore: ObservableObject {

    @Published var autoScan: Bool = !UserDefaults.autoScanDisabled {
        didSet {
            UserDefaults.autoScanDisabled = !self.autoScan
        }
    }
    
    @Published var myCard: String = UserDefaults.myCard {
        didSet {
            UserDefaults.myCard = self.myCard
        }
    }

}
