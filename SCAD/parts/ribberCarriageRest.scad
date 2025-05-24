include<../modules/params.scad>;
use<../parts/needleBed.scad>;
use<../parts/ribberBackCover.scad>;
use<../parts/ribberSpongeBar.scad>;
use<../modules/screwConnector.scad>;
use<../modules/connector.scad>;
use<../modules/ribberNeedlebedScrews.scad>;

// TODO: needs refactoring!

clampWidth = 50;
clampDepth = NEEDLE_BED_DEPTH-clampWidth/2;
clampThickness = 6;
clampHollow = 85; // adjust this for your table thickness
clampOffset = -30;


// LEFT
module leftCarriageRest() {
    difference(){
        union(){
            translate([-gauge, 0, 0]) carriageRest();
            translate([-gauge*3.5-(CAM_PLATE_WIDTH/2),0,0]) {
                frontRail(CAM_PLATE_WIDTH/2, rounded = true);
                backRail(CAM_PLATE_WIDTH/2, rounded = true);
            }
            translate([-gauge/2 - tolerance,-(NEEDLE_BED_DEPTH/2),-needleBedHeight]) {
                difference(){
                    screwConnector();
                    connectorScrews();
                }
            }
        }
        union() {
            translate([0,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR/2, 0])
            cube([(gauge * (numNeedles+2))+(tolerance*2), SPONGE_BAR,(screwHeadHeight-(1-tolerance)) * 2], center = true);
            cube([(gauge * (numNeedles+2))+(tolerance*2), BACK_COVER*2, (screwHeadHeight + 1) * 2], center = true);
            
            needleBedScrews();
        }
    }
}
//RIGHT
module rightCarriageRest() {
    difference() {
        union() {
            translate([gauge*numNeedles, 0, 0])
            mirror([1,0,0])
            carriageRest();
            translate([gauge*(numNeedles+1.5)+(CAM_PLATE_WIDTH/2),0,0]) {
                frontRail(CAM_PLATE_WIDTH/2, rounded = true);
                backRail(CAM_PLATE_WIDTH/2, rounded = true);
            }
        }
        union() {
            translate([gauge*numNeedles, 0, 0]){
                translate([0,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR/2, 0]) cube([(gauge * (numNeedles-2))+(tolerance*2), SPONGE_BAR,(screwHeadHeight-(1-tolerance)) * 2], center = true);
                cube([(gauge * (numNeedles-2))+(tolerance*2), BACK_COVER*2, ((screwHeadHeight + 1) * 2)], center = true);
            }
            translate([gauge*(numNeedles-1)+gauge/2,-(NEEDLE_BED_DEPTH/2),-needleBedHeight]){
                screwConnector(tolerance = tolerance);
                connectorScrews();
            }
            needleBedScrews();
        }
    }
}

////// CLAMP
//translate([-gauge,0,0])
//clampUnit();


module carriageRest() {
    union(){
        difference() {
            difference() {
                hull() {
                    needleBase();
                    translate([-CAM_PLATE_WIDTH, -10, -needleBedHeight/2])
                    cylinder(needleBedHeight, 10, 10, center = true); 
                    
                    translate([-CAM_PLATE_WIDTH, -NEEDLE_BED_DEPTH+10, -needleBedHeight/2])
                    cylinder(needleBedHeight, 10, 10, center = true); 
                }
                lastPoint = needleBedHeight/tan(45);
                translate([-(gauge*3)/2,-NEEDLE_BED_DEPTH,-(needleBedHeight + needleSlotHeight)])
                rotate([180,90,0])
                linear_extrude((CAM_PLATE_WIDTH*2) + 10, center = true)
                polygon(points = [[0,0],[-needleBedHeight,0],[0,-lastPoint]]);
                //frontAngle(CAM_PLATE_WIDTH * 2.5);
                /*for(i = [0:ceil(CAM_PLATE_WIDTH/gauge)]) {
                   translate([-gauge*i, 0, 0])
                   frontAngle(CAM_PLATE_WIDTH + 10);
                }*/
                // cutout for clamp
                translate([(-CAM_PLATE_WIDTH/2)+clampOffset, -NEEDLE_BED_DEPTH, -needleBedHeight])
                    cube([clampWidth, clampDepth*2, clampThickness*2], center = true); 
                clampScrews();
            }
        }
    }
}

