
import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var playCoopButton: UIButton!
    @IBOutlet weak var playOnlineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playCoopButton.layer.cornerRadius = 10
        playOnlineButton.layer.cornerRadius = 10
        
    }

}

