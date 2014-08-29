clear;
clc;
[y, Fs] = wavread('hootie');
channel_1 = y(:,1);
%for i=1:15000
%    channel_1(i) = channel_1(i)*1.5;
%end
%for i=30000:44000
%    channel_1(i) = channel_2(i)*1.5;
%end
%plot(channel_1);
channel_2 = y(:,2);
%for i=1:15000
%    channel_2(i) = channel_1(i)*1.5;
%end
%for i=30000:44000
%    channel_2(i) = channel_2(i)*1.5;
%end
%plot(channel_2);
%fc = 100;
fc = 150;
fc
fc = round(fc);
%filter used so that some drums and bass value with generally match with
%the vocals are saved from being removed.
if fc > 20
    fp = fc+5;
    fs = fc/(Fs/2);
    fp = fp/(Fs/2);
    [n wn] = buttord(fp,fs,0.5,80);
    [b, a] = butter(5,wn,'High');
    channel_2 = filtfilt(b,a,y(:,2));
%    plot(channel_2);
end
%karaoke = channel_1 - channel_2;
%soundsc(channel_1,fs);
%fs
%channel_1
karaoke = channel_1-channel_2;
plot(karaoke);
wavwrite(karaoke, Fs, 'out.wav');
