% % Transicoes
% Estado: Lista dos numeros no quadrado
s(Estado, Sucessor) :- move_cima(Estado, Sucessor).
s(Estado, Sucessor) :- move_baixo(Estado, Sucessor).
s(Estado, Sucessor) :- move_direita(Estado, Sucessor).
s(Estado, Sucessor) :- move_esquerda(Estado, Sucessor).

coordenadas(Item, Estado, X, Y) :- nth0(Indice, Estado, Item),
                                   X is Indice mod 3,
                                   Y is Indice div 3.

indice(X, Y, Indice) :- Indice is 3*Y+X.

troca(Indice, Novo_indice, Estado, Sucessor) :- same_length(Estado, Sucessor),
                                                length(Lista_anterior, Indice),
                                                length(Nova_lista_anterior, Novo_indice),
                                                append(Lista_anterior, [Elemento|Lista_posterior], Estado), % Pega lista do elemento em Indice para frente
                                                append(Lista_anterior, [Novo_elemento|Lista_posterior], Aux), % Substitui Elemento com Novo_elemento
                                                append(Nova_lista_anterior, [Novo_elemento|Nova_lista_posterior], Aux), % Pega lista do elemento em Novo_indice para frente
                                                append(Nova_lista_anterior, [Elemento|Nova_lista_posterior], Sucessor). % Substitui este Novo_elemento por Elemento

move_cima(Estado, Sucessor) :- coordenadas(0, Estado, X, Y),
                               Y > 0,
                               Novo_Y is Y-1,
                               indice(X, Y, Indice),
                               indice(X, Novo_Y, Novo_indice),
                               troca(Indice, Novo_indice, Estado, Sucessor).

move_baixo(Estado, Sucessor) :- coordenadas(0, Estado, X, Y),
                               Y < 2,
                               Novo_Y is Y+1,
                               indice(X, Y, Indice),
                               indice(X, Novo_Y, Novo_indice),
                               troca(Indice, Novo_indice, Estado, Sucessor).

move_direita(Estado, Sucessor) :- coordenadas(0, Estado, X, Y),
                              X < 2,
                              Novo_X is X+1,
                              indice(X, Y, Indice),
                              indice(Novo_X, Y, Novo_indice),
                              troca(Indice, Novo_indice, Estado, Sucessor).

move_esquerda(Estado, Sucessor) :- coordenadas(0, Estado, X, Y),
                             X > 0,
                             Novo_X is X-1,
                             indice(X, Y, Indice),
                             indice(Novo_X, Y, Novo_indice),
                             troca(Indice, Novo_indice, Estado, Sucessor).

meta([1, 2, 3, 8, 0, 4, 7, 6, 5]).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Busca

main(Inicio, Final) :- busca_profundidade([], Inicio, Final).

busca_profundidade(Caminho, Estado, [Estado|Caminho]) :- meta(Estado).
busca_profundidade(Caminho, Estado, Final) :- s(Estado, Sucessor),
                                              not(member(Sucessor, [Estado|Caminho])),
                                              busca_profundidade([Estado|Caminho], Sucessor, Final).
