//
//  TextTableViewCell.swift
//  sandbox
//
//  Created by sonson on 2017/04/07.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

internal class TextTableViewCell: UITableViewCell {
    let textView = UZTextView(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = .zero
        self.selectionStyle = .none
        textView.backgroundColor = .black
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.contentMode = .scaleAspectFit
        self.contentView.addSubview(textView)
        textView.frame = self.contentView.bounds
        textView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.contentView.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
