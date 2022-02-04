//
//  HomeViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import NMapsMap
import RxSwift
import CoreLocation
import RxRelay

final class HomeViewController: UIViewController {
    
    private let mapView = NMFMapView()
    private let locationManager = CLLocationManager()
    
    private let genderStackView = HomeGenderView().then {
        $0.addshadow(rad: 3, opacity: 0.3)
    }
    private let locationButton = UIButton().then {
        $0.addshadow(rad: 3, opacity: 0.3)
        $0.addCorner(rad: 10, borderColor: nil)
        $0.backgroundColor = .systemBackground
        $0.setImage(AssetsImages.place.image, for: .normal)
    }
    private let matchingButton = HomeMatchingButton(status: .normal)
    
    private var viewModel: HomeViewModel?
    private var disposeBag = DisposeBag()
    
    private var currentCoord = NMGLatLng(lat: 37.517819364682694, lng: 126.88647317074734) {
        didSet {
            coordRelay.accept(currentCoord)
        }
    }
    
    private lazy var coordRelay = BehaviorRelay<NMGLatLng>(value: currentCoord)
    private let userMarker = UIImageView().then {
        $0.frame.size.width = 48
        $0.image = AssetsImages.mapMarker.image
    }
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        locationManagerConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemGreen
        [mapView, genderStackView, locationButton, matchingButton, userMarker]
            .forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        userMarker.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(userMarker.frame.width)
        }
    }
    
    private func locationManagerConfig() {
        locationManager.delegate = self
        mapView.addCameraDelegate(delegate: self)
        checkUserLocationServiceAuthorization()
    }
    
    private func binding() {
        // requestRelay가 하나 필요할듯
//        let input = HomeViewModel.Input(matchingButtonTap: matchingButton.rx.tap.asDriver())
//        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        // 첫시작 -> 현재 기기 위치
        
        coordRelay
            .asDriver()
            .drive { [weak self] in
                self?.cameraMoving(coord: $0)
            }.disposed(by: disposeBag)
        
        locationButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.checkUserLocationServiceAuthorization()
            }.disposed(by: disposeBag)
    }
    
    private func cameraMoving(coord: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: 18)
        mapView.moveCamera(cameraUpdate)
    }
    
    private func projectionCoord() -> NMGLatLng {
        let center = view.center
        let projection = mapView.projection
        let coord = projection.latlng(from: center)
        return coord
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func checkUserLocationServiceAuthorization() {
        let authStatus: CLAuthorizationStatus
        authStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authStatus: authStatus)
        }
        else {
            print("alert: iOS 위치 서비스를 켜주세요")
        }
    }
    
    func checkCurrentLocationAuthorization(authStatus: CLAuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("location manager denied")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("DEFAULT")
        }
        
        let accuracyState = locationManager.accuracyAuthorization
        
        switch accuracyState {
        case .fullAccuracy:
            print("FULL")
        case .reducedAccuracy:
            print("REDUCE")
        @unknown default:
            print("DEFAULT")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            let lat = coordinate.latitude
            let lng = coordinate.longitude
            currentCoord = NMGLatLng(lat: lat, lng: lng)
            locationManager.stopUpdatingLocation()
        }
        else {
            print("Location CanNot Find")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServiceAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServiceAuthorization()
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        currentCoord = projectionCoord()
    }
}
