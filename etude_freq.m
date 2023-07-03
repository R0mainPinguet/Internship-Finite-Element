

for i_hauteur_dent=1:19

    coeff = i_hauteur_dent/10;
    
    mshfile = strcat("dent_",num2str(coeff),"_4.msh");

    fileName = strcat("medias/images/comp1_",num2str(coeff),".png");
    
    FE;
    
end
