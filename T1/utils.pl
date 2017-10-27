% % % Funcoes auxiliares
% % Indica funcoes de funcionalidades para
% % utilizar na criacao dos estados e transicoes


% % Retorno de informacoes
% Predicados que retornam informacoes sobre o estado

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


% % Interface grafica

%% escreve_ui(+Lista, +In)
% Escreve no arquivo In os estados em Lista
% Os Estados sao escritos um por linha
escreve_ui([Estado], In) :- writeln(In, Estado), !.
escreve_ui([Estado|OutrosEstados], In) :- writeln(In, Estado),
                                       escreve_ui(OutrosEstados, In).
