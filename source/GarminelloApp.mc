using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class GarminelloApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
	    var api = new GarminelloApi("https://garminello.herokuapp.com");
		var app = App.getApp();
		var lastBoard = app.getProperty("board");
		var lastItems = app.getProperty("items");
		if (lastBoard != null and lastItems != null) {
			var view = new ItemsView(lastBoard);
	    	var delegate = new ItemsViewDelegate(api, view, lastBoard, lastItems);
	    	return [ view, delegate ];    	
		} else {
	        return [ new GarminelloView(), new GarminelloDelegate(api) ];
        }
    }

}
