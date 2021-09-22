%% Calculate e-field

close all
clearvars -except E_field Data Fs
clc

% User input
pos = [1, 2, 3, 4, 5];
spos = {'p1', 'p2', 'p3', 'p4', 'p5'};
coords = {'X','Y','Z'};

for position = 1:length(pos)
    for coord = 1:length(coords)
        %cell(1,coord) = strcat('EFIELD_',DATE,'_',coords(1,coord));
        
        %% detrend, high-pass filter and compute RMS (V)
        temp_volt{1,coord} = (Data.(spos{1,position}){:,coord}(:,:));
        
        for amp = 1:size(Data.(spos{1,position}){:,coord}(:,:),2)
            temp_volt{1,coord}(1,amp) = temp_volt{1,coord}(1,amp)-mean(temp_volt{1,coord}(1,amp));
        end
        
        %% High-pass filter data and baseline to remove 1/f
        filt_order = 1;
        filt_f1 = 2;
        [b,a] = butter(filt_order, [filt_f1]/(Fs/2), 'high');
        temp_volt{1,coord} = filtfilt(b,a,temp_volt{1,coord});
        
        temp_volt_rms(coord,:)  = rms(temp_volt{1,coord}(45000:end,:));
    
        %% compute electric fields between locations using RMS (E(V/m))
        
        temp_field_rms(coord,:) = (temp_volt_rms(coord,:))./(2000/10^6); % loc 1 and 2
        
    end
    %% compute vector field magnitude
    
    for amp = 1:size(Data.(spos{1,position}){:,coord}(:,:),2)
        temp_vec(1,amp) = sqrt(temp_field_rms(1,amp)^2 + temp_field_rms(2,amp)^2 + temp_field_rms(3,amp)^2);
    end
    
    %% Save relevant info into a structure
    
    E_field.(spos{1,position}).field_rms = temp_field_rms;
    E_field.(spos{1,position}).volt_rms = temp_volt_rms;
    E_field.(spos{1,position}).vector_field_mag = temp_vec;
end

save('E_field','E_field');