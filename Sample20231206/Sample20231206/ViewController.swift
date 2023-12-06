//
//  ViewController.swift
//  Sample20231206
//
//  Created by Don Mag on 12/6/23.
//

import UIKit

// MARK: decent approach to easy view loading from XIB / NIB
//	see: https://stackoverflow.com/a/53937885/6257435
public protocol NibInstantiatable {
	static func nibName() -> String
}
extension NibInstantiatable {
	static func nibName() -> String {
		return String(describing: self)
	}
}
extension NibInstantiatable where Self: UIView {
	static func fromNib() -> Self {
		let bundle = Bundle(for: self)
		let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
		return nib!.first as! Self
	}
}

// MARK: default view controller
//	only has a button to push to the Example controller
class ViewController: UIViewController {
}

// MARK: XIB view class
class MyScrollXIBView: UIScrollView, NibInstantiatable {
	@IBOutlet var blueContentView: UIView!
}

// MARK: Example controller
class ExampleViewController: UIViewController {
	
	let stackView: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 20.0
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Wizard"
		
		let testView = MyScrollXIBView.fromNib()

		stackView.translatesAutoresizingMaskIntoConstraints = false
		testView.blueContentView.addSubview(stackView)
		
		testView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(testView)
		
		NSLayoutConstraint.activate([

			// constrain all 4 sides of testView to view (NOT to safe-area)
			testView.topAnchor.constraint(equalTo: view.topAnchor),
			testView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			testView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			testView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			// constrain all 4 sides of stackView to testView.blueContentView
			stackView.topAnchor.constraint(equalTo: testView.blueContentView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: testView.blueContentView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: testView.blueContentView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: testView.blueContentView.bottomAnchor),
			
		])

		// let's add some 100-point tall labels to the stack view
		for i in 0..<12 {
			let v = UILabel()
			v.backgroundColor = .yellow
			v.font = .systemFont(ofSize: 32.0, weight: .bold)
			v.textAlignment = .center
			v.text = "Arranged Subview \(i)"
			v.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
			stackView.addArrangedSubview(v)
		}
	}
	
}

class TempVC: UIViewController {
	
	let stackView: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 20.0
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// let's add some 100-point tall labels to the stack view
		for i in 0..<12 {
			let v = UILabel()
			v.backgroundColor = .yellow
			v.font = .systemFont(ofSize: 24.0, weight: .bold)
			v.textAlignment = .center
			v.text = "Arranged Subview \(i)"
			v.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
			stackView.addArrangedSubview(v)
		}

		guard let sv = view.subviews.first as? UIScrollView,
			  let bv = sv.subviews.first
		else {
			fatalError()
		}
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		bv.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			
			// constrain all 4 sides of stackView to testView.blueContentView
			stackView.topAnchor.constraint(equalTo: bv.topAnchor, constant: 8.0),
			stackView.leadingAnchor.constraint(equalTo: bv.leadingAnchor, constant: 8.0),
			stackView.trailingAnchor.constraint(equalTo: bv.trailingAnchor, constant: -8.0),
			stackView.bottomAnchor.constraint(equalTo: bv.bottomAnchor, constant: -8.0),
			
			stackView.widthAnchor.constraint(equalTo: sv.frameLayoutGuide.widthAnchor, constant: -(40.0 + 16.0)),
		])
		
	}
}
