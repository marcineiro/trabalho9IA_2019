clear all
clc

% Digite a dimensão dos vetores NOV
dim=16;


% Digite a quantidade de padrões a serem classificados

quant=2;

% Digite a quantidade de amostras por padrão para embaralhamento

amostras=2;

matriz1=ones(dim,dim);
matriz2=(-1)*matriz1;

for i=1:dim
    for j=1:dim
        if i==j
            matriz2(i,j)=1;
        end
    end
end

for m=1:dim
    for n=1:quant
        matriz3(m,n)=matriz2(m,n);
    end
end

t=1;
matriz4=matriz3;
while (t<amostras)
    
    matriz4=[matriz4 matriz3];
    t=t+1;

end

% cd('E:\Drive\Extras\Doutorado\Pesquisa\Experimentos atuais\irisnova\saida')
char1=char('nov');
char2=num2str(dim);
char3=char('para');
char4=num2str(amostras);
char5=char('.txt');

nome=strcat(char1,char2,char3,char4,char5);

% save(nome,'matriz4','-ASCII');
xlswrite('gerado',matriz4);
