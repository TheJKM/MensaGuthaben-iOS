//
//  LegalView.swift
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

struct LegalView: View {
    var body: some View {
        List {
            Section(header: Text("legal.disclaimertitle")) {
                TextRow(title: NSLocalizedString("legal.disclaimer", comment: ""))
                .font(.system(size: 14))
            }
            Section(header: Text("legal.licensetitle")) {
                TextRow(title: NSLocalizedString("legal.license", comment: ""))
                .font(.system(size: 14))
            }
            Section(header: Text("legal.third")) {
                TextRow(title: NSLocalizedString("legal.oss", comment: ""))
                .font(.system(size: 14))
                NavigationLink("legal.osstitle", destination: OpenSourceLicencesView())
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle("legal.title")
    }
}

struct LegalView_Previews: PreviewProvider {
    static var previews: some View {
        LegalView()
    }
}
