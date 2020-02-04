//
//  CardScanner.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 25.08.19.
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
import PromiseKit
import JKDesFireReader

class CardScanner: JKDesFireReaderDelegate {
    
    // MARK: Properties
    
    let delegate: CardScannerDelegate
    var reader: JKDesFireReader? = nil
    
    // MARK: Initialization
    
    init(delegate: CardScannerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: Control reader session
    
    func scan() {
        // Only start a new scanning session if there is no session open
        guard reader == nil else {
            return
        }
        reader = JKDesFireReader(start: false, delegate: self)
        reader?.setSessionInfoText(text: NSLocalizedString("reader.subtitle", comment: ""))
        reader?.setErrorInfoText(text: NSLocalizedString("reader.failed", comment: ""))
        
        // Start session
        if !(reader?.createReaderSession())! {
            print("Error creating reader session in JKDesFireReader.")
        }
    }
    
    func sessionRunning() -> Bool {
        return reader == nil ? false : true
    }
    
    // MARK: Delegate functions
    
    func didDetectDesFireTag() {
        firstly {
            (reader?.listApplications())!
        }.done { response in
            var cardKnown: Bool = false
            var appId: UInt32 = 0
            var fileId: UInt8 = 0
            
            // Check if we know an application id
            for id in response {
                if self.isCardValid(card: id) {
                    cardKnown = true
                    appId = id
                    fileId = self.getFileId(card: id)!
                }
            }
            
            // Show error message if card is unknown
            guard cardKnown else {
                self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.unknown", comment: "") + " (ERR_APPLICATION_NOT_FOUND).")
                self.delegate.sessionCancel()
                return
            }
            
            // Select application
            firstly {
                (self.reader?.selectApplication(applicationId: appId))!
            }.done { application in
                var fileFound: Bool = false
                
                // Check if the wanted file is available
                for file in application.getFiles() {
                    if (file == fileId) {
                        fileFound = true
                    }
                }
                
                // Show error message if card is unknown
                guard fileFound else {
                    self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.unknown", comment: "") + " (ERR_FILE_NOT_FOUND).")
                    self.delegate.sessionCancel()
                    return
                }
                
                // Get file settings
                application.getFileSettings(fileId: fileId)
                .done { settings in
                    var lastTransaction: Int = 0
                    
                    if let valueSettings = settings as? JKDesFireValueFileSettings {
                        lastTransaction = valueSettings.getValue()
                    } else {
                        self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.error", comment: "") + " (ERR_NO_VALUE_FILE).")
                        self.delegate.sessionCancel()
                    }
                    
                    // Read value
                    application.getValue(fileId: fileId)
                    .done { value in
                        self.delegate.newDataAvailable(current: value.getValue(), previous: lastTransaction, card: (self.reader?.getTagId())!)
                        self.reader?.stopRunningSession()
                    }.catch { error in
                        self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.error", comment: "") + " (ERR_READ_VALUE).")
                        self.delegate.sessionCancel()
                    }
                }.catch { error in
                    self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.error", comment: "") + " (ERR_READ_FILE_SETTINGS).")
                    self.delegate.sessionCancel()
                }
                
            }.catch { error in
                self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.error", comment: "") + " (ERR_SELECT_APPLICATION).")
                self.delegate.sessionCancel()
            }
            
        }.catch { error in
            print("Error getting application list: " + error.localizedDescription)
            self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.code", comment: "") + error.localizedDescription + ")")
            self.delegate.sessionCancel()
        }
    }
    
    func tagDetectionError(error: JKDesFirePublicError) {
        print("Error detecting tag: " + error.localizedDescription)
        self.reader?.stopRunningSession(errorMessage: NSLocalizedString("reader.code", comment: "") + error.localizedDescription + ")")
        self.delegate.sessionCancel()
    }
    
    // MARK: Private helpers
    
    private func isCardValid(card: UInt32) -> Bool {
        return getCard(id: card) != nil ? true : false
    }
    
    private func getFileId(card: UInt32) -> UInt8? {
        let c: Card? = getCard(id: card)
        if (c != nil) {
            return c!.fileId
        }
        return nil
    }
    
    private func getCard(id: UInt32) -> Card? {
        for (_, card) in Cards.c {
            if (card.applicationId == id) {
                return card
            }
        }
        return nil
    }
    
}
