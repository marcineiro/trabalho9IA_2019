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

cd ..
cd OBV
obv16 = xlsread('10_OBV16.xls');
cd ..
cd 'Trabalho 9'

%treinamento da rede

amostras = 900;
entradas = 256;
intNeu = 20;
erroV = 0.001;
alfa = 0.02;
t = zeros(900,10);
for i = 1:90
    t(i*10-9:i*10,:) = eye(10);
end
t(t==0) = -1;

acertos = zeros(1,100);

matrizes_v = zeros(entradas,intNeu,100);
matrizes_v0 = zeros(1,intNeu,100);
matrizes_w = zeros(intNeu,16,100);
matrizes_w0 = zeros(1,16,100);


A = importdata('semeion.data');
A1 = A(1:1593,1:256);
T = A(1:1593,257:266);

organization = randperm(1593);
for n = 1:1593
    treino(n,:) = A1(organization(n),:);
    t(n,:) = T(organization(n),:);
end
treino(treino==0) = -1;
t(t==0) = -1;

t1 = zeros(1593,16);
for i = 1:1593
    for j = 1:10
        if t(i,j)==1
            t1(i,:) = obv16(:,j)';
        end
    end
end
for turn = 1:50
    v = rand(entradas,intNeu)-0.5;
    v0 = rand(1,intNeu)-0.5;
    w = rand(intNeu,16)-0.5;
    w0 = rand(1,16)-0.5;
    vAnterior = v;
    wAnterior = w;
    v0Anterior = v0;
    w0Anterior = w0;
    vAnterior2 = v;
    wAnterior2 = w;
    v0Anterior2 = v0;
    w0Anterior2 = w0;
    beta = 0.25;
    zin = zeros(1,intNeu);
    z = zeros(1,intNeu);
    y = zeros(1500,10);
    y1 = zeros(1500,16);
    erro = 100;
    ciclos = 0;
    while erro > erroV && ciclos < 70
         for padrao=1:1593    %inserindo padrões
            zin = treino(padrao,:)*v+v0;
            for j = 1:intNeu
                z(j)=(1-exp(-2*zin(j)))/(1+exp(-2*zin(j)));
            end
            yin=z*w+w0;
            y1(padrao,:)=(1-exp(-2.*yin))./(1+exp(-2.*yin));
            
%             for classe = 1:10
%                 y(padrao,classe) = sqrt(sum((obv16(:,classe)-y1(padrao,:)').^2));
%             end

%             y(padrao,:) = y1(padrao,:);
            erro = 0.5*(sum((t1(padrao,:) - y1(padrao,:)).^2));        
            deltinhak = ((t1(padrao,:) - y1(padrao,:)).*(1+y1(padrao,:)).*(1-y1(padrao,:)))';
            momentumV = beta.*(vAnterior - vAnterior2);
            momentumV0 = beta.*(v0Anterior - v0Anterior2);
            momentumW = beta.*(wAnterior - wAnterior2);
            momentumW0 = beta.*(w0Anterior - w0Anterior2);
            dw = alfa.*deltinhak*z;
            dw0 = alfa*deltinhak;
            din = (deltinhak)'*(w)';
            deltinhaj = din.*(1+z).*(1-z);
            dv = alfa.*deltinhaj'*treino(padrao,:);
            dv0 = alfa*deltinhaj;
            if padrao>3
                vAnterior2 = vAnterior;
                wAnterior2 = wAnterior;
                v0Anterior2 = v0Anterior;
                w0Anterior2 = w0Anterior;
            end
            if padrao>2
                vAnterior = v;
                wAnterior = w;
                v0Anterior = v0;
                w0Anterior = w0;
            end
            w = w + momentumW + dw';
            w0 = w0 + momentumW0 + dw0';
            v = v + momentumV + dv';
            v0 = v0 + momentumV0 + dv0;
         end
%         erro
        ciclos = ciclos+1;
    end

    erroTotal=0;
    for i = 1:1593
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
        pos = 0;
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

    acertos(turn) = 1 - erroTotal/900;
    
    matrizes_v(:,:,turn) = v;
    matrizes_v0(:,:,turn) = v0;
    matrizes_w(:,:,turn) = w;
    matrizes_w0(:,:,turn) = w0;
    
    turn
end
maior = 0;
for turn = 1:100
    if acertos(turn) > maior
        maior = acertos(turn);
        pos = turn;
    end
end

acertos(pos)
xlswrite('matriz_v.xlsx',matrizes_v(:,:,pos));
xlswrite('vetor_v0.xlsx',matrizes_v0(:,:,pos));
xlswrite('matriz_w.xlsx',matrizes_w(:,:,pos));
xlswrite('vetor_w0.xlsx',matrizes_w0(:,:,pos));