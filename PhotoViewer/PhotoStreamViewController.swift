//
//  PhotoStream2ViewController.swift
//  PhotoViewer
//
//  Created by 中川慶悟 on 2019/06/27.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PhotoStreamViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var photoView: UITableView!

    private var viewModel: PhotoStreamViewModel?
    private let disposeBag = DisposeBag()

    var dataSource: RxTableViewSectionedReloadDataSource<SectionOfImageData>?

    override func viewDidLoad() {
        super.viewDidLoad()
        //        photoView.dataSource = self
        //        photoView.delegate = self

        let input = searchField.rx.controlEvent(.editingChanged)
            .map { self.searchField.text }

        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfImageData>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "full", for: indexPath)
                cell.textLabel?.text = item.image
                //            cell.addSubview(item.image)
                return cell
        })
        self.dataSource = dataSource

        viewModel = PhotoStreamViewModel(searchText: input,
                                         photoView: photoView.rx,
                                         dataSources: dataSource)

        photoView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        var cell: UITableViewCell
    //
    //        if indexPath.row != 0 && (indexPath.row+1) % 3 == 0 {
    //            cell = tableView.dequeueReusableCell(withIdentifier: "full", for: indexPath)
    //        } else {
    //            cell = tableView.dequeueReusableCell(withIdentifier: "thumbnail", for: indexPath)
    //        }
    //
    //        return cell
    //    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 && (indexPath.row+1) % 3 == 0 {
            return 400
        }
        return 200
    }
}
