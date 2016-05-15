using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ListView extends Ui.View {

	hidden var mItems;
	hidden var startX, startY, offsetX, offsetY;

    function initialize() {
        View.initialize();
        mItems = null;
        startX = 4;
        startY = 30;
        offsetX = 0;
        offsetY = 50;
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //Sys.println("[ListView] updating view with : " + mItems);
        View.onUpdate(dc);
        if (mItems instanceof Array) {
        	//draw backgrounds
        	dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_RED);
        	for (var i = 0; i < mItems.size(); i++) {
	        	dc.fillRoundedRectangle(0, startY + offsetY * i, 148, offsetY - 2, 5);
        	}
        	//draw text
        	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        	for (var i = 0; i < mItems.size(); i++) {
        		var midline = startY + offsetY * (i + 0.5);
        		dc.drawText(
        			startX + offsetX * i, midline, Graphics.FONT_XTINY,
        			mItems[i]["name"], Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        		);
        	}
        } else {
        	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        	dc.drawText(
        		dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_XTINY,
        		Ui.loadResource(Rez.Strings.loading), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        	);
        }
    }

    function getItemIndexFromCoordinates(coords) {
    	Sys.println(coords);
    	var i = (coords[1] - startY) / offsetY;
    	if (i >= 0 and i < mItems.size()) {
    		return i;
    	} else {
    		return null;
    	}
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

	function setItems(items) {
		mItems = items;
		Ui.requestUpdate();
	}
}
