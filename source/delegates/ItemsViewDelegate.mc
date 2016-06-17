using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ItemsViewDelegate extends Ui.BehaviorDelegate {

    hidden var mView;
    hidden var mModel;

    function initialize(view, model) {
        BehaviorDelegate.initialize();

        mView = view;
        mModel = model;

        model.getData(method(:onModelChanged));
    }

    function onModelChanged() {
        mView.onModelChanged();
    }

    function onTap(evt) {
        var coords = evt.getCoordinates();
        if (coords[1] < 32) {
            if (coords[0] < 71) {
                mView.prevList();
            } else {
                mView.nextList();
            }
        } else {
            var i = mView.getItemIndexFromCoordinates(evt.getCoordinates());
            if (i != null) {
                mModel.cardTapped(mView.getCurrentList(), i);
            }
        }
        return true;
    }

    function changeList(index) {
        mView.onChangeList(index);
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
            return onMenu();
        }
        return false;
    }

    function onMenu() {
        var menu = new Rez.Menus.ItemsViewMenu();
        //menu.setTitle(Rez.Strings.menu_title_lists);
        // create menu containing names of all lists
        var lists = mModel.getLists();
        for (var i=0; i < lists.size(); i++) {
            menu.addItem(lists[i]["name"], 10000 + i);
        }
        Ui.pushView(menu, new ItemsViewMenuDelegate(self), Ui.SLIDE_UP);
        return true;
    }

    function menuExitBoard() {
        // open board selection view
        var view = new BoardSelectionView();
        var delegate = new BoardSelectionViewDelegate(view);
        Ui.switchToView(view, delegate, Ui.SLIDE_IMMEDIATE);
    }

    function menuPlayList() {
        var view = new PlaybackView(mModel, mView.getCurrentList());
        var delegate = new PlaybackViewDelegate(view);
        Ui.pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
    }
}
