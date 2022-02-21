//
//  ProfileViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class ProfileViewModel: ViewModelType {
    typealias UserMyPageData = (UserGender, String, Bool, Int, Int)
    struct Input {
        // viewWillAppear
        let viewWillAppear: Driver<Void>
        // withdraw button tap
        let withdrawTap: Driver<Void>
        // update button tap
        let updateButtonTap: Driver<UserMyPageData>
        // comment button tap
        let commentButtonTap: Signal<Void>
    }
    
    struct Output {
        let gender = PublishRelay<UserGender>()
        let hobby = PublishRelay<String>()
        let searchable = PublishRelay<Bool>()
        let minAgeIndex = PublishRelay<Int>()
        let maxAgeIndex = PublishRelay<Int>()
        let ageRange = PublishRelay<String>()
        let profileItem = BehaviorRelay<[ProfileItemViewModel]>(value: [])
    }
    
    var useCase: ProfileUseCase
    weak var coordinator: AccountCoordinator?
    private var disposeBag = DisposeBag()
    
    init(useCase: ProfileUseCase, coordinator: AccountCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input to usecase
        input.withdrawTap
            .drive { [weak self] _ in
                let alert = BaseAlertView(message: .withdraw) { self?.useCase.executeWithdraw() }
                alert.show()
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .drive { [weak self] _ in
                print("viewwillappear")
                self?.useCase.executeFetchUserInfo()
            }.disposed(by: disposeBag)
        
        input.updateButtonTap
            .drive { [weak self] in
                BaseActivityIndicator.shared.show()
                self?.useCase.excuteUpdateUserInfo(gender: $0.0,
                                                    hobby: $0.1,
                                                    searchable: $0.2,
                                                    ageMin: $0.3 + 18,
                                                    ageMax: $0.4 + 18)
            }.disposed(by: disposeBag)
        
        // input to coordinator
        input.commentButtonTap
            .emit { [weak self] _ in
                self?.coordinator?.pushCommentVC(review: output.profileItem.value[0].comment)                
            }.disposed(by: disposeBag)
        
        // usecase to coordinator
        useCase.withdrawSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                guard let mainTabCoordinator = self?.coordinator?.parentCoordinator as? MainTabCoordinator else { return }
                mainTabCoordinator.finish(to: .auth, completion: nil)
            }.disposed(by: disposeBag)
        
        useCase.withdrawFail
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        useCase.getUserInfoFail
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        useCase.updateSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                BaseActivityIndicator.shared.hide()
                self?.coordinator?.pop(completion: {
                    self?.coordinator?.toasting(message: "회원정보가 변경됐습니다.")
                })
            }.disposed(by: disposeBag)
        
        useCase.updateFail
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        // Usecase to Output
        let profileFooter = useCase.userInfoData.map {
            ProfileFooterViewModel(model: $0)
        }
        
        let profileItem = useCase.userInfoData.map {
            [ProfileItemViewModel(model: $0)]
        }
        
        profileItem
            .bind(to: output.profileItem)
            .disposed(by: disposeBag)
        
        profileFooter
            .map { $0.gender }
            .bind(to: output.gender)
            .disposed(by: disposeBag)
        
        profileFooter
            .map { $0.hobby }
            .bind(to: output.hobby)
            .disposed(by: disposeBag)
        
        profileFooter
            .map { $0.searchable }
            .bind(to: output.searchable)
            .disposed(by: disposeBag)
        
        profileFooter
            .map { $0.minAge - 18 }
            .bind(to: output.minAgeIndex)
            .disposed(by: disposeBag)
        
        profileFooter
            .map { $0.maxAge - 18 }
            .bind(to: output.maxAgeIndex)
            .disposed(by: disposeBag)
        
        profileFooter
            .map { "\($0.minAge)-\($0.maxAge)" }
            .bind(to: output.ageRange)
            .disposed(by: disposeBag)
        
        return output
    }
}
