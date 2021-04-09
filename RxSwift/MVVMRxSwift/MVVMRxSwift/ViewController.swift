//
//  ViewController.swift
//  MVVMRxSwift
//
//  Created by YangJinMo on 2021/04/08.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  static func instantiate() -> ViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let viewController = storyboard.instantiateInitialViewController() as! ViewController
    return viewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let service = RestaurantService()
    service.fetchRestaurants()
      .subscribe { restaurants in
        print(restaurants)
      }
      .disposed(by: disposeBag)
  }
}
