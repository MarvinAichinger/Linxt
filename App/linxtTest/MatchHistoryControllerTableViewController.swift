//
//  MatchHistoryControllerTableViewController.swift
//  linxtTest
//
//  Created by Aichinger Marvin on 23.06.22.
//

import UIKit
import GoogleSignIn

class MatchHistoryControllerTableViewController: UITableViewController {
    
    var authentication: GIDAuthentication!
    
    var matches = [[String]]()
    
    var gameColors = GameColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let authData = try? JSONEncoder().encode(["token": self.authentication.idToken]) else {
            return
        }
        
        let url = URL(string: "http://172.17.217.10:3100/api/user/history")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.authentication.idToken!, forHTTPHeaderField: "authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                if let matches = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if let array = matches as? [[String : Any]] {
                        print(array)
                        for obj in array {
                            let match = obj["result"] as! String
                            let enemy = obj["enemy"] as! String
                            
                            self.matches.append([match,enemy])
                            
                            print(match)
                            print(enemy)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
        task.resume()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.matches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = matches[indexPath.row][0] == "true" ? "Won" : "Lost"
        cell.detailTextLabel?.text = "vs. " + matches[indexPath.row][1]
        
        if (matches[indexPath.row][0] == "true") {
            cell.backgroundColor = gameColors.blue
        }else {
            cell.backgroundColor = gameColors.red
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
