//
//  MainView.swift
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

import SwiftUI

struct MainView: View {
    @State private var showSettingsModal: Bool = false
    @EnvironmentObject var balance: Balance
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var historyData: HistoryData
    let sceneDelegate: SceneDelegate
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        BalanceView(title: "Aktuelles Guthaben", balance: self.balance.current)
                        BalanceView(title: "Letzte Transaktion", balance: self.balance.previous)
                        HStack {
                            Button(action: {
                                self.sceneDelegate.scanCard()
                            }) {
                                Text("Erneut scannen")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }.padding(.bottom, 15).padding(.top, 5)
                        VStack {
                            HStack {
                                Text("VERLAUF").font(.system(size: 15)).foregroundColor(.gray)
                                Spacer()
                            }
                            HStack {
                                ChartsContainer(historyData: self.historyData.myData).frame(height: 200.0)
                            }
                        }
                        HStack {
                            NavigationLink("Ganzen Verlauf ansehen", destination: HistoryView(sceneDelegate: sceneDelegate))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2)
                            )
                        }.padding(.leading, 2).padding(.trailing, 2)
                    }
                    
                }.padding()
            }
            .navigationBarTitle("MensaGuthaben")
            .navigationBarItems(trailing: Button(action: {
                self.showSettingsModal = true
            }) {
                Image(systemName: "line.horizontal.3")
            }).sheet(isPresented: $showSettingsModal, onDismiss: {self.showSettingsModal = false}, content: {
                SettingsView(sceneDelegate: self.sceneDelegate).environmentObject(self.settings)
            })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sceneDelegate: SceneDelegate())
    }
}
