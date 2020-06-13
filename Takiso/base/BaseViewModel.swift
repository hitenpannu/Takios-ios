//
//  BaseViewModel.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 13/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation


protocol BaseViewModelProtocol {
    
    associatedtype ViewType
    
    func isViewAttached() -> Bool
    
    func attachView(view : ViewType)
    
    func detachView()
}

class BaseViewModel<T>: BaseViewModelProtocol {
    
    typealias ViewType = T
    
    var attachedView : T? = nil
    
    func isViewAttached() -> Bool {
        return attachedView != nil
    }
    
    func attachView(view: T) {
        attachedView = view
        onViewAttached()
    }
    
    func detachView() {
        attachedView = nil
    }
    
    func onViewAttached(){}
    
}
