clear all; % clear Matlab work space
close all; % closes all figures

%soundArray = ["female_anger", "female_crying", "female_laughter", "male_anger", "male_crying", "male_laughter", "noisy_room", "party_crowd", "car_drive_away", "right_hook", "left_hook"];
%soundArray = ["ambulance", "british_woman", "little_boy", "old_man", "office", "party"];

%for i=1:length(soundArray)
%  signalProcess(soundArray(i));
%end

function signalProcess(fileName)
    % 3.1 Read sound file
    [y, Fs] = audioread(fileName+".wav");
    
    % 3.2 Check if sound is stereo
    fileSize = size(y);
    if fileSize(2) == 2
        y = y(:,1)+y(:,2);
    end
    
    % 3.3 Play sound
    sound(y, Fs);
    
    % 3.4 Write to file
    audiowrite(fileName+"v2.wav", y, Fs);
    
    % 3.5 Plot of sound waveform
    figure("Name", fileName);
    plot(y);
    title("Waveform of Test Audio");
    xlabel("Sample Index");
    ylabel("Amplitude");
    % 3.6 Downsampling to 16kHz
    if Fs > 16000
        [numer, denom] = rat(16000/Fs);
        resampledSignal = resample(y, numer, denom);
    end
    
    % 3.7 Cosine function sound
    time = fileSize(1)/Fs;
    timeRange = 0:(1/Fs):time;
    cosPlot = cos(2*pi*1000*timeRange);
    sound(cosPlot, Fs);
    
    % 3.7 Cosine function plot
    figure("Name", fileName);
    timeRange2 = 0:(1/Fs):0.002;
    cosPlot2 = cos(2*pi*1000*timeRange2);
    plot(timeRange2, cosPlot2);
    title("Waveform of Cosine");
    xlabel("Time (s)");
    ylabel("Amplitude");
end
