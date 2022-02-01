//
//  VerifyViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class VerifyViewModel: ViewModelType {
    init(useCase: VerifyUseCase?, coordinator: AuthCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct Input {
        // verifyButton tap
        let verifyButtonTap: Driver<(BaseButtonStatus, String)>
        // retryButton tap
        let retryButtonTap: ControlEvent<Void>
        // verifyTextField text
        let verifyTextFieldText: ControlProperty<String>        
    }
    
    struct Output {
        // textField status
        let textFieldStatus = PublishRelay<BaseTextFieldStatus>()
        // verifyButton status
        let verifyButtonStatus = PublishRelay<BaseButtonStatus>()        
        // edit begin empty string
        let emptyStringRelay = PublishRelay<String>()
        // timer text
        let timerTextRelay = PublishRelay<String>()
    }
    
    var useCase: VerifyUseCase?
    weak var coordinator: AuthCoordinator?
    private var disposeBag = DisposeBag()
    
    var remain: Int = 60
    var timer: Disposable?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        // timer
        startTimer(time: output.timerTextRelay, status: output.verifyButtonStatus)
        
        // Input to UseCase
        input.verifyButtonTap
            .drive { [weak self] in
                let buttonStatus = $0.0
                let code = $0.1
                if self?.remain == 0 {
                    self?.coordinator?.toasting(message: "입력시간이 초과됐습니다.")
                } else if buttonStatus == .disable {
                    self?.coordinator?.toasting(message: "전화 번호 인증 실패")
                } else {
                    BaseActivityIndicator.shared.show()
                    self?.timer?.dispose()
                    self?.useCase?.excuteAuthNumber(code: code)
                }
            }.disposed(by: disposeBag)
        
        input.retryButtonTap
            .asDriver()
            .drive { [weak self] _ in
                BaseActivityIndicator.shared.show()
                self?.timer?.dispose()
                self?.useCase?.requestRegisterCode()
            }.disposed(by: disposeBag)
        
        // Input to Output
        input.verifyTextFieldText
            .map(validation)
            .bind(to: output.verifyButtonStatus)
            .disposed(by: disposeBag)
        
        // UseCase to Coordinator
        useCase?.authSuccessRelay
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                BaseActivityIndicator.shared.hide()
                if $0 { self?.coordinator?.finish(to: .mainTab, completion: nil) }
            }.disposed(by: disposeBag)
        
        useCase?.authErrorRelay
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] error in                
                BaseActivityIndicator.shared.hide()
                switch error {
                case .unregistered:
                    self?.timer?.dispose()
                    self?.coordinator?.pushNicknameVC()
                default:
                    self?.coordinator?.toasting(message: error.description)                    
                }                
            }.disposed(by: disposeBag)
        
        useCase?.retrySuccessRelay
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                self?.remain = 60
                BaseActivityIndicator.shared.hide()
                self?.startTimer(time: output.timerTextRelay, status: output.verifyButtonStatus)
            }.disposed(by: disposeBag)
        
        return output
    }
    
    // MARK: - Timer
    private func startTimer(time: PublishRelay<String>, status: PublishRelay<BaseButtonStatus>) {
        timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                let remain = self?.remain ?? 0
                let min = remain / 60
                let sec = remain % 60
                time.accept(String(format: "%02d:%02d", min, sec))
                if remain == 0 {
                    self?.timer?.dispose()
                    status.accept(.disable)
                }
                else {
                    self?.remain -= 1
                }
            } onDisposed: {
                print("disposed")
            }
        timer?.disposed(by: disposeBag)
    }
    
    // MARK: - Validation
    func validation(text: String) -> BaseButtonStatus {
        if remain > 0 {
            let registerNumberRegex = "^([0-9]{6})$"
            let registerNumberPred = NSPredicate(format: "SELF MATCHES %@", registerNumberRegex)
            
            guard registerNumberPred.evaluate(with: text) else { return .disable }
            return .fill
        }
        else {
            return .disable
        }
    }
}
