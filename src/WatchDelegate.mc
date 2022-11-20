using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Timer as Timer;
using Toybox.Complications as Complications;

class WatchDelegate extends Ui.WatchFaceDelegate {

	function initialize() {
		WatchFaceDelegate.initialize();
	}

  public function onPress(clickEvent) {

    // grab the [x,y] position of the clickEvent
    var co_ords = clickEvent.getCoordinates();
    Sys.println( "clickEvent x:" + co_ords[0] + ", y:" + co_ords[1]  );

    // returns the complicationId within the boundingBoxes
    var complicationId = checkBoundingBoxes(co_ords);

    //
    if (complicationId) {
        Sys.println( "We found a complication! let's launch it ..." );
        var thisComplication = new Complications.Id(complicationId);
        if (thisComplication) {
          Complications.exitTo(thisComplication);
        }
        return(true);
    } else {
        Sys.println( "No complication found" );
    }

    return(false);

  }


}
