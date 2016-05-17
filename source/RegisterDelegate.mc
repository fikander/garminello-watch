using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Math as Math;

class RegisterDelegate extends Ui.BehaviorDelegate {

    hidden var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
        Sys.println("DELEGATE INITIALIZE");
        tryConfig();
    }

    function tryConfig() {
        gApi.getConfig(method(:onConfigReceived));
    }

    function onConfigReceived(status, data) {
        if (status == 200) {
            // registered - proceed
            var view = new BoardSelectionView();
            var delegate = new BoardSelectionViewDelegate(view);
            Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
        } else {
            // show error - try again
            // generate new watch id
            var app = App.getApp();
            var newWatchId = generateWatchId();
            app.setProperty("watch_id", newWatchId);
            mView.showNotRegistered(newWatchId);
        }
    }

    function onMenu() {
        Sys.println("ON MENU");
        //Ui.pushView(new Rez.Menus.MainMenu(), new GarminelloMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

    function onTap(evt) {
        tryConfig();
        //var view = new BoardSelectionView();
        //var delegate = new BoardSelectionViewDelegate(view);
        //Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
        return true;
    }

    function generateWatchId() {
        var id = "";
        var s = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"];
        for (var i=0; i<8; i++) {
            id += s[Math.rand() % s.size()];
        }
        return id;
    }

}