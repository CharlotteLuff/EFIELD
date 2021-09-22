 %% Calculate e-field

close all
clearvars -except E_field Data
clc

% User input
pos = [1, 2, 3, 4, 5];
spos = {'p1', 'p2', 'p3', 'p4', 'p5'};
coords = {'X','Y','Z'};

for position = 1:length(pos)
    for coord = 1:length(coords)
        cell(1,coord) = strcat('EFIELD_',DATE,'_',coords(1,coord));
        
        %% compute difference in field amplitude between locations for each carrier frequency condition (mV)
        temp_volt{1,coord} = (Data.(spos{1,position}).(cell{1,coord}).stim{1,1});
        
        for cond = 1:size(Data.(spos{1,position}).(cell{1,coord}).stim{1,1},2)
            temp_volt{1,coord}(1,cond) = temp_volt{1,coord}(1,cond)-mean(temp_volt{1,coord}(1,cond));
        end
        
        temp_volt_rms(coord,:)  = rms(temp_volt{1,coord});
        %% compute electric fields between locations using RMS E(V/m)
        
        temp_field_rms(coord,:) = (temp_volt_rms(coord,:))./(2000/10^6); % loc 1 and 2
        
        %% Save relevant info into a structure
        
        E_field.(spos{1,position}).field_rms = temp_field_rms;
        E_field.(spos{1,position}).volt_rms = temp_volt_rms;
        save('E_field','E_field');
    end
end