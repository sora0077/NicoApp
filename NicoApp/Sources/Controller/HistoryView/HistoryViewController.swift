//
//  HistoryViewController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/03.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RelayoutKit


class HistoryViewController: UIViewController {
    
    private let tableView = UITableView()

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let superview = view
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(superview)
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            make.bottom.equalTo(superview)
        }
        tableView.controller(self)
        tableView.rowHeight = 108
        
        
        domain.repository.history.list().subscribe(
            onNext: { [weak self] histories in
                guard let `self` = self else { return }
                
                self.tableView.removeAll()
                self.tableView.extend(histories.map {
                    RankingVideoRow<RankingVideoTableViewCell>(video: $0.video)
                }, atSetcion: 0)
            }
        ).addDisposableTo(disposeBag)
    }
    
}
