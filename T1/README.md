# Pacman

## Trabalho 1 de inteligência artificial

Trabalho realizado por:
Marcio Lima Inácio - 587265

## Como executar

Esta seção possui as informações necessárias para a execução do programa no Prolog. Bem como as configurações utilizadas para a implementação.

### Pré-requisitos

É necessária a presença de uma ferramenta de Prolog para que seja possível realizar as consultas e execução do trabalho. A implementação foi executada com o uso do `SWI-Prolog version 7.5.3 for x86_64-linux`.

Também é necessária a presença do Python 3.x para a execução do _script_ para a interface gráfica do programa. Durante a confecção do trabalho, utilizou-se o `Python 3.5.3`.

Também é necessária a presença da biblioteca `subprocess` para o Prolog. Esta biblioteca está presente no pacote `clib`, já embutido na instalação do SWI-Prolog em versões mais recentes. Em versões mais antigas de Linux, para verificar a instalação do pacote `clib`, basta executar o comando `apt-cache search prolog`.

### Execução

Para executar, é necessário carregar o arquivo principal do trabalho. Com todos os arquivos na mesma pasta, sendo a mesma pasta em que se está presente no Terminal, executa-se:

``` bash
swipl pacman.pl
```

Com isso, os arquivos necessários serão carregados. Para carregar o programa já de dentro da interface Prolog, executa-se:

```prolog
?- [pacman].
```

Uma vez carregado o trabalho, executa-se uma única consulta com:

```prolog
?- run().
```

Com todas as configurações realizadas corretamente, a consulta deverá ser realizada. A tecla da barra de espaço indica o retrocesso (tentativa da busca por um novo caminho) e a tecla Enter termina a busca. Uma vez pressionada a tecla Enter, a interface gráfica desenhará o resultado da busca ou das diversas buscas realizadas, dependendo de quantos retrocessos foram feitos com a barra de espaço.

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

Portanto, um estado válido para um tabuleiro de dimensões 5x5 pode ser:

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

A movimentação só pode ser bem sucedida em três casos distintos:

- Caso o pacman não possa comer fantasmas (nunca passou pelo ponto especial), ele não pode passar por nenhum fantasma. Portanto não deve existir fantasma na posição seguinte ao movimento;
- Caso o pacman possa comer fantasmas (já passou pelo ponto especial), sua movimentação não é impedida pela presença de fantasmas;
- Caso o pacman já tenha comido todos os fantasmas, ele poderá se mover para a posição que possui a cereja.

Em nenhum dos casos, o pacman pode se movimentar, caso a próxima movimentação seja para fora do tabuleiro de tamanho especificado, isto é, se o tabuleiro possui um tamanho de 5x5, o pacman não poderá andar para as coordenadas (5, 0), considerando que a contagem das coordenadas se inicia no número 0, pois a coordenada 5 no eixo x está fora do tabuleiro estipulado.

A movimentação é a transição necessária, partindo de um estado do tabuleiro em uma determinada configuração para outra diferente, portanto o estado sucessor.

### Geração da busca

O método de busca utilizado foi Busca em Profundidade, pelo fato de não gastar muita memória (sua complexidade de memória é linear) em comparação com a Busca em Largura que possui uma complexidade de memória exponencial. A escolha desta abordagem de busca torna mais difícil problemas de _overflow_ ou ''estouro'' da pilha de execução.

Também é possível se utilizar o próprio método de _backtracking_ para a implementação da busca em largura, tornando a programação do problema mais simples.

### Implementação

#### Inicialização

O primeiro passo para a implementação foi a criação do estado inicial, realizada a partir de parâmetros indicados pelo usuário em regras definidas no arquivo `params.pl`:

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

Com esses parâmetros, o predicado `cria_tabuleiro(?Tabuleiro)`, presente no arquivo `utils.pl` pode criar o estado inicial do problema.

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

Todos os predicados de inserção de elementos no estado estão no arquivo `utils.pl`.

#### Geração de estados e transições

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

- Se o pacman for para a posição onde está o ponto  especial, ele irá comer o ponto, trocando sua posição por vazio antes de efetivamente andar para a posição do ponto;
- Se o pacman puder comer fantasmas e andar para a  posição de um fantasma, o fantasma será comido e sua posição virará vazia antes de realizar a movimentação;
- Se não houver mais fantasmas no estado, indicando que todos os fantasmas já foram comidos, o pacman poderá andar para a posição da cereja.

