clear all; % clear Matlab work space
close all; % closes all figures
%soundArray = ["female_anger", "female_crying", "female_laughter", "male_anger", "male_crying", "male_laughter", "noisy_room", "party_crowd", "car_drive_away", "right_hook", "left_hook"];
%soundArray = ["ambulance", "british_woman", "little_boy", "old_man", "office", "party"];

%for i=1:length(soundArray)
%  signalProcess(soundArray(i));
%end
signalProcess("female_crying");


function signalProcess(fileName)
    % 3.1 Read sound file
    [y, Fs] = audioread(fileName+".wav");
    
    % 3.2 Check if sound is stereo
    fileSize = size(y);
    if fileSize(2) == 2
        y = y(:,1)+y(:,2);
    end
    
    % 3.3 Play sound
    %sound(y, Fs);
    
    % 3.4 Write to file
    % audiowrite(fileName+"v2.wav", y, Fs);
    
    % 3.5 Plot of sound waveform
    %figure("Name", fileName);
    %plot(y);
    %title("Waveform of Test Audio");
    %xlabel("Sample Index");
    %ylabel("Amplitude");
    
    % 3.6 Downsampling to 16kHz
    if Fs > 16000
        [numer, denom] = rat(16000/Fs);
        resampledSignal = resample(y, numer, denom);
    end
    
%     % 3.7 Cosine function sound
     time = fileSize(1)/Fs;
     timeRange = 0:(1/Fs):time-(1/Fs);
%     cosPlot = cos(2*pi*1000*timeRange);
%     sound(cosPlot, Fs);
%     
%     % 3.7 Cosine function plot
%     figure("Name", fileName);
%     timeRange2 = 0:(1/Fs):0.002;
%     cosPlot2 = cos(2*pi*1000*timeRange2);
%     plot(timeRange2, cosPlot2);
%     title("Waveform of Cosine");
%     xlabel("Time (s)");
%     ylabel("Amplitude");

    % Phase 2 
    % logArray = [2 2.237886 2.475772496 2.713658745 2.951544993 3.189431242 3.42731749 3.665203739 3.903089987];
    logArray = [0.0817 0.172225 0.26275 0.353275 0.4438 0.534325 0.62485 0.715375 0.8059];
    
    output = zeros(1, numel(y));
    timeRange2 = 0:(1/Fs):time-(1/Fs);
    for i=1:length(logArray)-1
        leftGreenwood = 165.4 * (power(10, logArray(i) * 2.1) - 0.88);
        rightGreenwood = 165.4 * (power(10, logArray(i+1) * 2.1) - 0.88);
        [num, denum] = butter(4, [leftGreenwood rightGreenwood]/(Fs/2));
        filteredSignal = filter(num ,denum, y);
 
% 
%         figure("Name", fileName);
%         
%         plot(timeRange,y);
%         hold on
%         plot(timeRange,filteredSignal);
%         legend("Input Data", "Filtered Data");
%         xlabel("Time");
%         ylabel("Amplitude");
%           
%         figure("Name", fileName);
%            
%         plot(timeRange,filteredSignal);
%         xlabel("Time");
%         ylabel("Amplitude");
%      
        lowpassSignal = lowpass(abs(filteredSignal), 400/(Fs/2));
%           
%         figure("Name", fileName);
%         plot(timeRange,abs(filteredSignal));
%         xlabel("Time");
%         ylabel("Amplitude");
%         figure("Name", fileName);
%         plot(timeRange,lowpassSignal);
%         xlabel("Time");
%         ylabel("Absolute Value");
        
        centerFreq = (rightGreenwood + leftGreenwood)/2;
        
        % figure("Name", fileName);
        timeRange2 = 0:(1/Fs):time-(1/Fs);
        cosPlot2 = cos(2*pi*centerFreq*timeRange2);
       
        modAmp = cosPlot2.* transpose(lowpassSignal);
        output = output + modAmp;
%         plot(timeRange2, modAmp);
%         title("Modulated Amplitude");
%         xlabel("Time (s)");
%         ylabel("Amplitude");
    end
    
%     plot(timeRange2, output);
%     title("Output Amplitude");
%     xlabel("Time (s)");
%     ylabel("Amplitude");
    
    audiowrite('output.wav',output, Fs);
    %for i=1:length(soundArray)
    %  signalProcess(soundArray(i));
    %end
    
    
%     N=5;
%     [num,den]=butter(N,[300,700],'s');
%     BPF=tf(num,den)
%     figure
%     bode(BPF)
    
        
end
