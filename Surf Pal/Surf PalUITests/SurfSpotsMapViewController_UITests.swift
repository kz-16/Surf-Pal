import XCTest
@testable import Surf_Pal

class SurfSpotsMapViewControllerTests: XCTestCase {

  var viewController: SurfSpotsMapViewController!

  override func setUpWithError() throws {
    try super.setUpWithError()
    let viewModel = SurfSpotsMapViewModel()
    viewController = SurfSpotsMapViewController(viewModel: viewModel)
    UIApplication.shared.windows.first?.rootViewController = viewController
    XCTAssertNotNil(viewController.view)
  }

  override func tearDownWithError() throws {
    viewController = nil
    try super.tearDownWithError()
  }

  func testMapViewExists() throws {
    XCTAssertNotNil(viewController.mapView)
  }

  func testBackButtonExists() throws {
    XCTAssertNotNil(viewController.backButton)
  }

  func testNextButtonExists() throws {
    XCTAssertNotNil(viewController.nextButton)
  }

  func testTitleLabelExists() throws {
    XCTAssertNotNil(viewController.titleLabel)
  }

  func testModePickerExists() throws {
    XCTAssertNotNil(viewController.modePicker)
  }

  func testMapSegment() throws {
    let mapIndex = 0
    viewController.modePicker.selectedSegmentIndex = mapIndex
    viewController.setMapSegment()
    XCTAssertEqual(viewController.mapView.isHidden, false)
  }

  func testListSegment() throws {
    let listIndex = 1
    viewController.modePicker.selectedSegmentIndex = listIndex
    viewController.setListSegment()
    XCTAssertEqual(viewController.mapView.isHidden, true)
  }

  func testTitleLabelText() throws {
    let title = "West Coast"
    XCTAssertEqual(viewController.titleLabel.text, title)
  }
}
