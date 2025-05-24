include<params.scad>;
//include<needlebed.scad>;

module screwHoles(screw) {
    
    
    // "screw" is passed in during the loop to place holes at either end of the assembly
    if (screw > 0) { //left half
       // spongebar screw
       translate([gauge/2,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR/2, 0]) {
         cylinder(h = needleBedHeight*2 + 1, d = screwDiamSm, center = true, $fn = 25); 
         translate([0,0,railHeight]) 
             cylinder(h = screwHeadHeight*2 + tolerance, d = screwHeadDiamSm, center = true, $fn = 25);   
       }
       // back screw, back cover
       translate([gauge/2, -5, 0]) {
         cylinder(h = needleBedHeight*2 + 1, d = screwDiamSm, center = true, $fn = 25);
                cylinder(h = screwHeadHeight*2 + tolerance, d = screwHeadDiamSm, center = true, $fn = 25);   
       }    
         // front screw, back cover
       translate([gauge/2, -BACK_COVER + 5, 0]) {
         cylinder(h = needleBedHeight*2 + 1, d = screwDiamSm, center = true, $fn = 25);  
          cylinder(h = screwHeadHeight*2 + tolerance, d = screwHeadDiamSm, center = true, $fn = 25);   
       }
     }
     
     if (screw < 0) { //right half
       // spongebar screw
       translate([-gauge/2,-(NEEDLE_BED_DEPTH-COMB) + SPONGE_BAR/2, 0]) {
         cylinder(h = needleBedHeight*2 + 1, d = screwDiamSm, center = true, $fn = 25); 
         translate([0,0,railHeight]) 
             cylinder(h = screwHeadHeight*2 + tolerance, d = screwHeadDiamSm, center = true, $fn = 25);   
       }
       // back screw, back cover
       translate([-gauge/2, -5, 0]) {
         cylinder(h = needleBedHeight*2 + 1, d = screwDiamSm, center = true, $fn = 25);
                cylinder(h = screwHeadHeight*2 + tolerance, d = screwHeadDiamSm, center = true, $fn = 25);   
       }    
         // front screw, back cover
       translate([-gauge/2, -BACK_COVER + 5, 0]) {
         cylinder(h = needleBedHeight*2 + 1, d = screwDiamSm, center = true, $fn = 25);  
          cylinder(h = screwHeadHeight*2 + tolerance, d = screwHeadDiamSm, center = true, $fn = 25);   
       }
     }
  
}

//screwHoles(screw = 1);
module needleBedScrews() {
    screwOffset = (floor(numNeedles/2) - screwPlacement);
    for(i = [-1:1]){
        translate([gauge*numNeedles*i,0,0]){
            if (i > -1) {
                translate([gauge*(screwOffset-1), 0, 0]) screwHoles(screw = 1);
            }
            if (i < 1) {
                translate([gauge*(numNeedles-(screwOffset+1)), 0, 0]) screwHoles(screw = 1);
            }
        }
    }
}

needleBedScrews() {
}