//
//  RestaurantsListViewController.swift
//  MVVMRxSwiftStudy
//
//  Created by Jmy on 2021/04/20.
//

import RxCocoa
import RxSwift
import UIKit

class RestaurantsListViewController: BaseMVVMViewController<RestaurantsListViewModel> {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView()

        // 값을 변경시켜줄 수 있으면 양방향이기 때문에 단방향으로 만들어줘야 한다.
        // viewModel.title.accept("")

        viewModel.title
            .asDriver()
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.restaurantList
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cell")) { _, viewModel, cell in
                cell.textLabel?.text = viewModel.displayText
            }
            .disposed(by: disposeBag)
    }
}
