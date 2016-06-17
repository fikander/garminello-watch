using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Math as Math;

class RegisterDelegate extends Ui.BehaviorDelegate {

    hidden var mView;
    hidden var mApp;

    function initialize(view) {
        mApp = App.getApp();
        BehaviorDelegate.initialize();
        mView = view;
        tryConfig();
    }

    function tryConfig() {
        gApi.getConfig(method(:onConfigReceived));
    }

    function onConfigReceived(status, data) {
        Sys.println("RegisterDelegate:onConfigReceived " + status.toString() + " " + data);
        if (status == 200) {
            // registered - proceed
            var view = new BoardSelectionView();
            var delegate = new BoardSelectionViewDelegate(view);
            Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
        } else if (status == 456) {
            // generate new activation_code
            var newActivationCode = generateActivationCode(8);
            mApp.setProperty("activation_code", newActivationCode);
            mView.showNotRegistered(newActivationCode);
        } else {
            // other error
            Ui.switchToView(new ConnectionErrorView(data), new ConnectionErrorDelegate(), Ui.SLIDE_IMMEDIATE);
        }
    }

    function tryRegister() {
        gApi.registerWatch(method(:onRegisterReceived));
    }

    function onRegisterReceived(status, data) {
        Sys.println("RegisterDelegate:onRegisterReceived " + status.toString() + " " + data);
        if (status == 200) {
            if (data instanceof Dictionary and data["active"]) {
                // registered, remember UUID and get proper config
                mApp.setProperty("watch_id", data["uuid"]);
                tryConfig();
            }
        } else {
            Ui.switchToView(new ConnectionErrorView(data), new ConnectionErrorDelegate(), Ui.SLIDE_IMMEDIATE);
        }
    }

    function onMenu() {
        //Ui.pushView(new Rez.Menus.MainMenu(), new GarminelloMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

    function onTap(evt) {
        tryRegister();
        //var view = new BoardSelectionView();
        //var delegate = new BoardSelectionViewDelegate(view);
        //Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
        return true;
    }

    function generateActivationCode(length) {
        var id = "";
        // no "O" and "0" as they could be confused
        var s = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9"];
        for (var i = 0; i < length; i++) {
            id += s[Math.rand() % s.size()];
        }
        return id;
    }

}