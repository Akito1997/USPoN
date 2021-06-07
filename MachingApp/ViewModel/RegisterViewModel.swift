//
//  RegisterViewModel.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/11.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel{
    let disposeBag=DisposeBag()
    
    //MARK:observable
    var nameTextOutput=PublishSubject<String>()
    var emailTextOutput=PublishSubject<String>()
    var passwordTextOutput=PublishSubject<String>()
    var validRegisterSubject=BehaviorSubject<Bool>(value: false)
    
    var nameTextInput:AnyObserver<String>{
        nameTextOutput.asObserver()
    }
    var emailTextInput:AnyObserver<String>{
        emailTextOutput.asObserver()
    }
    var passwordTextInput:AnyObserver<String>{
        passwordTextOutput.asObserver()
    }
    
    var validRegisterDriver: Driver<Bool> = Driver.never()

    init(){
        
        validRegisterDriver=validRegisterSubject
            .asDriver(onErrorDriveWith: Driver.never())
        
        let nameValid=nameTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 1
            }
        let  emailValid=emailTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 3 && (text.contains("@ec.usp.ac.jp") || text.contains("@st.shiga-u.ac.jp"))
            }
        let passwordValid=passwordTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 3
            }
        Observable.combineLatest(nameValid, emailValid, passwordValid){$0 && $1 && $2}
            .subscribe{ validAll in
                self.validRegisterSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
    }
}
