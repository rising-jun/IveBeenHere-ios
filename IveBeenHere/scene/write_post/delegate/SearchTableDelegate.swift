//
//  SearchTableDelegate.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/09/01.
//

import UIKit

final class SearchTableDelegate: NSObject {
    
}
extension SearchTableDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
