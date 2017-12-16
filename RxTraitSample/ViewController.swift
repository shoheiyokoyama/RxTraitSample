//
//  ViewController.swift
//  RxTraitSample
//
//  Created by shoheiyokoyama on 2017/12/16.
//  Copyright © 2017年 shoheiyokoyama. All rights reserved.
//

import UIKit
import RxSwift

let disposeBag = DisposeBag()
enum Result<V> {
    case success(V)
    case error(Error)
}

let url = URL(string: "http://lorempixel.com/400/200/")!

var singleObservable: Single<Result<UIImage>> {
    return Single.create { single in
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                single(.error(error))
                single(.success(Result.success(UIImage())))
                return
            }
            
            guard let data = data,
                let image = UIImage(data: data) else {
                    single(.success(Result.error(NSError())))
                    return
            }
            single(.success(Result.error(NSError(domain: "test", code: 2, userInfo: [:]))))
            single(.success(Result.success(image)))
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        singleObservable
            .debug("", trimOutput: false)
            .subscribe({
                    print("o!!!!!!!!!!!!!!!!!!!!!!: \($0)")
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

