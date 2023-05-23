import XCTest

class SurfSpotsMapViewControllerTests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() {
    super.setUp()

    continueAfterFailure = false

    app = XCUIApplication()
  }

  func testSearchSurfSpotWithBottomSheetTitle() {
    let searchTitle = "Noosa"
    let app = XCUIApplication()
    app.launch()

    let map = app.otherElements["map_view"]
    XCTAssertTrue(map.waitForExistence(timeout: 1))
    XCTAssertTrue(app.buttons["cluster-1"].waitForExistence(timeout: 1))
    XCTAssertTrue(app.buttons["cluster-2"].waitForExistence(timeout: 1))

    map.pinch(withScale: 7, velocity: 1)
    map.swipeLeft(velocity: 10)

    XCTAssertTrue(app.buttons["marker-1"].waitForExistence(timeout: 7))
    XCTAssertTrue(app.buttons["marker-2"].waitForExistence(timeout: 7))
    XCTAssertTrue(app.buttons["marker-5"].waitForExistence(timeout: 7))

    app.buttons["marker-1"].tap()
    sleep(1)
    XCTAssertTrue(app.otherElements["surf_spot_details_view"].waitForExistence(timeout: 1))
    XCTAssertNotEqual(app.staticTexts["surf_spot_details_view_title_label"].label, searchTitle)
    app.otherElements["surf_spot_details_view"].swipeDown()

    app.buttons["marker-2"].tap()
    sleep(1)
    XCTAssertTrue(app.otherElements["surf_spot_details_view"].waitForExistence(timeout: 1))
    XCTAssertNotEqual(app.staticTexts["surf_spot_details_view_title_label"].label, searchTitle)
    app.otherElements["surf_spot_details_view"].swipeDown()

    app.buttons["marker-5"].tap()
    sleep(1)
    XCTAssertTrue(app.otherElements["surf_spot_details_view"].waitForExistence(timeout: 1))
    XCTAssertEqual(app.staticTexts["surf_spot_details_view_title_label"].label, searchTitle)
  }

  func testSurfSpotsDetailsShown() {
    let app = XCUIApplication()
    app.launch()

    let map = app.otherElements["map_view"]
    XCTAssertTrue(map.isHittable)
    XCTAssertFalse(app.otherElements["surf_spot_full_details_view"].exists)

    map.pinch(withScale: 7, velocity: 1)

    XCTAssertTrue(app.buttons["marker-6"].isHittable)
    app.buttons["marker-6"].tap()
    XCTAssertTrue(app.buttons["details_button"].isHittable)
    app.buttons["details_button"].tap()

    sleep(1)
    XCTAssertFalse(map.isHittable)
    XCTAssertTrue(app.otherElements["surf_spot_full_details_view"].exists)
  }


  func testAddSurfSpotToFavorite() {
    let app = XCUIApplication()
    app.launch()

    let map = app.otherElements["map_view"]
    XCTAssertTrue(map.isHittable)

    map.pinch(withScale: 7, velocity: 1)

    XCTAssertTrue(app.buttons["marker-6"].isHittable)
    app.buttons["marker-6"].tap()
    XCTAssertTrue(app.buttons["details_button"].isHittable)
    app.buttons["details_button"].tap()

    sleep(1)
    XCTAssertTrue(app.buttons["surf_spot_full_details_view_favorite_button"].exists)
    if app.buttons["surf_spot_full_details_view_favorite_button"].isSelected {
      app.buttons["surf_spot_full_details_view_favorite_button"].tap()
      XCTAssertFalse(app.buttons["surf_spot_full_details_view_favorite_button"].isSelected)
    } else {
      app.buttons["surf_spot_full_details_view_favorite_button"].tap()
      XCTAssertTrue(app.buttons["surf_spot_full_details_view_favorite_button"].isSelected)
    }
  }

  func testShareSurfSpotInfo() {
    let app = XCUIApplication()
    app.launch()

    let map = app.otherElements["map_view"]
    XCTAssertTrue(map.isHittable)

    map.pinch(withScale: 7, velocity: 1)

    app.buttons["marker-6"].tap()
    app.buttons["details_button"].tap()

    sleep(1)
    XCTAssertTrue(app.buttons["surf_spot_full_details_view_share_button"].exists)
    app.buttons["surf_spot_full_details_view_share_button"].tap()
    sleep(1)
    XCTAssertTrue(app.otherElements["ActivityListView"].waitForExistence(timeout: 3))
  }