```prolog
%% move_<direcao>(+Estado, ?Sucessor)
% Sucessor representa o Estado apos o Pacman se mover para a <direcao>
% A condicao principal para a movimentacao eh
% haver espaco livre para onde o Pacman ira andar
% Existem tambem outras tres condicoes:
%   Pacman nao pode comer fantasmas, portanto nao pode passar por eles
%   Pacman pode comer fantasmas, estando livre para se mover
%   Pacman so pode andar para a cereja se nao houver fantasmas no campo
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
                                  % Proxima posicao nao e a cereja
                                  not(posicao(cereja, XNext, Y)),
                                  %Anda com o pacman
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
                                  not(posicao(cereja, XNext, Y)),
                                  indice(X, Y, Indice),
                                  indice(XNext, Y, IndiceNext),
                                  troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                                  % Pacman vai andar para a cereja
                                  % nao pode haver fantasmas para o pacman comer a cereja
                                  coordenadas(pacman, Estado, X, Y),
                                  dimensoes(Largura, _),
                                  X < Largura-1,
                                  XNext is X+1,
                                  not(member(fantasma, Estado)),
                                  posicao(cereja, XNext, Y),
                                  come_cereja(Estado, EstadoAux),
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
                                not(posicao(cereja, XNext, Y)),
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
                                not(posicao(cereja, XNext, Y)),
                                indice(X, Y, Indice),
                                indice(XNext, Y, IndiceNext),
                                troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                                coordenadas(pacman, Estado, X, Y),
                                X > 0,
                                XNext is X-1,
                                not(member(fantasma, Estado)),
                                posicao(cereja, XNext, Y),
                                come_cereja(Estado, EstadoAux),
                                indice(X, Y, Indice),
                                indice(XNext, Y, IndiceNext),
                                troca(Indice, IndiceNext, EstadoAux, Sucessor).

move_cima(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                               Y > 0,
                               YNext is Y-1,
                               not(come_fantasmas(Estado)),
                               not(coordenadas(fantasma, Estado, X, YNext)),
                               (posicao(ponto, X, YNext) ->
                                   come_ponto(Estado, EstadoAux);
                                   copy_term(Estado, EstadoAux)),
                               not(posicao(cereja, X, YNext)),
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
                               not(posicao(cereja, X, Ynext)),
                               indice(X, Y, Indice),
                               indice(X, YNext, IndiceNext),
                               troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                               coordenadas(pacman, Estado, X, Y),
                               Y > 0,
                               YNext is Y-1,
                               not(member(fantasma, Estado)),
                               posicao(cereja, X, YNext),
                               come_cereja(Estado, EstadoAux),
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
                              not(posicao(cereja, X, YNext)),
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
                              not(posicao(cereja, X, YNext)),
                              indice(X, Y, Indice),
                              indice(X, YNext, IndiceNext),
                              troca(Indice, IndiceNext, EstadoAux, Sucessor), !;

                              coordenadas(pacman, Estado, X, Y),
                              dimensoes(_, Altura),
                              Y < Altura-1,
                              YNext is Y+1,
                              not(member(fantasma, Estado)),
                              posicao(cereja, X, YNext),
                              come_cereja(Estado, EstadoAux),
                              indice(X, Y, Indice),
                              indice(X, YNext, IndiceNext),
                              troca(Indice, IndiceNext, EstadoAux, Sucessor).
```

As implementações das transições dos estados e movimentações estão no arquivo `states.pl`.

#### Busca em profundidade

A implementação da busca em profundidade segue o algoritmo mostrado em aula, com o aproveitamento do _backtracking_ presente internamente na linguagem Prolog. Sua implementação está no arquivo `busca.pl`.

Todo algoritmo de busca necessida de um estado meta, qual o estado em que se deseja chegar ao realizar a busca. Quando a busca encontrar o estado meta, aplicando as transições indicadas, ela deve parar e retornar o resultado.

Neste trabalho, o estado meta é representado por qualquer estado em que não haja fantasmas, isto é, todos foram comidos, e o pacman esteja na mesma posição da cereja indicada nos parâmetros, mostrando que o pacman comeu a cereja (objetivo principal).

```prolog
% % % Implementacao da busca
% % Busca utilizada: Busca em profundidade
% % Meta: Qualquer estado em que o pacman esteja na mesma posicao que a cereja

%% meta(+Estado)
% Indica se o estado e meta da busca
% Estados meta sao estados em que o pacman ja comeu o ponto
% e o pacman come a cereja (esta na mesma posicao)
meta(Estado) :- coordenadas(pacman, Estado, X, Y),
                come_fantasmas(Estado),
                not(member(fantasma, Estado)),
                posicao(cereja, X, Y).
```

