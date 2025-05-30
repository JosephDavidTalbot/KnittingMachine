include<../modules/params.scad>;
use<../modules/ribberNeedlebedScrews.scad>;
use<../modules/screwConnector.scad>;

width = 50;

//frontAngle();

module needleUnit() {
    difference() {
        needleBase();
        needleSlot();
        backCoverCutout();
        spongeBarCutout();
        combCutout();
        frontAngle();
    }
}

module needleBase() {
    translate([0,-NEEDLE_BED_DEPTH/2, -needleBedHeight/2])
    cube([gauge, NEEDLE_BED_DEPTH, needleBedHeight], center = true);
}

module needleSlot() {
    translate([0,-NEEDLE_BED_DEPTH/2, 0])
    cube([needleSlotWidth, NEEDLE_BED_DEPTH + 2, needleSlotHeight*2], center = true);
}

module backCoverCutout() {
//    translate([0,-BACK_COVER/2, 0])
    cube([gauge + 2, BACK_COVER*2, (screwHeadHeight + 1) * 2], center = true);
}

module spongeBarCutout() {
    translate([0,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR/2, 0])
    cube([gauge + 2, SPONGE_BAR,needleSlotHeight * 2], center = true);
}

module combCutout() {
    hull() {
        translate([0,-NEEDLE_BED_DEPTH, 0])    
        cube([combWidth,(COMB - combWidth)*2,needleSlotHeight * 2], center = true);
        translate([0,-NEEDLE_BED_DEPTH + (COMB - combWidth), 0])
        cylinder(h = needleSlotHeight * 2, r = combWidth/2, $fn = 25, center = true);
    }
    translate([0,-NEEDLE_BED_DEPTH, 0])
        cylinder(h = needleBedHeight * 2 + 1, r = combWidth/2, $fn = 25, center = true);
}

module frontAngle(width = gauge) {
    //echo(needleBedHeight - needleSlotHeight);
    lastPoint = (needleBedHeight - needleSlotHeight)/tan(45);
    translate([0,-NEEDLE_BED_DEPTH,-needleBedHeight])
    rotate([180,90,0])
    linear_extrude(width + 1, center = true)
    polygon(points = [[0,0],[-(needleBedHeight - needleSlotHeight),0],[0,-lastPoint]]);
}

module spongeBarSpacers() {
    translate([-gauge/2,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR - 2, -needleSlotHeight/2 - 1 - tolerance])
    cube([gauge/2, 4, needleSlotHeight - 2], center = true);
    translate([-gauge/2,-(NEEDLE_BED_DEPTH-COMB) + 2, -needleSlotHeight/2 - 1 - tolerance])
    cube([gauge/2, 4, needleSlotHeight - 2], center = true);
}
module protoNeedleBed() {
    screwOffset = (floor(numNeedles/2) - screwPlacement);
    for(i = [0:numNeedles-1]) {
        if (i==screwOffset || i==numNeedles-screwOffset) {
              translate([gauge*i, 0, 0]) {
              needleUnit(); 
              spongeBarSpacers();
              } 
        } else {
            // no spacer
            translate([gauge*i, 0, 0])
                     needleUnit();   
        }  
    }
}
module needleBed() {
    union() {
        difference() {
            protoNeedleBed();
            translate([-gauge/2 - tolerance,-(NEEDLE_BED_DEPTH/2),-needleBedHeight]) {
                union(){
                    screwConnector(tolerance = tolerance);
                    connectorScrews();
                }
            }
            needleBedScrews();
        }
        translate([gauge*(numNeedles-1)+gauge/2,-(NEEDLE_BED_DEPTH/2),-needleBedHeight]){
            difference(){
                screwConnector();
                connectorScrews();
            }
        }
    }
}
needleBed();