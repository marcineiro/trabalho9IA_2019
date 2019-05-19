%testes trabalho 9 IA
clear
clc
% cd digitos
%vetores teste
intNeu = 20;
testes = zeros(900,256);

% treino = dlmread('digitostreinamento900.txt');
% cd ..
% cd Matriz_95
v = xlsread('matriz_v.xlsx');
v0 = xlsread('vetor_v0.xlsx');
w = xlsread('matriz_w.xlsx');
w0 = xlsread('vetor_w0.xlsx');
% cd ..

cd ..
cd OBV
obv16 = xlsread('10_OBV16.xls');
cd ..
cd 'Trabalho 9'

A = importdata('semeion.data');
A(A==0) = -1;
treino = A(:,1:256);
t = A(:,257:266);

numData = 400;

zin = zeros(1,intNeu);
z = zeros(1,intNeu);
y = zeros(numData,16);
yin = zeros(numData,16);
y1 = zeros(numData,16);
erroTotal=0;
for i = 1:numData
    zin = treino(i,:)*v+v0;
    for j = 1:intNeu
        z(j)=(1-exp(-2*zin(j)))/(1+exp(-2*zin(j)));
    end
    yin=z*w+w0;
    y1(i,:) =(1-exp(-2.*yin))./(1+exp(-2.*yin));
    for classe = 1:10
        y(i,classe) = sqrt(sum((obv16(:,classe)-y1(i,:)').^2));
    end
    valor = 10;
    for classe = 1:10
        if y(i,classe) < valor
            valor = y(i,classe);
            pos = classe;
        end
    end
    for classe = 1:10
        if classe == pos
            y(i,classe) = 1;
        else 
            y(i,classe) = -1;
        end
    end
    
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

acertos = 1 - erroTotal/numData