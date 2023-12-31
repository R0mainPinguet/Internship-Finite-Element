
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Elastodynamic with Finite Element method
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

if(isdeployed==false)
    addpath(genpath('.'))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preprocessor phase: reads input from file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%========================%

%= VERBOSE =%
verbose_mesh = 0;
verbose_assemblage = 0;
verbose_load = 0;
verbose_erreur = 0;

%= PLOTS =%
plot_u = 1;
save_u = 0;
regions_to_plot = [1];

% Choice = 1,2 -> Affiche les deux composantes de la solution approchée
% Choice = 3,4 -> Affiche les deux composantes de la solution exacte
% Choice = 5,6 -> Affiche les deux composantes de l'erreur
% Choice = 7,8 -> Affiche les deux composantes de la solution approchée ( version heatmap , avec les discontinuités en rouge )
choice = 8;

%= VIDEOS =%
save_video_u = 1;

%========================%

%= Read the input file with the exact solution, boundary condition, quadrature

% read_input_circle_elasto2D;
% read_input_circle_sep_vert_elasto2D;

% read_input_square_elasto2D;
% read_input_square_sep_vert_elasto2D;
% read_input_square_sep_circle_elasto2D;
% read_input_square_sep_sinus_elasto2D;
% read_input_square_sep_3mat_elasto2D
read_input_square_sep_dent_elasto2D

%==%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%== Définition des différents types d'analyse ==%
%== tag -> Nom de l'analyse
%== ndof -> Nombre de degrés de libertés du problème par noeud
%== DG -> Dimension du problème ( 2D or 3D )
%== Sdim -> Dimension du stress ( ? )

%== Pour un problème solide, ndof = DG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%==% Marc Bonnet
% La(1)=struct('tag','2D_therm_','ndof',1,'DG',2,'Sdim',2); % thermal 2D
% La(2)=struct('tag','AX_therm_','ndof',1,'DG',2,'Sdim',3); % thermal AXI
% La(3)=struct('tag','3D_therm_','ndof',1,'DG',3,'Sdim',3); % thermal 3D

% La(4)=struct('tag','2A_solid_','ndof',2,'DG',2,'Sdim',3);  % solid plane-strain
% La(5)=struct('tag','2S_solid_','ndof',2,'DG',2,'Sdim',3);  % solid plane-stress
% La(6)=struct('tag','AX_solid_','ndof',2,'DG',2,'Sdim',4);  % solid AXI
% La(7)=struct('tag','3D_solid_','ndof',3,'DG',3,'Sdim',6);  % solid 3D

% La(8)=struct('tag','2A_fluidsolid_','ndof',2,'DG',2,'Sdim',3);  % fluid-solid 2D
% La(9)=struct('tag','2A_fluid_','ndof',1,'DG',2,'Sdim',3);  % fluid 2D (scalaire)
%==%

La(10) = struct('tag','2D_elasto_','ndof',2,'DG',2,'Sdim',0); % 2D Elastodynamic ( Problème fréquentiel / Problème temporel )

%= Cas tests =%
% La(11)=struct('tag','2D_laplace1D_','ndof',1,'DG',2,'Sdim',0); % 1D Laplacien
% La(12)=struct('tag','2D_laplace2D_','ndof',2,'DG',2,'Sdim',0); % 2D Laplacien
% La(13)=struct('tag','2D_elasto1D_','ndof',1,'DG',2,'Sdim',0); % 1D Elasto
%==%

Atag = La(analysis.type).tag;
ndof = La(analysis.type).ndof; 
DG = La(analysis.type).DG; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%== Définition des différents types d'éléments ==%
%== tag -> Nom de l'élément
%== ne -> Nombre de noeuds par éléments
%== c -> Nombre de noeud à rajouter pour créer un nouvel élément
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Le(1)=struct('tag','B2_','ne',2,'c',1); 
Le(2)=struct('tag','T3_','ne',3,'c',1); 
Le(3)=struct('tag','Q4_','ne',4,'c',2); 
Le(4)=struct('tag','P4_','ne',4,'c',1); 
Le(8)=struct('tag','B3_','ne',3,'c',2); 
Le(9)=struct('tag','T6_','ne',6,'c',3); 

readgmsh  % input file is read

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defines numbering of unknown nodal values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

neq=0;

%= Numérotation des inconnues u sur tout le domaine =%
for d=1:ndof
    for e=1:analysis.NE                      % global numbering of unknowns
        
        type=elements(e).type;
        ne=Le(type).ne;   
        connec=elements(e).nodes;
        
        for n=1:ne,
            node=connec(n);
            if nodes(node).dof(d) == 0            % if no displacement bc are enforced on node
                neq=neq+1;                       %   increments equation number
                nodes(node).dof(d) = neq;          %   and assigns value to current dof
            end  
        end
        
    end 
