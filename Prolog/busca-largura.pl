% % Transicoes
% Estado: numero
s(1, 2).
s(1, 3).
s(1, 4).
s(2, 5).
s(2, 6).
s(3, 7).
s(3, 8).
s(4, 9).
s(4, 10).
s(5, 11).
s(7, 12).
s(7, 13).
s(8, 14).
s(10, 15).
s(10, 16).
s(10, 17).
s(11, 18).
s(11, 19).
s(11, 20).
s(17, 21).
s(17, 22).

meta(12).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Busca

main(Inicio, Final) :- busca_largura([[Inicio]], Final).

busca_largura([[Estado|Caminho]| _], [Estado|Caminho]) :- meta(Estado).
busca_largura([Estado|Outros_estados], Final) :- explora_estado([Estado|Outros_estados], Lista_filhos),
                                                 append(Outros_estados, Lista_filhos, Lista_fronteira),
                                                 busca_largura(Lista_fronteira, Final).

explora_estado([[Estado|Caminho] | Outros_estados], Lista_filhos) :- bagof([Estado_filho, Estado|Caminho],
                                                                           (s(Estado, Estado_filho), not(pertence(Estado_filho, [[Estado|Caminho] | Outros_estados]))),
                                                                           Lista_filhos).
explora_estado(_, []).

pertence(Item, [Item|_]) :- !.
pertence(Item, [Cabeca|_]) :- is_list(Cabeca), pertence(Item, Cabeca), !.
pertence(Item, [_|Cauda]) :- pertence(Item, Cauda).
