tsteps = 2759;
l = 0;

D = './Young_friction';
S = dir(fullfile(D, '*'));
N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of D.
rgb=[254, 128, 1]/256;
yellow=[0.9290 0.6940 0.1250];
figure(1)
for ii = 1:numel(N)
    filelist = dir(fullfile(D,N{ii},'*.csv')); % improve by specifying the file extension
    filelist= filelist(~[filelist.isdir]);  % classification of folders in good order
    [~,idx] = sort([filelist.datenum]);
    filelist = filelist(idx);
    nfiles=length(filelist);
    C = {filelist(~[filelist.isdir]).name}; % files in subfolder (cell created for the loop)
    [klow, nlow, khigh, nhigh] = at_parametersfrictionplots(N{ii}, filelist, tsteps)
    %,Color',[0.9763 0.9831 0.0538]

    figure(1); hold on;
    h1=plot(nlow,klow,'.', 'MarkerSize',20,'Color', yellow);
    h(1)=h1(1);
    
    %'Color', rgb
    
    hold on;
    h2=plot(nhigh,khigh, '.','MarkerSize',20,'Color', rgb);
    h(2)=h2(1);
    h=[h(1);h(2)]
    legend(h, 'Low Friction', 'High Friction')
    %title('Comparison of friction - Elderly participants')
    title('Comparison of friction - Young participants')
    %ylabel('TF/NF')
    ylabel('k (-)')
    xlabel('n(-)')
    %xlabel('NF [N]')
    plot([nlow nhigh], [klow khigh], 'black')
end