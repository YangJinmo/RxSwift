//
//  ViewController.swift
//  iTunesExplorer
//
//  Created by YangJinMo on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

class RestaurantsListViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  private var viewModel: RestaurantsListModel!
  
  @IBOutlet weak var tableView: UITableView!
  
  static func instantiate(viewModel: RestaurantsListModel) -> RestaurantsListViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let viewController = storyboard.instantiateInitialViewController() as! RestaurantsListViewController
    viewController.viewModel = viewModel
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    
    navigationItem.title = viewModel.title
    navigationController?.navigationBar.prefersLargeTitles = true
    tableView.contentInsetAdjustmentBehavior = .never
    
    viewModel
      .fetchRestaurantViewModels()
      .observe(on: MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "cell")) { index, viewModel, cell in
        cell.textLabel?.text = viewModel.displayText
      }
      .disposed(by: disposeBag)
  }
}

