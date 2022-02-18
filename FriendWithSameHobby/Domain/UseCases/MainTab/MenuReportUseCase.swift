//
//  MenuReportUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/18.
//

import Foundation
import RxRelay

final class MenuReportUseCase: UseCaseType {
    private let firebaseRepo: FirebaseAuthRepositoryInterface
    private let userRepo: UserRepositoryInterface
    
    let reportSuccess = PublishRelay<Bool>()
    let reportFailure = PublishRelay<ReportUserError>()
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        userRepo: UserRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.userRepo = userRepo
    }
    
    func executeReportUser(reported: [BaseButtonStatus], comment: String) {
        let otheruid = UserChatManager.otherUID ?? ""
        let model = ReportUserModel(otheruid: otheruid, reportedReputation: reported, comment: comment)
        userRepo.reportUser(model: model) { [weak self] result in
            switch result {
            case .success(let isReported):
                self?.reportSuccess.accept(isReported)
            case .failure(let error):
                self?.reportFailure.accept(error)
            }
        }
    }
}
