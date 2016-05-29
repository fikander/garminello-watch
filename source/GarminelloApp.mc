using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

var VERSION = "1.0";

var gApi = null;

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
        gApi = new GarminelloApi("https://garminello.herokuapp.com");
        //gApi = new GarminelloApi("https://5d215908.ngrok.io");

        var app = App.getApp();
        var lastBoard = app.getProperty("board");
        var lastItems = app.getProperty("items");
        //Sys.println(lastBoard);
        if (lastBoard != null and lastItems != null) {
            // last board data available - show the last list
            var model = new ItemsModel(lastBoard, lastItems);
            var view = new ItemsView(model);
            var delegate = new ItemsViewDelegate(view, model);
            return [ view, delegate ];
        } else {
            // we need connection at this point, and potentitally need to register the watch as well
            // this will
            //  1. check config endpoint
            //  2. fail with no internet
            //  3. proceed to board selection view
            //  4. show new code for watch and after user interacts - go to 1.
            var view = new RegisterView();
            var delegate = new RegisterDelegate(view);
            return [ view, delegate ];

            // select a board
            //var view = new BoardSelectionView();
            //var delegate = new BoardSelectionViewDelegate(gApi, view);
        }
    }

}
