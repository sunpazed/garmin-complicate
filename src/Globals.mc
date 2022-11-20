using Toybox.System as Sys;
using Toybox.Complications as Complications;

public var bboxes = [];
public var boundingBoxes = [];

public function checkBoundingBoxes(points) {

  // iterate through each bounding box
  for(var i=0;i<boundingBoxes.size();i++) {

    var currentBounds = boundingBoxes[i];
    Sys.println("checking bounding box: " + currentBounds["label"]);

    // check if the current bounding box has been hit,
    // if so, return the corresponding complication
    if (checkBoundsForComplication(points,currentBounds["bounds"])) {
        return currentBounds["complicationId"];
    }

  }

  // we didn't hit a bounding box
  return false;

}

// true if the points are contained within this boundingBox
public function checkBoundsForComplication(points,boundingBox) {
  return boxContains(points,boundingBox[0],boundingBox[1]);
}

// true if points are contained within Min x1,y1 to Max x2,y2
public function boxContains(points, boxMinXY, boxMaxXY) {
    return points[0] <= boxMaxXY[0] &&
           points[1] <= boxMaxXY[1] &&
           points[0] >= boxMinXY[0] &&
           points[1] >= boxMinXY[1];
}
