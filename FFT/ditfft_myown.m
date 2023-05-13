function [output1,output2,output3,output4] = ditfft_myown(x_n,N)
%x_n is the input arrary,N is the fft points
x_origin = x_n;
len = length(x_n);
m = log2 (N);                   %蝶形运算所需要的的级数（自左向右依次为1，2，...）

if(len<N)                         %如果序列长度不够，进行补零操作
    x_n = [x_n,zeros(1,N-len)];
end
nxd = bin2dec(fliplr(dec2bin([1:N]-1,m)))+1;    %将坐标进行倒序操作
x_n = x_n(nxd);
A=zeros(N,4);                   %创建一个全零数组A，深度为N，保存每级蝶形运算计算的结果
for i = 1:N
    A(i,1) = x_n(1,i);                  %将原始序列作为A_0数据
end
    %算法流程为:
    %A_L(J)       = A_L-1(J) + W*A_L-1(J+B);
    %A_L(J+B)  = A_L-1(J)  - W*A_L-1(J+B);
    %L为蝶形运算的级数，从1,2....,m，如A_0(J)代表初始的序列值x_n(J);
    %W代表旋转因子(w_N）^P，在第L级蝶形运算中，需要完成2^（m-1）次蝶形运算，每级运算均有2^（m-1）个旋转因子；
    %不同旋转因子的个数为：2^(L-1),且旋转因子中的P=J*2^(m-L);
    %J=0,1...2^L-1;
    %每级蝶形运算有2^(L-1)个不同的旋转因子，具有相同的旋转因子的蝶形算子之间差距2^L个点，因此可以先确定旋转因子，再完成运算
    %B为每级蝶形运算！中！每组蝶形算子中两个输入值的差值，B = 2^（L-1）;比如第一级中，每组蝶形算子差值为1....

    for L=1:m                             %最外层循环肯定是各级蝶形运算
        B = 2^(L-1);
        
        for  J = 0:B-1                       %第L级中J所要遍历的值：2^(L-1)-1.
                                                   %也可以理解J为每级蝶形运算中！具有不同旋转因子的蝶形算子起始点位
              P = J*2^(m-L);               %计算J固定时的旋转因子
              W = exp(-j*2*pi*P/N);
              for k = (J+1) : 2^L :N         %当J固定时，代表下面蝶形算子所使用的旋转因子均一致.
                                                        %这里的循环，则是将旋转因子一致的蝶形算子全部计算出来  
                  A_mid = A(k,L) + A(k+B,L)*W;    %A_mid是用来防止计算改变A(k)中的值，影响A(k+B)的计算
                  A(k+B,L+1) = A(k,L) - A(k+B,L)*W;
                  A(k,L+1) = A_mid;
              end
        end
    end
   output1 = floor(A(:,1));
   output2 = floor(A(:,2));
   output3 = floor(A(:,3));
   output4 = floor(A(:,4));
    
       
    subplot(2,1,1);%在第1行绘制FFT内置函数
    H=fft(x_origin,N);
    [x1,y1]=size(H);
    y1_mid = 1:y1;
    stem(y1_mid,abs(H),'.');
     title('内置FFT');
     
    subplot(2,1,2);%在第2行绘制FFT手写函数
    [x2,y2]=size(output4');%数组列序号作为横坐标
    y2_mid = 1:y2;
    stem(y2_mid,abs(output4'),'.');
    title('手写FFT');
                    
                    