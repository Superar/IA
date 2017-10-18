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
                                  % Verifica se a próxima posição e ponto
                                  % Come ponto
                                  (posicao(ponto, XNext, Y) ->
                                      come_ponto(Estado, EstadoAux);
                                      copy_term(Estado, EstadoAux)),
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


% % % Funcoes auxiliares
% % Indica funcoes de funcionalidades para
% % utilizar na criacao dos estados e transicoes


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

%% escreve_ui(+Lista, +In)
% Escreve no arquivo In os estados em Lista
% Os Estados sao escritos um por linha
escreve_ui([Estado], In) :- writeln(In, Estado), !.
escreve_ui([Estado|OutrosEstados], In) :- writeln(In, Estado),
                                       escreve_ui(OutrosEstados, In).

% % % Implementacao da busca
% % Busca utilizada: Busca em profundidade
% % Meta: Qualquer estado em que o pacman esteja na mesma posicao que a cereja

%% meta(+Estado)
% Indica se o estado e meta da busca
% Estados meta sao estados em que o pacman ja comeu o ponto
% e o pacman come a cereja (esta na mesma posicao)
meta(Estado) :- coordenadas(pacman, Estado, X, Y),
                come_fantasmas(Estado),
                posicao(cereja, X, Y).

%% busca_profundidade(+Estado, +Caminho, ?Solucao)
% Realiza a busca em profundidade a partir do Estado,
% que foi obtido atraves do Caminho percorrido
% A Solucao retorna o caminho ate um estado meta
busca_profundidade(Estado, Caminho, [Estado|Caminho]) :- meta(Estado), !.
busca_profundidade(Estado, Caminho, Solucao) :- s(Estado, Sucessor),
                                                not(member(Sucessor, [Estado|Caminho])),
                                                busca_profundidade(Sucessor, [Estado|Caminho], Solucao).

%% main()
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

%% run()
% Funcao para execucao do programa
% Inicializa um procesos python para a interface e executa
% o predicado main(In).
run() :- setup_call_cleanup(process_create(path(python3), ['interface.py'],[stdin(pipe(In))]),
                          main(In),
                          close(In)).
