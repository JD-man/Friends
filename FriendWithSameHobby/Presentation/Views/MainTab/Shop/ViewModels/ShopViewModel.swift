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
        let faceShopButtonTap: Signal<Void>
        let bgShopButtonTap: Signal<Void>
    }
    
    struct Output {
        // true : face shop, false: bg shop
        let shopHidden = PublishRelay<Bool>()        
    }
    
    var useCase: ShopUseCase
    weak var coordinator: ShopCoordinator?
    
    init(useCase: ShopUseCase, coordinator: ShopCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.merge(
            input.faceShopButtonTap.map { _ in true }.asObservable(),
            input.bgShopButtonTap.map { _ in false }.asObservable())
            .bind(to: output.shopHidden)
            .disposed(by: disposeBag)
        
        return output
    }
}
