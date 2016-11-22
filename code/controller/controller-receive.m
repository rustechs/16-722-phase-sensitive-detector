%% PSD Experiment Controller (Receiver)
% 
%  Responsible for receiving the incoming data
%  from the receiver, and saving it.
%
% 16-722: Sensing & Sensors
% HW 9: Phase Sensitive Detection Experiment
% Alexander Volkov

% Clean up
clc;clear;close all

% Parameters
dataFile = 'data.mp3'; % audio data filename


% Load audio data
[data, Fs] = audioread(dataFile);

% Send audio data over UART to transmitter

