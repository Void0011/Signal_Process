function fine=sine_gener(N,width)

%NΪROM��ȣ�widthΪλ��

depth =2^N; %�洢�������
Y=zeros(1,depth);

qqq = fopen('sine.mif','wt') %ʹ��fopen��������sine.mif
fprintf(qqq, 'depth = %d;\n',depth); %ʹ��fprintf��ӡdepth = ;
fprintf(qqq, 'width = %d;\n',width); %ʹ��fprintf��ӡwidth = ;
fprintf(qqq, 'address_radix = UNS;\n'); %ʹ��fprintf��ӡaddress_radix = UNS; ��ʾ�޷�����ʾ����
fprintf(qqq,'data_radix = UNS;\n'); %ʹ��fprintf��ӡdata_radix = UNS; ��ʾ�޷�����ʾ����
fprintf(qqq,'content begin\n'); %ʹ��fprintf��ӡcontent begin

for(x = 1 : depth) %������������
    fprintf(qqq,'%d:%d;\n',x-1,round((2^(width-1)-1)*sin(2*pi*(x-1)/depth)+(2^(width-1)-1))); 
    Y(1,x)=round((2^(width-1)-1)*sin(2*pi*(x-1)/depth)+(2^(width-1)-1));
end

X=1:depth;
stem(X,Y,'filled');

fprintf(qqq, 'end;'); %ʹ��fprintf��ӡend;
fclose(qqq);



