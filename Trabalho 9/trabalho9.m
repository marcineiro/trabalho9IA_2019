%Trabalho 9 - Inteligência Artificial
clear
clc
cd digitos
%vetores teste
testes = zeros(900,256);
k=1;
for j = 1:90
    for i = 1:10
        fileName = sprintf('%d_%d.txt',i-1,j);
        testes(k,:) = dlmread(fileName);
        k=k+1;
    end
end
% testes(testes==-1) = 0;

%vetores treinamento
treino = dlmread('digitostreinamento900.txt');
% treino(treino==-1) = 0;
cd ..

%treinamento da rede

amostras = 900;
entradas = 256;
intNeu = 20;
erroV = 0.001;
alfa = 0.05;
t = zeros(900,10);
for i = 1:90
    t(i*10-9:i*10,:) = eye(10);
end
t(t==0) = -1;

v = rand(entradas,intNeu)-0.5;
v0 = rand(1,intNeu)-0.5;
w = rand(intNeu,10)-0.5;
w0 = rand(1,10)-0.5;
beta = 0.75;
zin = zeros(1,intNeu);
z = zeros(1,intNeu);
y = zeros(900,10);
erro = 100;
ciclos = 0;
while erro > erroV && ciclos < 25
     for padrao=1:amostras    %inserindo padrões
        zin = treino(padrao,:)*v+v0;
        for j = 1:intNeu
            z(j)=(1-exp(-2*zin(j)))/(1+exp(-2*zin(j)));
        end
        yin=z*w+w0;
        y(padrao,:)=(1-exp(-2.*yin))./(1+exp(-2.*yin));
        
%         y(y<0) = -1;
%         y(y>0) = 1;

        erro = 0.5*(sum((t(padrao,:) - y(padrao,:)).^2));        
        deltinhak = ((t(padrao,:) - y(padrao,:)).*(1+y(padrao,:)).*(1-y(padrao,:)))';
        dw = alfa.*deltinhak*z;
        dw0 = alfa*deltinhak;
        din = (deltinhak)'*(w)';
        deltinhaj = din.*(1+z).*(1-z);
        dv = alfa.*deltinhaj'*treino(padrao,:);
        dv0 = alfa*deltinhaj;
        w = w + dw';
        w0 = w0 + dw0';
        v = v + dv';
        v0 = v0 + dv0;
     end
    erro
    ciclos = ciclos+1;
end

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

acertos = 1 - erroTotal/900

ciclos