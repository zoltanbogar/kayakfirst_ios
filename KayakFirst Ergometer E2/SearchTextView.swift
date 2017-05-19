//
//  CustomHintTextView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 19..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class SearchTextView: UITextView, UITextViewDelegate {
    
    //MARK: properties
    var searchListener: ((_ text: String) -> ())?
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        
        initView()
        
        delegate = self
        
        returnKeyType = UIReturnKeyType.search
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    private func initView() {
        textContainer.maximumNumberOfLines = 1
        
        addSubview(initHintView())
        initHintView().snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.center.equalTo(self)
        }
    }
    
    func initHintView() -> UIView {
        return hintView
    }
    
    private lazy var hintView: UIView! = {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_search_18pt")
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.colorGrey
        let label = UILabel()
        label.text = getString("other_search")
        label.textColor = Colors.colorGrey
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(view)
        }
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.centerY.equalTo(view)
        }
        
        return view
    }()
    
    //MARK: delegate methods
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        hintView.isHidden = true
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text! == "" {
            hintView.isHidden = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            
            if let searchListenerValue = searchListener {
                searchListenerValue(textView.text)
            }
        }
        return true
    }
}
