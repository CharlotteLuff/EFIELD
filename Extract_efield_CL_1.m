close all
clearvars -except E_field Data
clc

% User input- positions/wellposition/filenames
pos = [5];
spos = {'p5'};
coord = {'Z'};

        FILENAMES{1,1} = '021120_Dipole_testing_1df10_1ep_0.5mA_Z_pos5';
        FILENAMES{1,2} = '021120_Dipole_testing_1df10_1ep_1mA_Z_pos5';
        FILENAMES{1,3} = '021120_Dipole_testing_1df10_1ep_1.5mA_Z_pos5';
        FILENAMES{1,4} = '021120_Dipole_testing_1df10_1ep_2mA_Z_pos5';
        FILENAMES{1,5} = '021120_Dipole_testing_1df10_1ep_2.5mA_Z_pos5';
        FILENAMES{1,6} = '021120_Dipole_testing_1df10_1ep_3mA_Z_pos5';
        FILENAMES{1,7} = '021120_Dipole_testing_1df10_1ep_3.5mA_Z_pos5';
        FILENAMES{1,8} = '021120_Dipole_testing_1df10_1ep_4mA_Z_pos5';
        FILENAMES{1,9} = '021120_Dipole_testing_1df10_1ep_4.5mA_Z_pos5';
        FILENAMES{1,10} = '021120_Dipole_testing_1df10_1ep_5mA_Z_pos5';
        FILENAMES{1,11} = '021120_Dipole_testing_1df10_1ep_5.5mA_Z_pos5';
        FILENAMES{1,12} = '021120_Dipole_testing_1df10_1ep_6mA_Z_pos5';
        FILENAMES{1,13} = '021120_Dipole_testing_1df10_1ep_6.5mA_Z_pos5';
        FILENAMES{1,14} = '021120_Dipole_testing_1df10_1ep_7mA_Z_pos5';
        FILENAMES{1,15} = '021120_Dipole_testing_1df10_1ep_7.5mA_Z_pos5';
        FILENAMES{1,16} = '021120_Dipole_testing_1df10_1ep_8mA_Z_pos5';
        FILENAMES{1,17} = '021120_Dipole_testing_1df10_1ep_8.5mA_Z_pos5';
        FILENAMES{1,18} = '021120_Dipole_testing_1df10_1ep_9mA_Z_pos5';
        FILENAMES{1,19} = '021120_Dipole_testing_1df10_1ep_9.5mA_Z_pos5';
        FILENAMES{1,20} = '021120_Dipole_testing_1df10_1ep_10mA_Z_pos5';
%         
    for file = 1:length(FILENAMES)
        clearvars -except Data pos spos file FILENAMES E_field sf f freq position coord
        FILENAME = FILENAMES{1,file};
        cell = strcat('EFIELD_',FILENAME(1:7),coord);
        
        % load data
        data_all = abfload([FILENAME,'.abf'], 'channels','a');
        
        % asign data
        data = data_all(:,1);
        waveform = data_all(:,2);
        
        % save matlab matrix
        save([FILENAME,'.mat'],'data');
        
        %% Set plot Properties
        PlotLineWidth = 2.5;
        PlotFontSize = 28;
        PlotAxesLineWidth = 2;
        PlotMarkerSize = 8;
        set(0,'defaultLineLineWidth',PlotLineWidth);   % set the default line width to lw
        set(0,'defaultLineMarkerSize',PlotMarkerSize); % set the default line marker size to msz
        PlotPrintResolution = '-r300';
        
        %% Define sampling frequency based on sampling interval
        % prompt= 'What is the sampling interval (µs)?';
        % a = input(prompt);
        dt = 10*10^-6;
        Fs = round(1/dt);
        
        %% Define time vector
        t = (0:dt:(length(data)-1)*dt)';
        
        %% Load data
        load([FILENAME,'.mat']); % load data
        
        %% Plot data and waveform
        s = strcat(FILENAME,'_full_data_and_waveform');
        figure;
        set(gca,'FontSize', 14)
        set(gca,'TickDir','out');
        set(gca,'ticklength',3*get(gca,'ticklength'))
        subplot(2,1,1)
        plot(t,data, 'k','linewidth',1);
        xlabel('Time (s)');
        ylabel('Amplitude (V)');
        xlim([0 length(t)/Fs]);
        title('Data');
        subplot(2,1,2)
        plot(t,waveform, 'k','linewidth',1);
        xlabel('Time (s)');
        ylabel('Amplitude (V)');
        xlim([0 length(t)/Fs]);
        saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
        saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.png']));
        
        %% Split data, filtered data and waveform roughly into sections (11 seconds)
        split = 1:1100000:length(data);
        
        for x = 2:length(split)
            split_data(:,x-1) = data(split(1,x-1):split(1,x));
            split_wf(:,x-1) = waveform(split(1,x-1):split(1,x));
        end
        
        %% Split data and waveform exactly into sections - each column is one condition (4 seconds - ramp up and ramp down removed)
        % Plot split data and waveform
        s = strcat(FILENAME,'_split_data');
        figure
        for y = 1:size(split_data,2)
            sgtitle('Data');
            subplot(size(split_data,2),1,y)
            split_data_2(:,y) = split_data(550000:550000 + 450000,y);
            plot(split_data_2(:,y),'k','linewidth',1)
            xlabel('Time (s)');
            xlim([0 400000]);
            ylabel('V');
            hold on
        end
        saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
        saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.png']));
        
        %% Save data and stats to structure
        Data.(spos{1,1}).(cell{1, 1}).stim{:,file}(:,:) = split_data_2;
        save('Data','Data','-v7.3');
    end