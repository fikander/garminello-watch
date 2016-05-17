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

    function onGetBoards(status, boards) {
        //Sys.println("Boards: " + boards);
        if (status == 200) {
            mCurrentBoards = boards;
            mOnReceiveBoards.invoke(null, boards);
        } else {
            Sys.println("Failed to load\nError: " + status.toString());
            mOnReceiveBoards.invoke(status.toString(), null);
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

}