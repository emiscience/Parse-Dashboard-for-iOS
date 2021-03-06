//
//  ObjectSelectorViewController.swift
//  Parse Dashboard for iOS
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 12/17/17.
//

import UIKit

protocol ObjectSelectorViewControllerDelegate: AnyObject {
    
    func didSelectObject(_ object: PFObject, for key: String)
}

class ObjectSelectorViewController: ClassViewController {
    
    // MARK: - Properties
    
    var selectorKey: String?
    
    weak var delegate: ObjectSelectorViewControllerDelegate?
    
    var previousViewController: UIViewController?
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        // Don't Call Super
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Don't Call Super
        configure()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Don't Call Super
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        
        if let controllers = (parent as? UINavigationController)?.viewControllers {
            previousViewController = controllers[controllers.count - 2]
        } else {
            if previousViewController is ObjectViewController {
                configure()
            } else if previousViewController is ObjectBuilderViewController {
                UIApplication.shared.statusBarStyle = .lightContent
                navigationController?.navigationBar.tintColor = .white
                navigationController?.navigationBar.barTintColor = .darkPurpleBackground
            }
        }
    }
    
    // MARK: - View Setup
    
    override func setupToolbar() {
        // Don't Call Super
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        navigationController?.navigationBar.tintColor = .logoTint
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "Filter"),
                            style: .plain,
                            target: self,
                            action: #selector(modifyQuery(sender:)))
        ]
    }
    
    // MARK: - User Actions
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = isFiltering() ? filteredObjects[indexPath.row] : objects[indexPath.row]
        guard let selectorKey = selectorKey else { return }
        delegate?.didSelectObject(object, for: selectorKey)
        navigationController?.popViewController(animated: true)
    }
}
