% Retorne o ultimo elemento de uma lista
ultimo([X], X) :- !.
ultimo([_|Cauda], X) :- ultimo(Cauda, X).

% Indique que dois elementos sao consecutivos
consecutivos([X, Y|_], X, Y) :- !.
consecutivos([Y, X|_], X, Y) :- !.
consecutivos([_|Cauda], X, Y) :- consecutivos(Cauda, X, Y).

% Retorne o numero de elementos em uma lista
tamanho([], 0) :- !.
tamanho([_|Cauda], N) :- tamanho(Cauda, TamanhoCauda), N is TamanhoCauda+1.

% Insira um elemento em qualquer posicao da lista
insere(X, 0, Lista, [X|Lista]) :- !.
insere(X, Indice, [Cabeca|Cauda], [Cabeca|CaudaRetorno]) :- NovoIndice is Indice-1, insere(X, NovoIndice, Cauda, CaudaRetorno).

% Retire todas as ocorrencias de um elemento em uma lista
retirar(_, [], []) :- !.
retirar(X, [X|Cauda], CaudaNova) :- retirar(X, Cauda, CaudaNova), !.
retirar(X, [Cabeca|Cauda], [Cabeca|CaudaNova]) :- retirar(X, Cauda, CaudaNova).

% Indique se a lista possui tamanho par ou impar
par(Lista) :- tamanho(Lista, Tam), Mod is Tam mod 2, Mod is 0.
impar(Lista) :- tamanho(Lista, Tam), Mod is Tam mod 2, Mod is 1.
par_impar(Lista) :- par(Lista), write("par"), !.
par_impar(Lista) :- impar(Lista), write("impar").

% Inverta os elementos de uma lista
reverse([], []) :- !.
reverse([Cabeca|Cauda], Retorno) :- reverse(Cauda, CaudaNova), append(CaudaNova, [Cabeca], Retorno).

% Indique se uma lista e subconjunto de outra
subconjunto([], _) :- !.
subconjunto([Cabeca|Cauda], Lista) :- member(Cabeca, Lista), subconjunto(Cauda, Lista).
