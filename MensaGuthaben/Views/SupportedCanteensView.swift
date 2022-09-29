//
//  SupportedCanteensView.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 24.08.19.
//  Copyright © 2019 - 2022 Johannes Kreutz. All rights reserved.
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
    let supported: [String] = ["HS Aschaffenburg", "Uni Bamberg", "Uni Bochum", "TU Braunschweig", "TU Darmstadt", "h_da Darmstadt", "TU Dresden Emeal", "Westfälische Hochschule Gelsenkirchen", "Uni Gießen", "Uni Greifswald", "Uni Hannover", "HS Hannover", "TU Ilmenau", "HS Koblenz", "Uni Koblenz", "Uni Köln", "FH Köln", "Uni Leipzig", "Uni Saarland", "Uni Ulm", "FH Würzburg", "Uni Würzburg", "HAW Würzburg-Schweinfurt"]
    let untested: [String] = ["Uni Bayreuth (nur Druckguthaben)", "Uni Bielefeld (nur neuere Karten)", "FH Brandenburg", "Uni Bremen", "HS Bremerhaven", "TU Clausthal", "HS Freiburg", "DH Gera Eisenbach", "MLU Halle", "HAW Hamburg", "Uni Heidelberg", "Uni Hohenheim (nur neuere Karten)", "Uni Lüneburg", "Uni Magdeburg", "DHBW Mosbach", "HS Offenburg", "Uni Osnabrück", "HS Osnabrück", "HS für Gestaltung Schwäbisch Gmünd", "Uni Stuttgart", "HS Zittau/Görlitz"]

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
            untestedString += "\u{2022} \(x)"
        }
        return untestedString
    }

    var body: some View {
        List {
            Section(header: Text("supported.tested")) {
                TextRow(title: getSupported())
                .font(.system(size: 14))
            }
            Section(header: Text("supported.untested")) {
                TextRow(title: NSLocalizedString("supported.infotext", comment: ""))
                HttpLinkRow(url: "https://github.com/TheJKM/MensaGuthaben-iOS", title: NSLocalizedString("supported.github", comment: ""))
                HttpLinkRow(url: "mailto:mensaguthaben@jkm-marburg.de", title: NSLocalizedString("supported.email", comment: ""))
                TextRow(title: getUntested())
                .font(.system(size: 14))
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle("supported.title")
    }
}

struct SupportedCanteensView_Previews: PreviewProvider {
    static var previews: some View {
        SupportedCanteensView()
    }
}
