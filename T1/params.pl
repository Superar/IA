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
