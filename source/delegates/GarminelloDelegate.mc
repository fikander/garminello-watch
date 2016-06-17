using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class GarminelloDelegate extends Ui.BehaviorDelegate {

	hidden var mApi;

    function initialize(api) {
        BehaviorDelegate.initialize();
        mApi = api;
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new GarminelloMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
    function onTap(evt) {
    	var view = new BoardSelectionView();
    	var delegate = new BoardSelectionViewDelegate(mApi, view);
    	Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
    }

}