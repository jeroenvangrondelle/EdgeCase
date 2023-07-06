/*
hull(){
    translate([0,0,0]) { cylinder($fa = 4, $fs=0.1, h=1, r=2); }
    translate([0,10,0]) { cylinder($fa = 4, $fs=0.1, h=2, r=2); }
    translate([10,0,0]) { cylinder($fa = 4, $fs=0.1, h=2, r=2); }
    translate([10,10,0]) { cylinder($fa = 4, $fs=0.1, h=1, r=2); }
}

*/

/*
hull(){
    translate([0,0,0]) { cylinder($fa = 4, $fs=0.1, h=2, r=2); }
    translate([0,10,0]) { cylinder($fa = 4, $fs=0.1, h=2, r=2); }
    translate([10,0,0]) { cylinder($fa = 4, $fs=0.1, h=1, r=2); }
    translate([10,10,0]) { cylinder($fa = 4, $fs=0.1, h=1, r=2); }
}
*/


include <BOSL2/std.scad>
include <BOSL2/wiring.scad>

/*
module wall()
{
    difference() {
        hull(){
            translate([-3,-3,0]) { cylinder($fa = 4, $fs=0.1, h=3, r=1); }
            translate([-3,3,0]) { cylinder($fa = 4, $fs=0.1, h=3, r=1); }
            translate([3,-3,0]) { cylinder($fa = 4, $fs=0.1, h=3, r=1); }
            translate([3,3,0]) { cylinder($fa = 4, $fs=0.1, h=3, r=1); }
        }
        union() {
            hull() {
                translate([-3,-3,-0.05]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
                translate([-3,3,-0.05]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
                translate([3,-3,-0.05]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
                translate([3,3,-0.05]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
            }
            hull() {
                translate([0,0,2.8]) {
                    translate([-3,-3,0]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
                    translate([-3,3,0]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
                    translate([3,-3,0]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
                    translate([3,3,0]) { cylinder($fa = 4, $fs=0.1, h=0.25, r=0.8); }
                }
            }
            translate([-3.5,-3.5,0]) cube([7,7,3]);
        }
    }
    
    
}
*/



module wall()
{
    union() {
        up(0) rect_tube($fa = 4, $fs=0.1, size=8, wall=.2, rounding=1, h=3);
        up(0.2) rect_tube($fa = 4, $fs=0.1, size=7.6, wall=.3, rounding=0.8, h=2.6);
    }
}

module stud() {
    union() {
        difference() {
            translate([0,0,1.5]) cube([1, 1, 2.6], center=true);
            union() {
                cylinder($fa = 4, $fs=0.1, h=3, r=0.2);
            }
        }
        translate([.5,-.5,.2]) cube([1,1,0.3]);
        translate([-.5,.5,.2]) cube([1,1,0.3]);
    }
}

module support()
{
    translate([-3.5,-0.3,0.2]) cube([7,0.6,0.4]);
    difference() {
        translate([-3.5,-0.1, 0.6]) cube([7, 0.2, 2.2]);
        translate([-2.5,-0.1, 0.9]) cube([5, 0.2, 2.4]);
    }
}


difference() {
    union() { 
        wall();
        translate([-3,-3,0]) stud();
        translate([-3,3,0]) rotate(-90) stud();
        translate([3,-3,0]) rotate(90) stud();
        translate([3,3,0])  rotate(180) stud();
        support();
    }
    union() {
        //up(0.2) rect_tube($fa = 4, $fs=0.1, size=7.8, wall=.2, rounding=.85, h=0.15);
        //up(2.65) rect_tube($fa = 4, $fs=0.1, size=7.8, wall=.2, rounding=.85, h=0.15);
       
        up(2.8) wire_bundle([[-3.7, 0, 0], [-3.7,-2.65, 0], [-2.65,-2.65, 0], [-2.65,-3.7, 0], [2.65,-3.7, 0], [2.65,-2.65, 0], [3.7,-2.65, 0], [3.7, 2.65,  0], [2.65,2.65, 0],[2.65,3.7, 0], [-2.65,3.7, 0], [-2.65,2.65, 0], [-3.7,2.65, 0], [-3.7, .01, 0]], rounding=.2, wirediam=.15, wires=1);
     
        
    }
}

