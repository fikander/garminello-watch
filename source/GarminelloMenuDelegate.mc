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
        } else if (item == :go_to_boards) {
            Ui.popView(Ui.SLIDE_DOWN);
            mOrigin.menuExitBoard();
            //Ui.pushView(new Ui.Confirmation(Ui.loadResource(Rez.Strings.are_you_sure)), new ExitBoardConfirmationDelegate(mOrigin), Ui.SLIDE_IMMEDIATE);
        }
    }
}
