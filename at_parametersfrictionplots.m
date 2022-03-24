function [klow, nlow, khigh, nhigh] = at_parametersfrictionplots(dataDir, filelist, tsteps)
%dataDir est le nom du dossier, par exemple 'GB', filelist contient les
%fichiers triés dans l'ordre et tsteps correspond au nombre d'échantillons
range=1:tsteps; % Nombre d'échantillons
index.conditions = cell(1,3); % Structures de données pour enregistrer les paramètres
show_graphs=true; % Paramètre à changer en fonction de si l'on veut afficher les courbes temporelles des signaux
correct_forces=false; % A mettre sur "True" si l'on veut corriger  la dérive des capteurs
clear h;
cond_tab={'Weak','Medium','Strong'};
%% %% Boucle pour le calcul de la friction de l'échantillon "non-glissant"
for i=1:3
    if i==1
        forcesFile = strcat(filelist(i).name);
    elseif i==2
        forcesFile = strcat(filelist(i).name);
    elseif i==3
        forcesFile = strcat(filelist(i).name);
    end
    data = at_import(fullfile(dataDir,forcesFile));
    
    cond=cond_tab{i};
    
    data=data(range,:);
    y_COP=(data.copy_cam+33)/1000;
    ft=[data.fx_cam data.fy_cam];
    NF=-data.fz_cam;
    
    if i==1
        x=1:length(NF);
        NF=NF-interp1([1 length(NF)],[NF(1) NF(end)],x)';
        ft(:,1)=ft(:,1)-interp1([1 length(NF)],[ft(1,1) ft(end,1)],x)';
        ft(:,2)=ft(:,2)-interp1([1 length(NF)],[ft(1,2) ft(end,2)],x)';
    end
    
    [mu_l,slip_indexes_l,search_zones_l] = get_mu_points(y_COP,ft,NF,'fs_science',200,'y_thresh',0.02);
    indexblue.conditions{i}=cond;
    indexblue.(cond).NF=NF;
    indexblue.(cond).TF=ft;
    indexblue.(cond).mu=mu_l;
    indexblue.(cond).slip_indexes=slip_indexes_l;
    indexblue.(cond).search_zones=search_zones_l;

end

indexblue=get_mu_fit(indexblue);
khigh=mean(indexblue.k);
nhigh = mean(indexblue.n);


%% Boucle pour le calcul de la friction de l'échantillon "glissant"
for i=1:3
    if i==1
        forcesFile = strcat(filelist(i+3).name);
    elseif i==2
        forcesFile = strcat(filelist(i+3).name);
    else
        forcesFile = strcat(filelist(i+3).name);
    end
    data = at_import(fullfile(dataDir,forcesFile),true,40,40,40,10);
    
    cond=cond_tab{i};
    
    data=data(range,:);
    y_COP=(data.copy_cam+33)/1000; % Ajustement du COP pour que zéro soit le centre de la vitre
    ft=[data.fx_cam data.fy_cam];
    NF=-data.fz_cam;
    
    if correct_forces %Correction de la dérive des capteurs
        x=1:length(NF);
        NF=NF-interp1([1 length(NF)],[NF(1) NF(end)],x)';
        ft(:,1)=ft(:,1)-interp1([1 length(NF)],[ft(1,1) ft(end,1)],x)';
        ft(:,2)=ft(:,2)-interp1([1 length(NF)],[ft(1,2) ft(end,2)],x)';
    end
    
    
    [mu_l,slip_indexes_l,search_zones_l] = get_mu_points(y_COP,ft,NF,'fs_science',200,'y_thresh',0.02); %previously,y=0.025
    index.conditions{i}=cond;
    index.(cond).NF=NF;
    index.(cond).TF=ft;
    index.(cond).mu=mu_l;
    index.(cond).slip_indexes=slip_indexes_l;
    index.(cond).search_zones=search_zones_l;

end

indexglass1=get_mu_fit(index);
klow=mean(indexglass1.k);
nlow = mean(indexglass1.n);

%% Create figure
figure;hold on;
%for i=1:3
%    cond=cond_tab{i};
%    plot(index.(cond).NF(index.(cond).slip_indexes),index.(cond).mu,'b.')
%end
%for i=1:3
%    cond=cond_tab{i};
%    plot(indexblue.(cond).NF(indexblue.(cond).slip_indexes),indexblue.(cond).mu,'r.')
%end
