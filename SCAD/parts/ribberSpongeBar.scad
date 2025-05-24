include<../modules/params.scad>;
use<../modules/ribberNeedlebedScrews.scad>;
use<../modules/roundedRail.scad>;


module spongeBar(width = gauge) { 
            translate([0,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR/2, -1])
            cube([width-(tolerance*2),SPONGE_BAR - tolerance*2,2], center = true);
}

module frontRail(width = gauge, rounded = false, tolerance = tolerance) {
    translate([0,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR/2, railHeight/2]) {
        if (rounded) {
            roundedRail(width-(tolerance*2), railDepth - tolerance*2, railHeight);
        } else {
            cube([width-(tolerance*2), railDepth - tolerance*2, railHeight], center = true);
        }
    }
}

module ribberSpongeBar(display = true) {
    x = display? -1: 0;
    for (i = [x:0]) {
        translate([i*gauge*numNeedles ,0,0]){
            difference() {
                union() {
                    translate([gauge*numNeedles - gauge, 0, 0]) {
                        frontRail(width = (numNeedles) * gauge, rounded = true);
                        spongeBar(width = numNeedles*gauge);
                    }
                }
                needleBedScrews();
            }
        }
    }
}

ribberSpongeBar(false);