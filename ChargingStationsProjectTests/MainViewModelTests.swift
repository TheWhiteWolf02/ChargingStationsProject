import XCTest
import Combine
@testable import ChargingStationsProject

class MockChargingStationsAPI: chargingStationsAPIProtocol {
    var mockResult: Result<[PointOfInterest], Error> = .failure(URLError(.badServerResponse))
    
    func fetchChargingStationsInfo() -> AnyPublisher<[PointOfInterest], Error> {
        return Future<[PointOfInterest], Error> { promise in
            promise(self.mockResult)
        }
        .eraseToAnyPublisher()
    }
}

class MainViewModelTests: XCTestCase {
    private var mainViewModel: MainViewModel?
    private var mockAPI: MockChargingStationsAPI?
    
    private var sampleChargingStation1: PointOfInterest = PointOfInterest(
        dataProvider: DataProvider(
            id: 1,
            title: "sample1"
        ),
        addressInfo: AddressInfo(
            title: "title1",
            addressLine1: "street 1",
            postcode: "01309",
            country: Country(
                title: "Germany"
            ),
            latitude: 10.00,
            longitude: 10.00
        ),
        numberOfPoints: 1
    )
    
    private var sampleChargingStation2: PointOfInterest = PointOfInterest(
        dataProvider: DataProvider(
            id: 2,
            title: "sample2"
        ),
        addressInfo: AddressInfo(
            title: "title2",
            addressLine1: "street 2",
            postcode: "01309",
            country: Country(
                title: "Germany"
            ),
            latitude: 20.00,
            longitude: 20.00
        ),
        numberOfPoints: 2
    )
    
    override func setUpWithError() throws {
        mockAPI = MockChargingStationsAPI()
        mainViewModel = MainViewModel(chargingStationsAPI: mockAPI!)
    }
    
    override func tearDownWithError() throws {
        mainViewModel = nil
        mockAPI = nil
    }
    
    func testFetchChargingStationsInfoSuccess() throws {
        // Define test data
        let testData = [sampleChargingStation1, sampleChargingStation2]
        // Set up mock API response
        mockAPI?.mockResult = .success(testData)
        
        mainViewModel?.fetchChargingStationsInfo()
        XCTAssertEqual(mainViewModel?.pointOfInterests.count, 2)
        XCTAssertEqual(mainViewModel?.pointOfInterests[0], sampleChargingStation1)
        XCTAssertEqual(mainViewModel?.pointOfInterests[1], sampleChargingStation2)
    }
    
    func testFetchChargingStationsInfoFailure() throws {
        // Set up mock API response
        mockAPI?.mockResult = .failure(URLError(.badServerResponse))
        
        mainViewModel?.fetchChargingStationsInfo()
        XCTAssertEqual(mainViewModel?.pointOfInterests.count, 0)
    }
    
    func testCancellables() throws {
        let testData = [sampleChargingStation1]
        // Set up mock API response
        mockAPI?.mockResult = .success(testData)
        mainViewModel?.fetchChargingStationsInfo()
        
        // Assert that the cancellables set is not empty and it store the correct number of elements
        XCTAssertEqual(mainViewModel?.cancellables.count, 2)
        
        mainViewModel = nil
        // Assert that cancellables is also deinitialized along with mainViewModel
        XCTAssertNil(mainViewModel?.cancellables)
    }
}