A busca possui um caráter recorrente, com condição de parada sendo o encontro de um estado meta. A busca implementada também permite guardar na variável `Caminho`, os estados pelos quais o algoritmo percorreu para chegar ao estado final.

```prolog
%% busca_profundidade(+Estado, +Caminho, ?Solucao)
% Realiza a busca em profundidade a partir do Estado,
% que foi obtido atraves do Caminho percorrido
% A Solucao retorna o caminho ate um estado meta
busca_profundidade(Estado, Caminho, [Estado|Caminho]) :- meta(Estado), !.
busca_profundidade(Estado, Caminho, Solucao) :- s(Estado, Sucessor),
                                                not(member(Sucessor, [Estado|Caminho])),
                                                busca_profundidade(Sucessor, [Estado|Caminho], Solucao).
```

### Utilidades

Diversos predicados auxilires foram criados para a realização deste trabalho. Estes predicados estão implementados no arquivo `utils.pl`.

Os predicados de utilidade foram separados em diversas categorias. A primeira indica o retorno de informações sobre o estado passado como parâmetro. As informações retornadas são:

- O pacman pode comer fantasmas apenas se o lugar onde o ponto deveria estar (indicado pelos parâmetros) tem vazio, indicando que o pacman já o comeu, ou se o pacman está, naquele exato estado, em cima do ponto, comendo-o.
- As coordenadas de um dado objeto dentro de um dado estado. Este predicado busca a posição do objeto na lista e realiza os cálculos com relação às dimensões do tabuleiro para obter os valores das coordenadas. O predicado não trabalha bem com fantasmas (seriam relizados _backtrackings_), porém isto não é um problema, pois esta funcionalidade não é utilizada para obter coordenadas de fantasmas.
- O predicado `indice(+X, +Y, ?Indice)` realiza os cálculos necessários, a partir das dimensões do tabuleiro, para retornar o índice na lista que representa o estado correspondente às coordenadas dadas.
- Também foi implementada um predicado que indica se há fantasmas em uma dada coordenada dentre todas as posições indicadas nos parâmetros.

``` prolog
%% come_fantasmas(+Estado)
% Indica se eh possivel para o pacman comer fantasmas
% isto eh, se o ponto especial ja foi comido
come_fantasmas(Estado) :- posicao(ponto, PontoX, PontoY),
                          coordenadas(vazio, Estado, PontoX, PontoY);
                          posicao(ponto, PontoX, PontoY),
                          coordenadas(pacman, Estado, PontoX, PontoY).

%% coordenadas(+Objeto, +Estado, ?X, ?Y)
% Retorna as coordenadas X e Y de Objeto dentro de Estado
% As coordenadas sao as posicoes de Objeto no Tabuleiro representado
% dentro do Estado, conforme descrito acima
coordenadas(Objeto, Estado, X, Y) :- nth0(Posicao, Estado, Objeto),
                                     dimensoes(Largura, _),
                                     X is Posicao mod Largura,
                                     Y is Posicao div Largura.

%% indice(+X, +Y, ?Indice)
% Remonta o indice na lista a partir das coordenadas de um Objeto
indice(X, Y, Indice) :- dimensoes(Largura, _),
                        Indice is Largura*Y+X.

%% posicao(fantasma, +X, +Y)
% Verifica se existe fantasma em (X,Y)
tem_fantasma(X, Y) :- posicao(fantasma, L),
                      is_list(L),
                      member([X, Y], L).
```

A segunda classe de predicados de utilidade são os predicados que realizam operações sobre os estados. Alguns destes predicados já foram indicados na explicação da implementação da inicialização do problema.

A operação `troca(+Indice, +IndiceNext, +Estado, ?Sucessor)` gera um estado sucessor de `Estado`, trocando os dois elemtnso presentes em `Indice` e `IndiceNext`. Para isso, são realizadas manipulações de listas: primeiramente, monta-se listas com todos os antecessores e sucessores de cada um dos itens a serem trocados. Após isso, realiza-se a troca e junta-se as listas necessárias.

