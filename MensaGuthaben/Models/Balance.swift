//
//  CardValue.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 22.08.19.
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

class Balance: ObservableObject {
    
    // MARK: Properties
    
    @Published var current: String
    @Published var previous: String
    @Published var currentDouble: Double
    
    // MARK: Initialization
    
    init() {
        self.current = "-,--€"
        self.previous = "-,--€"
        self.currentDouble = 0.0
    }
    
    // MARK: Private helpers
    
    private func convertToEuroValue(data: Int) -> String {
        return String(format: "%.2f", Double(data) / 1000).replacingOccurrences(of: ".", with: ",") + "€"
    }
    
    // MARK: Setters
    
    func setCurrent(current: Int) {
        self.current = convertToEuroValue(data: current)
        self.currentDouble = Double(current) / 1000
    }
    
    func setPrevious(previous: Int) {
        self.previous = convertToEuroValue(data: previous)
    }
    
}
