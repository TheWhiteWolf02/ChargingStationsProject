import Foundation

class DetailsViewModel {
    private let chargingStation: PointOfInterest
    
    init(chargingStation: PointOfInterest) {
        self.chargingStation = chargingStation
    }
    
    func getTitle() -> String {
        return chargingStation.dataProvider.title
    }
    
    func getNumberOfChargingStations() -> Int {
        return chargingStation.numberOfPoints ?? 0
    }
    
    func getAddress() -> String {
        var fullAddress: String = chargingStation.addressInfo.addressLine1 + ", "
        if let addressLine2 = chargingStation.addressInfo.addressLine2 {
            fullAddress += addressLine2 + ", "
        }
        fullAddress += "\(chargingStation.addressInfo.postcode), "
        if let town = chargingStation.addressInfo.town {
            fullAddress += town + ", "
        }
        fullAddress += chargingStation.addressInfo.country.title
        return fullAddress
    }
}