``` prolog
% % Operacoes sobre o estado
% Predicados que modificam o estado de alguma forma

%% troca(+Indice, +IndiceNext, +Estado, ?Sucessor)
% Troca o objeto em Indice com o objeto em IndiceNext
% dentro de Estado, retornando o novo estado em Sucessor
troca(Indice, IndiceNext, Estado, Sucessor) :- same_length(Estado, Sucessor),
                                               length(ListaAnteriorIndice, Indice),
                                               length(ListaAnteriorIndiceNext, IndiceNext),
                                               % Separa as listas antes e depois do elemento em Indice
                                               append(ListaAnteriorIndice, [Objeto|ListaPosteriorIndice], Estado),
                                               % Troca elemento em Indice pelo elemento em IndiceNext
                                               append(ListaAnteriorIndice, [ObjetoNext|ListaPosteriorIndice], Aux),
                                               % Separa as listas antes e depois do elemento em IndiceNext
                                               append(ListaAnteriorIndiceNext, [ObjetoNext|ListaPosteriorIndiceNext], Aux),
                                               % Substitui elemento em IndiceNext pelo elemento em Indice
                                               append(ListaAnteriorIndiceNext, [Objeto|ListaPosteriorIndiceNext], Sucessor).
```

Um exemplo é:
`[a, b, c, d, e]`, trocando-se `b` e `d` de lugar, com índices 1 e 3, respectivamente. A ordem do exemplo, segue as unificações realizadas.

```
Indice = 1
IndiceNext = 3
Estado = [a, b, c, d, e]

Sucessor = [_, _, _, _, _]

ListaAnteriorIndice = [_]
ListaAnteriorIndiceNext = [_, _, _]

ListaAnteriorIndice = [a]
Objeto = b
ListaPosteriorIndice = [c, d, e]

Aux = [a, ObjetoNext, c, d, e]

ListaAnteriorIndiceNext = [a, ObjetoNext, c]
ObjetoNext = d
ListaPosteriorIndiceNext = [e]

Sucessor = [a, d, c, b, e]
```

Outras funções de manipulação do estado, são as funções que comem itens presetnes no tabuleiro. Todos os predicados utilizam a ideia de trocar o item indicado por ''vazio'', gerando, assim, um sucessor em que o elemento foi comido.

O ponto e a cereja, por serem elementos únicos no tabuleiro, podem ser trocados de forma recursiva, já os fantasmas, que podem ser vários, necessitam de ter suas coordeanadas especificadas, para indicar qual fantasma está sendo comido pelo pacman.

O predicado `come_cereja(+Estado, ?Sucessor)` não é estritamente necessário para a lógica do programa e da busca, porém ele é necessário para uma boa funcionalidade da interface em python.

``` prolog
%% come_ponto(+Estado, ?Sucessor)
% Gera Sucessor trocando o ponto e Estado por vazio
% Indicando que o ponto ja foi comido
come_ponto([ponto|Cauda], [vazio|Cauda]) :- !.
come_ponto([Cabeca|Cauda], [Cabeca|CaudaNext]) :- come_ponto(Cauda, CaudaNext).

%% come_fantasma(+Estado, +X, +Y, ?Sucessor)
% Substitui fantasma em X e Y por vazio
come_fantasma(Estado, X, Y, Sucessor) :- same_length(Estado, Sucessor),
                                         indice(X, Y, Indice),
                                         length(ListaAnterior, Indice),
                                         append(ListaAnterior, [_|ListaPosterior], Estado),
                                         append(ListaAnterior, [vazio|ListaPosterior], Sucessor).

%% come_cereja(+Estado, ?Sucessor)
% Substitui a cereja em Estado por vazio
come_cereja([cereja|Cauda], [vazio|Cauda]) :- !.
come_cereja([Cabeca|Cauda], [Cabeca|CaudaNext]) :- come_cereja(Cauda, CaudaNext).
```

#### Interface Gráfica

Optou-se por implementar a interface gráfica na linguagem Python, por facilidade de manipulação de impressões na tela. Para que os dados gerados pelo programa em Prolog possam ser transportados da execução do código em Prolog para o programa em python, utilizou-se a funcionalidade disponilibizada pela biblioteca _library_, presente do pacote _clib_ do Prolog chamada: `setup_call_cleanup(:Setup, :Goal, :Cleanup)`.

Esta chamada gera é utilizada para criar um subprocesso que executa o _script_ em Python responsável pela interface. A entrada padrão do subprocesso Python é um pipe que permitirá a comunicação entre os dois processos.

