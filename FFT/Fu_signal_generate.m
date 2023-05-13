function  [s3,s3_real_f,s3_imag_f,s_hex,mag2]=Fu_signal_generate(N,fm,fs)

%N=128; % ��������
n=0:N-1;
%fm=1000; % �ز�Ƶ��
%fs=1e4; % ����Ƶ�� 
t=1/fs*n; % ʱ������


s3=100*cos(2*pi*fm*t)+100*1j*sin(2*pi*fm*t); % ���츴�ź�
s3_real_orgin=real(s3);
s3_imag_orgin=imag(s3);


s3_real_f = floor(s3_real_orgin);
s3_imag_f=floor(s3_imag_orgin);
for i = 1:N
    if(s3_real_f(1,i)<0)
        s3_real_f(1,i)=s3_real_f(1,i)+2^24;%��չ��24λ�Ĳ���
    else
        s3_real_f(1,i)=s3_real_f(1,i);
    end
    
     if(s3_imag_f(1,i)<0)
        s3_imag_f(1,i)=s3_imag_f(1,i)+2^24;%��չ��24λ
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
f=[0:N-1]*fs/N; % ��ʵƵ��
mag1=abs((fft(s3_1,N,2))); % FFT���������������ͬ

mag2=abs((fft(s3,N,2)));
figure(1)
plot(f,mag2);
xlabel('Ƶ��f/Hz');
ylabel('����');
title('���ź�s3��Ƶ��');
grid on;
figure(2)
plot(t,s3);
xlabel('ʱ��');
ylabel('����');
title('���źŵ�ʱ����');
grid on;
figure(3)
mesh(f,n,mag1)
set(gca, 'color', [202 / 255, 234 / 255, 206 / 255]);
xlabel('Ƶ��/Hz','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'r');
ylabel('FFT����','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'r');
zlabel('��ֵ','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'r');
title('���ź�s3��3DƵ��ͼ','FontSize', 15 , 'FontWeight', 'bold', 'Color', 'k')
