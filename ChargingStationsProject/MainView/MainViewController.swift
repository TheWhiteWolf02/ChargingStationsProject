import UIKit
import MapKit
import Combine

class MainViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    
    private let mainViewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        mainViewModel.fetchChargingStationsInfo()
        mainViewModel.$pointOfInterests
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pointOfInterests in
                self?.updateMap(chargingStations: pointOfInterests)
            }
            .store(in: &cancellables)
    }
    
    private func setupMap() {
        mapView.delegate = self
        let centerCoordinate = CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415)
        let regionRadius: CLLocationDistance = 5000 // 5km
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                
        mapView.setRegion(region, animated: true)
    }
    
    private func goToDetailsView(pointOfInterest: PointOfInterest) {
        let detailsViewModel: DetailsViewModel = DetailsViewModel(chargingStation: pointOfInterest)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailsViewController", creator: { coder in
            DetailsViewController(coder: coder, detailsViewModel: detailsViewModel)
        })
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func updateMap(chargingStations: [PointOfInterest]) {
        // at first remove old ones
        mapView.removeAnnotations(mapView.annotations)
        
        chargingStations.forEach { point in
            let marker = MapMarker(
                coordinate: CLLocationCoordinate2D(
                    latitude: point.addressInfo.latitude,
                    longitude: point.addressInfo.longitude
                ),
                chargingStation: point
            )
            mapView.addAnnotation(marker)
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let marker = view.annotation as? MapMarker {
            goToDetailsView(pointOfInterest: marker.chargingStation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapMarker else {
            return nil
        }
        let identifier = "MapMarker"
        var view: MKAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        view.image = annotation.icon
        return view
    }
}
