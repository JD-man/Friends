//
//  RequestInterceptor.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/03/27.
//

import Foundation
import Alamofire

// 401 에러 대응을 위한 Interceptor
final class TokenRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("Token Interceptor Adapt")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // 401 에러가 아니라면 retry없이 에러를 보냄
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            print("Token Interceptor not retry")
            return completion(.doNotRetryWithError(error))
        }
        
        // update ID token
        FirebaseAuthRepository(phoneID: nil).refreshingIDtoken { result in
            switch result {
            case .success(let idToken):
                // ID token 갱신 후에 1초 뒤 retry
                UserInfoManager.idToken = idToken                
                print("Token Interceptor 401 retry")
                completion(.retryWithDelay(1.0))
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
