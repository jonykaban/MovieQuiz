//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Никита Федоров on 24.03.2026.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
    
}