//  func testBottomMenuShown() {
//    let app = XCUIApplication()
//    app.launch()
//
//    let map = app.otherElements["map_view"]
//    XCTAssertTrue(map.waitForExistence(timeout: 1))
//
//    map.pinch(withScale: 7, velocity: 1)
//
//    XCTAssertTrue(app.buttons["back_button"].isHittable)
//    XCTAssertTrue(app.buttons["next_button"].isHittable)
//    XCTAssertTrue(app.staticTexts["spot_name"].isHittable)
//  }
//
//  func testBottomMenuHidden() {
//    let app = XCUIApplication()
//    app.launch()
//
//    let map = app.otherElements["map_view"]
//    XCTAssertTrue(map.waitForExistence(timeout: 1))
//
//    map.pinch(withScale: 7, velocity: 1)
//
//    XCTAssertTrue(app.buttons["back_button"].isHittable)
//    XCTAssertTrue(app.buttons["next_button"].isHittable)
//    XCTAssertTrue(app.staticTexts["spot_name"].isHittable)
//
//    map.pinch(withScale: 0.2, velocity: -1)
//
//    sleep(2)
//    XCTAssertFalse(app.buttons["back_button"].isHittable)
//    XCTAssertFalse(app.buttons["next_button"].isHittable)
//    XCTAssertFalse(app.staticTexts["spot_name"].isHittable)
//  }

  func testSearchSurfSpotWithBottomMenu() {
    let title = "Margaret River"
    let app = XCUIApplication()
    app.launch()

    let map = app.otherElements["map_view"]

    XCTAssertTrue(map.waitForExistence(timeout: 1))
    XCTAssertTrue(app.buttons["cluster-1"].waitForExistence(timeout: 1))
    XCTAssertTrue(app.buttons["cluster-1"].isHittable)
    XCTAssertFalse(app.buttons["back_button"].isHittable)
    XCTAssertFalse(app.buttons["next_button"].isHittable)
    XCTAssertFalse(app.staticTexts["spot_name"].isHittable)

    app.buttons["cluster-1"].tap()
    sleep(2)

    XCTAssertTrue(app.buttons["back_button"].isHittable)
    XCTAssertTrue(app.buttons["next_button"].isHittable)
    XCTAssertTrue(app.staticTexts["spot_name"].isHittable)

    XCTAssertNotEqual(app.staticTexts["spot_name"].label, title)
    app.buttons["next_button"].tap()
    sleep(2)
    XCTAssertNotEqual(app.staticTexts["spot_name"].label, title)
    app.buttons["next_button"].tap()
    sleep(2)
    XCTAssertEqual(app.staticTexts["spot_name"].label, title)
    XCTAssertTrue(app.buttons["marker-3"].isHittable)
    app.buttons["marker-3"].tap()
    app.buttons["details_button"].tap()
    XCTAssertTrue(app.otherElements["surf_spot_full_details_view"].exists)
  }

  func testShowSurfInfoPage() {
    let app = XCUIApplication()
    app.launch()

    let map = app.otherElements["map_view"]

    XCTAssertTrue(map.waitForExistence(timeout: 1))
    XCTAssertTrue(app.buttons["info_button"].isHittable)
    app.buttons["info_button"].tap()

    XCTAssertTrue(app.scrollViews["article_scroll_view"].waitForExistence(timeout: 1))
    XCTAssertTrue(app.scrollViews["article_scroll_view"].isHittable)
    app.scrollViews["article_scroll_view"].swipeUp()
  }

  func testOpenSafariOnSearchForAirplaneTicket() {
    let app = XCUIApplication()
    app.launch()

    let map = app.otherElements["map_view"]
    XCTAssertTrue(map.isHittable)
    XCTAssertFalse(app.otherElements["surf_spot_full_details_view"].exists)

    map.pinch(withScale: 7, velocity: 1)

    app.buttons["marker-6"].tap()
    app.buttons["details_button"].tap()

    sleep(1)
    XCTAssertFalse(map.isHittable)
    XCTAssertTrue(app.scrollViews["surf_spot_full_details_scroll_view"].isHittable)
    app.scrollViews["surf_spot_full_details_scroll_view"].swipeUp()

    XCTAssertTrue(app.buttons["ticket_button"].isHittable)
    app.buttons["ticket_button"].tap()

    let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    let safariLaunched = safari.wait(for: .runningForeground, timeout: 7)
    let myAppInBackground = app.wait(for: .runningBackground, timeout: 7)

    XCTAssertTrue(safariLaunched, "Safari did not launch")
    XCTAssertTrue(myAppInBackground, "My app did not open link")
  }

}
