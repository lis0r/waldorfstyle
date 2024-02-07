$fn=128;
r03 = 0.3;
r05 = 0.5;

module rubber(d=16,n=5) {
    R=(d/2)-8;
    A=360/n;
    color("dimgray") {
        difference() {
            rotate_extrude(angle=360, convexity=2) {
                union() {
                    translate([R+5.5-r03,19-r03]) circle(r=r03);
                    translate([0,16.49]) square(size=[R+5.5-r03,2.51]);
                    translate([0,16.49]) square(size=[R+5.5,2.51-r03]);
                    
                    difference() {
                        translate([0,4]) square(size=[R+8,12.5]);
                        translate([R+51.4902,17.4484]) circle(r=46);
                    }
                    
                    translate([R+8-r05,4-r05]) circle(r=r05);
                    square(size=[R+8-r05,4.01]);
                    square(size=[R+8,4-r05]);
                }
            }

            union() {
                rotate_extrude(angle=360, convexity=2) {
                    union() {
                        translate([0,16.49]) square(size=[R+4.5,2.52]);
                        
                        difference() {
                        translate([0,4]) square(size=[R+8,12.5]);
                        translate([R+51.4902,17.4484]) circle(r=47);
                        }
            
                        translate([0,2.99]) square(size=[R+6,1.02]);	
                        translate([0,-0.1]) square(size=[R+6.5,3.1]);            
                    }
                }
                for (i=[0:n]) {
                    rotate([0,0,A*i]) translate([0, R+6.5,10.25]) rotate([9.09,0,0]) scale([3,2,11.5]) sphere(r=0.5);
                    rotate([0,0,A*i]) translate([0, R+6.5,10.25]) rotate([9.09,0,0]) scale([3,2,11.5]) rotate([90,0,0]) cylinder(r=0.5, h=1);
                }
            }

        }
    }
}

module top(d=16,cnc=0,dmp=0) {
    R=(d/2)-8;
    dmpdist = R*.75;
    dmpa = 30;
    dmpsurf = ((dmp*sin(dmpa))+18.8) - (cos(asin(dmpdist / (R + 3.5))) * cnc);
    dmpr = dmp/(2*cos(dmpa)); //FIXME - make radius of cross section equal dmp
    if (cnc == 0) {
        difference() {
            union () {
                translate([0,0,16.8]) cylinder(r=R+4.50, h=2);
                intersection() {
                    cylinder(r=R+4.50, h=18.7);
                    translate([dmpdist,0,dmpsurf]) sphere(r=dmpr+2);
                }
            }
            if (dmp > 0) {
                translate([dmpdist,0,dmpsurf]) sphere(r=dmpr);
            }
        }
    }
    if (cnc > 0) {
        intersection() {
            cylinder(r=R+4.51, h=18.8);
            difference() {
                union() {
                    translate([0,0,16.8]) cylinder(r=R+4.50, h=2);
                    translate([0,0,18.8]) scale([R+5.5,R+5.5,cnc+2]) sphere();      
                  translate([dmpdist,0,dmpsurf]) sphere(r=dmpr+2);  
                }
                translate([0,0,18.8]) scale([R+3.5,R+3.5,cnc]) sphere(); 
                if (dmp > 0) {
                    translate([dmpdist,0,dmpsurf]) sphere(r=dmpr);
                }
            }            
        }
    }
    /*
    if (dmp > 0) {
        
        translate([dmpdist,0,dmpsurf]) {
            difference() {
            sphere(r=(dmp/2)+2);
            sphere(r=(dmp/2));
            }
        }
    }  
    */
}
        
module plastic(d=16,n=5,cnc=0,dmp=0) {
    R=(d/2)-8;
    A=360/n;
    color("fuchsia") { 
        union() {
            // Outer
            difference() {
                union() {
                    rotate_extrude(angle=360, convexity=2) {
                        union() {
                            translate([0,16.49]) square(size=[R+4.5,0.451]);
                    
                            difference() {
                                translate([0,4]) square(size=[R+8,12.5]);
                                translate([R+51.4902,17.4484]) circle(r=47);
                            }
            
                            translate([0,2.99]) square(size=[R+6,1.02]);	
                            square(size=[R+6.5,3]);
                        }
                    }
                    
                    for (i=[0:n]) {
                        rotate([0,0,A*i]) translate([0, R+6.5,10.25]) rotate([9.09,0,0]) scale([3,2,11.5]) sphere(r=0.5, $fn=128);
                        rotate([0,0,A*i]) translate([0, R+6.5,10.25]) rotate([9.09,0,0]) scale([3,2,11.5]) rotate([90,0,0]) cylinder(r=0.5, h=1, $fn=128);
                    }
                }

                translate([0,0,-0.1]) cylinder(r=R+5, h=2.11);
                translate([0,0,2]) cylinder(r1=R+5, r2=R+4.5, h=1.01);
                translate([0,0,3]) cylinder(r1=R+5, r2=R+3, h=2);
                cylinder(r=R+3, h=19);
            }
            // top
            top(d=d,cnc=cnc,dmp=dmp);
            // D shaft core
            difference() {
                union () {
                    difference() {
                        translate([0,0,3]) cylinder(r=5, h=14.51);
                        cylinder(r=3, h=17.6);                
                    }   
                    translate([-1.5,0.75,5]) scale([-1.5,2,12.5]) cube();
                    translate([-1.5,-0.75,5]) scale([-1.5,-2,12.5]) cube();
                    translate([-0.25,-3.5,14.5]) scale([.5,7,3.1]) cube();
                }
                if (cnc > 0){ 
                    translate([0,0,18.8]) scale([R+3.5,R+3.5,cnc]) sphere(); 
                }
            }
        }
    }
}

// cnc: concaveness of top, typically 3
// dmp: size of dimple in mm, 10 if present (maybe bigger?)
// n: number of nubs, should be prime

//d=16*1->n=5
//d=16*3->n=13

rubber(d=16*2, n=11);
plastic(d=16*2, n=11, cnc=0, dmp=0);
// with dimple
//plastic(d=16*3, n=5, cnc=3, dmp=10);
//top(d=16*3,cnc=4,dmp=10);