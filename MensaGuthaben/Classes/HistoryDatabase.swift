//
//  SQLiteDatabase.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 21.09.19.
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
import SQLite3

// Error cases
enum HistoryError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
    case Select(message: String)
}

// SQLite class
class HistoryDatabase {
    
    // MARK: Properties
    private let db: OpaquePointer?
    
    // MARK: Initialization
    init(db: OpaquePointer) {
        self.db = db
        self.setupTable()
    }
    
    // MARK: Static database opening
    static func open() throws -> HistoryDatabase {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("history.sqlite")
        
        var db: OpaquePointer? = nil
        if (sqlite3_open(fileURL.path, &db) == SQLITE_OK) {
            return HistoryDatabase(db: db!)
        } else {
            defer {
                if (db != nil) {
                    sqlite3_close(db)
                }
            }
            throw HistoryError.OpenDatabase(message: String(cString: sqlite3_errmsg(db)))
        }
    }
    
    // MARK: Error handling
    var errorMessage: String {
        return String(cString: sqlite3_errmsg(db))
    }
    
    // MARK: Private helpers
    private func setupTable() {
        sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS history (id integer primary key autoincrement, current integer, previous integer, card text, date integer)", nil, nil, nil)
    }
    
    // MARK: Public functions
    func prepare(command: String) throws -> OpaquePointer {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(db, command, -1, &statement, nil) == SQLITE_OK else {
            throw HistoryError.Prepare(message: errorMessage)
        }
        return statement!
    }
    
    func insertScan(current: Int32, previous: Int32, date: Int32, card: String) throws {
        let statement: OpaquePointer = try self.prepare(command: "INSERT INTO history (current, previous, card, date) VALUES (?, ?, ?, ?)")
        if (sqlite3_bind_int(statement, 1, current) != SQLITE_OK) {
            throw HistoryError.Bind(message: errorMessage)
        }
        if (sqlite3_bind_int(statement, 2, previous) != SQLITE_OK) {
            throw HistoryError.Bind(message: errorMessage)
        }
        if (sqlite3_bind_text(statement, 3, card, -1, nil) != SQLITE_OK) {
            throw HistoryError.Bind(message: errorMessage)
        }
        if (sqlite3_bind_int(statement, 4, date) != SQLITE_OK) {
            throw HistoryError.Bind(message: errorMessage)
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            throw HistoryError.Step(message: errorMessage)
        }
    }
    
    func getHistory(full: Bool = false) throws -> [HistoryEntry] {
        var statementExtension: String = ""
        if (full) {
            statementExtension = " LIMIT 10"
        }
        let statement: OpaquePointer = try self.prepare(command: "SELECT * FROM history ORDER BY date DESC" + statementExtension)
        var result: [HistoryEntry] = []
        while (sqlite3_step(statement) == SQLITE_ROW) {
            if let cString = sqlite3_column_text(statement, 3) {
                result.append(HistoryEntry(id: sqlite3_column_int(statement, 0), current: sqlite3_column_int(statement, 1), previous: sqlite3_column_int(statement, 2), card: String(cString: cString), date: sqlite3_column_int(statement, 4)))
            } else {
                throw HistoryError.Select(message: errorMessage)
            }
        }
        return result
    }
    
    func deleteEntry(id: Int32) throws {
        let statement: OpaquePointer = try self.prepare(command: "DELETE FROM history WHERE id = ?")
        if (sqlite3_bind_int(statement, 1, id) != SQLITE_OK) {
            throw HistoryError.Bind(message: errorMessage)
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            throw HistoryError.Step(message: errorMessage)
        }
    }
    
    func clear() throws {
        let statement: OpaquePointer = try self.prepare(command: "DELETE FROM history")
        if (sqlite3_step(statement) != SQLITE_DONE) {
            throw HistoryError.Step(message: errorMessage)
        }
    }
    
    // MARK: Object destroying
    deinit {
        sqlite3_close(db)
    }
}
