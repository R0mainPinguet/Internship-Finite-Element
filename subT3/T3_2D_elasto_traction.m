




function traction = T3_2D_elasto_traction(X,mate,quadra)

    lambda = mate(1);
    mu = mate(2);
    
    %= Coordonnées des trois noeuds :
    %=   X1 = (x1,y1) // X2 = (x2,y2) // X3 = (x3,y3)
    x1=X(1,1); x2=X(2,1); x3=X(3,1);
    y1=X(1,2); y2=X(2,2); y3=X(3,2);

    %= Aire du triangle étudié
    S = .5*((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

    %= Matrices par bloc =%
    traction = zeros(2,6);
    
    %== Cas où la frontière est verticale ==%

    %= Dérivées des fonctions de forme =%
    dphi_x = [y2-y3 y3-y1 y1-y2]/(2*S);

    dphi_y = [x3-x2 x1-x3 x2-x1]/(2*S);

    for i=1:3
        traction(1,i)   = (lambda+2*mu) * dphi_x(i);
        traction(1,i+3) = lambda * dphi_y(i);
        traction(2,i)   = mu * dphi_y(i);
        traction(2,i+3) = mu * dphi_x(i);
    end
    
    %====%

    
end

% %%%=== CE QUI MARCHE ===%%%

% % Ordre 1

% % if x123<0
% %     K11(indexes,[1 2 3]) = K11(indexes,[1 2 3]) - (l1-l2+2*(m1-m2))*L*M4(indexes,[1 2 3]);
% %     K12(indexes,[1 2 3]) = K12(indexes,[1 2 3]) -        (l1-l2)*L*M5(indexes,[1 2 3]);
% %     K21(indexes,[1 2 3]) = K21(indexes,[1 2 3]) -        (m1-m2)*L*M5(indexes,[1 2 3]);
% %     K22(indexes,[1 2 3]) = K22(indexes,[1 2 3]) -        (m1-m2)*L*M4(indexes,[1 2 3]);
% % end

% %%%======%%%

% % Ordre 1

% % if x123>0
% %     K11(indexes,[1 2 3]) = K11(indexes,[1 2 3]) - (l1-l2+2*(m1-m2))*L*M4(indexes,[1 2 3]);
% %     K12(indexes,[1 2 3]) = K12(indexes,[1 2 3]) -        (l1-l2)*L*M5(indexes,[1 2 3]);
% %     K21(indexes,[1 2 3]) = K21(indexes,[1 2 3]) -        (m1-m2)*L*M5(indexes,[1 2 3]);
% %     K22(indexes,[1 2 3]) = K22(indexes,[1 2 3]) -        (m1-m2)*L*M4(indexes,[1 2 3]);
% % end

% %%%======%%%

% % Ordre 1

% % if x123>0
% %     K11(indexes,[1 2 3]) = K11(indexes,[1 2 3]) - (l1+2*(m1))*L*M4(indexes,[1 2 3]);
% %     K12(indexes,[1 2 3]) = K12(indexes,[1 2 3]) -        (l1)*L*M5(indexes,[1 2 3]);
% %     K21(indexes,[1 2 3]) = K21(indexes,[1 2 3]) -        (m1)*L*M5(indexes,[1 2 3]);
% %     K22(indexes,[1 2 3]) = K22(indexes,[1 2 3]) -        (m1)*L*M4(indexes,[1 2 3]);
% % else
% %     K11(indexes,[1 2 3]) = K11(indexes,[1 2 3]) + (l2+2*(m2))*L*M4(indexes,[1 2 3]);
% %     K12(indexes,[1 2 3]) = K12(indexes,[1 2 3]) +        (l2)*L*M5(indexes,[1 2 3]);
% %     K21(indexes,[1 2 3]) = K21(indexes,[1 2 3]) +        (m2)*L*M5(indexes,[1 2 3]);
% %     K22(indexes,[1 2 3]) = K22(indexes,[1 2 3]) +        (m2)*L*M4(indexes,[1 2 3]);
% % end

% %%%======%%%

% % Ordre ~2

% % K11(indexes,[1 2 3]) = K11(indexes,[1 2 3]) - (l1-l2+2*(m1-m2))*L*M4(indexes,[1 2 3])/2;
% % K12(indexes,[1 2 3]) = K12(indexes,[1 2 3]) -           (l1-l2)*L*M5(indexes,[1 2 3])/2;
% % K21(indexes,[1 2 3]) = K21(indexes,[1 2 3]) -           (m1-m2)*L*M5(indexes,[1 2 3])/2;
% % K22(indexes,[1 2 3]) = K22(indexes,[1 2 3]) -           (m1-m2)*L*M4(indexes,[1 2 3])/2;                

% %%%======%%%

%     else

%         % Normale extérieure n1
%         n1 = [(yb1-yb2);(xb2-xb1)]/L;
%         if ( n1(1)*(x123-xb12) - n1(2)*(y123-yb12) ) > 0
%             n1 = -n1;
%         end

%         % Normale intérieure n2
%         n2 = -n1;

%         if (l2==lambda) & (m2==mu)
%             n1 = -n1;
%             n2 = -n2;
%         end

%         % Valeur des fonctions de base au milieu de la frontière
%         phi = [0;0;0];
%         phi(indexes(1)) = 0.5;
%         phi(indexes(2)) = 0.5;

%         % Dérivées des fonctions de base
%         dphi=[y2-y3 x3-x2;
%               y3-y1 x1-x3;
%               y1-y2 x2-x1]/(2*S);

%         %%%===% MARCHE %===%%%

%         %  Ordre ~2

%         % for i=1:3

%         %     %==%

%         %     % Matrice divergence(phi_i \e1) Id
%         %     div_1 = dphi(i,1) * [1 0;0 1];

%         %     % Matrice eps(phi_i \e1) Id
%         %     eps_1 = [dphi(i,1) dphi(i,2)/2;dphi(i,2)/2 0];

%         %     % Sigma_1(phi_i \e1) . n1
%         %     sigma_1_1 = (l1*div_1 + 2*m1*eps_1)*n1;

%         %     % Sigma_2(phi_i \e1) . n2
%         %     sigma_2_1 = (l2*div_1 + 2*m2*eps_1)*n2;

%         %     %==%

%         %     % Matrice divergence(phi_i \e2) Id
%         %     div_2 = dphi(i,2) * [1 0;0 1];                   

%         %     % Matrice eps(phi_i \e2) Id
%         %     eps_2 = [0 dphi(i,1)/2;dphi(i,1)/2 dphi(i,2)];

%         %     % Sigma_1(phi_i \e2) . n1
%         %     sigma_1_2 = (l1*div_2 + 2*m1*eps_2)*n1;

%         %     % Sigma_2(phi_i \e2) . n2
%         %     sigma_2_2 = (l2*div_2 + 2*m2*eps_2)*n2;

%         %     %==%

%         %     for j=1:3

%         %         K11(j,i) = K11(j,i) - (sigma_1_1(1)+sigma_2_1(1)) * L * phi(j) / 2 ;
%         %         K12(j,i) = K12(j,i) - (sigma_1_2(1)+sigma_2_2(1)) * L * phi(j) / 2 ;
%         %         K21(j,i) = K21(j,i) - (sigma_1_1(2)+sigma_2_1(2)) * L * phi(j) / 2 ;
%         %         K22(j,i) = K22(j,i) - (sigma_1_2(2)+sigma_2_2(2)) * L * phi(j) / 2 ;

%         %     end

%         % end

%         %%%======%%%

%         % % MARCHE PAS %

%         % test = setdiff([1 2 3],indexes);

%         % % Matrice divergence(phi_i \e1) Id
%         % div_1 = dphi(test,1) * [1 0;0 1];

%         % % Matrice eps(phi_i \e1) Id
%         % eps_1 = [dphi(test,1) dphi(test,2)/2;dphi(test,2)/2 0];

%         % % Matrice divergence(phi_i \e2) Id
%         % div_2 = dphi(test,2) * [1 0;0 1];                   

%         % % Matrice eps(phi_i \e2) Id
%         % eps_2 = [0 dphi(test,1)/2;dphi(test,1)/2 dphi(test,2)];

%         % % Sigma_1(phi_i \e1) . n1
%         % sigma_1_1 = (l1*div_1 + 2*m1*eps_1)*n1;

%         % % Sigma_1(phi_i \e2) . n1
%         % sigma_1_2 = (l1*div_2 + 2*m1*eps_2)*n1;

%         % for i_test=1:2

%         %     i = indexes(i_test);

%         %     if x123<0
%         %         K11(i,test) = K11(i,test) - sigma_1_1(1) * L * phi(i);
%         %         K12(i,test) = K12(i,test) - sigma_1_2(1) * L * phi(i);
%         %         K21(i,test) = K21(i,test) - sigma_1_1(2) * L * phi(i);
%         %         K22(i,test) = K22(i,test) - sigma_1_2(2) * L * phi(i);
%         %     else
%         %         K11(i,test) = K11(i,test) - sigma_1_1(1) * L * phi(i);
%         %         K12(i,test) = K12(i,test) - sigma_1_2(1) * L * phi(i);
%         %         K21(i,test) = K21(i,test) - sigma_1_1(2) * L * phi(i);
%         %         K22(i,test) = K22(i,test) - sigma_1_2(2) * L * phi(i);                   
%         %     end
%         % end

%         %%%===%%%

%         % i = setdiff([1 2 3],indexes);

%         % % Matrice divergence(phi_i \e1) Id
%         % div_1 = dphi(i,1) * [1 0;0 1];

%         % % Matrice eps(phi_i \e1) Id
%         % eps_1 = [dphi(i,1) dphi(i,2)/2;dphi(i,2)/2 0];

%         % % Sigma_1(phi_i \e1) . n1
%         % sigma_1_1 = (l1*div_1 + 2*m1*eps_1)*n1;

%         % % Sigma_2(phi_i \e1) . n2
%         % sigma_2_1 = (l2*div_1 + 2*m2*eps_1)*n2;

%         % %==%

%         % % Matrice divergence(phi_i \e2) Id
%         % div_2 = dphi(i,2) * [1 0;0 1];                   

%         % % Matrice eps(phi_i \e2) Id
%         % eps_2 = [0 dphi(i,1)/2;dphi(i,1)/2 dphi(i,2)];

%         % % Sigma_1(phi_i \e2) . n1
%         % sigma_1_2 = (l1*div_2 + 2*m1*eps_2)*n1;

%         % % Sigma_2(phi_i \e2) . n2
%         % sigma_2_2 = (l2*div_2 + 2*m2*eps_2)*n2;

%         % %==%

%         % for j=1:3

%         %     if x123<0
%         %         K11(j,i) = K11(j,i) - sigma_1_1(1) * L * phi(j) ;
%         %         K12(j,i) = K12(j,i) - sigma_1_2(1) * L * phi(j) ;
%         %         K21(j,i) = K21(j,i) - sigma_1_1(2) * L * phi(j) ;
%         %         K22(j,i) = K22(j,i) - sigma_1_2(2) * L * phi(j) ;
%         %     else
%         %         K11(j,i) = K11(j,i) - sigma_2_1(1) * L * phi(j) ;
%         %         K12(j,i) = K12(j,i) - sigma_2_2(1) * L * phi(j) ;
%         %         K21(j,i) = K21(j,i) - sigma_2_1(2) * L * phi(j) ;
%         %         K22(j,i) = K22(j,i) - sigma_2_2(2) * L * phi(j) ;
%         %     end

%         % end
