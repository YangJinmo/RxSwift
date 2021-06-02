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
  
  /*
   declare our view model
   there's a number of ways of doing this
   
   however we know that this view controller needs this RestaurantsListModel
   essentially to operate so we're going to force unwrap it
   
   because it can't work without this view model
   and if we force unwrap it, it means every time we use it.
   
   it needs to have a value otherwise the album crash
   */
  private var viewModel: RestaurantsListModel!
  
  @IBOutlet weak var tableView: UITableView!
  
  // so the perfect place to do this just to pass it into our instantiate method here
  static func instantiate(viewModel: RestaurantsListModel) -> ViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let viewController = storyboard.instantiateInitialViewController() as! ViewController
    viewController.viewModel = viewModel // just pass it in there we can set it on the view controller
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    
    navigationItem.title = viewModel.title
    navigationController?.navigationBar.prefersLargeTitles = true
    tableView.contentInsetAdjustmentBehavior = .never
    
    /*
     and that means when our view loads we can actually subscribe to our fetch restaurant view model
     but before we can subscribe to this function we need finish it off in the view model
     so come back to your restaurants list view model
     */
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
