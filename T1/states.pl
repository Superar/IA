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
