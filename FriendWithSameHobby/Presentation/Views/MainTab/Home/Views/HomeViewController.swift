//
//  HomeViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import NMapsMap
import RxSwift

final class HomeViewController: UIViewController {
    
    private let mapView = NMFMapView()
    private let genderStackView = HomeGenderView().then {
        $0.addshadow(rad: 2)
    }
    
    private let locationButton = UIButton().then {
        $0.addshadow(rad: 2)
        $0.addCorner(rad: 10, borderColor: nil)
        $0.backgroundColor = .systemBackground
        $0.setImage(AssetsImages.place.image, for: .normal)
    }
    
    private let matchingButton = HomeMatchingButton(status: .normal)
    private var viewModel: HomeViewModel?
    private var disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        viewConfig()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
    
    private func viewConfig() {
        [mapView, genderStackView, locationButton, matchingButton]
            .forEach { view.addSubview($0) }
        
//        mapView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        genderStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(52)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(48 * 3)
            make.width.equalTo(48)
        }
        
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.leading.equalTo(genderStackView.snp.leading)
            make.top.equalTo(genderStackView.snp.bottom).offset(16)
        }
        
        matchingButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(matchingButton.frame.width)
        }
    }
    
    private func binding() {
        let input = HomeViewModel.Input(matchingButtonTap: matchingButton.rx.tap.asDriver())
        let output = viewModel?.transform(input, disposeBag: disposeBag)
    }
}
