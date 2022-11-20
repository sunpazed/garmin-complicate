using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Timer as Timer;
using Toybox.Complications as Complications;

enum {
  SCREEN_SHAPE_CIRC = 0x000001,
  SCREEN_SHAPE_SEMICIRC = 0x000002,
  SCREEN_SHAPE_RECT = 0x000003,
  SCREEN_SHAPE_SEMI_OCTAGON = 0x000004
}

public class WatchView extends Ui.WatchFace {

  // globals for devices width and height
  var dw = 0;
  var dh = 0;

  function initialize() {
   Ui.WatchFace.initialize();
  }

  function onLayout(dc) {

    // w,h of canvas
    dw = dc.getWidth();
    dh = dc.getHeight();

    // define the global bounding boxes
    defineBoundingBoxes(dc);

  }

  function onUpdate(dc) {

    // clear the screen
    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    dc.clear();

    // grab time objects
    var clockTime = Sys.getClockTime();

    // define time, day, month variables
    var hour = clockTime.hour;
    var minute = clockTime.min < 10 ? "0" + clockTime.min : clockTime.min;
    var font = Gfx.FONT_SYSTEM_LARGE;
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    dc.drawText(dw/2,dh/5-(dc.getFontHeight(font)),font,hour.toString()+":"+minute.toString(),Gfx.TEXT_JUSTIFY_CENTER);

    // draw bounding boxes (debug)
    drawBoundingBoxes(dc);

  }

  function onShow() {
  }

  function onHide() {
  }

  function onExitSleep() {
  }

  function onEnterSleep() {
  }

  function defineBoundingBoxes(dc) {

    // "bounds" format is an array as follows [  [x1,y1] , [x2,y2] ]
    //
    //   [x1,y1] --------------+
    //      |                  |
    //      |                  |
    //      +---------------[x2,y2]
    //

    // left quad
    var bbox_left   = [ [ 0            , dh/4           ] ,
                        [ dw/4         , dh             ] ];

    // middle quad
    var bbox_midd  =  [ [ dw/4         , dh/4           ] ,
                        [ (dw/4)+(dw/2), (dh/4)+(dh/2.5)] ];

    // bottom quad
    var bbox_bottom = [ [ dw/4         , (dh/4)+(dh/2.5)] ,
                        [ (dw/4)+(dw/2), dh             ] ];

    // right quad
    var bbox_right =  [ [ (dw/4)+(dw/2), dh/4           ],
                        [ dw           , dh             ] ];

    boundingBoxes = [
      {
        "label" => "Heart Rate",
        "bounds" => bbox_midd,
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_HEART_RATE
      },
      {
        "label" => "Temperature",
        "bounds" => bbox_left,
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE
      },
      {
        "label" => "Steps",
        "bounds" => bbox_bottom,
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_STEPS
      },
      {
        "label" => "BodyBatt",
        "bounds" => bbox_right,
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_BODY_BATTERY
      }
    ];

  }

  // callback that updates the complication value
  function updateComplication(complication) {

    var thisComplication = Complications.getComplication(complication);
    var thisType = thisComplication.getType();

    for (var i=0; i < boundingBoxes.size(); i=i+1){

      if (thisType == boundingBoxes[i]["complicationId"]) {
        boundingBoxes[i]["value"] = thisComplication.value;
        boundingBoxes[i]["label"] = thisComplication.shortLabel;
      }

    }

  }

  // debug by drawing bounding boxes and labels
  function drawBoundingBoxes(dc) {

    dc.setPenWidth(1);

    for (var i=0; i < boundingBoxes.size(); i=i+1){

      var x1 = boundingBoxes[i]["bounds"][0][0];
      var y1 = boundingBoxes[i]["bounds"][0][1];
      var x2 = boundingBoxes[i]["bounds"][1][0];
      var y2 = boundingBoxes[i]["bounds"][1][1];

      // draw a cross and a box
      dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_PURPLE);
      dc.drawLine(x1,y1,x2,y2);
      dc.drawLine(x1,y2,x2,y1);
      dc.drawRectangle(x1,y1,x2-x1,y2-y1);

      // draw the complication label and value
      var value = boundingBoxes[i]["value"];
      var label = boundingBoxes[i]["label"];
      var font = Gfx.FONT_SYSTEM_TINY;

      dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      dc.drawText(x1+((x2-x1)/2),y1+((y2-y1)/2)-(dc.getFontHeight(font)),font,label.toString(),Gfx.TEXT_JUSTIFY_CENTER);
      dc.drawText(x1+((x2-x1)/2),y1+((y2-y1)/2),font,value.toString(),Gfx.TEXT_JUSTIFY_CENTER);

    }

  }


}
