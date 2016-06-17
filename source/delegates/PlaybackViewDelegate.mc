using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PlaybackViewDelegate extends Ui.BehaviorDelegate {

    hidden var mView;
    hidden var mModel;

    function initialize(view, model) {
        BehaviorDelegate.initialize();

        mView = view;
        mModel = model;
    }

    function onSwipe(evt)
    {
        var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
            onNextPage();
        } else if (swipe == SWIPE_DOWN) {
            onPreviousPage();
        }

        return true;
    }

    function onNextPage() {
        //TODO: skip to next card
        return true;
    }

    function onPreviousPage() {
        //TODO: skip to prev card
        return true;
    }

    function onKey(evt) {
        var key = evt.getKey();
        if( key == KEY_ENTER )
        {
            return onMenu();
        }
        return false;
    }

    function onMenu() {
        //TODO: start/stop
        return true;
    }

}