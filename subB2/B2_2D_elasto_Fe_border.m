
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Nodal forces due to elasto flux: B2
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function Fe=B2_2D_elasto_Fe_border(X,mate,val,idir,quadra)

    lambda = mate(1);
    mu = mate(2);
    
    % E = mate(1);
    % nu = mate(2);    
    % lambda = E*nu/((1+nu)*(1-2*nu));
    % mu = E/(2*(1+nu));
        
    x1=X(1,1); y1=X(1,2);                      % first node
    x2=X(2,1); y2=X(2,2);                      % second node

    % x12 = (x1+x2)/2.;
    % y12 = (y1+y2)/2.;
    % lambda = lambda_ex(x12,y12);
    % mu = mu_ex(x12,y12);
    
    L = sqrt((x2-x1)^2+(y2-y1)^2);             % element length

    if 1
        
        x = (x1+x2)/2.0;
        y = (y1+y2)/2.0;
        
        g_middle = eval(val);
        
        if idir==1
            Fe = L * g_middle * [1;1;0;0] / 2.0 ;
        else
            Fe = L * g_middle * [0;0;1;1] / 2.0 ;
        end    
        
    else
        
        lambda1 = @(u) 1-u;
        lambda2 = @(u) u;
        
        if idir==1
            
            Fe = L * [ B2_quadrature( @(u) g(u) * lambda1(u) , quadra ) ;
                       B2_quadrature( @(u) g(u) * lambda2(u) , quadra ) ;
                       0                                                     ;
                       0                                                     ] ;  
            
        else
            Fe = L * [ 0                                                     ;
                       0                                                     ;
                       B2_quadrature( @(u) g(u) * lambda1(u) , quadra ) ;
                       B2_quadrature( @(u) g(u) * lambda2(u) , quadra ) ] ; 
            
        end
        
    end

    function res=g(u)
        x = x1+u*(x2-x1);
        y = y1+u*(y2-y1);

        res = eval(val);
        
    end
    
end

