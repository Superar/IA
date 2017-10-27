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

%% busca_profundidade(+Estado, +Caminho, ?Solucao)
% Realiza a busca em profundidade a partir do Estado,
% que foi obtido atraves do Caminho percorrido
% A Solucao retorna o caminho ate um estado meta
busca_profundidade(Estado, Caminho, [Estado|Caminho]) :- meta(Estado), !.
busca_profundidade(Estado, Caminho, Solucao) :- s(Estado, Sucessor),
                                                not(member(Sucessor, [Estado|Caminho])),
                                                busca_profundidade(Sucessor, [Estado|Caminho], Solucao).
