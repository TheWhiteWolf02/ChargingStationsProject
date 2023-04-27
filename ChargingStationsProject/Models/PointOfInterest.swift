import Foundation

struct DataProvider: Codable, Equatable {
    var id: Int // unique id
    var title: String // name of charging station
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
    }
}

struct Country: Codable, Equatable {
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
}

struct AddressInfo: Codable, Equatable {
    var title: String
    var addressLine1: String
    var addressLine2: String?
    var town: String?
    var postcode: String
    var country: Country
    
    // location on map info
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case town = "Town"
        case postcode = "Postcode"
        case country = "Country"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}

struct PointOfInterest: Codable, Equatable {
    var dataProvider: DataProvider
    var addressInfo: AddressInfo
    var numberOfPoints: Int?
    
    enum CodingKeys: String, CodingKey {
        case dataProvider = "DataProvider"
        case addressInfo = "AddressInfo"
        case numberOfPoints = "NumberOfPoints"
    }
    
    static func == (lhs: PointOfInterest, rhs: PointOfInterest) -> Bool {
        return lhs.dataProvider == rhs.dataProvider && lhs.addressInfo == rhs.addressInfo && lhs.numberOfPoints == rhs.numberOfPoints
    }
}
