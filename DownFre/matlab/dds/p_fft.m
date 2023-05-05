function output = p_fft(Fs)

%read the data from the txt,The N is the lenth of the signal
fileID = fopen('./fout.txt','r');
formatSpec = '%d';
sizeA = [1 Inf];
A = fscanf(fileID,formatSpec,sizeA)
A=A-2000;
N=length(A);

%����Ƶ��
Ts=1/Fs;
%���ݲ���Ƶ������������õ��ź�Ƶ��
Fc=Fs/N;
Tc=1/Fc;

t=(0:N-1)*Ts;%����t��TsΪ�����ֱ��Tc
F_d=Fs/N;%Ƶ�ʷֱ���ΪF_d

f=F_d*(0:N-1);%������fֻ��Ҫȡһ�뼴��

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
%  subplot(2,1,1);%�ڵ�1�л���ԭʼ�ź�
% plot(t,A); 
%  title('ԭʼ�ź�ͼ');
%  
%  subplot(2,1,2);%�ڵ�2�л���ԭʼ�ź�
%  plot(f,P1);
%  title('ԭʼ�ź�Ƶ��ͼ');

figure(1);
subplot(2,1,1);%�ڵ�1�л���ԭʼ�ź�
stem(t,A,'fill');
title('ԭʼ�ź�ͼ');

 subplot(2,1,2);
plot(f0,power0)
xlabel('Frequency')
ylabel('Power')
title('ԭʼ�ź�Ƶ��ͼ');
                    