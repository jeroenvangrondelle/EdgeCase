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


A = 22;
B = 22;
C=50;
D=30;

width = A + B + 36;
height = C + 30;

wall=2;

has_back = false;
has_seal = true;

module wall()
{
    union() {
        up(0) rect_tube($fa = 4, $fs=0.1, size1=width, size2=height, wall=wall, rounding=10, h=D);
        up(2) rect_tube($fa = 4, $fs=0.1, size1=width-2*wall, size2=height-2*wall, wall=3, rounding=8, h=26);
    }
}

module back() {
    cuboid($fa = 4, $fs=0.1,[width,height,2], rounding=10, edges=[FWD+RIGHT,FWD+LEFT,BACK+LEFT, BACK+RIGHT]);
}

module stud() {
    union() {
        difference() {
            translate([0,0,15]) cube([10, 10, 26], center=true);
            union() {
                cylinder($fa = 4, $fs=0.1, h=30, r=2);
            }
        }
        translate([5,-5,2]) cube([10,10,3]);
        translate([-5,5,2]) cube([10,10,3]);
    }
}

module support()
{
    translate([-35,-3, 2]) cube([70,6,4]);
    difference() {
        translate([-35,-1, 6]) cube([70, 2, 22]);
        translate([-25,-1.5, 9]) cube([50, 3, 24]);
    }
}


difference() {
    union() { 
        if (has_back) { back(); }
        
        wall();
        
        translate([-30,-30,0]) stud();
        translate([-30,30,0]) rotate(-90) stud();
        translate([30,-30,0]) rotate(90) stud();
        translate([30,30,0])  rotate(180) stud();
        
        support();
        
    }
    union() {
        //up(0.2) rect_tube($fa = 4, $fs=0.1, size=7.8, wall=.2, rounding=.85, h=0.15);
        //up(2.65) rect_tube($fa = 4, $fs=0.1, size=7.8, wall=.2, rounding=.85, h=0.15);
        if(!has_back && has_seal) {
            up(2.4) wire_bundle($fa = 4, $fs=0.1, [[-37, 0, 0], 
                [-37,-26.5, 0], 
                [-26.5,-26.5, 0], [-26.5,-37, 0], [26.5,-37, 0], [26.5,-26.5, 0], [37,-26.5, 0], [37, 26.5,  0], [26.5, 26.5, 0], [26.5, 37, 0], [-26.5, 37, 0], [-26.5, 26.5, 0], [-37, 26.5, 0], [-37, .01, 0]], rounding=2, wirediam=1.5, wires=1);
        }
        if(has_seal) {
        up(27.62) wire_bundle([[-37, 0, 0], 
            [-37,-26.5, 0], 
            [-26.5,-26.5, 0], [-26.5,-37, 0], [26.5,-37, 0], [26.5,-26.5, 0], [37,-26.5, 0], [37, 26.5,  0], [26.5, 26.5, 0], [26.5, 37, 0], [-26.5, 37, 0], [-26.5, 26.5, 0], [-37, 26.5, 0], [-37, .01, 0]], rounding=2, wirediam=1.5, wires=1);
        }
        
    }
}

up(27.62) wire_bundle([[-37, 0, 0], 
            [-37,-26.5, 0], 
            [-26.5,-26.5, 0], [-26.5,-37, 0], [26.5,-37, 0], [26.5,-26.5, 0], [37,-26.5, 0], [37, 26.5,  0], [26.5, 26.5, 0], [26.5, 37, 0], [-26.5, 37, 0], [-26.5, 26.5, 0], [-37, 26.5, 0], [-37, .01, 0]], rounding=2, wirediam=1.5, wires=1);
        

