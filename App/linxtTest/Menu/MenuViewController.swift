
import UIKit
import GoogleSignIn

class MenuViewController: UIViewController {

    var authentication: GIDAuthentication!
    
    @IBOutlet weak var playCoopButton: UIButton!
    @IBOutlet weak var playOnlineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playCoopButton.layer.cornerRadius = 10
        playOnlineButton.layer.cornerRadius = 10
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? MultiplayerMenuViewController {
            view.authentication = self.authentication
        }else if let view = segue.destination as? CoopViewController {
            view.authentication = self.authentication
        }else if let view = segue.destination as? MatchHistoryControllerTableViewController {
            view.authentication = self.authentication
        }
    }

}

