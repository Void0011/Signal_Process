```flow
st=>start: Start_Rst
e=>end: End


op0=>operation: L,J,K=0

op1=>operation: L=1;
J,K=0

op2=>operation: K=K+2^L

op3=>operation: J=J+1
K=J+1

op4=>operation: Wait_3Cycle

op5=>operation: L=L+1

op6=>operation: L,J,K=0
J=0,K=0

op7=>operation: Read_Addr_Finish


cond0=>condition: RAM_Initial

cond1=>condition: K == K_MAX

cond2=>condition: J == 2^(L-1)


cond3=>condition: L ==L_MAX 




st->op0->cond0
op1->op2->cond1

cond0(yes)->op1
cond0(no)->cond0

cond1(yes)->op3(right)->cond2
cond1(no)->op2

cond2(yes)->op4(right)->op5(right)->cond3
cond2(no)->op2

cond3(yes)->op6(right)->op7(right)->cond0
cond3(no)->op2


```