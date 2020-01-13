//
//  SettingsView.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 24.08.19.
//  Copyright © 2019 - 2020 Johannes Kreutz. All rights reserved.
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

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var settings: SettingsStore
    let sceneDelegate: SceneDelegate
    
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    private func getBuildString() -> String {
        let appBuild: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let buildNumberParts: [String] = appBuild.components(separatedBy: ".")
        let convertMidPart: [String:String] = ["0": "A", "1": "B", "2": "C", "3": "D", "4": "E", "5": "F", "6": "G", "7": "H", "8": "I", "9": "J", "10": "K", "11": "L", "12": "M", "13": "N", "14": "O", "15": "P", "16": "Q", "17": "R", "18": "S", "19": "T", "20": "U", "21": "V", "22": "W", "23": "X", "24": "Y", "25": "Z"]
        return buildNumberParts[0] + (convertMidPart[buildNumberParts[1]] ?? "A") + buildNumberParts[2]
    }
    
    private func getCompileTimeString() -> String {
        var compileDate:Date {
            let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? "Info.plist"
            if let infoPath = Bundle.main.path(forResource: bundleName, ofType: nil),
               let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
               let infoDate = infoAttr[FileAttributeKey.creationDate] as? Date {
                return infoDate
            }
            return Date()
        }
        let format = DateFormatter()
        format.dateFormat = "dd.MM.yyyy HH:mm"
        return format.string(from: compileDate)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    CheckboxSettingRow(toggle: $settings.autoScan, title: "Beim Öffnen scannen")
                }
                Section(header: Text("MEINE KARTE")) {
                    HStack {
                        Text("ID").foregroundColor(.gray)
                        Spacer()
                        Text(settings.myCard)
                    }
                    TextRow(title: "Beim ersten Scan wurde die ID deiner Karte gespeichert. Anhand dieser ID kannst du den Verlauf filtern, falls du auch Karten von Freunden gescannt hast.")
                    Button(action: {
                        self.sceneDelegate.updateMyCard()
                    }) {
                        HStack {
                            Text("Meine Karten-ID neu setzen")
                            .foregroundColor(.textColor(for: self.colorScheme))
                            Spacer()
                            Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(Font.system(size: 18, weight: .semibold))
                        }
                    }
                }
                Section(header: Text("SUPPORT")) {
                    NavigationLink("Unterstützte Mensen", destination: SupportedCanteensView())
                    //NavigationLink("Meine Mensa hinzufügen", destination: AddCanteenView())
                }
                Section(header: Text("ÜBER DIE APP")) {
                    TextRow(title: "© 2019 - 2020 Johannes Kreutz.\nAlle Rechte vorbehalten.\nVersion \(appVersion) Build \(getBuildString())\n(compiled \(getCompileTimeString()))")
                    NavigationLink("Rechtliches", destination: LegalView())
                }
                Section(header: Text("OPEN SOURCE"), footer: Text("Made with ❤ and some code on the 🚂 between Marburg and Darmstadt.")
                    .font(.system(size: 13))
                    .italic()) {
                    HttpLinkRow(url: "https://github.com/TheJKM/MensaGuthaben-iOS", title: "MensaGuthaben auf GitHub")
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Einstellungen")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Fertig").bold()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(sceneDelegate: SceneDelegate())
    }
}
