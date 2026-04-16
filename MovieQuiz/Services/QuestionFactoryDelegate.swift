//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Никита Федоров on 19.03.2026.
//
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
