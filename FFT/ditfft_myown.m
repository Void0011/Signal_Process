function output = ditfft_myown(x_n,N)
%x_n is the input arrary,N is the fft points
x_origin = x_n;
len = length(x_n);
m = log2 (N);                   %������������Ҫ�ĵļ�����������������Ϊ1��2��...��

if(len<N)                         %������г��Ȳ��������в������
    x_n = [x_n,zeros(1,N-len)];
end
nxd = bin2dec(fliplr(dec2bin([1:N]-1,m)))+1;    %��������е������
x_n = x_n(nxd);
A=zeros(1,N);                   %����һ��ȫ������A������ΪN������ÿ�������������Ľ��
for i = 1:N
    A(i) = x_n(i);                  %��ԭʼ������ΪA_0����
end
    %�㷨����Ϊ:
    %A_L(J)       = A_L-1(J) + W*A_L-1(J+B);
    %A_L(J+B)  = A_L-1(J)  - W*A_L-1(J+B);
    %LΪ��������ļ�������1,2....,m����A_0(J)������ʼ������ֵx_n(J);
    %W������ת����(w_N��^P���ڵ�L�����������У���Ҫ���2^��m-1���ε������㣬ÿ���������2^��m-1������ת���ӣ�
    %��ͬ��ת���ӵĸ���Ϊ��2^(L-1),����ת�����е�P=J*2^(m-L);
    %J=0,1...2^L-1;
    %ÿ������������2^(L-1)����ͬ����ת���ӣ�������ͬ����ת���ӵĵ�������֮����2^L���㣬��˿�����ȷ����ת���ӣ����������
    %BΪÿ���������㣡�У�ÿ�������������������ֵ�Ĳ�ֵ��B = 2^��L-1��;�����һ���У�ÿ��������Ӳ�ֵΪ1....

    for L=1:m                             %�����ѭ���϶��Ǹ�����������
        B = 2^(L-1);
        
        for  J = 0:B-1                       %��L����J��Ҫ������ֵ��2^(L-1)-1.
                                                   %Ҳ��������JΪÿ�����������У����в�ͬ��ת���ӵĵ���������ʼ��λ
              P = J*2^(m-L);               %����J�̶�ʱ����ת����
              W = exp(-j*2*pi*P/N);
              for k = (J+1) : 2^L :N         %��J�̶�ʱ�������������������ʹ�õ���ת���Ӿ�һ��.
                                                        %�����ѭ�������ǽ���ת����һ�µĵ�������ȫ���������  
                  A_mid = A(k) + A(k+B)*W;    %A_mid��������ֹ����ı�A(k)�е�ֵ��Ӱ��A(k+B)�ļ���
                  A(k+B) = A(k) - A(k+B)*W;
                  A(k) = A_mid;
              end
        end
    end
    output = A;
    
       
    subplot(2,1,1);%�ڵ�1�л���FFT���ú���
    H=fft(x_origin,N);
    [x1,y1]=size(H);
    y1_mid = 1:y1;
    stem(y1_mid,abs(H),'.');
     title('����FFT');
     
    subplot(2,1,2);%�ڵ�2�л���FFT��д����
    [x2,y2]=size(output);%�����������Ϊ������
    y2_mid = 1:y2;
    stem(y2_mid,abs(output),'.');
    title('��дFFT');
                    
                    