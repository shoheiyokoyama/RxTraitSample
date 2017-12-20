//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let disposeBag = DisposeBag()

func getDataOrError(completionHandler: @escaping ((String?, Error?)) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//        return completionHandler((nil, NSError()))
        return completionHandler(("data fetched!", nil))
    }
}

var singleObservable: Single<String> {
    return Single.create { single in
        getDataOrError { (data, error) in
            if let error = error {
                single(.error(error))
                return
            }
            
            single(.success(data!))
        }
        return Disposables.create()
    }
}

singleObservable
    .subscribe({
        print($0)
    })
    .disposed(by: disposeBag)

// same as `singleObservable`
Observable.just(1).asSingle()
    .subscribe({
        print($0)
    })
    .disposed(by: disposeBag)

enum Result {
    case success
    case error(Error)
}

func excuteWork(completionHandler: @escaping (Result) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//        return completionHandler(.error(NSError()))
        return completionHandler(.success)
    }
}

var completableObservable: Completable {
    return Completable.create { completable in
        excuteWork { result in
            if case let .error(e) = result {
                completable(.error(e))
            }
            completable(.completed)
        }

        return Disposables.create {}
    }
}

completableObservable
    .subscribe({
        print($0)
    })
    .disposed(by: disposeBag)

var maybeObservable: Maybe<String> {
    return Maybe<String>.create { maybe in
        maybe(.success("Maybe"))

        // OR
//        maybe(.completed)

        // OR
//        maybe(.error(error))

        return Disposables.create {}
    }
}

maybeObservable
    .subscribe({
        print($0)
    })
    .disposed(by: disposeBag)

// same as `maybeObservable`
Observable.just(1).asMaybe()
    .subscribe({
        print($0)
    })
    .disposed(by: disposeBag)


