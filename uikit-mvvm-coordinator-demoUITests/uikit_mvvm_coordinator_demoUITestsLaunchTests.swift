//
//  uikit_mvvm_coordinator_demoUITestsLaunchTests.swift
//  uikit-mvvm-coordinator-demoUITests
//
//  Created by Keke Arif on 2023/3/31.
//

import XCTest

final class uikit_mvvm_coordinator_demoUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
