using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class GarminelloMenuDelegate extends Ui.MenuInputDelegate {

    hidden var mOrigin;

    function initialize(origin) {
        MenuInputDelegate.initialize();
        mOrigin = origin;
    }

    function onMenuItem(item) {
        if (item == :unregister_watch) {
            var app = App.getApp();
            app.setProperty("watch_id", null);
            Ui.popView(Ui.SLIDE_DOWN);
        } else if (item ==:about) {
            Ui.popView(Ui.SLIDE_DOWN);
            mOrigin.menuAbout();
        } else if (item == :go_to_boards) {
            Ui.popView(Ui.SLIDE_DOWN); // close this menu
            mOrigin.menuExitBoard();
        }
    }
}
