import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButtonState: UIButton!
    @IBOutlet private var yesButtonState: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private let presenter = MovieQuizPresenter()
    
    private var alertPresenter: AlertPresenter = AlertPresenter()
    var statisticService: StatisticServiceProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        alertPresenter.setup(viewController: self)
        
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        presenter.viewController = self
        
        showLoadingIndicator()
        presenter.questionFactory.loadData()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        presenter.questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
        noButtonState.isEnabled = false
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
        yesButtonState.isEnabled = false
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз"
        ) {
            [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            presenter.correctAnswers = 0
            presenter.questionFactory.requestNextQuestion()
        }
        
        alertPresenter.show(model: model)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = """
            Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        
        let model = AlertModel(title: result.title,
                               message: message,
                               buttonText: result.buttonText
        ) { [weak self] in
            guard let self = self else {return}
            self.presenter.resetQuestionIndex()
            presenter.correctAnswers = 0
            presenter.questionFactory.requestNextQuestion()
        }
        alertPresenter.show(model: model)
    }
    
    private func imageSettings() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter.correctAnswers += 1
        }
        imageSettings()
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0 // убираю рамку перед появлением нового вопроса
            
            self.presenter.showNextQuestionOrResult()
            self.noButtonState.isEnabled = true
            self.yesButtonState.isEnabled = true
        }
    }
    
//    func showNextQuestionOrResult() {
//         // тут должен вызываться аллерт об окончании игры
//    }
}
