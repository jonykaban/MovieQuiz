//
//  AlertModels.swift
//  MovieQuiz
//
//  Created by Никита Федоров on 20.03.2026.
//
import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    let completion: () -> Void
}
