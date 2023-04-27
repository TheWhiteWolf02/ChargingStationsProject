import XCTest
@testable import ChargingStationsProject

final class DetailsViewModelTests: XCTestCase {
    private var detailsViewModel: DetailsViewModel?
    
    private var sampleChargingStation: PointOfInterest = PointOfInterest(
        dataProvider: DataProvider(
            id: 1,
            title: "sample1"
        ),
        addressInfo: AddressInfo(
            title: "title1",
            addressLine1: "street 1",
            addressLine2: "street 2",
            town: "Berlin",
            postcode: "01309",
            country: Country(
                title: "Germany"
            ),
            latitude: 10.00,
            longitude: 10.00
        ),
        numberOfPoints: 1
    )
    
    override func setUpWithError() throws {
        detailsViewModel = DetailsViewModel(chargingStation: sampleChargingStation)
    }

    override func tearDownWithError() throws {
        detailsViewModel = nil
    }

    func testGetTitle() throws {
        let targetTitle = "sample1"
        let actualTitle = detailsViewModel?.getTitle()
        XCTAssertEqual(targetTitle, actualTitle)
    }
    
    func testGetNumberOfChargingStations() throws {
        let targetNumberOfChargingStations = 1
        let actualNumberOfChargingStations = detailsViewModel?.getNumberOfChargingStations()
        XCTAssertEqual(targetNumberOfChargingStations, actualNumberOfChargingStations)
    }
    
    func testNumberOfChargingStationsNull() throws {
        sampleChargingStation.numberOfPoints = nil
        detailsViewModel = DetailsViewModel(chargingStation: sampleChargingStation)
        XCTAssertEqual(detailsViewModel?.getNumberOfChargingStations(), 0)
    }
    
    func testGetAddress() throws {
        let targetAddress = "street 1, street 2, 01309, Berlin, Germany"
        let actualAddress = detailsViewModel?.getAddress()
        XCTAssertEqual(targetAddress, actualAddress)
    }
}
