//
//  MainCoordinator.swift
//  R-MLM
//
//  Created by GTMAC15 on 2.07.2022.
//


import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    

    
    
    func navigateToWatermarkVideo(data: Shot , url : URL) {
        let vc = WatermarkViewController.instantiate()
        vc.shot = data
        
        vc.videoUrl = url
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

