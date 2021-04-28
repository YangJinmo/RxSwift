//
//  BaseMVVMViewController.swift
//  iTunesPreviewer
//
//  Created by YangJinMo on 2021/04/28.
//

import UIKit
import RxSwift

class BaseMVVMViewController<VM: BaseViewModel>: UIViewController {
  
  // MARK: - Constants
  
  let disposeBag: DisposeBag = DisposeBag()
  
  // MARK: - Variables And Properties
  
  var viewModel: VM
  
  // MARK: - Initialization
  
  init(viewModel: VM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Controller
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.start()
  }
  
  func popViewController(animated: Bool = true) {
    navigationController?.popViewController(animated: animated)
  }
  
  func pushViewController(_ viewController: UIViewController, animated: Bool = true, hidesBottomBarWhenPushed: Bool = true) {
    navigationController?.pushViewController(
      viewController,
      animated: animated,
      hidesBottomBarWhenPushed: hidesBottomBarWhenPushed
    )
  }
  
  func popToRootViewController(animated: Bool = true) {
    navigationController?.popToRootViewController(animated: animated)
  }
}

extension UINavigationController {
  
  func pushViewController(
    _ viewController: UIViewController,
    animated: Bool = true,
    hidesBottomBarWhenPushed: Bool = true
  ) {
    viewController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    pushViewController(viewController, animated: animated)
  }
}
