import UIKit

class CountrySelectionViewControllerO: UIViewController,
                                      UITableViewDelegate,
                                      UITableViewDataSource,
                                      UISearchBarDelegate {

    var countries: [String] {
        let locale = Locale.current
        let countries = Locale.isoRegionCodes.map { locale.localizedString(forRegionCode: $0)! }
        return countries.sorted { $0 < $1 }
    }

    var filteredCountries: [String] = []
    var selectedCountry: String?

    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = filteredCountries[indexPath.row]
        return cell
    }

    func updateSearchResults(text: String?) {
        guard let searchText = text else { return }
        self.filteredCountries = countries.filter { country in
            return country.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            updateSearchResults(text: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults(text: searchBar.text)
        self.searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar.endEditing(true)
        filteredCountries = countries
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Country/Region"
        // table view
        self.filteredCountries = self.countries
        tableView.delegate = self
        tableView.dataSource = self
        // search bar
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow!
        self.selectedCountry = filteredCountries[indexPath.row]
    }
}
