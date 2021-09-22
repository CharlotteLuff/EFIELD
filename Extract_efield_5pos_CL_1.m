close all
clearvars -except E_field Data
clc

% User input- positions/wellposition/filenames
pos = [1, 2, 3, 4 ,5];
spos = {'p1','p2','p3','p4','p5'};

for position = 1:length(pos)
    if pos(1,position) == 1
        FILENAMES{1,1} = '160621_Dipole_testing_1ep_40hz_0.1mA_to_2mA_pos1_2.5ml';
        FILENAMES{1,2} = '160621_Dipole_testing_1ep_40hz_0.1mA_to_2mA_pos1_2.5ml';
    elseif pos(1,position) == 2
        FILENAMES{1,1} = '221020_X_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos2_2.5ml_1';
        FILENAMES{1,2} = '221020_Y_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos2_2.5ml_1';
    elseif pos(1,position) == 3
        FILENAMES{1,1} = '221020_X_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos3_2.5ml_1';
        FILENAMES{1,2} = '221020_Y_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos3_2.5ml_1';
    elseif pos(1,position) == 4
        FILENAMES{1,1} = '221020_X_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos4_2.5ml_1';
        FILENAMES{1,2} = '221020_Y_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos4_2.5ml_1';
    elseif pos(1,position) == 5
        FILENAMES{1,1} = '221020_X_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos5_2.5ml_1';
        FILENAMES{1,2} = '221020_Y_Dipole_testing_1ep_1000hz_41mA_to_60mA_pos5_2.5ml_1';
    end
    for file = 1:length(FILENAMES)
        clearvars -except Data pos spos file FILENAMES E_field sf f freq position
        FILENAME = FILENAMES{1,file};
        cell = strcat('EFIELD_',FILENAME(1:8));
        
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
        ylabel('Voltage (V)');
        xlim([0 length(t)/Fs]);
        title('Data');
        subplot(2,1,2)
        plot(t,waveform, 'k','linewidth',1);
        xlabel('Time (s)');
        ylabel('Amplitude (V)');
        xlim([0 length(t)/Fs]);
        saveas(gcf,fullfile('C:\Users\Katharine\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
        saveas(gcf,fullfile('C:\Users\Katharine\Documents\MATLAB\EFIELD\Figures',[s '.png']));
        
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
        saveas(gcf,fullfile('C:\Users\Katharine\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
        saveas(gcf,fullfile('C:\Users\Katharine\Documents\MATLAB\EFIELD\Figures',[s '.png']));
        
        %% Save data and stats to structure
        Data.(spos{1,position}).(cell).stim{:,1}(:,:) = split_data_2;
        save('Data','Data');
    end
end