module clampScrews() {
    // screwholes for clamp
    $fn = 50;
    /*echo((NEEDLE_BED_DEPTH-clampWidth));
    echo(ceil(clampWidth*2/3));
    echo(((NEEDLE_BED_DEPTH-clampWidth))-ceil(clampWidth*2/3));
    echo((NEEDLE_BED_DEPTH-clampDepth)-ceil(clampWidth*2/3));*/
    
    translate([(-CAM_PLATE_WIDTH/2)+clampOffset,0,-needleBedHeight]) {
        translate([0,-(NEEDLE_BED_DEPTH-clampWidth),0]) {
            translate([- clampWidth/2 + screwHeadDiam*1.5, 0, 0])
            cylinder(screwHeight*2, d = screwDiam, center = true);
            
            translate([ - clampWidth/2 + screwHeadDiam*1.5, 0, 0])
            cylinder((screwHeadHeight + tolerance)*2, d = screwHeadDiam, center = true); 
            
            translate([ + clampWidth/2 - screwHeadDiam*1.5, 0, 0])
            cylinder(screwHeight*2, d = screwDiam, center = true); 
            
            translate([ + clampWidth/2 - screwHeadDiam*1.5, 0, 0])
            cylinder((screwHeadHeight + tolerance)*2, d = screwHeadDiam, center = true); 
        }
        translate([0,floor(-clampWidth*2/3),0]) {
            translate([- clampWidth/2 + screwHeadDiam*1.5, 0, 0])
            cylinder(screwHeight*2, d = screwDiam, center = true); 
            
            translate([ - clampWidth/2 + screwHeadDiam*1.5, 0, 0])
            cylinder((screwHeadHeight + tolerance)*2, d = screwHeadDiam, center = true); 
            
            translate([ + clampWidth/2 - screwHeadDiam*1.5, 0, 0])
            cylinder(screwHeight*2, d = screwDiam, center = true); 
            
            translate([ + clampWidth/2 - screwHeadDiam*1.5, 0, 0])
            cylinder((screwHeadHeight + tolerance)*2, d = screwHeadDiam, center = true); 
        }
    }
}

module clampUnit() {
    difference() {
        // top
        translate([(-CAM_PLATE_WIDTH/2)+clampOffset-gauge , -NEEDLE_BED_DEPTH + clampDepth/2, -needleBedHeight + clampThickness/2])
            cube([clampWidth - tolerance*2, clampDepth - tolerance, clampThickness-tolerance], center = true); 
        clampScrews();
        for(i = [0:ceil(CAM_PLATE_WIDTH/gauge)]) {
           translate([-gauge*i, 0, 0])
           frontAngle(CAM_PLATE_WIDTH + 10);
        }
    }
    // front
    hull () {
        translate([(-CAM_PLATE_WIDTH/2)+clampOffset-gauge , -NEEDLE_BED_DEPTH + clampThickness/2 + 12, -(needleBedHeight - tolerance) - clampHollow/2]) {
                cube([clampWidth - tolerance*2, clampThickness, clampHollow], center = true);
            
            // rounded edge
            translate([0,0,-(clampHollow + clampThickness)/2])
            rotate([0,90,0])
            cylinder(clampWidth - tolerance*2, d = clampThickness, center = true, $fn = 30);
        }  
    }
    difference() {
        // bottom
        translate([(-CAM_PLATE_WIDTH/2)+clampOffset-gauge , -NEEDLE_BED_DEPTH + clampDepth/2 +  clampThickness/2, -(needleBedHeight - tolerance) - clampHollow - clampThickness/2 ])
        cube([clampWidth - tolerance*2, clampDepth - 25, clampThickness], center = true);
        
        
        translate([(-CAM_PLATE_WIDTH/2)+clampOffset,-clampWidth*2/3 - 18,-(needleBedHeight - tolerance) - clampHollow - clampThickness/2]) {
            // bolt hole
            cylinder(h = clampThickness*2, d = 8, center = true, $fn = 50);
            
            // nut cutout
            translate([-14.491/2,-12.55/2,clampThickness/2]) // use w/h specs from svg
            #linear_extrude(6.75, center = true)
            import("../../SVG/HexNut.svg");
        }        
    }
}

leftCarriageRest();
rightCarriageRest();