//
//  NoteCell.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

private struct Constants {
    static let padding: CGFloat = 16
    
    static let secondaryLabelColor = UIColor.secondaryLabel
    static let tertiaryLabelColor = UIColor.tertiaryLabel
    
    static let titleLabelNormalTopSpace: CGFloat = 13
    static let titleLabelBiggerTopSpace: CGFloat = 17
    static let titleLabelSmallerTopSpace: CGFloat = 8
    static let titleLabelFont = UIFont.boldSystemFont(ofSize: 17)
    
    static let noteNumberOfLines = 2
    static let noteLabelComparativeHeight: CGFloat = 25
    static let noteLabelFont = UIFont.systemFont(ofSize: 15)
    
    static let spaceBetweenTitleAndNote: CGFloat = 2
    
    static let separatorThickness: CGFloat = 1
}

final class NoteCell: UITableViewCell {
    
    var viewModel: NotesListViewModelProtocol?
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.noteLabelFont
        label.textColor = Constants.secondaryLabelColor
        label.numberOfLines = Constants.noteNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var separatorView: SeparatorView = {
        let view = SeparatorView(thickness: Constants.separatorThickness)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Changable constraints
    
    private lazy var titleTopConstaint = titleLabel.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Constants.titleLabelBiggerTopSpace)
    
    private lazy var noteTopConstraint = noteLabel.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: Constants.spaceBetweenTitleAndNote)
    
    private lazy var noteLeadingConstraintToTitle = noteLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTitleLabel()
        setupNoteLabel()
        setupSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        noteLabel.text = nil
        noteLabel.font = Constants.noteLabelFont
        noteLabel.textColor = Constants.secondaryLabelColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recalculateTitleLabelTopConstraint()
    }
    
    // MARK: - UI setup
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),     
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    private func setupNoteLabel() {
        contentView.addSubview(noteLabel)
        
        NSLayoutConstraint.activate([
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    private func setupSeparatorView() {
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func recalculateTitleLabelTopConstraint() {
        if noteLabel.frame.height > Constants.noteLabelComparativeHeight {
            titleTopConstaint.constant = Constants.titleLabelSmallerTopSpace
        } else {
            titleTopConstaint.constant = Constants.titleLabelBiggerTopSpace
        }
    }
    
    private func configureTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    private func configureNote(_ note: NSMutableAttributedString?) {
        guard let note else { return }
            setupNote(with: note)
    }
    
    private func setupNote(with text: NSMutableAttributedString) {
        noteLabel.attributedText = text
        noteTopConstraint.isActive = true
        noteLeadingConstraintToTitle.isActive = true
    }
}


extension NoteCell: ConfigurableViewProtocol {
    
    typealias ConfigurationModel = NoteModel
    
    func configure(with model: ConfigurationModel) {
        configureTitle(model.title)
        configureNote(model.text)
    }
}
