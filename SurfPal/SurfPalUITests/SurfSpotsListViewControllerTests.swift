import XCTest

class SurfSpotsListViewControllerTests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() {
    super.setUp()

    continueAfterFailure = false

    app = XCUIApplication()
  }

  func testSearchWithTableScroll() {
    let title = "Mavericks"
    let app = XCUIApplication()
    app.launch()

    app.buttons["List"].firstMatch.tap()
    sleep(1)
    XCTAssertFalse(app.staticTexts[title].isHittable)
    app.tables["surf_spots_list"].swipeUp()
    app.tables["surf_spots_list"].swipeUp()
    XCTAssertTrue(app.staticTexts[title].isHittable)
    app.staticTexts[title].tap()
    XCTAssertTrue(app.otherElements["surf_spot_full_details_view"].exists)
  }

  func testSearchWithSearchBar() {
    let app = XCUIApplication()
    app.launch()

    app.buttons["List"].firstMatch.tap()
    sleep(1)

    XCTAssertTrue(app.otherElements["🇦🇺 Australia"].isHittable)
    XCTAssertTrue(app.staticTexts["Snapper Rocks"].isHittable)
    XCTAssertFalse(app.otherElements["🇺🇸 United States"].isHittable)
    XCTAssertFalse(app.staticTexts["Jaws"].isHittable)

    let searchBar = app.otherElements["surf_spots_search_bar"]
    searchBar.tap()
    searchBar.typeText("Jaws")

    XCTAssertFalse(app.otherElements["🇦🇺 Australia"].isHittable)
    XCTAssertFalse(app.staticTexts["Snapper Rocks"].isHittable)
    XCTAssertTrue(app.otherElements["🇺🇸 United States"].isHittable)
    XCTAssertTrue(app.staticTexts["Jaws"].isHittable)
    app.staticTexts["Jaws"].tap()
    XCTAssertTrue(app.otherElements["surf_spot_full_details_view"].exists)
  }

  func testSearchWithFavorites() {
    let app = XCUIApplication()
    app.launch()

    app.buttons["List"].firstMatch.tap()
    sleep(1)

    XCTAssertTrue(app.otherElements["🇦🇺 Australia"].isHittable)
    XCTAssertTrue(app.staticTexts["Cactus Beach"].isHittable)
    XCTAssertTrue(app.staticTexts["Noosa"].isHittable)
    setSurfSpotFavorite()

    XCTAssertTrue(app.buttons["surf_spot_list_view_favorite_button"].waitForExistence(timeout: 1))
    app.buttons["surf_spot_list_view_favorite_button"].tap()

    XCTAssertTrue(app.otherElements["🇦🇺 Australia"].isHittable)
    XCTAssertTrue(app.staticTexts["Cactus Beach"].isHittable)
    XCTAssertFalse(app.staticTexts["Noosa"].isHittable)

    app.staticTexts["Cactus Beach"].tap()
    XCTAssertTrue(app.otherElements["surf_spot_full_details_view"].exists)
  }



  func testSearchBarClear() {
    let app = XCUIApplication()
    app.launch()

    app.buttons["List"].firstMatch.tap()
    sleep(1)

    let searchBar = app.otherElements["surf_spots_search_bar"]
    searchBar.tap()
    searchBar.typeText("Jaws")

    XCTAssertFalse(app.otherElements["🇦🇺 Australia"].isHittable)
    XCTAssertFalse(app.staticTexts["Snapper Rocks"].isHittable)
    XCTAssertTrue(app.otherElements["🇺🇸 United States"].isHittable)
    XCTAssertTrue(app.staticTexts["Jaws"].isHittable)

    app.buttons["Clear text"].tap()

    XCTAssertTrue(app.otherElements["🇦🇺 Australia"].isHittable)
    XCTAssertTrue(app.staticTexts["Snapper Rocks"].isHittable)
    XCTAssertFalse(app.otherElements["🇺🇸 United States"].isHittable)
    XCTAssertFalse(app.staticTexts["Jaws"].isHittable)
  }
}

extension SurfSpotsListViewControllerTests {
  func setSurfSpotFavorite() {
    let app = XCUIApplication()
    app.staticTexts["Cactus Beach"].tap()
//    XCTAssertTrue(app.otherElements["surf_spot_full_details_view"].exists)
//    XCTAssertTrue(app.buttons["surf_spot_full_details_view_favorite_button"].exists)
    if !app.buttons["surf_spot_full_details_view_favorite_button"].isSelected {
      app.buttons["surf_spot_full_details_view_favorite_button"].tap()
//      XCTAssertTrue(app.buttons["surf_spot_full_details_view_favorite_button"].isSelected)
    }
    app.buttons["surf_spot_full_details_view_close_button"].tap()
  }
}
