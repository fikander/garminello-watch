using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BoardSelectionViewDelegate extends Ui.BehaviorDelegate {

	hidden var mApi;
	hidden var mView;
	hidden var mOnReceiveBoards;
	hidden var mCurrentBoards;

    function initialize(api, view) {
        BehaviorDelegate.initialize();
        mApi = api;
        mView = view;
        mOnReceiveBoards = view.method(:onReceiveBoards);
        mCurrentBoards = null;

        // fetch boards for the user
        mApi.getBoards(method(:onGetBoards));
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
	    	var view = new ItemsView(mCurrentBoards[i]);
	    	var delegate = new ItemsViewDelegate(mApi, view, mCurrentBoards[i]);
	    	Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);    	
    	}
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