//
//  NoteViewController.swift
//  Notes
//
//  Created by Eugene Maksimow on 29.01.2024.
//

import UIKit
import Combine

private struct Constants {
    static let title = NSLocalizedString("Note", comment: "")
    
    static let isLargeTitle = false
    
    static let viewBackgroundColor = UIColor.systemBackground
    
    static let sideMargin: CGFloat = 20
    static let bottomMargin: CGFloat = 40
    static let segmentedControlMoveTime: CGFloat = 0.25
    static let keyboardInitialHeight: CGFloat = 34
    static let segmentedItems = ["Add Image", "Change font"]
    static let segmentedFontItems = ["H1", "H2", "Aa", "B", "I", "C", "⛌"]
    
    static let swipeActionTitle = NSLocalizedString("Delete", comment: "")
    static let swipeActionStyle = UIContextualAction.Style.destructive
}

final class NoteViewController: UIViewController {
    
    internal let viewModel: NoteViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private var keyboardHeight: CGFloat = Constants.keyboardInitialHeight
    
    // MARK: - Navigation Bar
    
    private var navigationBarBuilder: NavigationBarBuilderProtocol
    
    private lazy var saveNoteButton: UIBarButtonItem = {
        let button = navigationBarBuilder.saveButton(#selector(saveNote))
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Alerts
    
    private let alertBuilder: AlertProtocol & AlertActionProtocol
    
    // MARK: - UI
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.viewBackgroundColor
        
        return view
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.textAlignment = .natural
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var activityIndicatorView: ActivityIndicatorView = {
        let view = ActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var textActionsSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Constants.segmentedItems)
        segmentedControl.selectedSegmentIndex = -1
        segmentedControl.addTarget(NoteViewController.self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        return segmentedControl
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: NoteViewModelProtocol,
         navigationBarBuilder: NavigationBarBuilderProtocol,
         alertBuilder: AlertProtocol & AlertActionProtocol) {
        self.viewModel = viewModel
        self.navigationBarBuilder = navigationBarBuilder
        self.alertBuilder = alertBuilder
        
        super.init(nibName: nil, bundle: nil)
        
        self.navigationBarBuilder.target = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        makeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        setupNavigationBar()
        setupActivityIndicatorView()
        setupNoteTextField()
        setupTextActionsSegmentedControl()
        loadingHasFinished()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bindViewModel() {
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.loadingHasStarted()
                } else {
                    self.updateNoteText()
                    self.loadingHasFinished()
                }
            }.store(in: &cancellables)
        
        viewModel.noteText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                noteTextView.attributedText = text
            }.store(in: &cancellables)
    }
    
    @objc func saveNote() {
        guard let note = noteTextView.attributedText else { return }
        
        viewModel.noteText.send(NSMutableAttributedString(attributedString: note))
        viewModel.saveNoteToCoreData()
    }
    
    // MARK: - UI setup
    
    private func makeView() {
        view = mainView
    }
    
    private func setupNavigationBar() {
        title = viewModel.noteModel.title
        navigationController?.navigationBar.prefersLargeTitles = Constants.isLargeTitle
        
        navigationItem.rightBarButtonItem = saveNoteButton
    }
    
    private func setupNoteTextField() {
        view.addSubview(noteTextView)
        
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargin),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargin),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomMargin)
        ])
    }
    
    private func setupTextActionsSegmentedControl() {
        view.addSubview(textActionsSegmentedControl)
        
        textActionsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textActionsSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargin),
            textActionsSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargin),
            textActionsSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - UI actions
    
    private func loadingHasStarted() {
        activityIndicatorView.activityIndicator.startAnimating()
    }
    
    private func loadingHasFinished() {
        if activityIndicatorView.activityIndicator.isAnimating {
            activityIndicatorView.activityIndicator.stopAnimating()
        }
        saveNoteButton.isEnabled = true
    }
    
    private func updateNoteText() {
        noteTextView.attributedText = viewModel.noteModel.text
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.numberOfSegments {
        case 2:
            handleOptionsSegment(sender)
        case 3...10:
            handleFontSegmentAction(sender)
        default:
            print("Default case of number of segments")
        }
    }
    
    private func updateSegmentedControl(with items: [String], for segmentedControl: UISegmentedControl) {
        segmentedControl.removeAllSegments()
        
        for (index, item) in items.enumerated() {
            segmentedControl.insertSegment(withTitle: item, at: index, animated: false)
        }
    }
    
    private func handleOptionsSegment(_ sender: UISegmentedControl) {
        let selectedSegment = Constants.segmentedItems[sender.selectedSegmentIndex]
        
        switch selectedSegment {
        // future option to choose an image from gallery or take a photo
        case "Add Image":
            print("Add Image selected")
        case "Change font":
            updateSegmentedControl(with: Constants.segmentedFontItems, for: sender)
        default:
            print("Unknown segment selected")
        }
    }
    
    private func handleFontSegmentAction(_ sender: UISegmentedControl) {
        let selectedFontSegment = Constants.segmentedFontItems[sender.selectedSegmentIndex]
        
        switch selectedFontSegment {
        case "⛌":
            updateSegmentedControl(with: Constants.segmentedItems, for: sender)
        case "B":
            viewModel.traitSelected(trait: Traits.bold, range: noteTextView.selectedRange)
        case "C":
            viewModel.traitSelected(trait: Traits.clear, range: noteTextView.selectedRange)
        case "I":
            viewModel.traitSelected(trait: Traits.italic, range: noteTextView.selectedRange)
        case "H1":
            viewModel.sizeSelected(size: 24, range: noteTextView.selectedRange)
        case "H2":
            viewModel.sizeSelected(size: 20, range: noteTextView.selectedRange)
        case "Aa":
            viewModel.sizeSelected(size: 16, range: noteTextView.selectedRange)
        default:
            print("Unknown font segment selected")
        }
        
        sender.selectedSegmentIndex = -1
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            updateSegmentedControlPosition()
        }
    }
    
    @objc private func keyboardWillHide() {
        keyboardHeight = Constants.keyboardInitialHeight
        updateSegmentedControlPosition()
    }
    
    private func updateSegmentedControlPosition() {
        UIView.animate(withDuration: Constants.segmentedControlMoveTime) {
            self.textActionsSegmentedControl.frame.origin.y = self.view.bounds.height - self.keyboardHeight - self.textActionsSegmentedControl.bounds.height
        }
    }
}

// MARK: - TextField delegate

extension NoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case noteTextView:
            noteTextView.resignFirstResponder()
        default:
            print("none")
        }
        return true
    }
}
