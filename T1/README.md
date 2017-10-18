# Pacman
## Trabalho 1 de inteligência artificial
Trabalho realizado por:
	Marcio Lima Inácio
    
## Passos para a implementação
Para se obter a solução do problema, foi preciso realizar uma série de passos, incluindo: modelagem dos estados, modelagem das transições, geração da busca e implementação. Cada um dos momentos está descrito com detalhes a seguir.

### Definição dos estados
O primeiro passo para se atingir a solução do problema é a definição dos estados do problema. Para isso, optou-se por representar o estado como uma lista representando as posições do tabuleiro. Por exemplo, um tabuleiro de 2x2 seria representado por uma lista de 4 posições.

Cada posição da lista pode ter cinco diferentes valores:

- pacman - Indica que o personagem está naquela posição;
- fantasma - Indica que há um fantasma naquela posição;
- ponto - Indica que há um ponto especial esta naquela posição;
- cereja - Indica que a cereja esta naquela posição;
- vazio - Indica que a posição está vazia.

Portanto, um estado válido para um tabuleiro de dimenções 5x5 pode ser:
```
[pacman,vazio,vazio,vazio,vazio,vazio,fantasma,vazio,vazio,vazio,vazio,ponto,
vazio,fantasma,vazio,fantasma,vazio,vazio,vazio,vazio,vazio,vazio,vazio,fantasma,cereja]
```
Representado, na interface gráfica utilizada neste trabalho, como:
```
-------------------------
|   <   _   _   _   _   |
-------------------------
|   _   x   _   _   _   |
-------------------------
|   _   o   _   x   _   |
-------------------------
|   x   _   _   _   _   |
-------------------------
|   _   _   _   x   C   |
-------------------------
```
Em que `<` representa o pacman, `X` representa um fantasma, `o` representa o ponto especial, `C` representa a cereja e `_` representa espaço vazio.

### Modelagem das transições
As transições entre os estados dizem respeito à movimentação do pacman. Portanto as transições foram geradas a partir de quatro movimentações básicas: cima, baixo, direita e esquerda.

A movimentação só pode ser bem sucedida em dois casos distintos:

- Caso o pacman não possa comer fantasmas (nunca passou pelo ponto especial), ele não pode passar por nenhum fantasma. Portanto não deve existir fantasma na posição seguinte ao movimento;
- Caso o pacman possa comer fantasmas (já passou pelo ponto especial), sua movimentação não é impedida.

Em nenhum dos casos, o pacman pode se movimentar, caso a próxima movimentação seja para fora do tabuleiro de tamanho especificado, isto é, se o tabuleiro possui um tamanho de 5x5, o pacman não poderá andar para as coordenadas (5, 0), considerando que a contagem das coordenadas se inicia no número 0, pois a coordenada 5 no eixo x está fora do tabuleiro estipulado.

A movimentação é a transição necessária, partindo de um estado do tabuleiro em uma determinada configuração para outra diferente, portanto o estado sucessor.

### Geração da busca
O método de busca utilizado foi Busca em Profundidade, pelo fato de não gastar muita memória (sua complexidade de memória é linear) em comparação com a Busca em Largura que possui uma complexidade de memória exponencial. A escolha desta abordagem de busca torna mais difícil problemas de _overflow_ ou ''estouro'' da pilha de execução.

Também é possível se utilizar o próprio método de _backtracking_ para a implementação da busca em largura, tornando a programação do problema mais simples.

### Implementação

__Inicialização__

O primeiro passo para a implementação foi a criação do estado inicial, realizada a partir de parâmetros indicados pelo usuário em regras definidas na primeira seção do código:

```prolog
% % % Parametros
% % Parametros do jogo estao nesta secao
% % Alterar apenas esta parte do codigo para adaptar o jogo


%% dimensoes(+Largura, +Altura)
% Representa as dimensoes Largura e Altura do tabuleiro.
% Largura eh o numero de posicoes horizontais.
% Altura eh o numero de posicoes verticais
dimensoes(5, 5).

%% posicao(+Objeto, +X, +Y)
% Representa a posicao de Objeto
% Objeto pode possuir os seguintes valores:
%   pacman, ponto, cereja
% So pode existir um predicado para cada valor de Objeto
posicao(pacman, 0, 0).
posicao(ponto, 1, 2).
posicao(cereja, 4, 4).

%% posicao(fantasma, +ListaPosicoes)
% Representa as posicoes dos fantasmas
% ListaPosicoes e uma lista de listas
% As sublistas possuem duas posicoes, indicando as coordenadas de cada fantasma
posicao(fantasma, [[0, 3], [1, 1], [3, 2], [3, 4]]).
```

