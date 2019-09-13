//
//  SupportedCanteensView.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 24.08.19.
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

struct SupportedCanteensView: View {
    let supported: [String] = ["TU Darmstadt"]
    let untested: [String] = ["Uni Bamberg", "Uni Bayreuth (nur Druckguthaben)", "Uni Bielefeld (nur neuere Karten)", "Uni Bochum (nur neuere Karten)", "FH Brandenburg", "TU Braunschweig", "Uni Bremen", "HS Bremerhaven", "TU Clausthal", "h_da Darmstadt", "TU Dresden Emeal", "HS Freiburg", "DH Gera Eisenbach", "Uni Greifswald", "MLU Halle", "HAW Hamburg", "HS Hannover", "Uni Heidelberg", "Uni Hohenheim (nur neuere Karten)", "TU Ilmenau", "HS Koblenz", "Uni Koblenz", "FH Köln", "Uni Köln", "Uni Leipzig", "Uni Lüneburg", "Uni Magdeburg", "DHBW Mosbach", "HS Offenburg", "Uni Osnabrück", "HS Osnabrück", "Uni Saarland", "Uni Stuttgart", "FH Würzburg", "Uni Würzburg", "HS Zittau/Görlitz"]
    
    private func getSupported() -> String {
        var supportedString: String = ""
        for x in supported {
            if (supportedString != "") {
                supportedString += "\n"
            }
            supportedString += "\u{2022} \(x)"
        }
        return supportedString
    }
    private func getUntested() -> String {
        var untestedString: String = ""
        for x in untested {
            if (untestedString != "") {
                untestedString += "\n"
            }
            untestedString += "\u{2022} \(x)\n"
        }
        return untestedString
    }
    
    var body: some View {
        List {
            Section(header: Text("GETESTETE KARTEN")) {
                TextRow(title: getSupported())
                .font(.system(size: 14))
            }
            Section(header: Text("UNGETESTETE KARTEN")) {
                TextRow(title: "Die Karten folgender Mensen sollten mit der App funktionieren, wurden jedoch noch nicht getestet. Du hast die App erfolgreich mit einer Karte dieser Mensen oder einer hier nicht genannten Mensa genutzt? Schreib uns:")
                HttpLinkRow(url: "https://github.com/TheJKM/MensaGuthaben-iOS", title: "Auf GitHub")
                HttpLinkRow(url: "mailto:mensaguthaben@jkm-marburg.de", title: "Per E-Mail")
                TextRow(title: getUntested())
                .font(.system(size: 14))
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle("Unterstützte Mensen")
    }
}

struct SupportedCanteensView_Previews: PreviewProvider {
    static var previews: some View {
        SupportedCanteensView()
    }
}
