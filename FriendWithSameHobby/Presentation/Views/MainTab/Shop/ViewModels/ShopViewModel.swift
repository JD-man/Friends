//
//  ShopViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class ShopViewModel: ViewModelType {
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Signal<Void>
        let faceShopButtonTap: Signal<Void>
        let bgShopButtonTap: Signal<Void>        
        let faceSelected: ControlEvent<FaceShopItemViewModel>
        let bgSelected: ControlEvent<BackgroundShopItemViewModel>
        let saveButtonTap: Signal<Void>
    }
    
    struct Output {
        // true : face shop, false: bg shop
        let shopHidden = PublishRelay<Bool>()
        let faceProduct = BehaviorRelay<[FaceShopItemViewModel]>(value: [])
        let backgroundProduct = BehaviorRelay<[BackgroundShopItemViewModel]>(value: [])
        let currentFace = BehaviorRelay<SeSACFace>(value: .basic)
        let currentBackground = BehaviorRelay<SeSACBackground>(value: .basic)
    }
    
    var useCase: ShopUseCase
    weak var coordinator: ShopCoordinator?
    
    init(useCase: ShopUseCase, coordinator: ShopCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input to usecase        
        input.viewWillAppear
            .emit { [weak self] _ in                
                self?.useCase.executeGetShopInfo()
            }.disposed(by: disposeBag)
        
        // input to output
        
        Observable.merge(
            input.faceShopButtonTap.map { _ in true }.asObservable(),
            input.bgShopButtonTap.map { _ in false }.asObservable())
            .bind(to: output.shopHidden)
            .disposed(by: disposeBag)
        
        input.faceSelected
            .map { $0.faceImage }
            .bind(to: output.currentFace)
            .disposed(by: disposeBag)
        
        input.bgSelected
            .map { $0.backgroundImage }
            .bind(to: output.currentBackground)
            .disposed(by: disposeBag)
        
        input.saveButtonTap
            .map { (output.currentFace.value, output.currentBackground.value) }
            .distinctUntilChanged { $0 == $1 }
            .asSignal()
            .emit { [weak self] _ in                
                print("save button tap")
                self?.useCase.executeSaveImageProfile(sesac: output.currentFace.value,
                                                      bg: output.currentBackground.value)
            }.disposed(by: disposeBag)
        
        // Usecase to output
        useCase.shopInfoSuccess
            .map { FaceShopItemViewModel.products(sesacCollection: $0.sesacCollection) }
            .bind(to: output.faceProduct)
            .disposed(by: disposeBag)
        
        useCase.shopInfoSuccess
            .map { BackgroundShopItemViewModel.products(bgCollection: $0.backgroundCollection) }
            .bind(to: output.backgroundProduct)
            .disposed(by: disposeBag)
        
        useCase.shopInfoSuccess
            .map { $0.sesac }
            .bind(to: output.currentFace)
            .disposed(by: disposeBag)
        
        useCase.shopInfoSuccess
            .map { $0.background }
            .bind(to: output.currentBackground)
            .disposed(by: disposeBag)
        
        useCase.updateImageSuccess
            .asSignal()
            .emit { [weak self] _ in
                self?.coordinator?.toasting(message: "이미지가 변경됐습니다.")
            }.disposed(by: disposeBag)
        
        useCase.updateImageFail
            .asSignal()
            .emit { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        return output
    }
}
