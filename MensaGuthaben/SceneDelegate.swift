//
//  SceneDelegate.swift
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

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CardScannerDelegate {
    
    // MARK: Properties

    var window: UIWindow?
    var cardScanner: CardScanner?
    let balance: Balance = Balance()
    let settings: SettingsStore = SettingsStore()
    var history: HistoryDatabase?
    let historyData: HistoryData = HistoryData()
    var nextScanIsMyUpdate: Bool = false
    
    // MARK: Delegate functions

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let mainView = MainView(sceneDelegate: self).environmentObject(self.balance).environmentObject(self.settings).environmentObject(self.historyData)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
        // Connect to history database
        do {
            try self.history = HistoryDatabase.open()
            try self.historyData.set(data: self.history!.getHistory())
        }
        catch {
            print("Error opening history database: \(error)")
        }
        
        // Start scanning session if auto scan is enabled
        if (settings.autoScan) {
            self.scanCard()
        }
        // Demo data creation for screenshots
        /*let values: [Int32] = [14500, 12250, 8300, 5520, 25520, 21100, 19200, 16750]
        var timestamp: Int32 = Int32(NSDate().timeIntervalSince1970)
        values.forEach { value in
            do {
                try self.history?.insertScan(current: value, previous: Int32(1230), date: timestamp, card: String("XYZ"))
            }
            catch {
                print("Error storing scan in history: \(error)")
            }
            timestamp += 86400
        }*/
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: Card Scanner delegate functions
    
    func newDataAvailable(current: Int, previous: Int, card: Int) {
        cardScanner = nil
        self.balance.setCurrent(current: current)
        self.balance.setPrevious(previous: previous)
        let timestamp: Int32 = Int32(NSDate().timeIntervalSince1970)
        if (!nextScanIsMyUpdate) {
            do {
                try self.history?.insertScan(current: Int32(current), previous: Int32(previous), date: timestamp, card: String(card))
            }
            catch {
                print("Error storing scan in history: \(error)")
            }
        }
        if (settings.myCard == "0" || self.nextScanIsMyUpdate) {
            settings.myCard = String(card)
            self.nextScanIsMyUpdate = false
        }
        loadFromMemory()
    }
    
    func sessionCancel() {
        cardScanner = nil
    }
    
    // MARK: Scan card
    
    func scanCard() {
        guard cardScanner == nil || !cardScanner!.sessionRunning() else {
            return
        }
        cardScanner = CardScanner(delegate: self)
        cardScanner?.scan()
    }
    
    func updateMyCard() {
        self.nextScanIsMyUpdate = true
        self.scanCard()
    }
    
    // MARK: History functions
    
    func loadFromMemory() {
        do {
            try self.historyData.set(data: self.history!.getHistory())
        }
        catch {
            print("Error loading history: \(error)")
        }
    }
    
    func deleteFullHistory() {
        guard self.history != nil else {
            return
        }
        do {
            try self.history!.clear()
        }
        catch {
            print("Error clearing history: \(error)")
        }
        loadFromMemory()
    }
    
    func deleteEntry(id: Int32) {
        guard self.history != nil else {
            return
        }
        do {
            try self.history!.deleteEntry(id: id)
        }
        catch {
            print("Error deleting history entry: \(error)")
        }
        loadFromMemory()
    }
    
    // MARK: Getters
    
    func getSettings() -> SettingsStore {
        return self.settings
    }

}

