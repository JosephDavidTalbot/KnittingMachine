include<params.scad>;
//include<needlebed.scad>;

//testPrintM();

screwConnector();
//screwConnector();
//screwConnector(tolerance=tolerance);
//echo(needleBedHeight - (needleSlotHeight + 2));

module screwHoles(tolerance = 0) {
    translate([0,0,needleBedHeight+0.5]) cylinder(h = needleBedHeight*2 + 1, d = screwDiamSm, center = true, $fn = 25);
    translate([0,0,screwHeadHeight]) cylinder(h = screwHeadHeight*2 + tolerance, d = screwHeadDiamSm, center = true, $fn = 25);
}


module screwConnector(top = needleBedHeight - (needleSlotHeight + 3), length = gauge*12, width = gauge*6, tolerance = 0) {
    difference(){
        //translate([-(length/2),-(width/2),0])
        //cube([length,width,top]);
        linear_extrude(top+tolerance) polygon(points=[[-(length/2)-tolerance,(width/2)+tolerance],[-(length/2)-tolerance,-(width/2)-tolerance],[0,-(width/4)-tolerance],[length/2+tolerance,-(width/2-tolerance)],[length/2+tolerance,(width/2)+tolerance],[0,(width/4)+tolerance]]);
        connectorScrews(length, width, tolerance);
    }
}

module connectorScrews(length = gauge*12, width = gauge*6, tolerance = 0) {
    screwSpacing = floor((length/3)/gauge)*gauge;
    translate([screwSpacing,0,-tolerance]) screwHoles(tolerance);
}
