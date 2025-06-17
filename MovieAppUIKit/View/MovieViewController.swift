//
//  MovieViewController.swift
//  MovieAppUIKit
//
//  Created by Yogesh Rathore on 17/06/25.
//

import UIKit
import SwiftUI
import Combine

class MovieViewController: UIViewController {
    

    private let viewModel: MovieListViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    private func setUpUI() {
        
        viewModel.$loadingCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                if completed {
                    self?.movieTableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        view.backgroundColor = .white
        
        // register cells
        movieTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(movieTableView)
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
        
        let movie = viewModel.movies[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = movie.title
        content.secondaryText = "Release on \(movie.year)"
        cell.contentConfiguration = content
        return cell
    }
    
    
}

extension MovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("SearchBar: \(searchText)")
        viewModel.setSearchText(searchText)
    }
}

struct MovieViewControllerRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MovieViewController
    
    func makeUIViewController(context: Context) -> MovieViewController {
        MovieViewController(viewModel: MovieListViewModel(httpClient: HTTPClient()))
    }
    
    func updateUIViewController(_ uiViewController: MovieViewController, context: Context) {
        
    }
}

#Preview {
    MovieViewControllerRepresentable()
}
