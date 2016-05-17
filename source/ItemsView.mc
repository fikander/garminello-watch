using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ItemsView extends ListView {

    hidden var mModel;

    hidden var mListId;

    function initialize(model) {
        ListView.initialize();
        mModel = model;
        mListId = 0;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.ItemsLayout(dc));
    }

    //! Update the view
    function onUpdate(dc) {
        var l = mModel.getList(mListId);
        if (l != null) {
            findDrawableById("list_title").setText(l["name"]);
        }
        var c = mModel.getListsCount();
        if (c > 0) {
            findDrawableById("list_number").setText(Lang.format("$1$/$2$", [mListId + 1, c]));
        }
        ListView.onUpdate(dc);
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
}