function output = p_fft(Fs)

%read the data from the txt,The N is the lenth of the signal
fileID = fopen('./fout.txt','r');
formatSpec = '%d';
sizeA = [1 Inf];
A = fscanf(fileID,formatSpec,sizeA)
A=A-2000;
N=length(A);

%采样频率
Ts=1/Fs;
%根据采样频率与采样点数得到信号频率
Fc=Fs/N;
Tc=1/Fc;

t=(0:N-1)*Ts;%坐标t以Ts为间隔，直至Tc
F_d=Fs/N;%频率分辨率为F_d

f=F_d*(0:N-1);%横坐标f只需要取一半即可

y=fft(A);
power = abs(y).^2/N;

y0 = fftshift(y);         % shift y values
f0 = (-N/2:N/2-1)*F_d; % 0-centered frequency range
power0 = abs(y0).^2/N;    % 0-centered power


% P2 = abs(H/N);
% P1 = P2(1:N/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
%  figure(1);
%  subplot(2,1,1);%在第1行绘制原始信号
% plot(t,A); 
%  title('原始信号图');
%  
%  subplot(2,1,2);%在第2行绘制原始信号
%  plot(f,P1);
%  title('原始信号频谱图');

figure(1);
subplot(2,1,1);%在第1行绘制原始信号
stem(t,A,'fill');
title('原始信号图');

 subplot(2,1,2);
plot(f0,power0)
xlabel('Frequency')
ylabel('Power')
title('原始信号频谱图');
                    