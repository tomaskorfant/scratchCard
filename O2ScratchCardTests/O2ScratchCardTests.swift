//
//  O2ScratchCardTests.swift
//  O2ScratchCardTests
//
//  Created by Tomas Korfant on 26/03/2024.
//

import XCTest
import SwiftData
import SwiftUI
@testable import O2ScratchCard

final class O2ScratchCardTests: XCTestCase {

    var sharedModelContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: ScratchCard.self, configurations: config)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    let apiResponseFail = ApiResponse(ios: "6.0", iosTM: "", iosRA: "", iosRA_2: "", android: "", androidTM: "", androidRA: "")
    let apiResponseSuccess = ApiResponse(ios: "6.2", iosTM: "", iosRA: "", iosRA_2: "", android: "", androidTM: "", androidRA: "")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCardStates() throws {
        let card = ScratchCard()

        XCTAssertThrowsError(try card.activate(with: apiResponseFail))
        XCTAssertThrowsError(try card.activate(with: apiResponseSuccess))

        XCTAssertNoThrow(try card.scratched())

        XCTAssertThrowsError(try card.activate(with: apiResponseFail))
        XCTAssertNoThrow(try card.activate(with: apiResponseSuccess))

        XCTAssertThrowsError(try card.activate(with: apiResponseSuccess))

        XCTAssertThrowsError(try card.scratched())


        card.reset()

        XCTAssertTrue(card.state == .unscratched)
        XCTAssertNil(card.code)
    }

    func testContentView() throws {
        let card = ScratchCard()
        let contentView = ContentView(card: card)

        XCTAssertTrue(contentView.card.state == .unscratched)
        XCTAssertNil(contentView.card.code)
    }

    func testScratchView() throws {
        let card = ScratchCard()
        let scratchView = ScratchView(card: card)

        XCTAssertTrue(scratchView.card.state == .unscratched)
        XCTAssertNil(scratchView.card.code)


        let exp1 = XCTestExpectation()
        let exp2 = XCTestExpectation()

        scratchView.scratch()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            if scratchView.card.state == .unscratched {
                exp1.fulfill()
            }

            if scratchView.card.code == nil {
                exp2.fulfill()
            }
        }

        let exp3 = XCTestExpectation()
        let exp4 = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            if scratchView.card.state == .scratched {
                exp3.fulfill()
            }

            if scratchView.card.code != nil {
                exp4.fulfill()
            }
        }

        wait(for: [exp1, exp2, exp3, exp4], timeout: 3)
    }

    func testActivationView() throws {
        let card = ScratchCard()
        try card.scratched()
        let activateView = ActivateView(card: card)

        XCTAssertTrue(activateView.card.state == .scratched)
        XCTAssertNotNil(activateView.card.code)

        try card.activate(with: apiResponseSuccess)

        XCTAssertNotNil(activateView.card.code)
        XCTAssertTrue(activateView.card.state == .activated)
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
