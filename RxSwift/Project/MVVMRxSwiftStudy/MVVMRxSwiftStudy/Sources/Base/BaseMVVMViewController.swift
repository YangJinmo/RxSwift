//
//  BaseMVVMViewController.swift
//  MVVMRxSwiftStudy
//
//  Created by Jmy on 2021/04/20.
//

import UIKit
import RxSwift

class BaseMVVMViewController<VM: BaseViewModel>: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  var viewModel: VM!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.start()
  }
}
