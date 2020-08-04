clear all; % clear Matlab work space
close all; % closes all figures
%soundArray = ["female_anger", "female_crying", "female_laughter", "male_anger", "male_crying", "male_laughter", "noisy_room", "party_crowd", "car_drive_away", "right_hook", "left_hook"];
%soundArray = ["ambulance", "british_woman", "little_boy", "old_man", "office", "party"];

signalProcess("male_laughter");

function signalProcess(fileName)
    % 3.1 Read sound file
    [y, Fs] = audioread(fileName+".wav");
    
    % 3.2 Check if sound is stereo
    fileSize = size(y);
    if fileSize(2) == 2
        y = y(:,1)+y(:,2);
    end
    
    time = fileSize(1)/Fs;
    
    % 3.6 Downsampling to 16kHz
    if Fs > 16000
        [N, D] = rat(16000/Fs);
        resampledSignal = resample(y, N, D);

        y=resampledSignal;
        Fs = 16000;
    end

    % Phase 2 
    % logArray = [2 2.237886 2.475772496 2.713658745 2.951544993 3.189431242 3.42731749 3.665203739 3.903089987];
    logArray = [0.0817 0.172225 0.26275 0.353275 0.4438 0.534325 0.62485 0.715375 0.805];
    
    output = transpose(zeros(1,numel(y)));
    timeRange2 = transpose(0:(1/Fs):time);
    for i=1:length(logArray)-1
        leftGreenwood = 165.4 * (power(10, logArray(i) * 2.1) - 0.88);
        rightGreenwood = 165.4 * (power(10, logArray(i+1) * 2.1) - 0.88);
        
        [num, denum] = butter(5, [leftGreenwood rightGreenwood]/(Fs/2), 'bandpass');
        filteredSignal = filter(num ,denum, y);
      
        %lowpassSignal = lowpass(abs(filteredSignal), 400/(Fs/2));
        [lowNum, highNum] = butter(12, 400/(Fs/2));
        %[lowNum, highNum] = butter(12, 200/(Fs/2));
        %[lowNum, highNum] = butter(12, 1600/(Fs/2));
        lowpassSignal = filter(lowNum, highNum, abs(filteredSignal));
        
        centerFreq = (rightGreenwood + leftGreenwood)/2;

        cosPlot2 = cos(2*pi*centerFreq*timeRange2);

        modAmp = cosPlot2.* lowpassSignal;
        output = output + modAmp;
        
        figure("Name", fileName);
        plot(timeRange2, lowpassSignal);
        title("Amplitude of Envelope");
        xlabel("Time (s)");
        ylabel("Amplitude");
    end
    
%   plot(timeRange2, output);
%   title("Output Amplitude: Order 8");
%   xlabel("Time (s)");
%   ylabel("Amplitude");
    
    audiowrite('output3.wav',output, Fs);
    %for i=1:length(soundArray)
    %  signalProcess(soundArray(i));
    %end
        
end
