//
//  DynamicType.swift
//  NetHealth
//
//  Created by Sepehr Behroozi on 12/12/18.
//  Copyright © 2018 Sepehr. All rights reserved.
//

import Foundation

class DynamicType<T> {
    typealias ValueChangeListener = (T) -> Void
    
    var onValueChanged: ValueChangeListener = { _ in }
    
    private(set) var value: T {
        didSet {
            self.onValueChanged(self.value)
        }
    }
    
    func set(to value: T) {
        self.value = value
    }
    
    func bind(_ onValueChanged: @escaping ValueChangeListener) {
        self.onValueChanged = onValueChanged
        self.onValueChanged(self.value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}
