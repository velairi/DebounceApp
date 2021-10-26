//
//  ResultsCell.swift
//  DebounceApp
//
//  Created by Valerie Don on 10/19/21.
//

import UIKit

final class ResultsCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "Subtitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var model: PredictionElement? {
        didSet {
            guard let object = model else {
                titleLabel.text = nil
                subtitleLabel.text = nil
                return
            }
            update(with: object)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update
    func update(with object: PredictionElement) {
        titleLabel.text = object.structuredFormatting.mainText
        subtitleLabel.text = object.structuredFormatting.secondaryText
    }
}
