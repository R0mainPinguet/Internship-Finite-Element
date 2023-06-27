
saveError = 0;

%== INPUT FILES ==%
% input_files = ["Circle_1.msh";"Circle_2.msh";"Circle_3.msh";"Circle_4.msh";"Circle_5.msh"];
% input_files = ["Circle_sep_vert_1.msh";"Circle_sep_vert_2.msh";"Circle_sep_vert_3.msh";"Circle_sep_vert_4.msh";"Circle_sep_vert_5.msh"];

% input_files = ["Square_1.msh";"Square_2.msh";"Square_3.msh";"Square_4.msh";"Square_5.msh"];
% input_files = ["Square_sep_vert_1.msh","Square_sep_vert_2.msh","Square_sep_vert_3.msh","Square_sep_vert_4.msh"];
% input_files = ["Square_sep_circle_1.msh","Square_sep_circle_2.msh","Square_sep_circle_3.msh","Square_sep_circle_4.msh"];
% input_files = ["Square_sep_sinus_1.msh","Square_sep_sinus_2.msh","Square_sep_sinus_3.msh","Square_sep_sinus_4.msh","Square_sep_sinus_5.msh"];
% input_files = ["Square_sep_3mat_1.msh","Square_sep_3mat_2.msh","Square_sep_3mat_3.msh","Square_sep_3mat_4.msh","Square_sep_3mat_5.msh"];
input_files = ["Square_sep_dent_1.msh","Square_sep_dent_2.msh","Square_sep_dent_3.msh","Square_sep_dent_4.msh","Square_sep_dent_5.msh"];
%=================%

%== QUADRATURES ==%
% quadrature_T3_list = ["order_1","order_2","order_3"];
% quadrature_B2_list = ["order_1","order_3","order_5"];
%================%


% for i_quadra_B2=1:length(quadrature_B2_list)

% quadrature_B2 = quadrature_B2_list(i_quadra_B2);

% for i_quadra_T3=1:length(quadrature_T3_list)

% quadrature_T3 = quadrature_T3_list(i_quadra_T3);

% for i_uex=1:length(uex_list)

% uex = uex_list(i_uex);

h_list = zeros(1,length(input_files));
error_L2_list = zeros(1,length(input_files));
error_H1_list = zeros(1,length(input_files));

for i_file=1:length(input_files)
    
    mshfile = input_files(i_file);
    
    FE;
    
    h_list(i_file) = h;
    error_L2_list(i_file) = errorL2;
    error_H1_list(i_file) = errorH1;
    
end

disp("#=========#");
disp("h list :");
disp(h_list);

disp("error L2 list:");
disp(error_L2_list);

disp("error H1 list:");
disp(error_H1_list);
disp("#=========#");

if saveError
    
    %= Write in a file =%
    if uex=="Poly4" | uex=="Trigo" | uex=="Expo" | uex=="Poly2" | uex=="abs" | uex=="log"
        fileID = fopen(strcat('erreurs/',uex,'frontiere__T3_',quadrature_T3,'.txt'),'w');            
    else
        fileID = fopen(strcat('erreurs/',uex,'_T3_',quadrature_T3,'_B2_',quadrature_B2,'.txt'),'w');
    end
    
    fprintf(fileID,"h errorL2 errorH1\n");
    
    for i_print=1:length(h_list)
        fprintf(fileID,"%d %d %d\n",h_list(i_print),error_L2_list(i_print),error_H1_list(i_print));
    end
    
    fclose(fileID);
    %====%
end

% end

% end

% end
