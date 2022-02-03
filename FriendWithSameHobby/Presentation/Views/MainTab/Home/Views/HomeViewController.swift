//
//  HomeViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import NMapsMap

class HomeViewController: UIViewController {

    weak var coordinator: HomeCoordinator?
    
    let mapView = NMFMapView()
    
    init(coordinator: HomeCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
    
    private func viewConfig() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
    }
}