end
%==%

analysis.neq = neq;

%-----------------------------------------------------------------------------------------
disp(['Number of nodes : ' num2str(analysis.NN)]);
disp(['Number of elements : ' num2str(analysis.NE)]);
disp(['Number of loads : ' num2str(analysis.NL)]);
disp(['Number of continuous segments : ' num2str(analysis.NC)]);
disp(['Number of equations : ' num2str(analysis.neq)]);
%-----------------------------------------------------------------------------------------

if verbose_mesh
    
    disp("##== NODES ==##");
    for i=1:NN
        disp(i);
        disp(nodes(i));
        disp("--");
    end
    
    disp("##== ELEMENTS ==##");
    for i=1:NE
        disp(i);
        disp(elements(i));
        disp("--");
    end
    
    disp("##== LOADS ==##");
    for i=1:NL
        disp(i);
        disp(loads(i));
        disp("--");
    end
    
    disp("##== FRONTIERE ==##");
    for i=1:NC
        disp(i);
        disp(frontiere(i));
        disp("--");
    end
    
    quit;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% allocation of sparse matrix (with estimate of the number of non zero coefficients)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%= Nombre d'inconnues u dans tout le domaine =%

nm = zeros(analysis.NN,1);                     % initialisation of nm

for e=1:analysis.NE                         % loop over elements
    type=elements(e).type;
    connec=elements(e).nodes;                   % gets connectivity
    for n=1:Le(type).ne
        node=connec(n);   
        if nm(node)==0 
            nm(node)=nm(node)+Le(type).ne;
        else
            nm(node)=nm(node)+Le(type).c;             % nk is incr. on connec. nodes
        end
    end 
end

s = sum(nm); 

%==%

ncoeffs = ndof^2*s;



