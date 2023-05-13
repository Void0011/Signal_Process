function  [s3,s3_real_f,s3_imag_f,s_hex,mag2]=Fu_signal_generate(N,fm,fs)

%N=128; % 采样点数
n=0:N-1;
%fm=1000; % 载波频率
%fs=1e4; % 采样频率 
t=1/fs*n; % 时间向量


s3=100*cos(2*pi*fm*t)+100*1j*sin(2*pi*fm*t); % 构造复信号
s3_real_orgin=real(s3);
s3_imag_orgin=imag(s3);


s3_real_f = floor(s3_real_orgin);
s3_imag_f=floor(s3_imag_orgin);
for i = 1:N
    if(s3_real_f(1,i)<0)
        s3_real_f(1,i)=s3_real_f(1,i)+2^24;%扩展到24位的补码
    else
        s3_real_f(1,i)=s3_real_f(1,i);
    end
    
     if(s3_imag_f(1,i)<0)
        s3_imag_f(1,i)=s3_imag_f(1,i)+2^24;%扩展到24位
    else
        s3_imag_f(1,i)=s3_imag_f(1,i);
     end
    s(1,i)=s3_real_f(1,i)*2^24+s3_imag_f(1,i);
end
    
    s_hex=dec2hex(s);
    
fileID = fopen('F:\Lab_Work\1_Learning\4_Signal_Processing_Code\Signal_Process\FFT\signal.txt','w');
fprintf(fileID,'%012X\n',s);
fclose(fileID);

s3_1=repmat(s3,N,1);
y1=zeros(length(s3_1)/2-1,length(s3_1));
y2=zeros(length(s3_1)/2,length(s3_1));
s3_1(1:end/2-1,:)=y1;
s3_1(end/2+1:end,:)=y2;
f=[0:N-1]*fs/N; % 真实频率
mag1=abs((fft(s3_1,N,2))); % FFT点数与采样点数相同

mag2=abs((fft(s3,N,2)));
figure(1)
plot(f,mag2);
xlabel('频率f/Hz');
ylabel('幅度');
title('复信号s3的频谱');
grid on;
figure(2)
plot(t,s3);
xlabel('时间');
ylabel('幅度');
title('复信号的时域波形');
grid on;
figure(3)
mesh(f,n,mag1)
set(gca, 'color', [202 / 255, 234 / 255, 206 / 255]);
xlabel('频率/Hz','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'r');
ylabel('FFT点数','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'r');
zlabel('幅值','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'r');
title('复信号s3的3D频谱图','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'k')
