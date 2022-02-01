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
    init(useCase: EmptyUseCase?, coordinator: AuthCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct Input {
        // datepicker date
        let date: ControlProperty<Date>
        // button tap
        let tap: Driver<(BaseButtonStatus, Date)>
    }
    
    struct Output {
        // year string
        let yearRelay = BehaviorRelay<String>(value: "")
        // month string
        let monthRelay = BehaviorRelay<String>(value: "")
        // day string
        let dayRelay = BehaviorRelay<String>(value: "")        
        // button status
        let buttonStatus = BehaviorRelay<BaseButtonStatus>(value: .disable)        
    }
    
    var useCase: EmptyUseCase? = nil
    weak var coordinator: AuthCoordinator?
    
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
        
        input.tap
            .asDriver()
            .drive { [weak self] in
                let buttonStatus = $0.0
                let date = $0.1
                switch buttonStatus {
                case .fill:
                    UserInfoManager.birth = date
                    self?.coordinator?.pushEmailVC()
                default:
                    self?.coordinator?.toasting(message: "새싹친구는 만 17세 이상만 사용할 수 있습니다.")
                }
            }.disposed(by: disposeBag)
        return output
    }
}
