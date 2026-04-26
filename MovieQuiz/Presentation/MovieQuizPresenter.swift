import UIKit

final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func convert(_ model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.imageName,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func yesButtonClicked() {
        didAnswer()
    }
    
    func noButtonClicked() {
        didAnswer()
    }
    
    private func didAnswer() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(question)
        
        DispatchQueue.main.async{ [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
