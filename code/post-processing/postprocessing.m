% PSD Experiment Post-Processing
% 
%  Processes data collected during experiment and generates time-series
%  plots.
%
% 16-722: Sensing & Sensors
% HW 9: Phase Sensitive Detection Experiment
% Alexander Volkov

% Clean up
clc;clear;close all

% Settings
Fs = 8000;
delay = 0.185;
D = delay*Fs;

% Load data
% load('../../data/dataset1_kennedy');
% orig = data(1:end-D+1);
% orig = orig./abs(max(orig));
% recNoise = rec(D:end);
% 
% load('../../data/dataset2_kennedy');
% recModNoise = rec(D:end);
% recNoise = recNoise./abs(max(recNoise));
% 
% load('../../data/dataset3_kennedy');
% recModDemodNoise = rec(D:end);
% recModDemodNoise = recModDemodNoise./abs(max(recModDemodNoise));

% load('../../data/dataset1_avoid_use');
% orig = data(1:end-D+1);
% orig = orig./abs(max(orig));
% recNoise = rec(D:end);
% recNoise = recNoise./abs(max(recNoise));
% 
% load('../../data/dataset2_avoid_use');
% recModNoise = rec(D:end);
% recModNoise = recModNoise./abs(max(recModNoise));
% 
% load('../../data/dataset3_avoid_use');
% recModDemodNoise = rec(D:end);
% recModDemodNoise = recModDemodNoise./abs(max(recModDemodNoise));

load('../../data/dataset1_tune');
orig = data(1:end-D+1);
orig = orig./abs(max(orig));
recNoise = rec(D:end);
recNoise = recNoise./abs(max(recNoise));

load('../../data/dataset2_tune');
recModNoise = rec(D:end);
recModNoise = recModNoise./abs(max(recModNoise));

load('../../data/dataset3_tune');
recModDemodNoise = rec(D:end);
recModDemodNoise = recModDemodNoise./abs(max(recModDemodNoise));


% Plot original and received audio waveforms for all three cases
figure
plot((1:length(orig))/Fs,orig+1,(1:length(orig))/Fs,recNoise-1);
grid minor
box on

%print -depsc kennedy-data1
%print -depsc avoid-use-data1
print -depsc tune-data1

figure
plot((1:length(orig))/Fs,orig+1,(1:length(orig))/Fs,recModNoise-1);
grid minor
box on

%print -depsc kennedy-data2
%print -depsc avoid-use-data2
print -depsc tune-data2

figure
plot((1:length(orig))/Fs,orig+1,(1:length(orig))/Fs,recModDemodNoise-1);
grid minor
box on

%print -depsc kennedy-data3
%print -depsc avoid-use-data3
print -depsc tune-data3

% Compute RMS error over data
rmsNoise = sqrt(sum((abs(orig)-abs(recNoise)).^2))
rmsModNoise = sqrt(sum((abs(orig)-abs(recModNoise)).^2))
rmsModDemodNoise = sqrt(sum((abs(orig)-abs(recModDemodNoise)).^2))
percentImprovement = 100*(rmsNoise-rmsModDemodNoise)/rmsNoise

