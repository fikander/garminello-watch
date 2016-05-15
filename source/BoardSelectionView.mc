using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BoardSelectionView extends ListView {

    function initialize() {
        ListView.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.BoardSelectionLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	ListView.onShow();
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        ListView.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	ListView.onHide();
    }

	function onReceiveBoards(boards) {
		ListView.setItems(boards);
	}
}