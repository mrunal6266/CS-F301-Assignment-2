% prec(?Op, ?Level)
% Level is the binding strength of operator Op: + and - bind at level 1,
% * and / bind tighter, at level 2.
prec('+', 1).
prec('-', 1).
prec('*', 2).
prec('/', 2).

% expr_string(+Tree, -String)
% String is the canonical, space-free SWI-Prolog string of expression Tree,
% where Tree is num(N) or op(Operator, Left, Right). A left operand is
% parenthesised only if its operator binds strictly weaker than the parent's;
% a right operand if its operator binds weaker than or equal to the parent's.
expr_string(num(N), String) :-
    format(string(String), "~d", [N]).
expr_string(op(Op, Left, Right), String) :-
    prec(Op, P),
    expr_string(Left, LeftStr0),
    expr_string(Right, RightStr0),
    (   Left = op(LeftOp, _, _),
        prec(LeftOp, LeftP),
        LeftP < P
    ->  format(string(LeftStr), "(~w)", [LeftStr0])
    ;   LeftStr = LeftStr0
    ),
    (   Right = op(RightOp, _, _),
        prec(RightOp, RightP),
        RightP =< P
    ->  format(string(RightStr), "(~w)", [RightStr0])
    ;   RightStr = RightStr0
    ),
    format(string(String), "~w~w~w", [LeftStr, Op, RightStr]).

% eval(+Tree, -Value)
% Value is the integer value of expression Tree, and every division inside
% Tree has a non-zero divisor and leaves no remainder. Fails if some
% division in Tree is invalid.
eval(num(N), N).
eval(op('+', Left, Right), Value) :-
    eval(Left, LeftVal),
    eval(Right, RightVal),
    Value is LeftVal + RightVal.
eval(op('-', Left, Right), Value) :-
    eval(Left, LeftVal),
    eval(Right, RightVal),
    Value is LeftVal - RightVal.
eval(op('*', Left, Right), Value) :-
    eval(Left, LeftVal),
    eval(Right, RightVal),
    Value is LeftVal * RightVal.
eval(op('/', Left, Right), Value) :-
    eval(Left, LeftVal),
    eval(Right, RightVal),
    RightVal =\= 0,
    LeftVal mod RightVal =:= 0,
    Value is LeftVal // RightVal.

% expr_tree(+List, -Tree)
% Tree is an expression tree whose leaves, read left to right, are exactly
% the numbers of the non-empty List, each used once: either num(N) for a
% one-element list, or op(Op, Left, Right) where Left and Right are trees
% over a non-empty prefix and the remaining non-empty suffix of List.
expr_tree([N], num(N)).
expr_tree(List, op(Op, Left, Right)) :-
    append(Prefix, Suffix, List),
    Prefix = [_|_],
    Suffix = [_|_],
    expr_tree(Prefix, Left),
    expr_tree(Suffix, Right),
    member(Op, ['+', '-', '*', '/']).

% generate_equation(+List, -Equation)
% Equation is the canonical string "L=R" of one valid equation for List:
% L is an expression over a non-empty prefix of List, R is an expression over
% the remaining non-empty suffix, and L and R have the same integer value.
% Fails if List has no valid equation (including lengths 0 and 1).
generate_equation(List, Equation) :-
    once(( append(Prefix, Suffix, List),
           Prefix = [_|_],
           Suffix = [_|_],
           expr_tree(Prefix, Left),
           eval(Left, Value),
           expr_tree(Suffix, Right),
           eval(Right, Value),
           expr_string(Left, LeftStr),
           expr_string(Right, RightStr),
           format(string(Equation), "~w=~w", [LeftStr, RightStr])
         )).

% all_equations(+List, -Equations)
% Equations is the sort/2-ordered list, without duplicates, of the canonical
% strings "L=R" of all valid equations for List. It is [] if there are none,
% including for lists of length 0 and 1.
all_equations(List, Equations) :-
    findall(Equation,
            ( append(Prefix, Suffix, List),
              Prefix = [_|_],
              Suffix = [_|_],
              expr_tree(Prefix, Left),
              eval(Left, Value),
              expr_tree(Suffix, Right),
              eval(Right, Value),
              expr_string(Left, LeftStr),
              expr_string(Right, RightStr),
              format(string(Equation), "~w=~w", [LeftStr, RightStr])
            ),
            Found),
    sort(Found, Equations).

% count_equations(+List, -N)
% N is the number of valid equations for List, i.e. the length of the list
% Equations for which all_equations(List, Equations) holds.
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).