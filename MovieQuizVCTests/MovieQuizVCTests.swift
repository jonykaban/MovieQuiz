import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var lastStepModel: QuizStepViewModel?
    var lastResultModel: QuizResultsViewModel?
    var isHighlightImageBorderCalled = false
    var shownNetworkErrorMessage: String?
    var isShowLoadingIndicatorCalled = false
    var isHideLoadingIndicatorCalled = false
    var isRemoveImageBorderBeforeNewQuestionCalled = false
    var isImageSettingsCalled = false
    var isActivateButtonsAfterQuestionCalled = false
    var isButtonsEnabled: Bool?
    
    func show(quiz step: QuizStepViewModel) {
        lastStepModel = step
    }
    
    func show(quiz result: QuizResultsViewModel) {
        lastResultModel = result
    }
    
    func setButtonsEnabled(_ isEnabled: Bool) {
        isButtonsEnabled = isEnabled
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        isHighlightImageBorderCalled = true
    }
    
    func showLoadingIndicator() {
        isShowLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        isHideLoadingIndicatorCalled = true
    }
    
    func showNetworkError(message: String) {
        shownNetworkErrorMessage = message
    }
    func removeImageBorderBeforeNewQuestion() {
        isRemoveImageBorderBeforeNewQuestionCalled = true
    }
    
    func imageSettings() {
        isImageSettingsCalled = true
    }
    
    func activateButtonsAfterQuestion() {
        isActivateButtonsAfterQuestionCalled = true
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(imageName: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(question)
        
        XCTAssertEqual(viewControllerMock.lastStepModel?.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
