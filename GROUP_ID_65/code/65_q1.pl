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

% CLUE 5: The friend whose favorite language is Java works in the design
% department.
% Reading: some friend has both java as their language and design as
% their department.
clue(5, S) :-
    member(p(_, design, java, _), S).

% CLUE 6: Carla's project preference is not embedded, and her department
% is not development.
% Reading: Carla's project is not embedded and Carla's department is not
% development.
clue(6, S) :-
    member(p('Carla', Dept, _, Proj), S),
    Proj \== embedded,
    Dept \== development.

% CLUE 7: Dana's favorite language is not Java, and she works in research
% or testing.
% Reading: Dana's language is not java and Dana's department is one of
% research or testing.
clue(7, S) :-
    member(p('Dana', Dept, Lang, _), S),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% CLUE 8: The friend who prefers data projects works in research and does
% not use JavaScript.
% Reading: the friend whose project is data has research as their
% department and a language other than javascript.
clue(8, S) :-
    member(p(_, research, Lang, data), S),
    Lang \== javascript.

% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, S) :-
    member(p(_, testing, _, 'AI'), S).

% main
% Prints one solution of clues 1 to 8, one line per friend, in the order
% Alex, Ben, Carla, Dana.
main :-
    once(solution([1,2,3,4,5,6,7,8], S)),
    forall(member(p(Name, Dept, Lang, Proj), S),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Proj])).
% count_solutions(+Active, -N)
% N is the number of solutions that satisfy exactly the clues in Active
% and ignore all the others.
count_solutions(Active, N) :-
    aggregate_all(count, solution(Active, _), N).
