/*

TODO

- [x] border height => 3mm
- [x] Check: lid fit
- [x] rounded studs
- [x] tapped screw holes
- [x] new type of rims instead of the 8 flaps?
- [x] slightly more curve in the seal?
- [] Make size actually changeable...
- [] Fix the lid spacing
- [] Make the edge (4)/lid (3) thickness independent of the case back thinckness (=2)
*/

include <BOSL2/std.scad>
include <BOSL2/wiring.scad>

// DEFAULTS, 8 by 8 box
//A=24;
//B=24;
//C=50;
//D=22;

//A=12;
//B=12;
//C=24;
//D=12;



A=16;
B=32;
C=70;
D=30;



has_back = true;
has_seal = true;
has_support = true;

wall=2;
edge=4;

width_y = A + B + 32; // 32 = 2* wand + stud + 2mm voor devider 
width_x = 62 + 30;
height = D + 2*edge;



detail = .2;
lid_gap = .1;

module wall()
{
    union() {
        up(0) rect_tube($fa = 4, $fs=detail, 
            size=[width_x, width_y], wall=wall, rounding=10, h=height);
        up(edge) rect_tube($fa = 4, $fs=detail, 
            size=[width_x-(2*wall),width_y-(2*wall)], wall=3, rounding=8, h=height-2*edge);
        
        up(edge + 1.5) right(width_x/2-6.5) cube([3, width_y-30, 3], center=true);
        up(edge + 1.5) right(-width_x/2+6.5) cube([3, width_y-30, 3], center=true);
        
        up(edge + 1.5) fwd(width_y/2-6.5) cube([width_x-30, 3, 3], center=true);
        up(edge + 1.5) fwd(-width_y/2+6.5) cube([width_x-30, 3, 3], center=true);
        
    }
}

module back() {
    up(edge/2) cuboid($fa = 4, $fs=detail, [width_x,width_y, edge],
        rounding=10, edges=[FWD+RIGHT,FWD+LEFT,BACK+LEFT, BACK+RIGHT]);
}

module lid() {
    difference() {
        cuboid($fa = 4, $fs=detail,[width_x-4-2*lid_gap, width_y-4-2*lid_gap, edge-1], 
            rounding=8-lid_gap, edges=[FWD+RIGHT,FWD+LEFT,BACK+LEFT, BACK+RIGHT]);
        union() {
            
            //holes
            translate([width_x/2-9,width_y/2-9,0]) {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
                up(edge-3) zcyl($fa = 4, $fs=detail, h=1.5, r1=2, r2=4);
            }
            translate([-(width_x/2-9),width_y/2-9,0])
            {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
                up(edge-3) zcyl($fa = 4, $fs=detail, l=1.5, r1=2, r2=4);
            }
            translate([width_x/2-9,-(width_y/2-9),0]) {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
               up(edge-3) zcyl($fa = 4, $fs=detail, l=1.5, r1=2, r2=4);
            }
            translate([-(width_x/2-9),-(width_y/2-9),0]) {
                cylinder($fa = 4, $fs=0.1, h=30, r=2, center=true);
                up(edge-3) zcyl($fa = 4, $fs=detail, l=1.5, r1=2, r2=4);
            }
        }
    }
}

module stud() {
    union() {
        difference() {
            translate([-5,-5, edge])
            {   
                diff()
                    cube([10, 10, height-2*edge], center=false)
                        edge_mask(BACK+RIGHT) 
                            #rounding_edge_mask(l=height-2*edge, r=4, orient=UP);
            }    
            translate([-1,-1,0]) cylinder($fa = 4, $fs=detail, h=height, r=2);
        }
    }
}

module support()
{
    opening_width = 0.5 * (width_x-10);
    translate([-(width_x-10)/2, -3, edge]) cube([width_x-10,6,3]);
    difference() {
        translate([-(width_x-10)/2, -1, edge+3]) cube([width_x-10, 2, D-3]);
        translate([-opening_width/2, -1.5, 9]) cube([opening_width, 3, 33]);
    }
}

module house() {
    seal_x = width_x/2 - 3;
    seal_y = width_y/2 - 3;
    
    difference() {
        union() { 
            if (has_back) { back(); }
            
            wall();
            
            // four studs
            
            translate([-(width_x-20)/2,-(width_y-20)/2,0]) stud();
            translate([-(width_x-20)/2,(width_y-20)/2,0]) rotate(-90) stud();
            translate([(width_x-20)/2,-(width_y-20)/2,0]) rotate(90) stud();
            translate([(width_x-20)/2,(width_y-20)/2,0])  rotate(180) stud();
            
            if (has_support) { support(); }
            
        }
        union() {
            //cube([100,100,40], center=true);
           
            // back seal, if no back
            if(!has_back && has_seal) {
                up(edge+0.4) wire_bundle($fa = 4, $fs=detail, [
                    [-seal_x,       0, 0], 
                    [-seal_x,       -seal_y+10, 0], 
                    [-seal_x+10,    -seal_y+10, 0], 
                    [-seal_x+10,    -seal_y, 0], 
                    [seal_x-10,     -seal_y, 0], 
                    [seal_x-10,     -seal_y+10, 0], 
                    [seal_x,        -seal_y+10,    0], 
                    [seal_x,        seal_y-10,    0], 
                    [seal_x-10,     seal_y-10, 0], 
                    [seal_x-10,     seal_y, 0], 
                    [-seal_x+10,    seal_y, 0], 
                    [-seal_x+10,    seal_y-10, 0], 
                    [-seal_x,       seal_y-10,   0], 
                    [-seal_x, .01,  0]], 
                    rounding=3, wirediam=2, wires=1);
            }
            // front seal
            if(has_seal) {
               //was 26.62
                up(D + edge - 0.4) wire_bundle($fa = 4, $fs=detail, [
                    [-seal_x,       0, 0], 
                    [-seal_x,       -seal_y+10, 0], 
                    [-seal_x+10,    -seal_y+10, 0], 
                    [-seal_x+10,    -seal_y, 0], 
                    [seal_x-10,     -seal_y, 0], 
                    [seal_x-10,     -seal_y+10, 0], 
                    [seal_x,        -seal_y+10,    0], 
                    [seal_x,        seal_y-10,    0], 
                    [seal_x-10,     seal_y-10, 0], 
                    [seal_x-10,     seal_y, 0], 
                    [-seal_x+10,    seal_y, 0], 
                    [-seal_x+10,    seal_y-10, 0], 
                    [-seal_x,       seal_y-10,   0], 
                    [-seal_x, .01,  0]], 
                    rounding=3, wirediam=2, wires=1);
            }
        }
    }
}

house();

right(100) lid();

