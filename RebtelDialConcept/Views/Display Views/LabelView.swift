//
//  LabelView.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 27/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

class LabelView: UIView {
    
    lazy var fAicon: UILabel = {
        let lbl = UILabel.init()
        lbl.font = Theme.fontAwesome
        lbl.text = ""
        lbl.textColor = .white
        lbl.textAlignment = .right
        lbl.widthAnchor.constraint(equalToConstant: 30).isActive = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var labelTitle: UILabel = {
        let lbl = UILabel.init()
        lbl.text = ""
        lbl.font = Theme.labelHeader
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let sv = UIStackView.init(arrangedSubviews: [fAicon, labelTitle])
        sv.alignment = .center
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    init(frame: CGRect, fontAwesomeCode: String, title: String) {
        super.init(frame: frame)
        
        self.fAicon.text = fontAwesomeCode
        self.labelTitle.text = title
        
        self.setupView()
    }
    
    private func setupView() {
        self.addSubview(horizontalStackView)
        
        
        NSLayoutConstraint.activate([
            horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
