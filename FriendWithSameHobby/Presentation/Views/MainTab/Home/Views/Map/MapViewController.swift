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
import RxCocoa

final class MapViewController: UIViewController {
    typealias OnqueueInput = (UserGender, Double, Double)
    
    private let nmfMapView = NMFMapView()
    private let locationManager = CLLocationManager()
    
    private let genderStackView = MapGenderView().then {
        $0.addshadow(rad: 3, opacity: 0.3)
    }
    private let locationButton = UIButton().then {
        $0.addshadow(rad: 3, opacity: 0.3)
        $0.addCorner(rad: 10, borderColor: nil)
        $0.backgroundColor = .systemBackground
        $0.setImage(AssetsImages.place.image, for: .normal)
    }
    private let userMarker = UIImageView().then {
        $0.frame.size.width = 48
        $0.image = AssetsImages.mapMarker.image
    }
    private let matchingButton = MapMatchingButton(status: .normal)
    private var viewModel: MapViewModel
    private var disposeBag = DisposeBag()
    private var currentCoord: NMGLatLng = NMGLatLng() {
        didSet {            
            let gender = genderStackView.gender
            let lat = currentCoord.lat
            let lng = currentCoord.lng
            inputRelay.accept((gender, lat, lng))
        }
    }
    private var friendsMarkers: [NMFMarker] = [] {
        willSet { friendsMarkers.forEach { $0.mapView = nil } }
        didSet {
            friendsMarkers.forEach {
                $0.width = 80
                $0.height = 80
                $0.mapView = nmfMapView
            }
        }
    }
    
    private let inputRelay = PublishRelay<OnqueueInput>()
    private let locationAuthDenied = PublishRelay<Void>()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        print(UserInfoManager.idToken)
        viewConfig()
        binding()
        locationManagerConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func viewConfig() {
        view.backgroundColor = .white        
        [nmfMapView, genderStackView, locationButton, matchingButton, userMarker]
            .forEach { view.addSubview($0) }
        
        nmfMapView.snp.makeConstraints { make in
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
        nmfMapView.addCameraDelegate(delegate: self)
        checkUserLocationServiceAuthorization()
    }
    
    private func binding() {
        let input = MapViewModel.Input(
            matchingButtonTap: matchingButton.rx.tap.map({ [weak self] in
                let coord = self?.nmfMapView.cameraPosition.target ?? NMGLatLng()
                let matchingStatus = self?.matchingButton.matchingStatus ?? .normal
                return (matchingStatus, coord.lat, coord.lng) }).asDriver(onErrorJustReturn: (.normal, 0.0, 0.0)),
            inputRelay: inputRelay,
            viewWillAppear: self.rx.viewWillAppear.asSignal()            
        )
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.userCoord
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] in
                let markers = $0.map {
                    NMFMarker(position: NMGLatLng(lat: $0.lat, lng: $0.long),
                              iconImage: NMFOverlayImage(image: $0.sesac.imageAsset.image)) }
                self?.friendsMarkers = markers                
            }.disposed(by: disposeBag)
        
        output.isUserMatched
            .asDriver(onErrorJustReturn: ())
            .drive { [weak self] _ in                
                self?.matchingButton.setMatchingStatus()
            }.disposed(by: disposeBag)
        
        // MARK: - Relay Input
        Observable.merge(
            genderStackView.allGenderButton.rx.tap.map { UserGender.unselected },
            genderStackView.maleButton.rx.tap.map { UserGender.male },
            genderStackView.femaleButton.rx.tap.map { UserGender.female })
            .asDriver(onErrorJustReturn: .unselected)
            .drive { [weak self] in
                self?.genderStackView.gender = $0
                self?.projectionCoord()
            }.disposed(by: disposeBag)
        
        locationButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.checkUserLocationServiceAuthorization()
            }.disposed(by: disposeBag)
    }
    
    private func cameraMoving(coord: NMGLatLng) {
        print("camera moving")
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: 15)        
        nmfMapView.moveCamera(cameraUpdate)
    }
    
    private func projectionCoord() {
        currentCoord = self.nmfMapView.cameraPosition.target
    }
    
    private func alertLocationAuth() {
        let alert = BaseAlertView(message: .locationAuth) {
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
            }
        }
        alert.show()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func checkUserLocationServiceAuthorization() {
        let authStatus: CLAuthorizationStatus
        authStatus = locationManager.authorizationStatus

        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authStatus: authStatus)
        }
        else {
            alertLocationAuth()
        }
    }

    func checkCurrentLocationAuthorization(authStatus: CLAuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            print("not determined")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("location manager denied")
            let defaultCoord = NMGLatLng(lat: 37.517819364682694, lng: 126.88647317074734)
            cameraMoving(coord: defaultCoord)
            alertLocationAuth()
        case .authorizedWhenInUse:
            print("authorized when in use")
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
        if let coordinate = locations.last?.coordinate {
            let lat = coordinate.latitude
            let lng = coordinate.longitude
            let nmg = NMGLatLng(lat: lat, lng: lng)
            print("updated location")
            cameraMoving(coord: nmg)
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
        checkUserLocationServiceAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServiceAuthorization()
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        projectionCoord()
    }
}
