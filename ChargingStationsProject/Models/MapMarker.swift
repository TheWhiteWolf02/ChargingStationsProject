import Foundation
import MapKit

class MapMarker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var chargingStation: PointOfInterest
    var title: String?
    var icon: UIImage

    init(coordinate: CLLocationCoordinate2D, chargingStation: PointOfInterest) {
        self.coordinate = coordinate
        self.chargingStation = chargingStation
        self.title = chargingStation.dataProvider.title
        self.icon = UIImage(named: "charging-station")!
        
        super.init()
    }
}
