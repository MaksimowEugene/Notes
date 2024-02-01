//
//  NotesDataSource.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

enum NotesSection: Hashable, CaseIterable {
    case main
}

final class NotesDataSource: UITableViewDiffableDataSource<NotesSection, NoteModel> {
    
    let viewModel: NotesListViewModelProtocol
    
    init(_ tableView: UITableView,
         viewModel: NotesListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteCell.self),
                                                           for: indexPath) as? NoteCell
            else { return nil }
            
            cell.viewModel = viewModel
            cell.configure(with: item)
            
            return cell
        }
    }
}

extension NotesListViewController {
    
    internal func setupDataSource(_ notes: [NoteModel]) {
        var snapshot = dataSource.snapshot()
        if !NotesSection.allCases.allSatisfy({ snapshot.sectionIdentifiers.contains($0) }) {
            snapshot.appendSections(NotesSection.allCases)
        }
        
        if snapshot.itemIdentifiers.isEmpty {
            snapshot.appendItems(notes)
        } else {
            let notesDifference = notes.difference(from: snapshot.itemIdentifiers)
            for change in notesDifference {
                switch change {
                case .insert(_, let note, _):
                    snapshot.appendItems([note])
                case .remove(_, let note, _):
                    snapshot.deleteItems([note])
                }
            }
        }
        
        let sortedNotes = viewModel.sortNotes(snapshot.itemIdentifiers)
        snapshot = NSDiffableDataSourceSnapshot<NotesSection, NoteModel>()
        snapshot.appendSections(NotesSection.allCases)
        snapshot.appendItems(sortedNotes)
        
        if view.window == nil {
            dataSource.apply(snapshot, animatingDifferences: false)
        } else {
            dataSource.apply(snapshot)
        }
    }
}
