//
//  ViewPauseLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 04..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewPauseLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(pauseView)
        pauseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        handlePortraitLayout(size: CGSize.zero)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        super.handlePortraitLayout(size: size)
        
        pauseStackView.axis = .vertical
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        
        pauseStackView.axis = .horizontal
    }
    
    lazy var pauseView: UIView! = {
        let view = UIView()
        
        let viewPlay = UIView()
        let viewStop = UIView()
        viewPlay.addSubview(self.btnPlay)
        self.btnPlay.snp.makeConstraints({ (make) in
            make.center.equalTo(viewPlay)
        })
        viewStop.addSubview(self.btnStop)
        self.btnStop.snp.makeConstraints({ (make) in
            make.center.equalTo(viewStop)
        })
        
        let viewSpace1 = UIView()
        let viewSpace2 = UIView()
        let viewSpace3 = UIView()
        
        self.pauseStackView.addArrangedSubview(viewSpace1)
        self.pauseStackView.addArrangedSubview(viewPlay)
        self.pauseStackView.addArrangedSubview(viewSpace2)
        self.pauseStackView.addArrangedSubview(viewStop)
        self.pauseStackView.addArrangedSubview(viewSpace3)
        
        view.addBlurEffect()
        
        view.addSubview(self.pauseStackView)
        self.pauseStackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        return view
    }()
    
    lazy var btnPlay: RoundButton! = {
        let btnPlay = RoundButton(radius: 125, image: UIImage(named: "ic_play_big")!, color: Colors.colorGreen)
        
        return btnPlay
    }()
    
    lazy var btnStop: RoundButton! = {
        let btnStop = RoundButton(radius: 125, image: UIImage(named: "ic_stop_big")!, color: Colors.colorRed)
        
        return btnStop
    }()
    
    lazy var pauseStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
}
