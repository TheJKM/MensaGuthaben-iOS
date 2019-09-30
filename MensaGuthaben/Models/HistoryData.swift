//
//  HistoryData.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 22.09.19.
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
import Combine

class HistoryData: ObservableObject {

    // MARK: Combine helpers
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    // MARK: Properties
    @Published var data: [HistoryEntry]
    @Published var myData: [HistoryEntry] = []
    
    // MARK: Initialization
    init() {
        self.data = []
        self.myData = []
    }
    
    init(data: [HistoryEntry]) {
        self.data = data
        updateMyData(data: data)
    }
    
    // MARK: Private helpers
    private func updateMyData(data: [HistoryEntry]) {
        self.myData = []
        data.forEach { entry in
            if (entry.card == UserDefaults.myCard || UserDefaults.myCard == "0") {
                self.myData.append(entry)
            }
        }
    }
    
    // MARK: Setters
    func set(data: [HistoryEntry]) {
        self.data = data
        updateMyData(data: data)
        objectWillChange.send()
    }
    
}
