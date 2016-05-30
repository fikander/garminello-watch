using Toybox.WatchUi as Ui;

class ConnectionErrorDelegate extends Ui.BehaviorDelegate {
}

class ConnectionErrorView extends Ui.View {
    hidden var mMessage;
    function initialize(message) {
        mMessage = message;
    }
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.ConnectionErrorLayout(dc));
    }

    function onUpdate(dc) {
        findDrawableById("error_msg").setText(mMessage.toString());
        View.onUpdate(dc);
    }
}