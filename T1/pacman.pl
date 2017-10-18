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


% % % % % % % % % % NAO ALTERAR A PARTIR DESTA LINHA % % % % % % % % % %


% % % Transicoes
% % Estado: Lista que representa as posicoes do tabuleiro.
% % Conteudo de uma posição da lista pode ser:
% %   pacman - indica que o personagem esta naquela posicao
% %   fantasma - indica que ha um fantasma naquela posicao
% %   ponto - indica que ha um ponto especial esta naquela posicao
% %   comido - indica que o ponto especial ja foi comido
% %   cereja - indica que a cereja esta naquela posicao
% %   vazio - Indica que a posicao esta vazia


%% s(+Estado, ?Sucessor)
% Representa uma transicao de Estado para o estado Sucessor
% Os estados Sucessores podem ser obtidos pela movimentacao
% do pacman em todas as quatro direções:
% direita, esquerda, cima e baixo
s(Estado, Sucessor) :- move_direita(Estado, Sucessor);
                       move_esquerda(Estado, Sucessor);
                       move_cima(Estado, Sucessor);
                       move_baixo(Estado, Sucessor).

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
                                  indice(X, Y, Indice),
                                  indice(XNext, Y, IndiceNext),
                                  troca(Indice, IndiceNext, Estado, Sucessor), !;

                                  % Ha fantasma a direta do Pacman, porem
                                  % o personagem pode come-los
                                  coordenadas(pacman, Estado, X, Y),
                                  dimensoes(Largura, _),
                                  X < Largura-1,
                                  XNext is X+1,
                                  come_fantasmas(Estado),
                                  indice(X, Y, Indice),
                                  indice(XNext, Y, IndiceNext),
                                  troca(Indice, IndiceNext, Estado, Sucessor).

move_esquerda(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                                X > 0,
                                XNext is X-1,
                                not(come_fantasmas(Estado)),
                                not(coordenadas(fantasma, Estado, XNext, Y)),
                                indice(X, Y, Indice),
                                indice(XNext, Y, IndiceNext),
                                troca(Indice, IndiceNext, Estado, Sucessor), !;

                                coordenadas(pacman, Estado, X, Y),
                                X > 0,
                                XNext is X-1,
                                come_fantasmas(Estado),
                                indice(X, Y, Indice),
                                indice(XNext, Y, IndiceNext),
                                troca(Indice, IndiceNext, Estado, Sucessor).

move_cima(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                               Y > 0,
                               YNext is Y-1,
                               not(come_fantasmas(Estado)),
                               not(coordenadas(fantasmas, Estado, X, YNext)),
                               indice(X, Y, Indice),
                               indice(X, YNext, IndiceNext),
                               troca(Indice, IndiceNext, Estado, Sucessor), !;

                               coordenadas(pacman, Estado, X, Y),
                               Y > 0,
                               YNext is Y-1,
                               indice(X, Y, Indice),
                               indice(X, YNext, IndiceNext),
                               troca(Indice, IndiceNext, Estado, Sucessor).

move_baixo(Estado, Sucessor) :- coordenadas(pacman, Estado, X, Y),
                              dimensoes(_, Altura),
                              Y < Altura-1,
                              YNext is Y+1,
                              not(come_fantasmas(Estado)),
                              not(coordenadas(fantasmas, Estado, X, YNext)),
                              indice(X, Y, Indice),
                              indice(X, YNext, IndiceNext),
                              troca(Indice, IndiceNext, Estado, Sucessor), !;

                              coordenadas(pacman, Estado, X, Y),
                              dimensoes(_, Altura),
                              Y < Altura-1,
                              YNext is Y+1,
                              indice(X, Y, Indice),
                              indice(X, YNext, IndiceNext),
                              troca(Indice, IndiceNext, Estado, Sucessor).


% % % Funcoes auxiliares
% % Indica funcoes de funcionalidades para
% % utilizar na criacao dos estados e transicoes


%% come_fantasmas(+Estado)
% Indica se eh possivel para o pacman comer fantasmas
% isto eh, se o ponto especial ja foi comido
come_fantasmas(Estado) :- posicao(ponto, PontoX, PontoY),
                          coordenadas(comido, Estado, PontoX, PontoY).

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

%% add_objeto(fantasma, +?Tabuleiro)
% Insere N fantasmas em Tabuleiro
% em coordenadas indicadas nos parametros
add_objeto(fantasma, Tabuleiro) :- posicao(fantasma, ListaPosicoes),
                                   add_fantasmas(Tabuleiro, ListaPosicoes), !.

%% add_objeto(+Objeto, +?Tabuleiro)
% Insere Objeto em Tabuleiro de acordo com as coordenadas
% indicadas nos parametros da execucao
add_objeto(Objeto, Tabuleiro) :- posicao(Objeto, X, Y),
                                 coordenadas(Objeto, Tabuleiro, X, Y).

%% add_fantasmas(+?Tabuleiro, +ListaPosicoes)
% Insere em Tabuleiro N fantasmas
% ListaPosicoes eh uma lista de listas em que cada sublista
% possui as duas coordenadas do fantasma
add_fantasmas(_, []) :- !.
add_fantasmas(Tabuleiro, [[X, Y] | Cauda]) :- coordenadas(fantasma, Tabuleiro, X, Y),
                                              add_fantasmas(Tabuleiro, Cauda).

%% add_vazios(+Tabuleiro, ?TabuleiroPreenchido)
% Insere nas posicoes nao preenchidas do Tabuleiro (com _)
% o valor atomico 'vazio', retornando em TrabuleiroPreenchido
add_vazios([], []) :- !.
add_vazios([Cabeca|Cauda], [vazio|CaudaNext]) :- not(atom(Cabeca)),
                              add_vazios(Cauda, CaudaNext), !.
add_vazios([Cabeca|Cauda], [Cabeca|CaudaNext]) :- atom(Cabeca),
                                                  add_vazios(Cauda, CaudaNext).

%% get_vazios(+Estado, ?ListaIndices)
% Retorna todos os indices em que ha posicao vazia em Estado
% get_vazios([], []) :- !.
% get_vazios([Cabeca])

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

%% main(+In)
% Funcao principal do programa
% In representa o pipe para comunicacao com o processo de interface
% executando em python
main(In) :- cria_tabuleiro(Estado),
            dimensoes(Largura, Altura),
            write(In, Largura),
            write(In, 'x'),
            write(In, Altura),
            nl(In),
            s(Estado, Sucessor),
            write(In, Sucessor),
            nl(In).

%% run()
% Funcao para execucao do programa
% Inicializa um procesos python para a interface e executa
% o predicado main(In).
run() :- setup_call_cleanup(process_create(path(python3), ['interface.py'],[stdin(pipe(In))]),
                            main(In),
                            close(In)).
