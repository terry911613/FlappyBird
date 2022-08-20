//
//  GameManager.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/17.
//

import Foundation

class GameManager {
    static let shared = GameManager()
    private init() {}
    
    var bird: BirdType = .Blue
    var birds = BirdType.allCases
    
    func getBird() -> BirdType {
        bird
    }
    
    func toggleBird() {
        if let index = birds.firstIndex(of: bird) {
            var newIndex = index + 1
            if newIndex >= birds.count {
                newIndex = 0
            }
            bird = birds[newIndex]
        }
    }
    
    func setHighScore(_ score: Int) {
        GameDataManager.shared.score = score
    }
    
    func getHighScore() -> Int {
        GameDataManager.shared.score
    }
}
