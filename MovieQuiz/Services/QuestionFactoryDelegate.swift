//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Никита Федоров on 19.03.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
