import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButtonState: UIButton!
    @IBOutlet private var yesButtonState: UIButton!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol!
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(self)
        self.questionFactory = questionFactory
        self.questionFactory.requestNextQuestion()
        
        alertPresenter.setup(viewController: self)
        
        statisticService = StatisticService()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(question)
        
        DispatchQueue.main.async{ [weak self] in
            self?.show(quiz: viewModel)
        }
    }

    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        noButtonState.isEnabled = false
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        yesButtonState.isEnabled = false
    }
    
    private func convert(_ model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.imageName) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let message = """
            Ваш результат: \(correctAnswer)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        
        let model = AlertModel(title: result.title,
                               message: message,
                               buttonText: result.buttonText
        ) { [weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            self.questionFactory.requestNextQuestion()
        }
        alertPresenter.show(model: model)
    }
    
    private func imageSettings() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        imageSettings()
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0 // убираю рамку перед появлением нового вопроса
            self.showNextQuestionOrResult()
            self.noButtonState.isEnabled = true
            self.yesButtonState.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswer, total: questionsAmount)
            
            let text = "Ваш результат \(correctAnswer)/\(questionsAmount)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд закончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            
            show(quiz: viewModel) // тут должен вызываться аллерт об окончании игры
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
}
