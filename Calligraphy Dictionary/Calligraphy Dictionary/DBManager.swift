//
//  DBManager.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 30/10/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import FMDB

class DBManager: NSObject {
    static let shared: DBManager = DBManager()
    private var urlToDatabase: URL!
    private var pathToDatabase: String!
    
    private var database: FMDatabase!
    let mDfmt = DateFormatter()
    
    override init() {
        super.init()
        
        mDfmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let fileManager = FileManager.default

        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        urlToDatabase = documentsUrl.appendingPathComponent("fmdb.db")
        pathToDatabase = urlToDatabase.path
        
        copyDatabaseIfNeeded()
        //        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        //        pathToDatabase = documentsDirectory.appending("/fmdb.db")
    }
    
    func copyDatabaseIfNeeded() {
        let fileManager = FileManager.default
        do {
            if !fileManager.fileExists(atPath: pathToDatabase) {
                print("DB does not exist in documents folder")

                if let dbFilePath = Bundle.main.path(forResource: "fmdb", ofType: "db") {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: pathToDatabase)
                } else {
                    print("Uh oh - foo.db is not in the app bundle")
                }
            } else {
                print("Database file found at path: \(pathToDatabase)")
            }
        } catch {
            print("Unable to copy foo.db: \(error)")
        }
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func random() -> String {
        var char:String!
        if openDatabase() {
            let query = "SELECT c.charName FROM cursive c ORDER BY RANDOM() LIMIT 1;"
            
            do {
                let results = try database.executeQuery(query, values: [])
                
                while results.next() {
                    char = results.string(forColumn: "charName")!
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        return char
    }
    
    func randomSmallSeal() -> String {
        var char:String!
        if openDatabase() {
            let query = "SELECT c.charName FROM smallseal c ORDER BY RANDOM() LIMIT 1;"
            
            do {
                let results = try database.executeQuery(query, values: [])
                
                while results.next() {
                    char = results.string(forColumn: "charName")!
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        return char
    }
    
    func getPict(_ character:String) -> [(image:String,starred:Bool)] {
        var picts: [(image:String,starred:Bool)] = []
        
        if openDatabase() {
            let query = "SELECT c.image, s.key FROM cursive c LEFT JOIN starred s ON c.image = s.key WHERE charName = ?"
            
            do {
                let results = try database.executeQuery(query, values: [character])
                
                while results.next() {
                    picts.append((image: results.string(forColumn: "image")!, starred: (results.string(forColumn: "key") != nil)))
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return picts
    }
    
    func getSmallSeal(_ character:String) -> [(image:String,caption:String,starred:Bool)] {
        var picts: [(image:String,caption:String,starred:Bool)] = []
        
        if openDatabase() {
            let query = "SELECT c.image, c.caption_zh_Hant, s.key FROM smallseal c LEFT JOIN starred s ON c.image = s.key WHERE charName = ?"
            
            do {
                let results = try database.executeQuery(query, values: [character])
                
                while results.next() {
                    picts.append((image: results.string(forColumn: "image")!, caption: results.string(forColumn: "caption_zh_Hant")!, starred: (results.string(forColumn: "key") != nil)))
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return picts
    }
    
    func addHistory(_ key:String, _ type:Int) {
        if openDatabase() {
            let query = "INSERT INTO history (key, createDate, type) VALUES (?, ?, ?)"
            
            do {
                try database.executeUpdate(query, values: [key, mDfmt.string(from: Date()), type])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    func clearHistory() {
        if openDatabase() {
            let query = "DELETE FROM history"
            
            do {
                try database.executeUpdate(query, values: [])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    func deleteRecord(_ image:String) {
        if openDatabase() {
            let query = "DELETE FROM history WHERE key = ?"
            
            do {
                try database.executeUpdate(query, values: [image])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    func getHistory(_ lang:String) -> [[String:String]] {
        var dicts:[[String:String]] = []
        if openDatabase() {
            let query = "SELECT c.charName, c.image, c.caption_\(lang), s.charName AS s_charName, s.image AS s_image, s.caption_\(lang) AS s_caption_\(lang), h.createDate FROM history h LEFT JOIN cursive c ON h.type = 0 AND h.key = c.image LEFT JOIN smallseal s ON h.type = 1 AND h.key = s.image ORDER BY h.createDate DESC"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let dict = ["key": results.string(forColumn: "charName") ?? results.string(forColumn: "s_charName")!, "image": results.string(forColumn: "image") ?? results.string(forColumn: "s_image")!, "caption": results.string(forColumn: "caption_\(lang)") ?? (results.string(forColumn: "s_caption_\(lang)") ?? ""), "createDate": results.string(forColumn: "createDate")!]
                    
                    dicts.append(dict)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        return dicts
    }
    
    func starChar(_ key:String, _ type:Int) {
        if openDatabase() {
            let query = "INSERT INTO starred (key, createDate, type) VALUES (?, ?, ?)"
            print("asdf \(key)")
            do {
                try database.executeUpdate(query, values: [key, mDfmt.string(from: Date()), type])
            }
            catch {
                print("What")
                print(error.localizedDescription)
            }
            
//            let query2 = "SELECT key FROM starred"
//            do {
//                let results = try database.executeQuery(query2, values: [])
//                while results.next() {
//                    print(results.string(forColumn: "key")!)
//                }
//            }
//            catch {
//                print("What")
//                print(error.localizedDescription)
//            }
            
            database.close()
        }
    }
    
    func getStarred(_ lang:String) -> [[String:String]] {
        var dicts:[[String:String]] = []
        if openDatabase() {
            let query = "SELECT c.charName, c.image, c.caption_\(lang), s.charName AS s_charName, s.image AS s_image, s.caption_\(lang) AS s_caption_\(lang), x.createDate FROM starred x LEFT JOIN cursive c ON x.type = 0 AND x.key = c.image LEFT JOIN smallseal s ON x.type = 1 AND x.key = s.image ORDER BY x.createDate DESC"

            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let dict = ["key": results.string(forColumn: "charName") ?? results.string(forColumn: "s_charName")!, "image": results.string(forColumn: "image") ?? results.string(forColumn: "s_image")!, "caption": results.string(forColumn: "caption_\(lang)") ?? (results.string(forColumn: "s_caption_\(lang)") ?? ""), "createDate": results.string(forColumn: "createDate")!]
                    
                    dicts.append(dict)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        return dicts
    }
    
    func unstarChar(_ key:String) {
        if openDatabase() {
            let query = "DELETE FROM starred WHERE key = ?"
            
            do {
                try database.executeUpdate(query, values: [key])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
}
