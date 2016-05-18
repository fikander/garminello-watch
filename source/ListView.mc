using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ListView extends Ui.View {

    hidden var mItems;
    hidden var mErr;
    hidden var startX, startY, offsetX, offsetY, listHeight;
    hidden var pageSize, lastPage, currentPage;

    hidden var COLORS = [Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLUE, Graphics.COLOR_RED];

    function initialize() {
        View.initialize();
        mItems = null;
        mErr = null;
        startX = 4;
        startY = 30;
        offsetX = 0;
        offsetY = 50;
        listHeight = 174;
        pageSize = 3;
        currentPage = 0;
        lastPage = 0;
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //Sys.println("[ListView] updating view with : " + mItems);
        View.onUpdate(dc);
        if (mItems instanceof Array) {
            // determine which items to draw
            var startItem = currentPage * pageSize;
            var endItem = startItem + pageSize; // always draw one more item to show it's there
            if (endItem >= mItems.size()) {
                endItem = mItems.size()-1;
            }
            Sys.println("page: " + currentPage + "/" + lastPage + " first item: " + startItem + " last item: " + endItem);
            //draw backgrounds
            dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_RED);
            var i = 0;
            for (var item = startItem; item <= endItem; item++) {
                var style = mItems[item]["color"] ? mItems[item]["color"] : 0;
                dc.setColor(COLORS[style % COLORS.size()], Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(0, startY + offsetY * i, 144, offsetY - 2, 5);
                i++;
            }
            //draw text fields
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            i = 0;
            for (var item = startItem; item <= endItem; item++) {
                var midline = startY + offsetY * (i + 0.5);
                dc.drawText(
                    startX + offsetX * i, midline, Graphics.FONT_XTINY,
                    mItems[item]["name"], Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
                );
                i++;
            }
            // draw progress on the right - show which page is currently shown
            if (lastPage > 0) {
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(144, startY, 8, listHeight);
                dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
                var progressSize = listHeight / (lastPage + 1);
                var progressStart = listHeight * currentPage / (lastPage + 1);
                Sys.println("size: " + progressSize + " start: " + progressStart);
                dc.fillRectangle(144, startY + progressStart, 8, progressSize);
            }
        } else {
            var message;
            if (mErr) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                message = Ui.loadResource(Rez.Strings.load_failed) + mErr;
            } else {
                dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
                message = Ui.loadResource(Rez.Strings.loading);
            }
            dc.drawText(
                dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_XTINY,
                message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
    }

    function nextPage() {
        if (currentPage < lastPage) {
            currentPage += 1;
            Ui.requestUpdate();
        }
    }

    function prevPage() {
        if (currentPage > 0) {
            currentPage -= 1;
            Ui.requestUpdate();
        }
    }

    function getItemIndexFromCoordinates(coords) {
        Sys.println(coords);
        if (coords[1] < startY or coords[1] > startY + listHeight) {
            return null;
        }
        var i = (coords[1] - startY) / offsetY + (currentPage * pageSize);
        Sys.println("clicked item: " + i);
        if (i >= 0 and mItems != null and i < mItems.size()) {
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
        mErr = null;
        currentPage = 0;
        if (items != null) {
            lastPage = items.size() / pageSize + (items.size() % pageSize > 0 ? 1 : 0) - 1;
        } else {
            lastPage = 0;
        }
        Ui.requestUpdate();
    }

    function setError(err) {
        mErr = err;
        mItems = null;
        Ui.requestUpdate();
    }
}
