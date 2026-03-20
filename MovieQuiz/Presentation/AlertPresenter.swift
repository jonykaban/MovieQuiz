//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Никита Федоров on 20.03.2026.
//
import UIKit

class AlertPresenter {
    private weak var viewController: UIViewController?
    
    func setup(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
}
