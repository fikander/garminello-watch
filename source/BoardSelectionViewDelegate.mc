using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BoardSelectionViewDelegate extends Ui.BehaviorDelegate {

    hidden var mView;
    hidden var mOnReceiveBoards;
    hidden var mCurrentBoards;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
        mOnReceiveBoards = view.method(:onReceiveBoards);
        mCurrentBoards = null;

        // fetch boards for the user
        gApi.getBoards(method(:onGetBoards));
    }

    function onGetBoards(status, data) {
        if (status == 200) {
            mCurrentBoards = data;
            mOnReceiveBoards.invoke(null, data);
        } else {
            mOnReceiveBoards.invoke(data.toString(), null);
        }
    }

    function onTap(evt) {
        if (mCurrentBoards == null) {
            return;
        }
        var i = mView.getItemIndexFromCoordinates(evt.getCoordinates());
        //Sys.println("clicked board: " + i);

        if (i != null) {
            // open list view screen
            var model = new ItemsModel(mCurrentBoards[i], null);
            var view = new ItemsView(model);
            var delegate = new ItemsViewDelegate(view, model);
            Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
        }
    }

    function onSwipe(evt)
    {
        var swipe = evt.getDirection();

        if(swipe == SWIPE_LEFT) {
            mView.nextList();
        } else if(swipe == SWIPE_RIGHT) {
            mView.prevList();
        } else if (swipe == SWIPE_UP) {
            onNextPage();
        } else if (swipe == SWIPE_DOWN) {
            onPreviousPage();
        }

        return true;
    }

    function onNextPage() {
        mView.nextPage();
        return true;
    }

    function onPreviousPage() {
        mView.prevPage();
        return true;
    }

    function onKey(evt) {
        var key = evt.getKey();
        if( key == KEY_ENTER )
        {
            onMenu();
            return true;
        }
        return false;
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new GarminelloMenuDelegate(self), Ui.SLIDE_UP);
        return true;
    }

    function menuAbout() {
        Ui.pushView(new AboutView(), new AboutViewDelegate(self), Ui.SLIDE_UP);
        return true;
    }
}