/*

TODO

- [x] border height => 3mm
- [x]  Check: lid fit
- [x] rounded studs
- [x]  tapped screw holes
- [x]  new type of rims instead of the 8 flaps?
- [x] slightly more curve in the seal?
- []  Make size actually changeable...
*/

include <BOSL2/std.scad>
include <BOSL2/wiring.scad>


A=22;
B=22;
C=50;
D=30;

width = A + B + 36; //6? 
height = C + 30;

wall=2;

has_back = true;
has_seal = true;

detail = .2;

module wall()
{
    union() {
        up(0) rect_tube($fa = 4, $fs=detail, 
            size1=width, size2=height, wall=wall, rounding=10, h=D);
        up(3) rect_tube($fa = 4, $fs=detail, 
            size1=width-2*wall, size2=height-2*wall, wall=3, rounding=8, h=24);
        
        up(4.5) right(width/2-6.5) cube([3, width-30, 3], center=true);
        up(4.5) right(-width/2+6.5) cube([3, width-30, 3], center=true);
        
        up(4.5) fwd(height/2-6.5) cube([height-30, 3, 3], center=true);
        up(4.5) fwd(-height/2+6.5) cube([height-30, 3, 3], center=true);
        
    }
}

module back() {
    up(1.5) cuboid($fa = 4, $fs=detail, [width,height,3],
        rounding=10, edges=[FWD+RIGHT,FWD+LEFT,BACK+LEFT, BACK+RIGHT]);
}

module lid() {
    difference() {
        cuboid($fa = 4, $fs=detail,[width-4-0.1, height-4-0.1, 2], 
            rounding=8, edges=[FWD+RIGHT,FWD+LEFT,BACK+LEFT, BACK+RIGHT]);
        union() {
            
            //holes
            translate([width/2-9,height/2-9,0]) {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
                up(.5) zcyl($fa = 4, $fs=detail, l=1.5, r1=2, r2=4);
            }
            translate([-(width/2-9),height/2-9,0])
            {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
                up(.5) zcyl($fa = 4, $fs=detail, l=1.5, r1=2, r2=4);
            }
            translate([width/2-9,-(height/2-9),0]) {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
               up(.5) zcyl($fa = 4, $fs=detail, l=1.5, r1=2, r2=4);
            }
            translate([-(width/2-9),-(height/2-9),0]) {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
                up(.5) zcyl($fa = 4, $fs=detail, l=1.5, r1=2, r2=4);
            }
        }
    }
}

module stud() {
    union() {
        difference() {
            translate([-5,-5,3])
            {   
                diff()
                    cube([10, 10, 24], center=false)
                        edge_mask(BACK+RIGHT) 
                            #rounding_edge_mask(l=24, r=4, orient=UP);
            }    
            translate([-1,-1,0]) cylinder($fa = 4, $fs=detail, h=30, r=2);
        }
    }
}

module support()
{
    translate([-35, -3, 3]) cube([70,6,3]);
    difference() {
        translate([-35, -1, 6]) cube([70, 2, 21]);
        translate([-25, -1.5, 9]) cube([50, 3, 23]);
    }
}

module house() {
    difference() {
        union() { 
            if (has_back) { back(); }
            
            wall();
            
            // four studs
            translate([-30,-30,0]) stud();
            translate([-30,30,0]) rotate(-90) stud();
            translate([30,-30,0]) rotate(90) stud();
            translate([30,30,0])  rotate(180) stud();
            
            support();
            
        }
        union() {
            //cube([100,100,40], center=true);
            
            // back seal, if no back
            if(!has_back && has_seal) {
                up(3.4) wire_bundle($fa = 4, $fs=detail, [
                    [-37, 0, 0], 
                    [-37,-27, 0], 
                    [-27,-27, 0], 
                    [-27,-37, 0], 
                    [27,-37, 0], 
                    [27,-27, 0], 
                    [37,-27, 0], 
                    [37, 27,  0], 
                    [27, 27, 0], 
                    [27, 37, 0], 
                    [-27, 37, 0], 
                    [-27, 27, 0], 
                    [-37, 27, 0], 
                    [-37, .01, 0]], 
                    rounding=3, wirediam=2, wires=1);
            }
            // front seal
            if(has_seal) {
                up(26.62) wire_bundle($fa = 4, $fs=detail, [
                    [-37, 0, 0], 
                    [-37,-27, 0], 
                    [-27,-27, 0], 
                    [-27,-37, 0], 
                    [27,-37, 0], 
                    [27,-27, 0], 
                    [37,-27, 0], 
                    [37, 27,  0], 
                    [27, 27, 0], 
                    [27, 37, 0], 
                    [-27, 37, 0], 
                    [-27, 27, 0], 
                    [-37, 27, 0], 
                    [-37, .01, 0]], 
                    rounding=3, wirediam=2, wires=1);
            }
        }
    }
}

house();

right(90) lid();

