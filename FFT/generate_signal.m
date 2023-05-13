%fsΪ����Ƶ�� LΪ�źų���
function output = generate_signal(fs,L);

T=1/fs;

t=(0:L-1)*T;

s = 0.7*sin(2*pi*800*t)+0.4*sin(2*pi*1200*t);


y=fft(s);


P2 = abs(y/L);


P1 = P2(1:L/2+1);


P1(2:end-1) = 2*P1(2:end-1);

f=fs*(0:(L/2))/L;


 subplot(2,1,1);
 plot(t,s);
 title('ԭʼ�ź�ͼ');
 
subplot(2,1,2);
 plot(f,P1);
 title('Ƶ��ͼ');

output = s;
