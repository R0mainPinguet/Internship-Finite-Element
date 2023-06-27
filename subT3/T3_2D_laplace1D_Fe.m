
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Helmholtz right hand side vector: T3
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



function Fe=T3_2D_laplace1D_Fe(X,mate,type,uex,indexes_border)
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);
    
    x123 = (x1+x2+x3)/3.;
    y123 = (y1+y2+y3)/3.;
    
    %= Aire du triangle étudié
    S= .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));
    
    %= Fonctions de forme sur le triangle de référence
    lambda1 = @(xhat,yhat) 1-xhat-yhat;
    lambda2 = @(xhat,yhat) xhat;
    lambda3 = @(xhat,yhat) yhat;

    
    Fe = 2*S*[T3_quadrature( @(x,y) f(x,y,1)*lambda1(x,y) , type );
              T3_quadrature( @(x,y) f(x,y,1)*lambda2(x,y) , type );
              T3_quadrature( @(x,y) f(x,y,1)*lambda3(x,y) , type )];
           

    % if x123>0 & length(indexes_border)>0
    %     Fe(indexes_border) = zeros(length(indexes_border),1);
    % end
    
    function z=f(xhat,yhat,dir)
        x = x1*lambda1(xhat,yhat) + x2*lambda2(xhat,yhat) + x3*lambda3(xhat,yhat);
        y = y1*lambda1(xhat,yhat) + y2*lambda2(xhat,yhat) + y3*lambda3(xhat,yhat);
        
        z = F_ex(x,y,mate,dir,uex);
    end
    
end