Com esses parâmetros, o predicado `cria_tabuleiro(?Tabuleiro)` pode criar o estado inicial do problema.

```prolog
%% cria_tabuleiro(?Tabuleiro)
% Cria o Tabuleiro e inicializa todos os objetos
cria_tabuleiro(Tabuleiro) :- dimensoes(Largura, Altura),
                             Length is Largura*Altura,
                             length(TabuleiroTemp, Length),
                             add_objeto(pacman, TabuleiroTemp),
                             add_objeto(fantasma, TabuleiroTemp),
                             add_objeto(ponto, TabuleiroTemp),
                             add_objeto(cereja, TabuleiroTemp),
                             add_vazios(TabuleiroTemp, Tabuleiro).
```

Para a realização desta criação, uma lista inicial de tamanho `Largura*Altura` é criada através do predicado `length(?List, ?Int)` com todas as suas posições iguais à variável anônima `_`, podendo ser unificado com qualquer valor.

Após isso, são chamados diversos predicados do tipo `add_objeto(+Objeto, +?Tabuleiro)`.

```prolog
%% add_objeto(+Objeto, +?Tabuleiro)
% Insere Objeto em Tabuleiro de acordo com as coordenadas
% indicadas nos parametros da execucao
add_objeto(Objeto, Tabuleiro) :- posicao(Objeto, X, Y),
                                 coordenadas(Objeto, Tabuleiro, X, Y).
```
Caso o objeto seja fantasma, ele deve adicionar de acordo com uma lista de coordenadas.
```prolog
%% add_objeto(fantasma, +?Tabuleiro)
% Insere N fantasmas em Tabuleiro
% em coordenadas indicadas nos parametros
add_objeto(fantasma, Tabuleiro) :- posicao(fantasma, ListaPosicoes),
                                   add_fantasmas(Tabuleiro, ListaPosicoes), !.
                                   
%% add_fantasmas(+?Tabuleiro, +ListaPosicoes)
% Insere em Tabuleiro N fantasmas
% ListaPosicoes eh uma lista de listas em que cada sublista
% possui as duas coordenadas do fantasma
add_fantasmas(_, []) :- !.
add_fantasmas(Tabuleiro, [[X, Y] | Cauda]) :- coordenadas(fantasma, Tabuleiro, X, Y),
                                              add_fantasmas(Tabuleiro, Cauda).
```
Depois de adicionados todos os objetos, o tabuleiro deve ser preenchido por espaços vazios.
```prolog
%% add_vazios(+Tabuleiro, ?TabuleiroPreenchido)
% Insere nas posicoes nao preenchidas do Tabuleiro (com _)
% o valor atomico 'vazio', retornando em TrabuleiroPreenchido
add_vazios([], []) :- !.
add_vazios([Cabeca|Cauda], [vazio|CaudaNext]) :- not(atom(Cabeca)),
                                                 add_vazios(Cauda, CaudaNext), !.
add_vazios([Cabeca|Cauda], [Cabeca|CaudaNext]) :- atom(Cabeca),
                                                  add_vazios(Cauda, CaudaNext).
```

__Geração de estados e transições__

Após a criação do estado inicial, é preciso implementar as transições, que indicaram à busca quais ações devem ser tomadas e quais os estados sucessores do estado atual.

```prolog
%% s(+Estado, ?Sucessor)
% Representa uma transicao de Estado para o estado Sucessor
% Os estados Sucessores podem ser obtidos pela movimentacao
% do pacman em todas as quatro direções:
% direita, esquerda, cima e baixo
s(Estado, Sucessor) :- move_direita(Estado, Sucessor);
                       move_esquerda(Estado, Sucessor);
                       move_cima(Estado, Sucessor);
                       move_baixo(Estado, Sucessor).
```

A lógica presente na hora da movimentação segue o cálculo das novas coordenadas do pacman e do índice correspondente na lista que representa o Estado. O movimento é realizado trocando-se o conteúdo das duas posições na lista.

As movimentações seguem o mesmo padrão de verificação da possibilidade de se poder realizar o movimento. Também são realizadas verificações de:

- Se o pacman for para a posição onde está o ponto  especial, ele irá comer o ponto, trocando sua posição por vazio antes de efetivamente andar para a posição do ponto.
- Se o pacman puder comer fantasmas e andar para a  posição de um fantasma, o fantasma será comido e sua posição virará vazia antes de realizar a movimentação.

