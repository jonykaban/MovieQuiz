import Foundation
import XCTest
@testable import MovieQuiz // импорт этого приложения для теста

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {  // тест на успешное взятие по индексу
        //Given (Дано)
        let array = [1, 1, 2, 3, 5]
        
        //When (Когда)
        let value = array[safe: 4]
        
        //Then (Тогда)
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 5)
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие по неверноему индексу
        //Given (Дано)
        let array = [1, 1, 2, 3, 5]
        
        //When (Когда)
        let value = array[safe: 20]
        
        //Then (Тогда)
        XCTAssertNil(value)
    }
}
