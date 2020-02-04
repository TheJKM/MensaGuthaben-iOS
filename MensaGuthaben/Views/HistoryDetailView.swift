//
//  HistoryDetailView.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 23.09.19.
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

struct HistoryDetailView: View {
    let current: String
    let previous: String
    let date: String
    let card: String
    
    var body: some View {
        List {
            Section(header: Text("historyDetail.balance")) {
                Text(self.current)
            }
            Section(header: Text("historyDetail.last")) {
                Text(self.previous)
            }
            Section(header: Text("historyDetail.timestamp")) {
                Text(self.date)
            }
            Section(header: Text("historyDetail.id")) {
                Text(self.card)
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle(self.date)
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetailView(current: "-,--€", previous: "-,--€", date: "23.09.2019 21:03", card: "1234567890")
    }
}
