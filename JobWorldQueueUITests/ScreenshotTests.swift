import XCTest

final class ScreenshotTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func test_captureAllScreenshots() {
        sleep(2)
        captureScreenshot(name: "01_home")
        
        // 탭바에서 다른 탭 선택
        let tabBar = app.tabBars
        if tabBar.buttons.count > 1 {
            tabBar.buttons.element(boundBy: 1).tap()
            sleep(1)
            captureScreenshot(name: "02_timetable")
        }
        if tabBar.buttons.count > 2 {
            tabBar.buttons.element(boundBy: 2).tap()
            sleep(1)
            captureScreenshot(name: "03_route")
        }
        if tabBar.buttons.count > 3 {
            tabBar.buttons.element(boundBy: 3).tap()
            sleep(1)
            captureScreenshot(name: "04_profile")
        }
    }
    
    private func captureScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
