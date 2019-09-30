//
//  HistoryView.swift
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

import SwiftUI

struct HistoryView: View {
    @State private var deleteSheet = false
    @State private var displayMode = 1
    @EnvironmentObject var historyData: HistoryData
    @EnvironmentObject var settings: SettingsStore
    let sceneDelegate: SceneDelegate
    
    private func getDateString(timestamp: Int32) -> String {
        let date: Date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func createList() -> [HistoryEntry] {
        var showData: [HistoryEntry] = []
        self.historyData.data.forEach { entry in
            if (self.displayMode == 2 || self.settings.myCard == entry.card) {
                showData.append(entry)
            }
        }
        return showData
    }
    
    private func getDeleteId(index: Int) -> Int32 {
        if (self.displayMode == 2) {
            return self.historyData.data[index].id
        } else {
            var count: Int = 0
            for entry in self.historyData.data {
                if (count == index) {
                    return entry.id
                }
                if (self.settings.myCard == entry.card) {
                    count += 1
                }
            }
        }
        return 0
    }
    
    var body: some View {
        VStack {
            Picker("Anzeigemodus", selection: $displayMode) {
                Text("Meine Karte").tag(1)
                Text("Alle").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
                        
            List {
                ForEach(self.createList(), id: \.id) { entry in
                    NavigationLink("\(entry.balance.current) (\(self.getDateString(timestamp: entry.date)))", destination: HistoryDetailView(current: entry.balance.current, previous: entry.balance.previous, date: self.getDateString(timestamp: entry.date), card: entry.card))
                }.onDelete { (IndexSet) in
                    self.sceneDelegate.deleteEntry(id: self.getDeleteId(index: IndexSet.first!))
                }
            }
        }
        .navigationBarTitle("Verlauf")
        .navigationBarItems(trailing: Button(action: {
            self.deleteSheet = true
        }) {
            Image(systemName: "trash.fill")
        })
        .actionSheet(isPresented: $deleteSheet) {
            ActionSheet(title: Text("Möchtest du den gesamten Verlauf wirklich löschen?"), buttons: [
                .destructive(Text("Löschen"), action: {
                    self.sceneDelegate.deleteFullHistory()
                }),
                .cancel(Text("Abbrechen"))
            ])
        }
    }
}

let historyDataDemo: HistoryData = HistoryData(data: [HistoryEntry(id: 1, current: 10, previous: 10, card: "12345", date: 13424234)])

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(sceneDelegate: SceneDelegate())
    }
}
