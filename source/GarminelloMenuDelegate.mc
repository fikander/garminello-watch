using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class GarminelloMenuDelegate extends Ui.MenuInputDelegate {

	hidden var mOrigin;
	
    function initialize(origin) {
        MenuInputDelegate.initialize();
        mOrigin = origin;
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            Sys.println("item 1");
        } else if (item == :item_2) {
            Sys.println("item 2");
        } else if (item == :go_to_boards) {
        	Sys.println("go to boards");
        	Ui.popView(Ui.SLIDE_DOWN);
        	mOrigin.menuExitBoard();
        }
    }

}