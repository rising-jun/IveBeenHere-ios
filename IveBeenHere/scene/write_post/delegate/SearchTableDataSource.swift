//
//  SearchTableDelegate.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/09/01.
//

import UIKit

final class SearchTableDataSource: NSObject {
    private var places: [PlaceDTO] = []
    var tappedRelay: PublishRelay<Int>?
    
    func updatePlaces(from places: [PlaceDTO]) {
        self.places = places
    }
}
extension SearchTableDataSource: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = places[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedRelay?.accept(value: indexPath.item)
    }
}

