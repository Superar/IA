% % % Importacao de modulos e arquivos
% Biblioteca process - Para utilizar os comandos de criacao de subprocessos
:- use_module(library(process)).
% params contem predicados relativos aos parametros de execucao
:- [params].
% utils contem predicados auxiliares para a execucao
:- [utils].
% states contem predicados para as transicoes de estados
:- [states].
% busca contem predicados relativos a busca de estados
:- [busca].


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

%% run()
% Funcao para execucao do programa
% Inicializa um procesos python para a interface e executa
% o predicado main(In).
run() :- setup_call_cleanup(process_create(path(python3), ['interface.py'],[stdin(pipe(In))]),
                          main(In),
                          close(In)).