Neste pipe, serão escritos todos os estados necessários para a geração da interface.

``` prolog
%% run()
% Funcao para execucao do programa
% Inicializa um procesos python para a interface e executa
% o predicado main(In).
run() :- setup_call_cleanup(process_create(path(python3), ['interface.py'], [stdin(pipe(In))]),
                          main(In),
                          close(In)).
```

Após a criação do subprocesso, é chamado o predicado `main(+In)`, que realiza a criação do estado inicial de acordo com os parâmetros, realiza a busca e escreve o resultado no pipe para o processo Python desenhar a interface.

``` prolog
%% main(+In)
% Funcao principal do programa
% Tabuleiro e criado, informacoes para a interface sao inicializadas
% e a busca em profundidade e iniciada
% Ao final, todos os passos obtidos sao escritos para a interface
main(In) :- cria_tabuleiro(Estado),
            dimensoes(Largura, Altura),
            write(In, Largura),
            write(In, 'x'),
            writeln(In, Altura),
            busca_profundidade(Estado, [], Final),
            escreve_ui(Final, In).
```

Primeiramente, escreve-se no pipe as dimensões do tabuleiro sendo utilizado no formato (Largura x Altura). Após isso, realiza-se a busca e utiliza-se um predicado utilitário `escreve_ui(+Lista, +In)` para escrever todo o caminho obtido pele busca no pipe. Os estados são escritos no formato padrão de lista do prolog: `[a, b, c]`.

``` prolog
%% escreve_ui(+Lista, +In)
% Escreve no arquivo In os estados em Lista
% Os Estados sao escritos um por linha
escreve_ui([Estado], In) :- writeln(In, Estado), !.
escreve_ui([Estado|OutrosEstados], In) :- writeln(In, Estado),
                                       escreve_ui(OutrosEstados, In).
```

O _script_ em python é o responsável por desenhar a atualizar a tela após recebido o resultado da busca. Primeiramente, são lidas as dimensões do tabuleiro, para o cálculo das linhas a serem desenhadas.

``` python
# Le as dimensoes do tabuleiro
dim = sys.stdin.readline()
dim = dim.split('x')
dim = [int(axis) for axis in dim]
```

Após isso, são lidos todos os estados enviados pelo pipe. Como os estados lidos possuem `[, ] e \n`,  é ralizado um pré-processamento para ignorar estes caracteres. Após isso, é desenhado cada estado, no formato indicado na seção sobre a modelagem dos estados.

Também é realizada uma verificação da presença ou não da cereja no estado. Caso a cereja não esteja presente no estado, isto é, o pacman comeu a cereja, indica que o estado é um estado meta e portanto a interface deve mostrar uma janela de ''Game Over''.

A tela é atualizada a cada 0.5 segundo para que seja possível ver as transições, a tela também é limpa após este tempo para que o novo estado seja desenhado e a interface seja melhor entendida.

``` python
# Le dados das execucoes
lines = sys.stdin.readlines()

num_exec = 1
for line in reversed(lines):
    print('Execucao numero: ' + str(num_exec))
    line = line.translate({ord(c): None for c in '[]\n'})

    print_game(dim, line)
    time.sleep(0.5)
    os.system('cls' if os.name == 'nt' else 'clear')

    if 'cereja' not in line.split(','):
        num_exec = num_exec + 1
        print_game_over(dim)

```

A função que desenha o tabuleiro deve se ajustas às dimensões indicadas no início da execução.

``` python
def print_game(dim, line):
    for i, elem in enumerate(line.split(',')):
        if i % dim[0] == 0:
            print('-----' * dim[0])
            print('|', end='')
            print('   ' + obj_map[elem], end='   ')
        elif i % dim[0] == dim[0] - 1:
            print(obj_map[elem], end='   ')
            print('|')
        else:
            print(obj_map[elem], end='   ')
    print('-----' * dim[0])
```

A função de desenho da tela de ''Game Over'' também se ajusta ao tamanho do tabuleiro e a mensagem é mostrada o mais próximo possível do centro da tela. A mensagem é mostrada por um segundo e meio e depois a tela é limpa para um novo estado ser desenhado (caso haja mais de uma execução enviada pelo Prolog) ou para terminar a execução.

``` python
def print_game_over(dim):
    print('\n' * (dim[1] // 2))
    print((' ' * (dim[0] // 3)) + 'GAME OVER')
    time.sleep(1.5)
    os.system('cls' if os.name == 'nt' else 'clear')
```