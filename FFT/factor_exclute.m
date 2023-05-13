
function [re,im,out] = factor_exclute(N)  

m=log2(N);

for i=1:(N/2)
        W_R(1,i) =exp(-1i*2*pi*(i-1)/N);
        W(1,i)=floor(W_R(1,i)*(2^13));%expand 2^13
         r(1,i) = real( W(1,i));
         m(1,i) = imag(W(1,i));
        if(  r(1,i)      <0)
             r(1,i) =   r(1,i) + 2^16;
        else
            r(1,i) =   r(1,i);
        end
        
        if( m(1,i)      <0)
            m(1,i) =  m(1,i) + 2^16;
        else
            m(1,i) = m(1,i);
        end
        w(1,i)=r(1,i)*2^16+m(1,i);%高16位为实部，低16位为虚部。
  end
        re = dec2hex(r);
        im=dec2hex(m);
        out = dec2hex(w);
        


fileID = fopen('F:\Lab_Work\1_Learning\4_Signal_Processing_Code\Signal_Process\FFT\factor.txt','w');
fprintf(fileID,'%08X\n',w);


fclose(fileID);
