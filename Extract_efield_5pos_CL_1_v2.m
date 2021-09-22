close all
clearvars -except E_field Data
clc

% User input- positions/wellposition/filenames
pos = [1, 2, 3, 4 ,5];
spos = {'p1','p2','p3','p4','p5'};

FILENAMES{1,1} = '160621_Dipole_testing_1ep_40hz_0.1mA_to_2mA_pos1_2.5ml';
FILENAMES{1,2} = '160621_Dipole_testing_1ep_40hz_0.1mA_to_2mA_pos2_2.5ml';
FILENAMES{1,3} = '160621_Dipole_testing_1ep_40hz_0.1mA_to_2mA_pos3_2.5ml';
FILENAMES{1,4} = '160621_Dipole_testing_1ep_40hz_0.1mA_to_2mA_pos4_2.5ml';
FILENAMES{1,5} = '160621_Dipole_testing_1ep_40hz_0.1mA_to_2mA_pos5_2.5ml';

for file = 1
    clearvars -except Data pos spos file FILENAMES E_field
    FILENAME = FILENAMES{1,file};
    position = spos{file};
    
    % load data
    data_all = abfload([FILENAME,'.abf'], 'channels','a');
    
    % asign data
    waveform = data_all(:,1);
    x = data_all(:,2);
    y = data_all(:,3);
    z = data_all(:,4);
    
    % save matlab matrix
    save([FILENAME,'.mat'],'x','y','z');
    
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
    t = (0:dt:(length(waveform)-1)*dt)';
    
    %% Load data
    load([FILENAME,'.mat']); % load data
    
    %% High-pass filter data and baseline to remove 1/f
    filt_order = 3;
    filt_f1 = 1;
    [b,a] = butter(filt_order, [filt_f1]/(Fs/2), 'high');
    filt_x = filtfilt(b,a, x);
    filt_y = filtfilt(b,a, y);
    filt_z = filtfilt(b,a, z);
    
    %% Plot data and waveform
    s = strcat(FILENAME,'_full_data_and_waveform_',position);
    figure;
    set(gca,'FontSize', 14)
    set(gca,'TickDir','out');
    set(gca,'ticklength',3*get(gca,'ticklength'))
    subplot(2,1,1)
    plot(t,filt_x,'linewidth',1,'Color',[0.4941    0.1843    0.5569]);
    hold on
    plot(t,filt_y,'linewidth',1,'Color',[0.6353    0.0784    0.1843]);
    hold on
    plot(t,filt_z,'linewidth',1,'Color',[0.3020    0.7451    0.9333]);
    hold on
    xlabel('Time (s)');
    ylabel('Amplitude (V)');
    xlim([0 length(t)/Fs]);
    legend('x','y','z')
    subplot(2,1,2)
    plot(t,waveform, 'k','linewidth',1);
    xlabel('Time (s)');
    ylabel('Amplitude (V)');
    xlim([0 length(t)/Fs]);
    ylim([-3, 3])
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.png']));
    
    %% Split data, filtered data and waveform roughly into sections (11 seconds)
    split = 1:1100000:length(waveform);
    
    for i = 2:length(split)
        split_x(:,i-1) = x(split(1,i-1):split(1,i));
        split_y(:,i-1) = y(split(1,i-1):split(1,i));
        split_z(:,i-1) = z(split(1,i-1):split(1,i));
        split_wf(:,i-1) = waveform(split(1,i-1):split(1,i));
    end
    
    %% Split data and waveform exactly into sections - each column is one condition (4 seconds - ramp up and ramp down removed)
    % Plot split data and waveform
    s = strcat(FILENAME,'x_split_data');
    figure
    for a = 1:size(split_x,2)
        sgtitle('X Data');
        subplot(size(split_x,2),1,a)
        split_x_2(:,a) = split_x(550000:550000 + 450000,a);
        plot(split_x_2(:,a),'k','linewidth',1)
        xlabel('Time (s)');
        xlim([0 400000]);
        hold on
    end
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.png']));
    s = strcat(FILENAME,'y_split_data');
    figure
    for a = 1:size(split_y,2)
        sgtitle('Y Data');
        subplot(size(split_y,2),1,a)
        split_y_2(:,a) = split_y(550000:550000 + 450000,a);
        plot(split_y_2(:,a),'k','linewidth',1)
        xlabel('Time (s)');
        xlim([0 400000]);
        hold on
    end
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.png']));
    s = strcat(FILENAME,'z_split_data');
    figure
    for a = 1:size(split_z,2)
        sgtitle('Z Data');
        subplot(size(split_z,2),1,a)
        split_z_2(:,a) = split_z(550000:550000 + 450000,a);
        plot(split_z_2(:,a),'k','linewidth',1)
        xlabel('Time (s)');
        xlim([0 400000]);
        hold on
    end
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.fig']));
    saveas(gcf,fullfile('C:\Users\GLab\Documents\MATLAB\EFIELD\Figures',[s '.png']));
    
    %% Save data and stats to structure
    Data.(spos{1,file}){:,1}(:,:) = split_x_2;
    Data.(spos{1,file}){:,2}(:,:) = split_y_2;
    Data.(spos{1,file}){:,3}(:,:) = split_z_2;
    save('Data','Data');
end