% PSD Experiment Controller
% 
%  Responsible for loading a data file, sending it over USB to the
%  transmitter, generating environmental noise, reading data back from
%  reciever, and saving it for post-processing.
%
% 16-722: Sensing & Sensors
% HW 9: Phase Sensitive Detection Experiment
% Alexander Volkov

% Clean up
clc;clear;close all

% Parameters
dataFile = '../../sound/ask_not.mp3'; % audio data filename
portTrans = 'COM1';
portRcv = 'COM2';

% Load audio data
[dataRaw, Fs] = audioread(dataFile);

% Convert to 8192 Sa/sec and uint8
[P,Q] = rat(8192/Fs);
data = uint8(255*(resample(dataRaw,P,Q)+1)/2);

% Pre-allocate storage space for received message
rec = zeros(size(data));

% Send audio data over UART to transmitter and collect data over UART from
% receiver

% Connect to transmitter serial line
sTrans = serial(portTrans);
set(sTrans,'BaudRate',115200);
fopen(sTrans);

% Connect to receiver serial line
sRcv = serial(portRcv);
set(sRcv,'BaudRate',115200);
fopen(sRcv);

% Handshake with transmitter
fprintf(sTrans,'foo');
while (~strcmp(fgetl(sTrans),'foo'))
    fprintf(sTrans,'foo');
end

% Handshake with receiver
fprintf(sRcv,'foo');
while (~strcmp(fgetl(sRcv),'foo'))
    fprintf(sRcv,'foo');
end

% Generate and play interference sound
interference = randn(1,length(data)+100);
soundsc(interference,8192);

% Send out the data
fwrite(sTrans,data,'uint8','async');

% Begin reading data
rec = fread(sRcv,length(rec),'uint8');

% Save data with timestamp
save(['../../data/data ' datestr(now-1)],data,rec);

% Close the serial ports
fclose(sTrans);
fclose(sRcv);
delete(sTrans);
delete(sRcv);
clear sTrans
clear sRcv