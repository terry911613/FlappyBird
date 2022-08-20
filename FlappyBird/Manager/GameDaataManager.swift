//
//  GameDaataManager.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/20.
//

import Foundation

class GameDataManager {
    
    public static let shared = GameDataManager()
    private init() {}
    
    private let userDef = UserDefaults.standard
    
    // MARK: - Keys
    private enum Key: String, CaseIterable {
        case score
    }
    
    // MARK: - Value
    
    public var score: Int {
        get {
            return userDef.integer(forKey: Key.score.rawValue)
        }
        set {
            userDef.set(newValue, forKey: Key.score.rawValue)
        }
    }
}
