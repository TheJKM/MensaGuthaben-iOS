//
//  DarkmodeTextColor.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 27.08.19.
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

import SwiftUI

extension Color {
    
    static let lightTextColor = Color(white: 0.0)
    
    static let darkTextColor = Color(white: 1.0)
        
    static func textColor(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? darkTextColor : lightTextColor
    }
    
}
