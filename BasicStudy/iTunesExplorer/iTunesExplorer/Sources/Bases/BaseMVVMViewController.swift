//
//  BaseMVVMViewController.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/20.
//

import RxSwift
import UIKit

class BaseMVVMViewController<VM: BaseViewModel>: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: VM

    // MARK: - Initialization

    init(viewModel: VM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.start()
    }
}
