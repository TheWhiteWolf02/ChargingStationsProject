import Foundation
import Combine

class MainViewModel {
    @Published var pointOfInterests: [PointOfInterest] = []
    private var chargingStationsAPI: chargingStationsAPIProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init(chargingStationsAPI: chargingStationsAPIProtocol = ChargingStationsAPI()) {
        self.chargingStationsAPI = chargingStationsAPI
    }
    
    func fetchChargingStationsInfo() {
        // get data for the first time
        fetchAndUpdateData()
        // then set up a timer to fire every 30 seconds
        let _ = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchAndUpdateData()
            }
            .store(in: &cancellables)
    }
    
    private func fetchAndUpdateData() {
        chargingStationsAPI.fetchChargingStationsInfo()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("[MainViewModel] fetching charging stations info completed successfully")
                    break
                case .failure(let error):
                    print("Error fetching charging stations info: \(error)")
                }
            }, receiveValue: { [weak self] newData in
                self?.pointOfInterests = newData
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
