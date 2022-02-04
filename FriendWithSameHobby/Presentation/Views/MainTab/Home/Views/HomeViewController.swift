//
//  HomeViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import NMapsMap

final class HomeViewController: UIViewController {

    weak var coordinator: HomeCoordinator?
    
    //private let mapView = NMFMapView()
    private let genderStackView = HomeGenderView().then {
        $0.addshadow(rad: 2.5)
    }
    
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
//        [mapView, genderStackView]
//            .forEach { view.addSubview($0) }
        
//        mapView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        genderStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(52)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(48 * 3)
            make.width.equalTo(48)
        }
    }
}
