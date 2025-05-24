include<../modules/params.scad>;
use<../modules/ribberNeedlebedScrews.scad>;
use<../modules/roundedRail.scad>;

module backCover(width = gauge) { 

            translate([0,-BACK_COVER/2, -((screwHeadHeight + 1) - tolerance)/2])
            cube([width-(tolerance*2), BACK_COVER - tolerance, (screwHeadHeight + 1) - tolerance], center = true);
}

module backRail(width = gauge, rounded = false, tolerance = tolerance) {
    translate([0,-BACK_COVER/2, railHeight/2]) {
        if (rounded) {
            roundedRail(width-(tolerance*2), railDepth - tolerance*2, railHeight);
        } else {
            cube([width, railDepth - tolerance*2, railHeight], center = true);
        }
    }
}

module ribberBackCover(display = true) {
    x = display? -1: 0;
    for (i = [x:0]) {
        translate([i*gauge*numNeedles + i*tolerance,0,0]){
            difference() {
                union() {
                    translate([gauge*numNeedles - gauge, 0, 0]){
                        backCover(width = numNeedles*gauge);
                        backRail(width = numNeedles * gauge, rounded = true);
                    }
                }
                needleBedScrews();
            }
        }
    }
}

ribberBackCover(false);