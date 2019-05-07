%testes trabalho 9 IA
clear
clc
cd digitos
%vetores teste
intNeu = 10;
testes = zeros(900,256);
k=1;
for j = 1:90
    for i = 1:10
        fileName = sprintf('%d_%d.txt',i-1,j);
        testes(k,:) = dlmread(fileName);
        k=k+1;
    end
end

treino = dlmread('digitostreinamento900.txt');
cd ..
cd Matriz_95
v = xlsread('matriz_v.xlsx');
v0 = xlsread('vetor_v0.xlsx');
w = xlsread('matriz_w.xlsx');
w0 = xlsread('vetor_w0.xlsx');
cd ..
zin = zeros(1,intNeu);
z = zeros(1,intNeu);
y = zeros(900,10);

t = zeros(900,10);
for i = 1:90
    t(i*10-9:i*10,:) = eye(10);
end
t(t==0) = -1;

erroTotal=0;
for i = 1:900
    zin = testes(i,:)*v+v0;
    for j = 1:intNeu
        z(j)=(1-exp(-2*zin(j)))/(1+exp(-2*zin(j)));
    end
    yin=z*w+w0;
    y(i,:) =(1-exp(-2.*yin))./(1+exp(-2.*yin));
    y(y<0)=-1;
    y(y>0)=1;
    erro = 0;
    for j = 1:10
        if(t(i,j)~=y(i,j))
            erro = 1;
        end
    end
    if(erro~=0)
        erroTotal = erroTotal+1;
    end
end

acertosTeste = 1 - erroTotal/900

zin = zeros(1,intNeu);
z = zeros(1,intNeu);
y = zeros(900,10);
yin = zeros(900,10);
erroTotal=0;
for i = 1:900
    zin = treino(i,:)*v+v0;
    for j = 1:intNeu
        z(j)=(1-exp(-2*zin(j)))/(1+exp(-2*zin(j)));
    end
    yin=z*w+w0;
    y(i,:) =(1-exp(-2.*yin))./(1+exp(-2.*yin));
    y(y<0)=-1;
    y(y>0)=1;
    erro = 0;
    for j = 1:10
        if(t(i,j)~=y(i,j))
            erro = 1;
        end
    end
    if(erro~=0)
        erroTotal = erroTotal+1;
    end
end

acertosTreino = 1 - erroTotal/900

acertosMedia = (acertosTreino+acertosTeste)/2