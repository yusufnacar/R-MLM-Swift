//
//  HomeViewController.swift
//  R-MLM
//
//  Created by GTMAC15 on 1.07.2022.
//
//



import UIKit
import RealmSwift




protocol HomeViewControllerProtocol : AnyObject {
    func changeLoading(value:Bool)
    func showError(desc:String)
    func getData(data : MLMResponse?)
}


// MARK: - HOME View Controller

class HomeViewController: UIViewController , Storyboarded  {
    
    
    
    // MARK: - Variables
    var selectedPlayerIndex = 0
    var selectedRowPlay : Int?
    var videoURL: URL?
    var isOk : Bool?
    private var shotItems: MLMResponse? = []
    lazy var viewModel : HomeViewModel = HomeViewModel(homeService: HomeService(), delegate: self)
    weak var coordinator : MainCoordinator?
    
    
    
    // MARK: - UI Define
    
    let loadingIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        return indicator
    }()
    
    
     let nameList : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    
     let shotList : UITableView = {
        let table = UITableView()
        table.frame = .zero
        return table
    }()
    
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // API Call
        viewModel.fetchData()
        
        // UI
        configureUI()
        configureConstraint()
        
        // Table-Collection View
        self.nameList.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        shotList.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        // Delegates
        nameList.dataSource = self
        nameList.delegate = self
        shotList.dataSource = self
        shotList.delegate = self
        VideoService.instance.delegate = self
        
    }
}


// MARK: - Configure UI
extension HomeViewController {
    func configureUI() {
        
        shotList.separatorColor = UIColor.clear
        
        nameList.translatesAutoresizingMaskIntoConstraints = false
        shotList.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        loadingIndicator.center = self.view.center
        
        navigationItem.title = "R-MLM DATA"
        self.view.addSubview(shotList)
        self.view.addSubview(nameList)
        self.view.addSubview(loadingIndicator)
        
    }
    
    func configureConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            nameList.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nameList.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            nameList.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            nameList.heightAnchor.constraint(equalToConstant: 100),
            
            shotList.topAnchor.constraint(equalTo: nameList.bottomAnchor),
            shotList.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            shotList.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            shotList.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        
    }
}


// MARK: - Vc Protocol
extension HomeViewController : HomeViewControllerProtocol {
    func getData(data: MLMResponse?) {
        shotItems = data
        DispatchQueue.main.async {
            self.shotList.reloadData()
            self.nameList.reloadData()
            self.viewModel.addDataToDB()
        }
        
    }
    
    
    
    func changeLoading(value: Bool) {
        DispatchQueue.main.async {
            if value {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            }
        }
    }

    func showError(desc: String) {
        print(desc)
    }
}

// MARK: - Collection View Data Source Protocols

extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shotItems?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = 10.0
        
        cell.setup(with: "\(shotItems?[indexPath.row].name ?? "") \(shotItems?[indexPath.row].surname ?? "")")
        
        if (indexPath.row == 0){
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            cell.layer.borderColor = UIColor.blue.cgColor
        }else{
            cell.layer.borderColor = UIColor.black.cgColor
        }

        return cell
    }
}

// MARK: - UICollection Protocols
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.selectedPlayerIndex = indexPath.row
        DispatchQueue.main.async {
            self.shotList.reloadData()
        }
        cell?.layer.borderColor = UIColor.blue.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.black.cgColor
    }
    
}


// MARK: - UICollection Flow Protocols
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let name = "\(shotItems?[indexPath.row].name ?? "") \(shotItems?[indexPath.row].surname ?? "")"
        
        return CGSize(width: name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: 30)
        
    }
    
    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return finalWidth - 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20.0
    }
    
    
}

// MARK: - Table View Protocols

extension HomeViewController : UITableViewDelegate , UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shotItems?.count ?? 0 > 0  {
            return shotItems?[selectedPlayerIndex].shots.count ?? 0
        }
        else {
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else
        
        {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.playButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.setShotsData(shot: (shotItems?[selectedPlayerIndex].shots[indexPath.row])!)
        return cell    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


// MARK: - HOmeViewCell Protocol

extension HomeViewController : HomeViewCellProtocol {
    func didPressPlayButton(_ row: Int) {
        let id = shotItems?[selectedPlayerIndex].shots[row].id
        self.selectedRowPlay = row
        
        let urlString = viewModel.getVideoUrl(selectedPlayerIndex: selectedPlayerIndex, shotIndex: row)
        
        if(urlString.isEmpty) {
            VideoService.instance.launchVideoRecorder(in: self,id: id, completion: nil)
            
        } else{
            print(urlString)
            coordinator?.navigateToWatermarkVideo( data: (shotItems?[self.selectedPlayerIndex].shots[self.selectedRowPlay!])! , url: URL(string: urlString)!)
        }
        
        
    }
}


// MARK: - VideoService Protocol

extension HomeViewController : VideoServiceDelegate {
    func videoDidFinishSaving( url: URL? , error : Error?) {
        let success: Bool = error == nil
        if success {
            self.videoURL = url
            viewModel.updateVideoUrl(videoUrl: url!.absoluteURL, selectedPlayerIndex: self.selectedPlayerIndex, shotIndex: self.selectedRowPlay!)
            
            if shotItems?[selectedPlayerIndex].shots[self.selectedRowPlay!] != nil {
                coordinator?.navigateToWatermarkVideo( data: (shotItems?[self.selectedPlayerIndex].shots[self.selectedRowPlay!])! , url: url!)
            }
        }
        
    }
}








