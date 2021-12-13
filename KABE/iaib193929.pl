:- module('iaib193929', [iaib193929/3]).

iaib193929(Color,_,_):-  ((TammColor is Color*10, leia_votmine(X,Y,X1,Y1,X2,Y2,TammColor)); leia_votmine(X,Y,X1,Y1,X2,Y2, Color)), write(" leidsin votmise "), write(["leitud votmine ",X,Y,X1,Y1, X2, Y2]), vota(Y,X,Y1,X1,Y2,X2),!.
iaib193929(Color,_,_):-  (leia_kaik(X,Y,X1,Y1,Color);(TammColor is Color*10, leia_kaik(X,Y,X1,Y1,TammColor))), write(["leitud kaik ",X,Y,X1,Y1]), tee_kaik(X,Y,X1,Y1), !.
iaib193929(_,_,_).

tamm(1, 10).
tamm(2, 20).

on_tamm(10).
on_tamm(20).

%votmine

leia_votmine(X,Y,X1,Y1,X2,Y2, Color):-
    findall(ruut(Yfin,Xfin,Color), ruut(Yfin,Xfin,Color), L),
    otsi_votmine(X,Y,X1,Y1,X2,Y2,L).

otsi_votmine(X,Y,X1,Y1,X2,Y2, [ruut(Ycan,Xcan,Color)| L]):-
    (0 is mod(Color,10), (saab_votta_tamm(Xcan,Ycan,X1,Y1,X2,Y2,Color), X is Xcan, Y is Ycan); otsi_votmine(X,Y,X1,Y1,X2,Y2,L));
    (saab_votta(Xcan,Ycan,X1,Y1,X2,Y2,Color), X is Xcan, Y is Ycan); otsi_votmine(X,Y,X1,Y1,X2,Y2,L).

saab_votta(X,Y,X1,Y1,X2,Y2,Color):- 
    ruut(Y, X, Color),
    (Color == 1,  Color2 is 2; Color == 2, Color2 is 1),
    saab_votta_NE(X,Y,X1,Y1,X2,Y2,Color2), write("ne olemas").

saab_votta(X,Y,X1,Y1,X2,Y2,Color):- 
    ruut(Y, X, Color),
    (Color == 1,  Color2 is 2; Color == 2, Color2 is 1),
    saab_votta_SE(X,Y,X1,Y1,X2,Y2,Color2), write("se olemas").

saab_votta(X,Y,X1,Y1,X2,Y2,Color):- 
    ruut(Y, X, Color),
    (Color == 1,  Color2 is 2; Color == 2, Color2 is 1),
    saab_votta_SW(X,Y,X1,Y1,X2,Y2,Color2), write("sw olemas").

saab_votta(X,Y,X1,Y1,X2,Y2,Color):- 
    ruut(Y, X, Color),
    (Color == 1,  Color2 is 2; Color == 2, Color2 is 1),
    saab_votta_NW(X,Y,X1,Y1,X2,Y2,Color2), write("nw olemas").

saab_votta_NE(X,Y,X1,Y1,X2,Y2, Color):- 
    X1 is X+1, Y1 is Y+1, NewColor is Color*10,
    (ruut(Y1, X1, Color);ruut(Y1,X1,NewColor)),
    X2 is X+2, Y2 is Y+2,
    ruut(Y2, X2, 0).

saab_votta_SE(X,Y,X1,Y1,X2,Y2, Color):-
    X1 is X+1, Y1 is Y-1, NewColor is Color*10,
    (ruut(Y1, X1, Color);ruut(Y1,X1,NewColor)),
    X2 is X+2, Y2 is Y-2,
    ruut(Y2, X2, 0).

saab_votta_SW(X,Y,X1,Y1,X2,Y2, Color):-
    X1 is X-1, Y1 is Y-1, NewColor is Color*10,
    (ruut(Y1, X1, Color);ruut(Y1,X1,NewColor)),
    X2 is X-2, Y2 is Y-2,
    ruut(Y2, X2, 0). 

saab_votta_NW(X,Y,X1,Y1,X2,Y2, Color):-
    X1 is X-1, Y1 is Y+1, NewColor is Color*10,
    (ruut(Y1, X1, Color);ruut(Y1,X1,NewColor)),
    X2 is X-2, Y2 is Y+2,
    ruut(Y2, X2, 0).


saab_votta_tamm(X,Y,X1,Y1,X2,Y2,Color) :-
    ((Color == 10,  Color2 is 2); (Color == 20, Color2 is 1)),
    (find_sw(X, Y, Res, Color2), ruut(X1, Y1) = Res, X2 is X1 -1, Y2 is Y1 -1);
    ((Color == 10,  Color2 is 2); (Color == 20, Color2 is 1)),
    (find_nw(X, Y, Res, Color2), ruut(X1, Y1) = Res, X2 is X1 -1, Y2 is Y1 +1);
    ((Color == 10,  Color2 is 2); (Color == 20, Color2 is 1)),
    (find_se(X, Y, Res, Color2), ruut(X1, Y1) = Res, X2 is X1 +1, Y2 is Y1 -1);
    ((Color == 10,  Color2 is 2); (Color == 20, Color2 is 1)),
    (find_ne(X, Y, Res, Color2), ruut(X1, Y1) = Res, X2 is X1 +1, Y2 is Y1 +1).

