//
//  ViewController+RxExt.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/12.
//

import Foundation

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
