//
//  BirthViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class BirthViewModel: ViewModelType {
    struct Input {
        // datepicker date
        let date: ControlProperty<Date>
        // button tap
        let tap: Driver<Date>
    }
    
    struct Output {
        // year string
        let yearRelay = PublishRelay<String>()
        // month string
        let monthRelay = PublishRelay<String>()
        // day string
        let dayRelay = PublishRelay<String>()
        
        // button status
        let buttonStatus = BehaviorRelay<BaseButtonStatus>(value: .disable)
        //
    }
    
    var useCase: VerifyUseCase? = nil
    weak var coordinator: AuthCoordinator?
    
    var dateRelay = BehaviorRelay<Date>(value: Date())
    
    init(coordinator: AuthCoordinator) {        
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let components = input.date
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        
        components
            .map { String($0.year ?? 0) }
            .bind(to: output.yearRelay)
            .disposed(by: disposeBag)
        
        components
            .map { String($0.month ?? 0) }
            .bind(to: output.monthRelay)
            .disposed(by: disposeBag)
        
        components
            .map { String($0.day ?? 0) }
            .bind(to: output.dayRelay)
            .disposed(by: disposeBag)
        
        // validation
        input.date
            .map { (date) -> BaseButtonStatus in
                let minDate = Calendar.current.date(byAdding: .year, value: -17, to: Date()) ?? Date()                
                return date >= minDate ? .disable : .fill
            }.bind(to: output.buttonStatus)
            .disposed(by: disposeBag)
        
        // tap to coordinator & data save
        
        input.date
            .bind(to: dateRelay)
            .disposed(by: disposeBag)
        
        input.tap
            .asDriver()
            .drive { [weak self] in
                switch output.buttonStatus.value {
                case .fill:                    
                    UserDefaultsManager.birth = $0.toString
                    self?.coordinator?.pushEmailVC()
                default:
                    print("toast under 17")
                }
            }.disposed(by: disposeBag)
        return output
    }
}
