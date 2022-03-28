//
//  ViewModelType.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype UseCase: UseCaseType
    associatedtype Coordinator: CoordinatorType
    
    var useCase: UseCase { get set }
    var coordinator: Coordinator? { get set }    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output    
}
