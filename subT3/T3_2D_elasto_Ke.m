
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Elastodynamic divergence + linear deformation matrix: T3
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% X -> Coordonnées du triangle
% mate -> Matériau à l'intérieur du triangle
% quadra -> Quadrature à utiliser pour calculer les intégrales sur le triangle

function Ke=T3_2D_elasto_Ke(X,mate,quadra)
    
    lambda = mate(1);
    mu = mate(2);
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);

    x123 = (x1+x2+x3)/3.;
    y123 = (y1+y2+y3)/3.;
    
    %= Aire du triangle étudié
    S = .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));
    
    if 1
        M1 = [(y2-y3)*(y2-y3) (y2-y3)*(y3-y1) (y2-y3)*(y1-y2);
              (y2-y3)*(y3-y1) (y3-y1)*(y3-y1) (y3-y1)*(y1-y2);
              (y2-y3)*(y1-y2) (y1-y2)*(y3-y1) (y1-y2)*(y1-y2)];
        
        M2 = [(x2-x3)*(x2-x3) (x2-x3)*(x3-x1) (x2-x3)*(x1-x2);
              (x2-x3)*(x3-x1) (x3-x1)*(x3-x1) (x3-x1)*(x1-x2);
              (x2-x3)*(x1-x2) (x1-x2)*(x3-x1) (x1-x2)*(x1-x2)];
        
        M3 = [(y2-y3)*(x3-x2) (y2-y3)*(x1-x3) (y2-y3)*(x2-x1);
              (y3-y1)*(x3-x2) (y3-y1)*(x1-x3) (y3-y1)*(x2-x1);
              (y1-y2)*(x3-x2) (y1-y2)*(x1-x3) (y1-y2)*(x2-x1)];
        
        K11 = ( (lambda+2*mu)*M1 + mu*M2 )/(4*S);
        
        K12 = ( lambda*M3 + mu*M3.' )/(4*S);
        
        K21 = ( lambda*M3.' + mu*M3 )/(4*S);
        
        K22 = ( (lambda+2*mu)*M2 + mu*M1 )/(4*S);
        
        Ke = [K11 K12;
              K21 K22];      
        
    elseif 0

        E1 = [1 -1 0;-1 1 0;0 0 0]/2;
        E2 = [1 0 -1;-1 0 1;0 0 0]/2;
        E3 = [1 -1 0;0 0 0;-1 1 0]/2;
        E4 = [1 0 -1;0 0 0;-1 0 1]/2;

        dxhat_dx = (y3-y1)/(2*S);
        dxhat_dy = (x1-x3)/(2*S);
        dyhat_dx = (y1-y2)/(2*S);
        dyhat_dy = (x2-x1)/(2*S);

        K11 = 2*S*( ((lambda+2*mu)*dxhat_dx^2 + mu*dxhat_dy^2)*E1 + ...
                    ((lambda+2*mu)*dxhat_dx*dyhat_dx + mu*dxhat_dy*dyhat_dy)*(E2+E3) + ...
                    ((lambda+2*mu)*dyhat_dx^2 + mu*dyhat_dy^2)*E4);
        
        K12 = 2*S*( (lambda+mu)*dxhat_dx*dxhat_dy*E1 + ...
                    (lambda*dxhat_dx*dyhat_dy + mu*dxhat_dy*dyhat_dx)*E2 + ...
                    (lambda*dxhat_dy*dyhat_dx + mu*dxhat_dx*dyhat_dy)*E3 + ...                    
                    (lambda+mu)*dyhat_dx*dyhat_dy*E4 );

        K21 = K12.';

        K22 = 2*S*( ((lambda+2*mu)*dxhat_dy^2 + mu*dxhat_dx^2)*E1 + ...
                    ((lambda+2*mu)*dxhat_dy*dyhat_dy + mu*dxhat_dx*dyhat_dx)*(E2+E3) + ...
                    ((lambda+2*mu)*dyhat_dy^2 + mu*dyhat_dx^2)*E4);

        Ke = [K11 K12;
              K21 K22];
        
    else
        
        A11 = @(x,y) [lambda+2*mu 0;0 mu];
        A12 = @(x,y) [0 mu;lambda 0];
        A21 = @(x,y) [0 lambda;mu 0];
        A22 = @(x,y) [mu 0;0 lambda+2*mu];

        % A11 = @(x,y) [lambda_ex(x,y,mate)+2*mu_ex(x,y,mate) 0;0 mu_ex(x,y,mate)];
        % A12 = @(x,y) [0 mu_ex(x,y,mate);lambda_ex(x,y,mate) 0];
        % A21 = @(x,y) [0 lambda_ex(x,y,mate);mu_ex(x,y,mate) 0];
        % A22 = @(x,y) [mu_ex(x,y,mate) 0;0 lambda_ex(x,y,mate)+2*mu_ex(x,y,mate)];
        
        B = [y3-y1 y1-y2;
             x1-x3 x2-x1]/(2*S);

        %= Gradient des fonction chapeau sur le triangle de référence =%
        %= grad_lambda_hat(:,i) = grad_lambda_hat_i
        grad_lambda_hat = [-1 1 0;
                           -1 0 1];
                
        for i=1:3
            for j=1:3
                
                f11 = @(x,y) grad_lambda_hat(:,i).' * B.' * A11(x,y) * B * grad_lambda_hat(:,j);
                f12 = @(x,y) grad_lambda_hat(:,i).' * B.' * A12(x,y) * B * grad_lambda_hat(:,j);
                f21 = @(x,y) grad_lambda_hat(:,i).' * B.' * A21(x,y) * B * grad_lambda_hat(:,j);
                f22 = @(x,y) grad_lambda_hat(:,i).' * B.' * A22(x,y) * B * grad_lambda_hat(:,j);
        
                K11(j,i) = T3_quadrature( f11 , quadra);
                K12(j,i) = T3_quadrature( f12 , quadra);
                K21(j,i) = T3_quadrature( f21 , quadra);
                K22(j,i) = T3_quadrature( f22 , quadra);

            end
        end

        Ke = 2*S*[K11 K12;
                  K21 K22];
        
    end
    
       
end

