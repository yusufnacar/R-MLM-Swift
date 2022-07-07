//
//  HomeViewModel.swift
//  R-MLM
//
//  Created by GTMAC15 on 1.07.2022.
//

import Foundation
import RealmSwift
import Network


protocol HomeViewModelProtocol {
//    func fetchShotItems()
    var shotItems : MLMResponse {get}
}


class HomeViewModel : HomeViewModelProtocol{
    private let homeService: IHomeService
    weak var delegate : HomeViewControllerProtocol?
    internal var shotItems: MLMResponse = []
    internal var dbDataItems : Results<MLMResponseElement>?
    var isSuccess : Bool?
    let realm = try! Realm()
    

    init(homeService: IHomeService , delegate : HomeViewControllerProtocol) {
        self.homeService = homeService
        self.delegate = delegate
    }
    
    
    func fetchData() {
        checkToConnection(callback: {(isConnected) -> Void in
            if isConnected {
                self.fetchItemFromAPI()
            } else {
                DispatchQueue.main.async {
                    self.loadDataFromDB()
                }

            }
        })

    }
    
    func fetchItemFromAPI() {
        self.delegate?.changeLoading(value: true)
        homeService.fetchData  { [weak self] (success, model, error) in
            if success, let items = model {
                self?.shotItems = items
                self?.delegate?.getData(data: items)
                self?.delegate?.changeLoading(value: false)
                self?.isSuccess = true
                
                
            } else {
                self?.isSuccess = false
                self?.delegate?.showError(desc:"Data not found!")
                self?.delegate?.changeLoading(value: false)
                print(error!)
            }
            
        }
    }
    
    func addDataToDB() {
        dbDataItems = realm.objects(MLMResponseElement.self)
        if dbDataItems?.count == 0 && isSuccess == true {
            for index in 0...shotItems.count-1 {
                try! realm.write{
                    realm.add(shotItems[index])
                }
            }
        }
        
   
    }
    
    func checkToConnection(callback: @escaping (Bool) -> Void)  {
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
        monitor.pathUpdateHandler = {  (path) in
            if path.status == .satisfied {
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func loadDataFromDB() {
        self.delegate?.changeLoading(value: true)
        dbDataItems = realm.objects(MLMResponseElement.self)
        
        if (dbDataItems?.count ?? 0 > 0) {
            shotItems = Array(dbDataItems!)
            self.delegate?.getData(data: shotItems)
            self.delegate?.changeLoading(value: false)
        } else {
            self.delegate?.showError(desc: "Load Data Failed")
            self.delegate?.changeLoading(value: false)
        }
    }
    
    func updateVideoUrl(videoUrl : URL , selectedPlayerIndex: Int , shotIndex : Int) {
        if let shotData = dbDataItems?[selectedPlayerIndex].shots[shotIndex] {
            try! realm.write{
                shotData.videoUrl = videoUrl.absoluteString
            }
        }
      
    }
    
    func getVideoUrl( selectedPlayerIndex: Int , shotIndex : Int) -> String {
         let shotData = dbDataItems?[selectedPlayerIndex].shots[shotIndex].videoUrl
        return shotData ?? ""
    }
}
