use<../parts/ribberNeedleBed.scad>;
use<../parts/ribberBackCover.scad>;
use<../parts/ribberSpongeBar.scad>;
use<../parts/ribberCarriageRest.scad>;
use<../modules/screwConnector.scad>;

/* 
Full bed assembly for layout and debugging
See individual files to export models
*/
leftCarriageRest();
needleBed();
ribberSpongeBar();
ribberBackCover();
rightCarriageRest();