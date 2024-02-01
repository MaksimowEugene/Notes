//
//  NotesListViewController.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import UIKit
import Combine

private struct Constants {
    static let title = NSLocalizedString("Notes", comment: "")
    
    static let isLargeTitle = false
    static let tableSeparatorStyle = UITableViewCell.SeparatorStyle.none
    static let tableScrollIndicator = false
    static let cellHeight: CGFloat = 76
    static let tableMargin: CGFloat = 10
    static let viewBackgroundColor = UIColor.systemBackground
    
    static let swipeActionTitle = NSLocalizedString("Delete", comment: "")
    static let swipeActionStyle = UIContextualAction.Style.destructive
}

final class NotesListViewController: UIViewController, UITextFieldDelegate {
    
    internal let viewModel: NotesListViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    internal lazy var dataSource: NotesDataSource = {
        let dataSource = NotesDataSource(tableView,
                                         viewModel: viewModel)
        return dataSource
    }()
    
    // MARK: - Navigation Bar
    
    private var navigationBarBuilder: NavigationBarBuilderProtocol
    
    private lazy var createNoteButton: UIBarButtonItem = {
        let button = navigationBarBuilder.createNoteButton(#selector(addNote))
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Alerts
    
    private let alertBuilder: AlertProtocol & AlertActionProtocol
    
    // MARK: - New note alert
    
    private lazy var cancelAction = alertBuilder.cancelAction { [weak self] _ in
        guard let self,
              let titleTextField = self.newNoteAlert.textFields?.first,
              let title = titleTextField.text
        else { return }
        titleTextField.text = nil
    }
    
    private lazy var createNoteAction = alertBuilder.createNoteAction { [weak self] _ in
        guard let self,
              let titleTextField = self.newNoteAlert.textFields?.first,
              let title = titleTextField.text
        else { return }
        self.viewModel.createNoteTitle.send(title)
        self.viewModel.createNote()
        titleTextField.text = nil
    }
    
    private lazy var newNoteAlert: UIAlertController = { [weak self] in
        guard let self else { return UIAlertController() }
        let alert = alertBuilder.newNoteAlert(cancelAction,
                                              createNoteAction)
        let titleTextField = alert.textFields?.first
        titleTextField?.addTarget(self,
                                  action: #selector(noteTitleDidChange),
                                  for: .editingChanged)
        
        return alert
    }()
    
    // MARK: - UI
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.viewBackgroundColor
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .null)
        view.delegate = self
        view.rowHeight = Constants.cellHeight
        view.separatorStyle = Constants.tableSeparatorStyle
        view.showsVerticalScrollIndicator = Constants.tableScrollIndicator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(NoteCell.self,
                      forCellReuseIdentifier: String(describing: NoteCell.self))
        
        return view
    }()
    
    private lazy var activityIndicatorView: ActivityIndicatorView = {
        let view = ActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: NotesListViewModelProtocol,
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
        setupTableView()
        setupActivityIndicatorView()
        
        refreshNotes()
        
        loadingHasFinished()
    }
    
    private func bindViewModel() {
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.loadingHasStarted()
                } else {
                    self.loadingHasFinished()
                }
            }
            .store(in: &cancellables)
        
        viewModel.notes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notes in
                guard let self else { return }
                self.setupDataSource(notes)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI setup
    
    private func makeView() {
        view = mainView
    }
    
    private func setupNavigationBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = Constants.isLargeTitle
        
        navigationItem.rightBarButtonItem = createNoteButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: -Constants.tableMargin),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: Constants.tableMargin)
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
    
    @objc private func addNote() {
        present(newNoteAlert, animated: true)
    }
    
    @objc private func noteTitleDidChange(_ textField: UITextField) {
        guard let createAction = newNoteAlert.actions.last,
              let title = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }
        let titleIsEmpty = title.isEmpty
        createAction.isEnabled = !titleIsEmpty
    }
    
    private func loadingHasStarted() {
        activityIndicatorView.activityIndicator.startAnimating()
        createNoteButton.isEnabled = false
    }
    
    private func loadingHasFinished() {
        if activityIndicatorView.activityIndicator.isAnimating {
            activityIndicatorView.activityIndicator.stopAnimating()
        }
        createNoteButton.isEnabled = true
    }
    
    // MARK: - Data configuration actions
    
    @objc private func refreshNotes() {
        viewModel.loadNotes()
    }
}

// MARK: - TableView delegate

extension NotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
        let noteModel = NoteModel(id: note.id,
                             title: note.title,
                             text: note.text)
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showNoteView(note: noteModel)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: Constants.swipeActionStyle,
                                        title: Constants.swipeActionTitle) { [weak self] (_, _, completionHandler) in
            guard let self else { return }
            let snapshot = self.dataSource.snapshot()
            let noteToDelete = snapshot.itemIdentifiers[indexPath.row]
            self.viewModel.deleteNote(by: noteToDelete.id)
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        
        return swipeActionConfig
    }
}
