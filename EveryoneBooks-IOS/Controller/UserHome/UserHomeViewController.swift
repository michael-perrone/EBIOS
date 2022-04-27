import UIKit

class UserHomeViewController: SlideTabBarController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTabs()
        // Do any additional setup after loading the view.
    }
    

    func configureUI() {
        view.backgroundColor = .mainLav;
        tabBar.backgroundColor = .mainLav;
        tabBar.barTintColor = .mainLav;
     }
     
     func configureTabs() {
        let notifications = UserNotifications(collectionViewLayout: UICollectionViewFlowLayout());
        let businessesFollowing = BusinessesFollowingCollection(collectionViewLayout: UICollectionViewFlowLayout());
        businessesFollowing.delto = self;
        let businessFollowing = Components().createNavBarItemController(image: UIImage(named: "business-tab-bar"), viewController: businessesFollowing, title: "Following");
        let userBookingsCollection = UserBookings(collectionViewLayout: UICollectionViewFlowLayout());
        let userBookings = Components().createNavBarItemController(image: UIImage(named: "service-bell-tab-bar"), viewController: userBookingsCollection, title: "Bookings")
        let connect = Components().createNavBarItemController(image: UIImage(named: "groupy"), viewController: ConnectViewController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Connect");
        let notificationsTab = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: notifications, title: "Notifications");
        viewControllers = [userBookings, businessFollowing, notificationsTab];
        view.setHeight(height: UIScreen.main.bounds.height);
        view.setWidth(width: UIScreen.main.bounds.width);
    }
}