```prolog
%% move_<direcao>(+Estado, ?Sucessor)
% Sucessor representa o Estado apos o Pacman se mover para a <direcao>
% A condicao principal para a movimentacao eh
% haver espaco livre para onde o Pacman ira andar
% Existem tambem outras duas condicoes:
%   Pacman nao pode comer fantasmas, portanto nao pode passar por eles
%   Pacman pode comer fantasmas, estando livre para se mover
move_direita(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                                  dimensoes(Largura, _),
                                  % Ha espaco livre a direita de X
                                  X < Largura-1,
                                  XNext is X+1,
                                  % Pacman nao pode comer fantasmas
                                  not(come_fantasmas(Estado)),
                                  % Nao ha fantasma a direita do Pacman
                                  not(coordenadas(fantasma, Estado, XNext, Y)),
                                  % Verifica se a próxima posição e ponto
                                  % Come ponto
                                  (posicao(ponto, XNext, Y) ->
                                      come_ponto(Estado, EstadoAux);
                                      copy_term(Estado, EstadoAux)),
                                  % Anda com o pacman
                                  indice(X, Y, Indice),
                                  indice(XNext, Y, IndiceNext),
                                  troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                                  % Pacman pode comer fantasmas, ponto especial
                                  % ja foi comido
                                  coordenadas(pacman, Estado, X, Y),
                                  dimensoes(Largura, _),
                                  X < Largura-1,
                                  XNext is X+1,
                                  come_fantasmas(Estado),
                                  (tem_fantasma(XNext, Y) ->
                                      come_fantasma(Estado, X, Y, EstadoAux);
                                      copy_term(Estado, EstadoAux)),
                                  indice(X, Y, Indice),
                                  indice(XNext, Y, IndiceNext),
                                  troca(Indice, IndiceNext, EstadoAux, Sucessor).

move_esquerda(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                                X > 0,
                                XNext is X-1,
                                not(come_fantasmas(Estado)),
                                not(coordenadas(fantasma, Estado, XNext, Y)),
                                (posicao(ponto, XNext, Y) ->
                                    come_ponto(Estado, EstadoAux);
                                    copy_term(Estado, EstadoAux)),
                                indice(X, Y, Indice),
                                indice(XNext, Y, IndiceNext),
                                troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                                coordenadas(pacman, Estado, X, Y),
                                X > 0,
                                XNext is X-1,
                                come_fantasmas(Estado),
                                (tem_fantasma(XNext, Y) ->
                                    come_fantasma(Estado, XNext, Y, EstadoAux);
                                    copy_term(Estado, EstadoAux)),
                                indice(X, Y, Indice),
                                indice(XNext, Y, IndiceNext),
                                troca(Indice, IndiceNext, EstadoAux, Sucessor).

move_cima(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                               Y > 0,
                               YNext is Y-1,
                               not(come_fantasmas(Estado)),
                               not(coordenadas(fantasmas, Estado, X, YNext)),
                               (posicao(ponto, X, YNext) ->
                                   come_ponro(Estado, EstadoAux);
                                   copy_term(Estado, EstadoAux)),
                               indice(X, Y, Indice),
                               indice(X, YNext, IndiceNext),
                               troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                               coordenadas(pacman, Estado, X, Y),
                               Y > 0,
                               YNext is Y-1,
                               come_fantasmas(Estado),
                               (tem_fantasma(X, YNext) ->
                                   come_fantasma(Estado, X, YNext, EstadoAux);
                                   copy_term(Estado, EstadoAux)),
                               indice(X, Y, Indice),
                               indice(X, YNext, IndiceNext),
                               troca(Indice, IndiceNext, EstadoAux, Sucessor).

move_baixo(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                              dimensoes(_, Altura),
                              Y < Altura-1,
                              YNext is Y+1,
                              not(come_fantasmas(Estado)),
                              not(coordenadas(fantasmas, Estado, X, YNext)),
                              (posicao(ponto, X, YNext) ->
                                  come_ponto(Estado, X, YNext, EstadoAux);
                                  copy_term(Estado, EstadoAux)),
                              indice(X, Y, Indice),
                              indice(X, YNext, IndiceNext),
                              troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                              coordenadas(pacman, Estado, X, Y),
                              dimensoes(_, Altura),
                              Y < Altura-1,
                              YNext is Y+1,
                              come_fantasmas(Estado),
                              (tem_fantasma(X, YNext) ->
                                  come_fantasma(Estado, X, YNext, EstadoAux);
                                  copy_term(Estado, EstadoAux)),
                              indice(X, Y, Indice),
                              indice(X, YNext, IndiceNext),
                              troca(Indice, IndiceNext, EstadoAux, Sucessor).
```
