using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class ItemsView extends ListView {

    hidden var mModel;

    hidden var mListId;

    hidden var mListNumberText;

    function initialize(model) {
        ListView.initialize();
        mModel = model;
        mListId = 0;
        mListNumberText = "";
    }

    //! Load your resources here
    function onLayout(dc) {
        ListView.onLayout(dc);
        setLayout(Rez.Layouts.ItemsLayout(dc));
        findDrawableById("list_title").setLocation(RenderTools.scaleX(dc, 25), RenderTools.scaleY(dc, 5));
    }

    //! Update the view
    function onUpdate(dc) {
        var l = mModel.getList(mListId);
        if (l != null) {
            findDrawableById("list_title").setText(l["name"]);
        }
        var c = mModel.getListsCount();
        if (c > 0) {
            mListNumberText = Lang.format("$1$/$2$", [mListId + 1, c]);
        }
        ListView.onUpdate(dc);

        // counter box, drawn last so it stays on top of the list rows
        var boxSize = RenderTools.scaleX(dc, 25);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, RenderTools.scaleY(dc, 4), boxSize, boxSize);
        dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        dc.drawText(0, RenderTools.scaleY(dc, 5), Gfx.FONT_SMALL, mListNumberText, Gfx.TEXT_JUSTIFY_LEFT);
    }

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
        if (index >= 0 and index < mModel.getListsCount()) {
            mListId = index;
            setItems(mModel.getCards(mListId));
        }
    }

    function onModelChanged() {
        if (mModel.getError()) {
            ListView.setError(mModel.getError());
        } else {
            onChangeList(0);
        }
    }

    function getCurrentList() {
        return mListId;
    }
}