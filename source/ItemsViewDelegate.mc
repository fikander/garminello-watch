using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ItemsViewDelegate extends Ui.BehaviorDelegate {

	hidden var mApp;
	hidden var mApi;
	hidden var mView;
	hidden var mOnReceiveItems;
	hidden var mCurrentItems;
	hidden var mBoard;

    function initialize(api, view, board, items) {
        BehaviorDelegate.initialize();
	    mApp = App.getApp();
        mApi = api;
        mView = view;
        mBoard = board;
        mOnReceiveItems = view.method(:onReceiveItems);
        mCurrentItems = items;

        if (mCurrentItems != null) {
        	mOnReceiveItems.invoke(null, mCurrentItems);
		} else {
	        // fetch boards for the user
	        mApi.getBoard(board["id"], method(:onGetItems));
	    }
    }

    function onGetItems(status, items) {
    	//Sys.println(Lang.format("Items for board $1$: $2$", [mBoard["name"], items]));
    	if (status == 200) {
    		mCurrentItems = items;
    		mOnReceiveItems.invoke(null, items);
    		// save as property for the next run
	        mApp.setProperty("board", mBoard);
	        mApp.setProperty("items", items);
    	} else {
    		Sys.println(Ui.loadResource(Rez.Strings.load_failed) + status.toString());
    		mOnReceiveItems.invoke(status.toString(), null);
    	}
    }

    function onTap(evt) {
    	if (mCurrentItems == null) {
    		return;
    	}
    	var coords = evt.getCoordinates();
    	if (coords[1] < 32) {
    		if (coords[0] < 124) {
    			mView.prevList();
    		} else {
    			mView.nextList();
    		}
    		return true;
    	}
    	var i = mView.getItemIndexFromCoordinates(evt.getCoordinates());
    	// TODO - open menu?
    	return true;
    }
    
    function onSwipe(evt)
    {
        var swipe = evt.getDirection();
        
		if(swipe == SWIPE_LEFT) {
        	mView.nextList();
        } else if(swipe == SWIPE_RIGHT) {
        	mView.prevList();
        } else if (swipe == SWIPE_UP) {
        	mView.nextPage();
        } else if (swipe == SWIPE_DOWN) {
        	mView.prevPage();
        } 

        return true;
    }

	function onKey(evt) {
		var key = evt.getKey();
        if( key == KEY_ENTER )
        {
        	onMenu();
        }
        return true;
	}
    
    function onMenu() {
        Ui.pushView(new Rez.Menus.ItemsViewMenu(), new GarminelloMenuDelegate(self), Ui.SLIDE_UP);
        return true;
    }

    function menuExitBoard() {
    	// delete cached list
    	mApp.setProperty("board", null);
	    mApp.setProperty("items", null);
		// open board selection view
    	var view = new BoardSelectionView();
    	var delegate = new BoardSelectionViewDelegate(mApi, view);
    	Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
    }

}