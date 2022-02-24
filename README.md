# Friends - Service Level Project

# Overview

- 지도, 위치 기반 취미 공유 친구찾기 앱
- 전화번호 인증, 회원가입
- 지도를 통한 주변 유저 탐색
- 유저 매칭 및 채팅
- 매칭취소, 유저신고, 리뷰
- 인앱결제
- 프로필 수정, 회원탈퇴

---

# Architecture
## iOS-Clean-Architecture

<div align = "center">        
    <img src = "./ProjectInformation/architecture.png">
</div>

- Presentation Layer = View, ViewModel, Coordinator
- Domain Layer = UseCase, Entities, Repository Interface
- Data Layer = Repository(Network API, DB..), DTO + Mapping

## MVVM Input/Output
```swift
final class ChatViewModel: ViewModelType {
    struct Input {
        let backButtonTap: Driver<Void>
        let moreButtonTap: Driver<Void>        
        let viewWillAppear: Driver<Void>
        let sendButtonTap: Driver<String>
        let messageText: ControlProperty<String>
    }
    
    struct Output {        
        let chatMessages = BehaviorRelay<[ChatItemViewModel]>(value: [])        
        let messageTextViewScrollEnabled = PublishRelay<Bool>()        
        let initializeTextView = PublishRelay<String>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()        
        input.viewWillAppear
            .drive { [weak self] _ in
                self?.useCase.executeSocketConnect()
            }.disposed(by: disposeBag)
        
        input.sendButtonTap
            .drive { [weak self] in                
                self?.useCase.executeSendMessage(chat: $0)
            }.disposed(by: disposeBag)

        // ...
        return output
    }
```

## Coordinator

<div align = "center">        
    <img src = "./ProjectInformation/coordinator.png">
</div>

---

# Framework, Library

- UIKit
- Autolayout, SnapKit, Code-Based UI
- RxSwift, RxCocoa, RxRelay
- RxDatasources, RxKeyboard, RxGesture
- Firebase Auth, Firebase Cloud Message
- Moya, SocketIO
- Realm

---

# Issues

---