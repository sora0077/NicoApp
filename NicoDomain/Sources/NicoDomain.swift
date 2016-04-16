//
//  NicoDomain.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/22.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoRepository
import RxSwift
import RxCocoa


public enum RequestState {
    case None
    case Requesting
    case Error
}

protocol GlobalStateType {
    
}


protocol RequestListStateType: class {
    
    associatedtype Item
    
    var disposeBag: DisposeBag { get }
    
    var requestState: PublishSubject<RequestState> { get }
    
    var items: PublishSubject<[Item]> { get }
    
    var noDataViewHidden: Variable<Bool> { get }
    var indicatorViewHidden: Variable<Bool> { get }
    var retryViewHidden: Variable<Bool> { get }
    
    
    func stream() -> Observable<[Item]>
}

extension RequestListStateType {
    
    func binding() {

        let combine = Observable
            .combineLatest(requestState, items) { ($0, $1) }
            .shareReplay(1)
        
        combine
            .map { $0.0 != .Requesting }
            .bindTo(indicatorViewHidden)
            .addDisposableTo(disposeBag)

        combine
            .map { $0 != .Error && !$1.isEmpty }
            .bindTo(retryViewHidden)
            .addDisposableTo(disposeBag)
        
        combine
            .map { $0 != .None && !$1.isEmpty }
            .bindTo(noDataViewHidden)
            .addDisposableTo(disposeBag)
        
    }
}

public class RequestViewModel<Item>: RequestListStateType {
    
    let disposeBag = DisposeBag()
    
    public let requestState = PublishSubject<RequestState>()
    
    public let items = PublishSubject<[Item]>()
    
    public let noDataViewHidden = Variable<Bool>(true)
    public let indicatorViewHidden = Variable<Bool>(true)
    public let retryViewHidden = Variable<Bool>(true)
    
    init() {
        binding()
    }
    
    func stream() -> Observable<[Item]> {
        fatalError()
    }
    
    public var request: AnyObserver<Bool> {
        return UIBindingObserver(UIElement: self) { viewmodel, value in
            if value {
                viewmodel.requestState.onNext(.Requesting)
                viewmodel.stream()
                    .subscribe(
                        onNext: { [weak viewmodel = viewmodel] in
                            viewmodel?.requestState.onNext(.None)
                            viewmodel?.items.onNext($0)
                        },
                        onError: { [weak viewmodel = viewmodel] _ in
                            viewmodel?.requestState.onNext(.Error)
                        }
                    )
                    .addDisposableTo(viewmodel.disposeBag)
            }
        }.asObserver()
    }
}

public func delayIfViewHidden(hidden: Bool) -> Driver<Bool> {
    return delayIfViewHidden(hidden, delay: 0.3)
}

public func delayIfViewHidden(hidden: Bool, delay: RxTimeInterval) -> Driver<Bool> {
    
    var o = Observable.just(hidden)
    if hidden {
        o = o.delaySubscription(delay, scheduler: MainScheduler.instance)
    }
    
    return o.asDriver(onErrorJustReturn: hidden)
}

public protocol Repository {
    
    var session: SessionRepository { get }
    
    var video: VideoRepository { get }
    
    var ranking: RankingRepository { get }
    
    var history: HistoryRepository { get }
}

public protocol Domain {
    
    var repository: Repository { get }
}

private var _domain: Domain!

func domain() -> Domain {
    return _domain
}

public func setup(domain: Domain) {
    _domain = domain
}