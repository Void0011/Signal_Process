function fine=sine_gener(N,width)

%N为ROM深度，width为位宽

depth =2^N; %存储器的深度
Y=zeros(1,depth);

qqq = fopen('sine.mif','wt') %使用fopen函数生成sine.mif
fprintf(qqq, 'depth = %d;\n',depth); %使用fprintf打印depth = ;
fprintf(qqq, 'width = %d;\n',width); %使用fprintf打印width = ;
fprintf(qqq, 'address_radix = UNS;\n'); %使用fprintf打印address_radix = UNS; 表示无符号显示数据
fprintf(qqq,'data_radix = UNS;\n'); %使用fprintf打印data_radix = UNS; 表示无符号显示数据
fprintf(qqq,'content begin\n'); %使用fprintf打印content begin

for(x = 1 : depth) %产生正弦数据
    fprintf(qqq,'%d:%d;\n',x-1,round((2^(width-1)-1)*sin(2*pi*(x-1)/depth)+(2^(width-1)-1))); 
    Y(1,x)=round((2^(width-1)-1)*sin(2*pi*(x-1)/depth)+(2^(width-1)-1));
end

X=1:depth;
stem(X,Y,'filled');

fprintf(qqq, 'end;'); %使用fprintf打印end;
fclose(qqq);



