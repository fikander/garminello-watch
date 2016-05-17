using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ItemsModel {

	var mApp;
	var mBoard; // board data
	var mItems; // array of lists with arrays of cards
	
	var mLastError;

	var mUpdateCallback;

	function initialize(board, items) {
	    mApp = App.getApp();
		mBoard = board;
		mItems = items;

		if (mBoard == null) {
			Sys.println("ERROR: board cannot be null");
			return;
		}
	}

	function getData(updateCallback) {
		if (mUpdateCallback != null) {
			Sys.println("ERROR: updateCallback already set - getting data in progress");
			return;
		}
		mUpdateCallback = updateCallback;
		if (mItems == null) {
	        gApi.getBoard(mBoard["id"], method(:onGetItems));
		} else {
			mUpdateCallback.invoke();
			mUpdateCallback = null;
		}
	}

	function onGetItems(status, items) {
    	//Sys.println(Lang.format("Items for board $1$: $2$", [mBoard["name"], items]));
    	if (status == 200) {
    		mItems = items;
    		// save as property for the next run
	        mApp.setProperty("board", mBoard);
	        mApp.setProperty("items", items);
    	} else {
    		mLastError = status.toString();
    		Sys.println("ERRROR: Failed loading of items for board " + mBoard + " : " + status.toString());
    	}
    	mUpdateCallback.invoke();
    	mUpdateCallback = null;
	}

	function getError() {
		return mLastError;
	}

	function hasItems() {
		return mItems != null;
	}
	
	function getListsCount() {
		return mItems != null ? mItems.size() : 0;
	}

	function getList(i) {
		if (mItems != null and i < mItems.size()) {
			return mItems[i];
		} else {
			return null;
		}
	}

	function getCards(i) {
		if (mItems != null and i < mItems.size()) {
			return mItems[i]["cards"];
		} else {
			return null;
		}
	}

}