if analysis.problem==1

    % Allocation de la matrice de divergence + tenseur des déformations linéarisé
    K = spalloc(analysis.neq,analysis.neq,ncoeffs);

    % Allocation du second membre
    F = zeros(analysis.neq,1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Phase d'assemblage : Matrice du système et forces nodales dû au déplacement imposé.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    percold = 0;
    h = 0;

    %% ELEMENTS TRIANGULAIRES %%

    for e=1:analysis.NE,         

        %-----------------------------------------------------------------------------------------
        perc=20*floor(5*e/analysis.NE);
        if perc~=percold,
            percold=perc;
            disp(['Assembling: ' num2str(percold) '%'])
        end
        %-----------------------------------------------------------------------------------------
        
        type = elements(e).type;               % Type de l'élément ( segment, triangle ... )
        Etag = Le(type).tag;                   % Nom du type ( D2 , T3 ... )
        ne = Le(type).ne;                      % Nombre de fonctions de base par élément
        
        Dne = ndof*ne;                         % Nombre de valeurs nodales par élément de surface
        mat = material(elements(e).mat,:);   % Matériau de l'élément
        
        Xe=zeros(ne,DG);                     % Coordonnées des noeuds de l'élément
        Ge=zeros(Dne,1);                     % Index globaux des valeurs nodales de l'élément
        Ue=zeros(Dne,1);                     % Valeurs nodales de l'élément
        
        pos=1;
        
        %= Remplit : Xe ( coordonnées des noeuds de l'élément )                 =%
        %=           Ge ( index globaux des équations des noeuds de l'élément ) =%
        %=           Ue ( valeurs prises par la fonction si condition de bord ) =%
        for n=1:ne
            node=elements(e).nodes(n);
            
            Xe(n,:) = nodes(node).coor;                 % creates element
            
            for ind=1:ndof
                Ge(pos+(ind-1)*ne) = nodes(node).dof(ind);
                Ue(pos+(ind-1)*ne) = nodes(node).U(ind);
            end
            
            pos = pos+1;
            
        end    
        
        %= Indexage des inconnues et des équations =%
        Le0=find(Ge>0);                        % Numérotation locale des inconnues
        LeD = find(Ge<0);                      % Numérotation locale des conditions de bord imposées
        Ie = Ge(Le0);                          % Numérotation globale des inconnues

        %= Calcul de h =%
        eval(['run ', Etag , 'mesh_info.m']);
        %====%
        
        %==% Ke = matrice ( divergence + tenseur des deformations linéarisé )
        Ke = eval([Etag Atag 'Ke(Xe,mat,quadrature_T3)']);

        %==% Me = matrice de masse
        rho = mat(3) ; omega = onde_incidente(1);
        Me = - rho * omega^2 * eval([Etag Atag 'Me(Xe)']);
        K(Ie,Ie) = K(Ie,Ie) + Me(Le0,Le0);
        
        %==% Fe = Second membre
        Fe = eval([Etag Atag 'Fe(Xe,[0 0],mat,geo,onde_incidente,quadrature_T3,uex)']);
        
        %= MATRICE =%
        % Matrice globale K ( divergence + tenseur des déformations linéarisé + masse )
        K(Ie,Ie) = K(Ie,Ie) + Ke(Le0,Le0) ;
        
        
        %= SECOND MEMBRE =%
        % Assemblage du second membre : Dirichlet non homogène
        F(Ie) = F(Ie) - ( Ke(Le0,LeD) + Me(Le0,LeD) ) *Ue(LeD);
       
        % Assemblage du second membre : Terme source
        F(Ie) = F(Ie) + Fe(Le0);
        %====%
        
        if verbose_assemblage
            
            disp("elements(e)");
            disp(elements(e));
            
            disp("Xe");
            disp(Xe);
            
            disp("nodes");
            disp(nodes(elements(e).nodes(1)));
            disp(nodes(elements(e).nodes(2)));
            disp(nodes(elements(e).nodes(3)));
            
            disp("Ge");
            disp(Ge);
            
            % disp("Ge_traction");
            % disp(Ge_traction);
            
            disp("Le0");
            disp(Le0);
            
            % disp("Le0_traction");
            % disp(Le0_traction);
            
            disp("Ke");
            disp(Ke);
            
            disp("Ke(Le0,Le0)");
            disp(Ke(Le0,Le0));
            
            % disp("K");
            % disp(K);
            
            disp("LeD");
            disp(LeD);

            % disp("Ue");
            % disp(Ue);
            
            % disp("Ue(LeD)");
            % disp(Ue(LeD));
            
            disp("Fe");
            disp(Fe);
            
            disp("Fe(Le0)");
            disp(Fe(Le0));

            % disp("F");
            % disp(F);

            disp("#=======#");
            
            % quit;
        end
        
    end


    % disp("K=");
    % disp(K);

    % disp("F=");
    % disp(F);

    % quit;


    %% FRONTIERE (S) %%

    percold = 0;
    for e2=1:analysis.NC,         
        
        %-----------------------------------------------------------------------------------------
        perc=20*floor(5*e2/analysis.NC);
        if perc~=percold,
            percold=perc;
            disp(['Assembling border: ' num2str(percold) '%'])
        end
        %-----------------------------------------------------------------------------------------
        
        type = frontiere(e2).type;               % Type de l'élément ( segment, triangle ... )
        left_mat = material(frontiere(e2).left_material,:);
        right_mat = material(frontiere(e2).right_material,:);
        jump_func = frontiere(e2).jump_function;
        
        Etag=Le(type).tag;                     % Nom du type ( D2 , T3 ... )
        ne=Le(type).ne;                        % Nombre de fonctions de base par élément
        
        Dne=ndof*ne;                           % Nombre de valeurs nodales par élément de surface
        
        Xe = zeros(ne,DG);                     % Coordonnées des noeuds de l'élément
        Ge = zeros(Dne,1);                     % Index globaux des valeurs nodales de l'élément
        
        pos=1;
        
        %= Remplit : Xe ( coordonnées des noeuds de l'élément )                 =%
        %=           Ge ( index globaux des équations des noeuds de l'élément ) =%
        for n=1:ne
            node = frontiere(e2).nodes(n);
            
            Xe(n,:) = nodes(node).coor;                 % creates element
            
            for ind=1:ndof
                Ge(pos+(ind-1)*ne) = nodes(node).dof(ind);
            end
            
            pos=pos+1;
            
        end
        
        %= Indexage des inconnues et des équations =%
        Le0 = find(Ge>0);                        % Numérotation locale des inconnues
        LeD = find(Ge<0);               % Numérotation locale des valeurs au bord connues
                                        %====%
        
        Ie = Ge(Le0);
        
        %= frontiere_e = matrice d'intégrale de la traction contre une fonction test sur la frontière  =%
        frontiere_e = eval([Etag Atag 'frontiere(Xe,quadrature_B2,geo,left_mat,right_mat,jump_func)']);
        %==%
        
        F(Ie) = F(Ie) - frontiere_e(Le0);
        
    end


    % disp("K=");
    % disp(K);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % assemblage phase: nodal loads due to surface tractions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for e=1:analysis.NL,                         % for each element in loads
        
        type=loads(e).type;                      % type of the element
        Etag=Le(type).tag;                       % element tag
        
        ne=Le(type).ne;                          % number of nodes 
        Dne=ndof*ne;                             % num of nodal values in one element
        
        idir = loads(e).dir;                       % traction direction
        val = loads(e).val;                        % traction value ( string )
        mat = material(loads(e).mat,:);
        
        Xe=zeros(ne,DG);                         % Coordinates of the nodes
        Ge=zeros(Dne,1);                         % Global indexes of the nodes

        pos=1;

        for n=1:ne                                 
            node=loads(e).nodes(n);   
            Xe(n,:) = nodes(node).coor;               % matrix of nodal coords
            
            for ind=1:ndof
                Ge(pos+(ind-1)*ne) = nodes(node).dof(ind);
            end
            
            pos=pos+1;
        end
        
        %= Second membre =%
        Fe = eval([Etag Atag 'Fe_border(Xe,mat,val,idir,quadrature_B2)']);
        
        Le0 = find(Ge>0);                           % finds non-zero entries of dofe
        Ie = Ge(Le0);
        
        F(Ie) = F(Ie) + Fe(Le0);
        %==========%

        
        
        if verbose_load
            disp("loads(e)");
            disp(loads(e));

            disp("Ge");
            disp(Ge);

            disp("Le0");
            disp(Le0);
            
            disp("Ie");
            disp(Ie);

            disp("Fe");
            disp(Fe);

            disp("Fe(Le0)");
            disp(Fe(Le0));

            disp("#==============#");

            % quit;
        end
        
    end 



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Resolution of the system
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %= U est un vecteur de taille neq =%

    U = K\F;

    disp("Longueur de U");
    disp(length(U));

    disp("Erreur dans la résolution du système : ||KU-F||_2 :");
    disp(norm(K*U-F));

    error_vect = zeros(1,length(U));

    %= Remplit les noeuds avec la solution calculée U  =%
    for n=1:length(nodes)
        for d=1:ndof

            dof = nodes(n).dof(d);
            
            %= Si pas de condition Dirichlet sur cette équation =%
            if(dof>0)
                nodes(n).U(d) = U( dof );
                error_vect(dof) = abs( U(dof) - eval('U_ex(nodes(n).coor(1),nodes(n).coor(2),[0 0],geo,onde_incidente,d,uex)') );
            end
            %========%
            
        end
    end

    %= On retire de l'affichage les régions que l'on ne veut pas voir =%
    for e=1:analysis.NE
        
        type=elements(e).type;               % Type de l'élément ( segment, triangle ... )
        Etag=Le(type).tag;                   % Nom du type ( D2 , T3 ... )

        ne=Le(type).ne;                      % Nombre de fonctions de base par élément
        Dne=ndof*ne;                         % num of nodal values in one element

        if ~ismember(elements(e).mat,regions_to_plot)
            for n=1:ne

                node = elements(e).nodes(n);
                onBorder = 0;
                for nC=1:NC
                    if ismember(node,frontiere(nC).nodes) & ( ismember(frontiere(nC).left_material,regions_to_plot) | ismember(frontiere(nC).right_material,regions_to_plot) )
                        onBorder = 1;
                    end
                end
                if onBorder==0
                    for d=1:ndof
                        nodes(node).U(d) = NaN;
                    end
                end
  
            end
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calcul de l'erreur 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    errorL2 = 0;
    errorGradL2 = 0;

    errorH1 = 0;

    for e=1:analysis.NE
        
        type=elements(e).type;               % Type de l'élément ( segment, triangle ... )
        Etag=Le(type).tag;                   % Nom du type ( D2 , T3 ... )

        ne=Le(type).ne;                      % Nombre de fonctions de base par élément
        Dne=ndof*ne;                         % num of nodal values in one element
        
        Xe=zeros(ne,DG);                     % Coordonnées des noeuds de l'élément
        Ge=zeros(Dne,1);                     % Index globaux des valeurs nodales de l'élément
        
        pos=1;
        
        %= Remplit : Xe ( coordonnées des noeuds de l'élément )                 =%
        %=           Ge ( index globaux des équations des noeuds de l'élément ) =%
        for n=1:ne
            node=elements(e).nodes(n);
            
            Xe(n,:) = nodes(node).coor;                 % creates element
            
            for ind=1:ndof
                Ge(pos+(ind-1)*ne) = nodes(node).dof(ind);
            end
            
            pos=pos+1;
        end
        
        Le0 = find(Ge>0);                       % Numérotation locale des inconnues
        Ie = Ge(Le0);                           % Numérotation globale des inconnues
        
        Me = eval([Etag Atag 'Me(Xe)']);
        Re = eval([Etag Atag 'Re(Xe)']);
        
        error_vect_local = zeros(1,Dne);
        error_vect_local(Le0) = error_vect(Ie);
        
        errorL2 = errorL2 + error_vect_local * Me * error_vect_local.' ;
        errorGradL2 = errorGradL2 + error_vect_local * Re * error_vect_local.';
        
    end
    
    errorL2 = sqrt(errorL2);
    errorGradL2 = sqrt(errorGradL2);
    
    errorH1 = sqrt(errorL2^2 + errorGradL2^2);
    
    disp("h = ");
    disp(h);

    disp("Erreur L2 :");
    disp(errorL2);

    disp("Erreur H1 :");
    disp(errorH1);


    Triangles = zeros(analysis.NE,3);
    X = zeros(analysis.NN);
    Y = zeros(analysis.NN);

    %== Première et deuxième composantes approchées
    Z1 = zeros(analysis.NN);
    Z2 = zeros(analysis.NN);

    %== Première et deuxième composantes exactes
    Zex1 = zeros(analysis.NN);
    Zex2 = zeros(analysis.NN);

    %== Première et deuxième composantes de l'erreur
    Eps1 = zeros(analysis.NN);
    Eps2 = zeros(analysis.NN);

    for n=1:analysis.NE
        Triangles(n,:) = elements(n).nodes;
    end

    test = zeros(analysis.NN,1);

    for n=1:analysis.NN

        node = nodes(n);
        
        if test(n)==0
            
            X(n) = node.coor(1);
            Y(n) = node.coor(2);
            
            % Z1(n) = real(node.U(1));
            % Z2(n) = real(node.U(2));
            
            % Pour le problème fréquentiel, on retire u^I à la solution approchée u^1
            Z1(n) = real(node.U(1)-U_ex(node.coor(1),node.coor(2),[0 0],geo,onde_incidente,1,uex));
            Z2(n) = real(node.U(2)-U_ex(node.coor(1),node.coor(2),[0 0],geo,onde_incidente,2,uex));
            
            Zex1(n) = U_ex(node.coor(1),node.coor(2),[0 0],geo,onde_incidente,1,uex);
            Zex2(n) = U_ex(node.coor(1),node.coor(2),[0 0],geo,onde_incidente,2,uex);
            
            Eps1(n) = Z1(n) - Zex1(n);
            Eps2(n) = Z2(n) - Zex2(n);

            test(n) = 1;
            
        end
        
    end

    %=======================================%

    

    if plot_u

        if choice==7 | choice==8

            %= Version Heatmap =%
            if choice==7
                trisurf(Triangles,X,Y,zeros(analysis.NN),Z1,"LineStyle","none");
                hold on;
            else
                trisurf(Triangles,X,Y,zeros(analysis.NN),Z2,"LineStyle","none");
                hold on;
            end
            
            %= Caméra du dessus =%
            view([0 0 1]);
            set(gcf, 'Position',  [100, 100, 700, 700]);

            
            %= Pour afficher les frontières en rouge =%
            if analysis.NC > 0
                
                Xf = zeros(1,1);
                Yf = zeros(1,1);
                left_mat = frontiere(1).left_material;
                right_mat = frontiere(1).right_material;
                posBorder = 0;
                foundNode = zeros(analysis.NN,1);

                for e2=1:analysis.NC
                    
                    %= Si on change de frontière =%
                    if ~(left_mat==frontiere(e2).left_material) | ~(right_mat==frontiere(e2).right_material)

                        plot3(Xf,Yf,zeros(length(Xf),1),'Color','r');
                        hold on;
                        Xf = zeros(1,1);
                        Yf = zeros(1,1);
                        left_mat = frontiere(e2).left_material;
                        right_mat = frontiere(e2).right_material;
                        posBorder = 0;
                        foundNode = zeros(analysis.NN,1);
                        
                    end
                    
                    for n=1:2
                        node = frontiere(e2).nodes(n);
                        if foundNode(node)==0
                            foundNode(node)=1;
                            
                            posBorder = posBorder+1;
                            Xf(posBorder) = nodes(node).coor(1);
                            Yf(posBorder) = nodes(node).coor(2);
                        end
                    end
                    
                end
                
            end
            %===%

            %==%
            plot3(Xf,Yf,zeros(length(Xf),1),'Color','r');
            hold off;
            %==%
            
            colorbar;
            grid on;
            
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            
            if save_u
                saveas(gcf, fileName);
                clf;
            end
            
        elseif choice==1 | choice==2 | choice==3 | choice==4 |choice==5 | choice==6

            colorbar;
            grid on;
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            
            if choice==1
                trisurf(Triangles,X,Y,Z1);
                % title(strcat('Première composante de la solution approchée. h = ',num2str(h,'%.5f')));
            elseif choice==2
                trisurf(Triangles,X,Y,Z2);
                % title(strcat('Deuxième composante de la solution approchée. h = ',num2str(h,'%.5f')));
            elseif choice==3
                trisurf(Triangles,X,Y,Zex1);
                % title(strcat('Première composante de la solution exacte. h = ',num2str(h,'%.5f')));
            elseif choice==4
                trisurf(Triangles,X,Y,Zex2);
                % title(strcat('Deuxième composante de la solution exacte. h = ',num2str(h,'%.5f')));
            elseif choice==5
                trisurf(Triangles,X,Y,Eps1);
                % title(strcat('Première composante de l'erreur. h = ',num2str(h,'%.5f')));
            elseif choice==6
                trisurf(Triangles,X,Y,Eps2);
                % title(strcat('Deuxième composante de l'erreur. h = ',num2str(h,'%.5f')));
            end
                
            % if save_u
            %     saveas(gcf , strcat("fonctions/",uex,"_1_appro.png"));
            % end

        end
        
        %quit;
        
    end

elseif analysis.problem==2

    % Allocation de la Matrice de divergence + tenseur des déformations linéarisé // Matrice de densité
    K = spalloc(analysis.neq,analysis.neq,ncoeffs);
    M = spalloc(analysis.neq,analysis.neq,ncoeffs);
    
    % Allocation du second membre
    F = zeros(analysis.neq,1);
    
    %== Pas de temps / Temps final / Étapes à stocker==%
    dt = 0.05;
    T = 1;
    Nt = int8(T/dt)+1;
    %====%
    
    %= Allocation et remplissage des conditions initiales =%
    U0 = zeros(analysis.neq,1);
    U1 = zeros(analysis.neq,1);
    
    for node=1:analysis.NN
        x = nodes(node).coor(1);
        y = nodes(node).coor(2);
        
        d1 = nodes(node).dof(1); d2 = nodes(node).dof(2);
        
        if(d1>0)
            U0(d1) = U_ex(x,y,0,geo,onde_incidente,1,uex);
            U1(d1) = U_ex(x,y,dt,geo,onde_incidente,1,uex);
        end
        
        if(d2>0)
            U0(d2) = U_ex(x,y,0,geo,onde_incidente,2,uex);
            U1(d2) = U_ex(x,y,dt,geo,onde_incidente,2,uex);
        end
        
    end
    %===%

    h = 0;
    
    %= Calcul de K et de l'inverse de la matrice de M ( dépendent pas du temps )
    percold = 0;
    for e=1:analysis.NE,         

        %-----------------------------------------------------------------------------------------
        perc=20*floor(5*e/analysis.NE);
        if perc~=percold,
            percold=perc;
            disp(['Assembling: ' num2str(percold) '%'])
        end
        %-----------------------------------------------------------------------------------------
        
        type = elements(e).type;               % Type de l'élément ( segment, triangle ... )
        Etag = Le(type).tag;                   % Nom du type ( D2 , T3 ... )
        ne = Le(type).ne;                      % Nombre de fonctions de base par élément
        
        Dne = ndof*ne;                         % Nombre de valeurs nodales par élément de surface
        mat = material(elements(e).mat,:);     % Matériau de l'élément
        
        Xe = zeros(ne,DG);                     % Coordonnées des noeuds de l'élément
        Ge = zeros(Dne,1);                     % Index globaux des valeurs nodales de l'élément
        
        pos = 1;
        
        %= Remplit : Xe ( coordonnées des noeuds de l'élément )                 =%
        %=           Ge ( index globaux des équations des noeuds de l'élément ) =%
        for n=1:ne
            node=elements(e).nodes(n);
            
            Xe(n,:) = nodes(node).coor;                 % creates element
            
            for ind=1:ndof
                Ge(pos+(ind-1)*ne) = nodes(node).dof(ind);
            end
            
            pos = pos+1;
            
        end    
        
        %= Indexage des inconnues et des équations =%
        Le0 = find(Ge>0);                      % Numérotation locale des inconnues
        Ie  = Ge(Le0);                         % Numérotation globale des inconnues

        %= Calcul de h =%
        eval(['run ', Etag , 'mesh_info.m']);
        %====%
        
        %==% Ke = matrice ( divergence + tenseur des deformations linéarisé )
        Ke = eval([Etag Atag 'Ke(Xe,mat,quadrature_T3)']);
        K(Ie,Ie) = K(Ie,Ie) + Ke(Le0,Le0) ;
        
        %==% Me = matrice de masse
        rho = mat(3);
        Me = rho * eval([Etag Atag 'Me(Xe)']);
        M(Ie,Ie) = M(Ie,Ie) + Me(Le0,Le0);
        
    end
    
    disp(strcat("h = " , num2str(h)));
    
    invM = inv(M);

    t = dt;
    iteration = 1;
    
    %== Version implicite ==%
    while t < T
        
        t = t+dt;
        iteration = iteration+1;

        disp(strcat("t = ",num2str(t)));
        
        F = zeros(analysis.neq,1);
        
        for e=1:analysis.NE,         

            type = elements(e).type;               % Type de l'élément ( segment, triangle ... )
            Etag = Le(type).tag;                   % Nom du type ( D2 , T3 ... )
            ne = Le(type).ne;                      % Nombre de fonctions de base par élément
            
            Dne = ndof*ne;                          % Nombre de valeurs nodales par élément de surface
            mat = material(elements(e).mat,:);      % Matériau de l'élément
            
            Xe=zeros(ne,DG);                         % Coordonnées des noeuds de l'élément
            Ge=zeros(Dne,1);                         % Index globaux des valeurs nodales de l'élément
            Ue=zeros(Dne,1);                         % Valeurs nodales de l'élément
            
            pos=1;
            
            %= Remplit : Xe ( coordonnées des noeuds de l'élément )                 =%
            %=           Ge ( index globaux des équations des noeuds de l'élément ) =%
            %=           Ue ( valeurs prises par la fonction si condition de bord ) =%
            for n=1:ne
                node = elements(e).nodes(n);
                
                Xe(n,:) = nodes(node).coor;                 % creates element
                
                for d=1:ndof
                    
                    %= Mets à jour les conditions au bord =%
                    if(nodes(node).dof(d) < 0)
                        
                        x = nodes(node).coor(1);
                        y = nodes(node).coor(2);
                        H = geo(1);
                        
                        nodes(node).U(d) = eval(nodes(node).boundary_condition(d));
                    end
                    %===%
                    
                    Ge(pos+(d-1)*ne) = nodes(node).dof(d);
                    Ue(pos+(d-1)*ne) = nodes(node).U(d);
                end
                
                pos = pos+1;
                
            end
            
            %= Indexage des inconnues et des équations =%
            Le0 = find(Ge>0);                      % Numérotation locale des inconnues
            LeD = find(Ge<0);                      % Numérotation locale des conditions de bord imposées
            Ie  = Ge(Le0);                         % Numérotation globale des inconnues
            
            %==% Fe = Second membre
            Fe = eval([Etag Atag 'Fe(Xe,[t,T],mat,geo,onde_incidente,quadrature_T3,uex)']);
            F(Ie) = F(Ie) - ( Ke(Le0,LeD) + Me(Le0,LeD) ) * Ue(LeD);
            F(Ie) = F(Ie) + Fe(Le0);
            %====%
            
        end
        
        U2 = (M/(dt*dt) + K) \ (2*M/(dt*dt) * U1 - M*U0/(dt*dt) + F);
        
        U0 = U1;
        U1 = U2;

        %= Remplit les noeuds avec la solution approchée =%
        for n=1:length(nodes)
            x = nodes(n).coor(1);
            y = nodes(n).coor(2);
            for d=1:ndof
                dof = nodes(n).dof(d);
                if(dof>0)
                    % nodes(n).U(d) = U2( dof );
                    nodes(n).U(d) = U_ex(x,y,t,geo,onde_incidente,2,uex);
                end
            end
        end
        %===%
        
        %= Enregistre l'image de U2 à chaque pas de temps =%
        Triangles = zeros(analysis.NE,3);
        X = zeros(analysis.NN);
        Y = zeros(analysis.NN);

        %== Première et deuxième composantes approchées
        Z1 = zeros(analysis.NN);
        Z2 = zeros(analysis.NN);

        %== Première et deuxième composantes exactes
        Zex1 = zeros(analysis.NN);
        Zex2 = zeros(analysis.NN);

        %== Première et deuxième composantes de l'erreur
        Eps1 = zeros(analysis.NN);
        Eps2 = zeros(analysis.NN);

        for n=1:analysis.NE
            Triangles(n,:) = elements(n).nodes;
        end
        
        test = zeros(analysis.NN,1);
        
        for n=1:analysis.NN

            node = nodes(n);
            
            if test(n)==0
                X(n) = node.coor(1);
                Y(n) = node.coor(2);
                
                Z1(n) = node.U(1);
                Z2(n) = node.U(2);
                
                Zex1(n) = U_ex(node.coor(1),node.coor(2),t,geo,onde_incidente,1,uex);
                Zex2(n) = U_ex(node.coor(1),node.coor(2),t,geo,onde_incidente,2,uex);
                
                Eps1(n) = Z1(n) - Zex1(n);
                Eps2(n) = Z2(n) - Zex2(n);

                test(n) = 1;
            end
            
        end
        %=======================================%


        if save_video_u
            
            %= Version Heatmap =%
            trisurf(Triangles,X,Y,zeros(analysis.NN),Z2,"LineStyle","none");
            hold on;
            %==%
            
            %= Caméra du dessus =%
            view([0 0 1]);
            set(gcf, 'Position',  [100, 100, 700, 700]);
            %==%
            
            %= Pour afficher les frontières en rouge =%
            if analysis.NC > 0
                
                Xf = zeros(1,1);
                Yf = zeros(1,1);
                left_mat = frontiere(1).left_material;
                right_mat = frontiere(1).right_material;
                posBorder = 0;
                foundNode = zeros(analysis.NN,1);

                for e2=1:analysis.NC
                    
                    %= Si on change de frontière =%
                    if ~(left_mat==frontiere(e2).left_material) | ~(right_mat==frontiere(e2).right_material)

                        plot3(Xf,Yf,zeros(length(Xf),1),'Color','r');
                        hold on;
                        Xf = zeros(1,1);
                        Yf = zeros(1,1);
                        left_mat = frontiere(e2).left_material;
                        right_mat = frontiere(e2).right_material;
                        posBorder = 0;
                        foundNode = zeros(analysis.NN,1);
                        
                    end
                    
                    for n=1:2
                        node = frontiere(e2).nodes(n);
                        if foundNode(node)==0
                            foundNode(node)=1;
                            
                            posBorder = posBorder+1;
                            Xf(posBorder) = nodes(node).coor(1);
                            Yf(posBorder) = nodes(node).coor(2);
                        end
                    end
                    
                end
                
            end
            %===%

            %==%
            plot3(Xf,Yf,zeros(length(Xf),1),'Color','r');
            hold on;
            %==%
            
            % trisurf(Triangles,X,Y,Z2);
            
            colorbar;
            grid on;
            
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            
            fileName = strcat("medias/videos/",num2str(iteration),".png");
            saveas(gcf, fileName);
            
            clf;
            
        end
        
    end
    %====%

            
end



        %     %==% Index locaux des noeuds qui touchent la frontiere %==%
        %     indexes_border = [];
        %     border_mate = [];
        %     border_bc = [];
        %     foundBorder = false;
        %     foundVertex = false;

        %     for e2=1:analysis.NC

        %         if ismember(frontiere(e2).nodes(1),elements(e).nodes) & ismember(frontiere(e2).nodes(2),elements(e).nodes) & ~foundBorder

        %             indexes_border = [find(elements(e).nodes==frontiere(e2).nodes(1)) find(elements(e).nodes==frontiere(e2).nodes(2))];

        %             border_mate = [material(frontiere(e2).left_material,:);
        %                            material(frontiere(e2).right_material,:)];

        %             border_bc = [frontiere(e2).left_bc frontiere(e2).right_bc];

        %             foundBorder = true;

        %         elseif ismember(frontiere(e2).nodes(1),elements(e).nodes) & ~foundBorder & ~foundVertex

        %             indexes_border = [find(elements(e).nodes==frontiere(e2).nodes(1))];

        %             border_mate = [material(frontiere(e2).left_material,:);
        %                            material(frontiere(e2).right_material,:)];

        %             border_bc = [frontiere(e2).left_bc frontiere(e2).right_bc];

        %             foundVertex = true;

        %         elseif ismember(frontiere(e2).nodes(2),elements(e).nodes) & ~foundBorder & ~foundVertex

        %             indexes_border = [find(elements(e).nodes==frontiere(e2).nodes(2))];

        %             border_mate = [material(frontiere(e2).left_material,:);
        %                            material(frontiere(e2).right_material,:)];

        %             border_bc = [frontiere(e2).left_bc frontiere(e2).right_bc];

        %             foundVertex = true;

        %         end

        %     end
        %     %====%
