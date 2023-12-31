%= T3 Quadrature on the reference triangle (0,0) - (1,0) - (0,1) =%

function res = T3_quadrature(f,type)
       
    if type=="order_1"
        
        res = .5 * f(1/3,1/3);
        
    elseif type=="order_2"
        
        res = .5 * ( f(0.5,0)+f(0,0.5)+f(.5,.5) )/3. ;
        
    elseif type=="order_3"

        res = .5 * ( 3*(f(0,0)+f(0,1)+f(1,0)) + ...
                       8*(f(0.5,0)+f(0,0.5)+f(0.5,0.5)) + ...
                          27 * f(1/3,1/3) ) / 60 ;
    elseif type=="test"

        % https://zhilin.math.ncsu.edu/TEACHING/MA587/Gaussian_Quadrature2D.pdf %
        
        w1 = 0.05283121635 ; u1 = 0.166666666   ; v1 = 0.7886751346 ;
        w2 = 0.1971687836  ; u2 = 0.6220084679  ; v2 = 0.2113248654 ;
        w3 = 0.05283121635 ; u3 = 0.04465819874 ; v3 = 0.7886751346 ;
        w4 = 0.1971687836  ; u4 = 0.1666666667  ; v4 = 0.2113248654 ;

        res = .5*( w1 * f(u1,v1) + w2 * f(u2,v2) + w3 * f(u3,v3) + w4 * f(u4,v4) )/(w1+w2+w3+w4);

    elseif type=="test2"

        w1 = 0.06943184420297371 ;u1 = 0.04365302387072518  ; v1 =0.01917346464706755  ;
        w2 = 0.06943184420297371 ;u2 = 0.214742881469342    ; v2 =0.03873334126144628  ; 
        w3 = 0.06943184420297371 ;u3 = 0.465284077898513    ; v3 =0.04603770904527855  ;
        w4 = 0.06943184420297371 ;u4 = 0.715825274327684    ; v4 =0.03873334126144628  ;
        w5 = 0.06943184420297371 ;u5 = 0.886915131926301    ; v5 =0.01917346464706755  ;
        w6 = 0.330009478207572 ;  u6 = 0.04651867752656094  ; v6 =0.03799714764789616  ;
        w7 = 0.330009478207572 ;  u7 = 0.221103222500738    ; v7 =0.07123562049953998  ;
        w8 = 0.330009478207572 ;  u8 = 0.448887299291690    ; v8 =0.07123562049953998  ;
        w9 = 0.330009478207572 ;  u9 = 0.623471844265867    ; v9 =0.03799714764789616  ;
        w10 = 0.669990521792428 ; u10 = 0.03719261778493340 ; v10 =0.02989084475992800 ;
        w11 = 0.669990521792428 ; u11 = 0.165004739103786   ; v11 =0.04782535161588505 ;
        w12 = 0.669990521792428 ; u12 = 0.292816860422638   ; v12 =0.02989084475992800 ;
        w13 = 0.930568155797026 ; u13 = 0.01467267513102734 ; v13 =0.006038050853208200;
        w14 = 0.930568155797026 ; u14 = 0.05475916907194637 ; v14 =0.006038050853208200;

        res = .5*( w1 * f(u1,v1) + w2 * f(u2,v2) + w3 * f(u3,v3) + w4 * f(u4,v4) + w5 * f(u5,v5) + w6 * f(u6,v6) + w7 * f(u7,v7) + w8 * f(u8,v8) + w9 * f(u9,v9) + w10 * f(u10,v10) + w11 * f(u11,v11) + w12 * f(u12,v12) + w13 * f(u13,v13) + w14 * f(u14,v14) )/(w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12+w13+w14);
    end
    

end

