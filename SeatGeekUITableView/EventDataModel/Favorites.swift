//
//  Favorites.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/21/21.
//

import Foundation
import SQLite3

class Favorite: Codable {
    var id: Int = -1
}

class DBHelper {
    
    var db: OpaquePointer?
    var path: String = "favoritesDB.sqlite"
    
    init() {
        self.db = createDB()
        self.createTable()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error creating DB.")
            return nil
        }
        else {
            print("Database created at \(path)")
            return db
        }
    }
    
    func createTable() {
        let query = "CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, eid INTEGER NOT NULL UNIQUE);"
        
        var createTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &createTable, nil) == SQLITE_OK {
            if sqlite3_step(createTable) == SQLITE_DONE {
                print("Table created")
            }
            else {
                print("Table creation failed")
            }
        }
        else {
            print("Prepare failed")
        }
    }
    
    func insert(id: Int) {
        let query = "INSERT INTO favorites (id, eid) VALUES (?, ?);"
        var insert: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &insert, nil) == SQLITE_OK {
            sqlite3_bind_int(insert, 2, Int32(id))
            
            if sqlite3_step(insert) == SQLITE_DONE {
                print("Insertion success")
            }
            else {
                print("Data insertion failed inside prepare")
            }
        }
        else {
            print("Insertion failed")
        }
    }
    
    func delete(id: Int) {
        let query = "DELETE FROM favorites where eid = \(id)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Deletion Success")
            }
            else {
                print("Deletion Failure")
            }
        }
    }
    
    func getFavorites() -> [Favorite] {
        var favorites = [Favorite]()
        let query = "SELECT * FROM favorites;"
        var select: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &select, nil) == SQLITE_OK {
            while sqlite3_step(select) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(select, 0))
                let eid = Int(sqlite3_column_int(select, 1))
                let obj = Favorite()
                obj.id = eid
                favorites.append(obj)
            }
        }
        
        return favorites
    }
}
