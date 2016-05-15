using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ItemsView extends ListView {

	 hidden var mListId;
	 hidden var mLists;

    function initialize() {
        ListView.initialize();
        mListId = 0;
        mLists = null;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.ItemsLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	ListView.onShow();
    }
    
    function getCurrentList() {
    	try {
    		return mLists[mListId];
    	} catch (ex) {
    		return null;
    	}
    }

    //! Update the view
    function onUpdate(dc) {
        //Sys.println("[ItemsView] updating view with : " + mItems);
        // Call the parent onUpdate function to redraw the layout
        var l = getCurrentList();
        if (l != null) {
			var list_title = findDrawableById("list_title");
	    	list_title.setText(l["name"]);
	    	//Sys.println("  currentlist: " + l["name"]);
/*
	    	dc.drawText(
	    		dc.getWidth()/2, 0, Graphics.FONT_XTINY,
	    		l["name"], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
	    	);
*/
	    }
        ListView.onUpdate(dc);
    }
    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	ListView.onHide();
    }

	function nextList() {
		onChangeList(mListId + 1);
	}

	function prevList() {
		onChangeList(mListId - 1);
	}
	
    function onChangeList(index) {
    	if (index >= 0 and mLists != null and index < mLists.size()) {
    		mListId = index;
    		ListView.setItems(mLists[mListId]["cards"]);
    	}
    }

	function onReceiveItems(items) {
		Sys.println("RECEIVED: " + items);
		mLists = items;
		onChangeList(0);
	}
}