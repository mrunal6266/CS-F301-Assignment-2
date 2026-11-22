% prec(?Op, ?Level)
% Level is the binding strength of operator Op: + and - bind at level 1,
% * and / bind tighter, at level 2.
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

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