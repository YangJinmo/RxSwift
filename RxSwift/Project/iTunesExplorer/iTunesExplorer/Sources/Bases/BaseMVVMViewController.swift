//
//  BaseMVVMViewController.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/20.
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
}
