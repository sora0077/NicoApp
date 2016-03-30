//
//  RankingListViewController.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/27.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RelayoutKit
import SDWebImage
import SnapKit
import NicoEntity
import TLYShyNavBar

import NicoAPI


extension TableRowRenderer where Self: UITableViewCell {
    
    static func register(tableView: UITableView) {
        tableView.registerNib(
            UINib(nibName: self.identifier, bundle: nil),
            forCellReuseIdentifier: self.identifier
        )
    }
}

protocol RankingVideoRowRenderer: TableRowRenderer {
    
    weak var thumbnailImageView: UIImageView! { get }
    weak var titleLabel: UILabel! { get }
}

class RankingVideoRow<T: UITableViewCell where T: RankingVideoRowRenderer>: TableRow<T> {
    
    let id: String
    
    let video: Video
    
    private let disposeBag = DisposeBag()
    
    init(video: Video) {
        self.id = video.id
        self.video = video
        super.init()
    }
    
    override func componentUpdate() {
        
        renderer?.titleLabel.text = video.title
        if let url = NSURL(string: video.thumbnail_url) {
            renderer?.thumbnailImageView.sd_setImageWithURL(url)
        } else {
            renderer?.thumbnailImageView.image = nil
        }
    }
    
    override func didSelect(indexPath: NSIndexPath) {
        super.didSelect(indexPath)
        
    }
}

func lazy<T>(block: () -> T) -> T {
    return block()
}

class RankingListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let category: GetRanking.Category
    private let period: GetRanking.Period
    
    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView()
    
    init(category: GetRanking.Category, period: GetRanking.Period) {
        self.category = category
        self.period = period
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        
        let category = self.category
        let period = self.period
        refreshControl.rx_controlEvent(.ValueChanged)
            .asDriver()
            .startWith()
            .flatMap {
                domain.repository.ranking
                    .list(category, period: period, target: .Total)
                    .doOnError { error in
                        print(error)
                    }
                    .asDriver(onErrorJustReturn: [])
            }
            .driveNext { [weak self] videos in
                guard let `self` = self else { return }
                
                async_after(0.3) {
                    self.refreshControl.endRefreshing()
                }
                
                self.tableView.flush()
                self.tableView.extend(videos.map {
                    RankingVideoRow<RankingVideoTableViewCell>(video: $0)
                }, atSetcion: 0)
                
            }
            .addDisposableTo(disposeBag)
     
        tableView.rx_itemSelected
            .asDriver()
            .map {
                (self.tableView[indexPath: $0] as! RankingVideoRow<RankingVideoTableViewCell>).video
            }
            .driveNext(videoPlay)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var itemInfo = IndicatorInfo(title: "View")
}

import XLPagerTabStrip

extension RankingListViewController: IndicatorInfoProvider {
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
