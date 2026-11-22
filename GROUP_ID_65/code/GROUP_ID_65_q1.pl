:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).

% solution(+Active, -S)
% S is an assignment of a distinct department, language and project to
% each of Alex, Ben, Carla and Dana (in that order) such that every clue
% whose number is in Active holds.
solution(Active, S) :-
    S = [ p('Alex',  D1, L1, P1),
          p('Ben',   D2, L2, P2),
          p('Carla', D3, L3, P3),
          p('Dana',  D4, L4, P4) ],
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],        [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],              [P1, P2, P3, P4]),
    forall(member(N, Active), clue(N, S)).
% clue(+N, +S)
% Clue N holds in the fully filled-in solution S.

% CLUE 1: The friend who prefers the AI project does not work in research
% and is not Dana.
% Reading: the friend whose project is 'AI' has a department other than
% research and a name other than 'Dana'.
clue(1, S) :-
    member(p(Name, Dept, _, 'AI'), S),
    Dept \== research,
    Name \== 'Dana'.

% CLUE 2: Alex does not work in development and does not prefer C++.
% Reading: Alex's department is not development and Alex's favorite
% language is not 'c++'.
clue(2, S) :-
    member(p('Alex', Dept, Lang, _), S),
    Dept \== development,
    Lang \== 'c++'.
    
% CLUE 3: The friend working in the testing department likes Python.
% Reading: the friend whose department is testing has python as their
% favorite language.
clue(3, S) :-
    member(p(_, testing, python, _), S).

% CLUE 4: Ben prefers web projects and does not work in testing.
% Reading: Ben's project is web and Ben's department is not testing.
clue(4, S) :-
    member(p('Ben', Dept, _, web), S),
    Dept \== testing.