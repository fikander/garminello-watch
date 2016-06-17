using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;


class UnregisterConfirmationDelegate extends Ui.ConfirmationDelegate {

    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
        if (response == Ui.CONFIRM_YES) {
            var app = App.getApp();
            app.setProperty("watch_id", null);
            app.setProperty("activation_code", null);
        }
    }
}

class ExitBoardConfirmationDelegate extends Ui.ConfirmationDelegate {
    hidden var mOrigin;

    function initialize(origin) {
        ConfirmationDelegate.initialize();
        mOrigin = origin;
    }

    function onResponse(response) {
        if (response == Ui.CONFIRM_YES) {
            mOrigin.menuExitBoard();
        }
    }
}

class GarminelloMenuDelegate extends Ui.MenuInputDelegate {

    hidden var mOrigin;

    function initialize(origin) {
        MenuInputDelegate.initialize();
        mOrigin = origin;
    }

    function onMenuItem(item) {
        if (item == :unregister_watch) {
            Ui.popView(Ui.SLIDE_DOWN);
            Ui.pushView(new Ui.Confirmation(Ui.loadResource(Rez.Strings.are_you_sure)), new UnregisterConfirmationDelegate(), Ui.SLIDE_IMMEDIATE);
        } else if (item == :about) {
            Ui.popView(Ui.SLIDE_DOWN);
            mOrigin.menuAbout();
        }
    }
}

class ItemsViewMenuDelegate extends Ui.MenuInputDelegate {

    hidden var mOrigin;

    function initialize(origin) {
        MenuInputDelegate.initialize();
        mOrigin = origin;
    }

    function symbolToInt(symbol) {
        if (symbol == 10000) { return 0; }
        else if (symbol == 10001) { return 1; }
        else if (symbol == 10002) { return 2; }
        else if (symbol == 10003) { return 3; }
        else if (symbol == 10004) { return 4; }
        else if (symbol == 10005) { return 5; }
        else if (symbol == 10006) { return 6; }
        else if (symbol == 10007) { return 7; }
        else if (symbol == 10008) { return 8; }
        else if (symbol == 10009) { return 9; }
        else if (symbol == 10010) { return 10; }
        else if (symbol == 10011) { return 11; }
        else if (symbol == 10012) { return 12; }
        else if (symbol == 10013) { return 13; }
        else if (symbol == 10014) { return 14; }
        else if (symbol == 10015) { return 15; }
        else if (symbol == 10016) { return 16; }
        else if (symbol == 10017) { return 17; }
        else if (symbol == 10018) { return 18; }
        else if (symbol == 10019) { return 19; }
        else if (symbol == 10020) { return 20; }
        else if (symbol == 10021) { return 21; }
        return 0;
    }

    function onMenuItem(item) {
        if (item == :go_to_boards) {
            Ui.popView(Ui.SLIDE_DOWN);
            mOrigin.menuExitBoard();
            //Ui.pushView(new Ui.Confirmation(Ui.loadResource(Rez.Strings.are_you_sure)), new ExitBoardConfirmationDelegate(mOrigin), Ui.SLIDE_IMMEDIATE);
        } else if (item == :menu_play_list) {
            Ui.popView(Ui.SLIDE_DOWN);
            mOrigin.menuPlayList();
        } else {
            var i = symbolToInt(item);
            mOrigin.changeList(i);
        }
    }

}
