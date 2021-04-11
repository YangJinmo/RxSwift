//
//  ViewController.swift
//  MVVMRxSwift
//
//  Created by YangJinMo on 2021/04/08.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  private var viewModel: RestaurantsListModel!
  
  @IBOutlet weak var tableView: UITableView!
  
  static func instantiate(viewModel: RestaurantsListModel) -> ViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let viewController = storyboard.instantiateInitialViewController() as! ViewController
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
    
    /*
    let service = RestaurantService()
    service.fetchRestaurants()
      .subscribe { restaurants in
        print(restaurants)
      }
      .disposed(by: disposeBag)
     */
  }
}