find_sw(CurrentX,CurrentY, Res, Color):-
    CurrentX > 1, CurrentY > 1,
    TammColor is Color*10,
    ((ruut(CurrentY, CurrentX, Color);ruut(CurrentY, CurrentX, TammColor)), NewerX is CurrentX -1, NewerY is CurrentY -1, !, ruut(NewerY, NewerX, 0), ruut(CurrentX, CurrentY) = Res, write(["found sw ", Res]), !);
    NewX is CurrentX -1, NewY is CurrentY -1,
    NewX > 0, NewX > 0, (ruut(NewX, NewY, Color);ruut(NewX, NewY, 0);ruut(NewX, NewY, TammColor)),
    find_sw(NewX, NewY, Res, Color).

find_nw(CurrentX,CurrentY, Res, Color):-
    CurrentX > 1, CurrentY < 8,
    TammColor is Color*10,
    ((ruut(CurrentY, CurrentX, Color);ruut(CurrentY, CurrentX, TammColor)), NewerX is CurrentX -1, NewerY is CurrentY +1, !, ruut(NewerY, NewerX, 0), ruut(CurrentX, CurrentY) = Res, write(["found nw ", Res]), !);
    NewX is CurrentX -1, NewY is CurrentY +1,
    NewX > 0, NewX < 9, (ruut(NewX, NewY, Color);ruut(NewX, NewY, 0);ruut(NewX, NewY, TammColor)),
    find_nw(NewX, NewY, Res, Color).

find_se(CurrentX, CurrentY, Res, Color):-
    CurrentX < 8, CurrentY > 1, 
    TammColor is Color*10,
    ((ruut(CurrentY, CurrentX, Color);ruut(CurrentY, CurrentX, TammColor)), NewerX is CurrentX +1, NewerY is CurrentY -1, !, ruut(NewerY, NewerX, 0), ruut(CurrentX, CurrentY) = Res, write(["found se ", Res]), !);
    NewX is CurrentX +1, NewY is CurrentY -1,
    NewX < 9, NewY > 0, (ruut(NewX, NewY, Color);ruut(NewX, NewY, 0);ruut(NewX, NewY, TammColor)),
    find_se(NewX, NewY, Res, Color).

find_ne(CurrentX, CurrentY, Res, Color):-
    CurrentX < 8, CurrentY < 8,
    TammColor is Color*10,
    ((ruut(CurrentY, CurrentX, Color);ruut(CurrentY, CurrentX, TammColor)), NewerX is CurrentX +1, NewerY is CurrentY +1, !, ruut(NewerY, NewerX, 0), ruut(CurrentX, CurrentY) = Res, write(["found ne ", Res]), !);
    NewX is CurrentX +1, NewY is CurrentY +1,
    NewX < 9, NewY < 9, (ruut(NewX, NewY, Color);ruut(NewX, NewY, 0); ruut(NewX, NewY, TammColor)),
    find_ne(NewX, NewY, Res, Color).





%kaimine

leia_kaik(X,Y,X1,Y1, Color):-
    findall(ruut(Yfin,Xfin,Color), ruut(Yfin,Xfin,Color), L),
    otsi_kaik(X,Y,X1,Y1, L).

otsi_kaik(X,Y,X1,Y1, [ruut(Xcan,Ycan,Color) | L]):-
    ((Color == 1,Suund is 1); (Color == 2, Suund is -1); (Color == 10, Suund is 1); (Color == 20, Suund is -1)),
    (kaik_vaba(Xcan,Ycan,Suund,X1,Y1),X is Xcan, Y is Ycan); otsi_kaik(X,Y,X1,Y1,L).

kaik_vaba(X, Y, Suund, X1, Y1) :-
  X1 is X + Suund,
  Y1 is Y + 1,
  ruut(X1, Y1, 0).

kaik_vaba(X, Y, Suund, X1, Y1) :-
  X1 is X + Suund,
  Y1 is Y - 1,
  ruut(X1, Y1, 0).

kaik_vaba(X,Y,Suund,X1,Y1) :-
  ruut(X, Y, Type),
  on_tamm(Type),
  X1 is X - Suund,
  Y1 is Y + 1,
  ruut(X1, Y1, 0).

kaik_vaba(X,Y,Suund,X1,Y1) :-
  ruut(X, Y, Type),
  on_tamm(Type),
  X1 is X - Suund,
  Y1 is Y - 1,
  ruut(X1, Y1, 0).

vota(X,Y,X1,Y1,X2,Y2):-
    retract(ruut(X,Y,Color)),
    retract(ruut(X1,Y1,_)),
    retract(ruut(X2,Y2,0)),
    assert(ruut(X1,Y1,0)),
    assert(ruut(X,Y,0)),
    (
        (tamm(Color, 10), X2 is 8,
        assert(ruut(X2,Y2,10)); tamm(Color, 20), X2 is 1, assert(ruut(X2,Y2,20)));
        assert(ruut(X2,Y2,Color))).

tee_kaik(X,Y,X1,Y1) :-
    retract(ruut(X1,Y1,0)),
    retract(ruut(X,Y,Color)),
    assert(ruut(X,Y,0)),
    (
        (tamm(Color, 10), X1 is 8, 
        assert(ruut(X1,Y1,10)); 
        tamm(Color, 20), X1 is 1, assert(ruut(X1,Y1,20)));
        assert(ruut(X1,Y1,Color))).

saab_tammiks(X1,_, Color, Val):-
    tamm(Color, Val), X1 == 8;
    tamm(Color, Val), X1 is 1.

saa_tammiks(X,Y,Color, Val):-
    tamm(Color, Val),
    assert(ruut(X,Y,Val)).