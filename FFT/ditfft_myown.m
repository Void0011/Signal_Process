function [output1,output2,output3,output4,output5,output6,output7,output8,output9,output10] = ditfft_myown(x_n,N)
%x_n is the input arrary,N is the fft points
x_origin = x_n;
len = length(x_n);
m = log2 (N);                   %������������Ҫ�ĵļ�����������������Ϊ1��2��...��

if(len<N)                         %������г��Ȳ��������в������
    x_n = [x_n,zeros(1,N-len)];
end
nxd = bin2dec(fliplr(dec2bin([1:N]-1,m)))+1;    %��������е������
x_n = x_n(nxd);
A=zeros(N,10);                   %����һ��ȫ������A�����ΪN������ÿ�������������Ľ��
for i = 1:N
    A(i,1) = x_n(1,i);                  %��ԭʼ������ΪA_0����
end
    %�㷨����Ϊ:
    %A_L(J)       = A_L-1(J) + W*A_L-1(J+B);
    %A_L(J+B)  = A_L-1(J)  - W*A_L-1(J+B);
    %LΪ��������ļ�������1,2....,m����A_0(J)�����ʼ������ֵx_n(J);
    %W������ת����(w_N��^P���ڵ�L�����������У���Ҫ���2^��m-1���ε������㣬ÿ���������2^��m-1������ת���ӣ�
    %��ͬ��ת���ӵĸ���Ϊ��2^(L-1),����ת�����е�P=J*2^(m-L);
    %J=0,1...2^L-1;
    %ÿ������������2^(L-1)����ͬ����ת���ӣ�������ͬ����ת���ӵĵ�������֮����2^L���㣬��˿�����ȷ����ת���ӣ����������
    %BΪÿ���������㣡�У�ÿ�������������������ֵ�Ĳ�ֵ��B = 2^��L-1��;�����һ���У�ÿ��������Ӳ�ֵΪ1....

    for L=1:m                             %�����ѭ���϶��Ǹ�����������
        B = 2^(L-1);
        
        for  J = 0:B-1                       %��L����J��Ҫ������ֵ��2^(L-1)-1.
                                                   %Ҳ�������JΪÿ�����������У����в�ͬ��ת���ӵĵ���������ʼ��λ
              P = J*2^(m-L);               %����J�̶�ʱ����ת����
              W = exp(-j*2*pi*P/N);
              for k = (J+1) : 2^L :N         %��J�̶�ʱ�������������������ʹ�õ���ת���Ӿ�һ��.
                                                        %�����ѭ�������ǽ���ת����һ�µĵ�������ȫ���������  
                  A_mid = A(k,L) + A(k+B,L)*W;    %A_mid��������ֹ����ı�A(k)�е�ֵ��Ӱ��A(k+B)�ļ���
                  A(k+B,L+1) = A(k,L) - A(k+B,L)*W;
                  A(k,L+1) = A_mid;
              end
        end
    end
   output1 = floor(A(:,1));
   output2 = floor(A(:,2));
   output3 = floor(A(:,3));
   output4 = floor(A(:,4));
   output5 = floor(A(:,5));
   output6 = floor(A(:,6));
   output7 = floor(A(:,7));
   output8 = floor(A(:,8));
   output9 = floor(A(:,9));
   output10 = floor(A(:,10));
   
  FPGA_RE=importdata('./FPGA_FFT_OUT.txt');
  FPGA_IM=importdata('./FPGA_FFT_OUT_im.txt');
  FFT_FPGA=(FPGA_RE.^2+FPGA_IM.^2).^0.5;
    
 figure(1);
    subplot(3,1,1);%�ڵ�1�л���FFT���ú���
    H=fft(x_origin,N);
    [x1,y1]=size(H);
    y1_mid = 1:y1;
    stem(y1_mid,abs(H),'.');
     title('����FFT');
     
    subplot(3,1,2);%�ڵ�2�л���FFT��д����
    [x2,y2]=size(A(:,10)');%�����������Ϊ������
    y2_mid = 1:y2;
    stem(y2_mid,abs(A(:,10)'),'.');
    title('��дFFT');
    
    subplot(3,1,3);%�ڵ�3�л���FPGA�����FFT
    [x3,y3]=size(FFT_FPGA');%�����������Ϊ������
    y3_mid = 1:y3;
    stem(y3_mid,(FFT_FPGA'),'.');
    title('FPGAFFT');
 
    figure(2);
    subplot(2,1,1);%�ڵ�3�л���FPGA�����FFT
    stem(y1_mid,abs(H),'.');  
    hold on;
    stem(y3_mid,(FFT_FPGA'),':diamondr');

    title('FFT-Compare');
    xlabel('N');
    ylabel('Value');
    legend('Matlab-FFT','FPGA-FFT');
    
  subplot(2,1,2);%�ڵ�3�л���FPGA�����FFT
  sub=abs(abs(H)-(FFT_FPGA'))./abs(H);
  plot(y3_mid,sub);
  

    title('Difference');
    xlabel('N');
    ylabel('Value');
    
                    
                    