//
//  RestaurantsListViewController.swift
//  MVVMRxSwiftStudy
//
//  Created by YangJinMo on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

class RestaurantsListViewController: BaseMVVMViewController<RestaurantsListViewModel> {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.tableFooterView = UIView()
    
    // 값을 변경시켜줄 수 있으면 양방향이기 때문에 단방향으로 만들어줘야 한다.
    //viewModel.title.accept("")
    
    viewModel.title
      .asDriver()
      .drive(navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    viewModel.restaurantList
      .asDriver()
      .drive(tableView.rx.items(cellIdentifier: "cell")) { index, viewModel, cell in
        cell.textLabel?.text = viewModel.displayText
      }
      .disposed(by: disposeBag)
  }
}

