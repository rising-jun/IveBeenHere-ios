//
//  LocationSearchBarDelegate.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/26.
//

import UIKit

final class LocationSearchBarDelegate: NSObject {
    var searchBarChangeObserver: PublishRelay<String>?
    
}
extension LocationSearchBarDelegate: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarChangeObserver?.accept(value: searchText)
    }
}
