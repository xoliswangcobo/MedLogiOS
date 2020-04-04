//
//  ManagedCollection.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation

protocol ManagedCollectionDelegate {
    func didAppendElement<Element: Hashable>(element:Element, index:Int)
    func didDeleteElement<Element: Hashable>(element:Element, index:Int)
}

class ManagedCollection<Element : Hashable> {
    public var collection = Array<Element>()
    public var delegate:ManagedCollectionDelegate?
    
    func elements() -> Array<Element> {
        return self.collection
    }
    
    func count() -> Int {
        return self.collection.count
    }
    
    func append(element:Element) -> Bool {
        guard let location = self.indexOf(element: element) else {
            return false
        }
        
        self.collection.append(element)
        
        if self.delegate != nil {
            self.delegate?.didAppendElement(element:element, index: location)
        }
        
        return true
    }
    
    func delete(element:Element) -> Void {
        guard let location = self.indexOf(element: element) else {
            return
        }
        
        self.collection.remove(at: location)
        
        if self.delegate != nil {
            self.delegate?.didDeleteElement(element:element, index: location)
        }
    }
    
    func elementExists(element: Element) -> Bool {
        if self.indexOf(element: element) != nil {
            return true
        }
        
        return false
    }
    
    func indexOf(element:Element) -> Int? {
        return self.collection.firstIndex(of: element)
    }
}
