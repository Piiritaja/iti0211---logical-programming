laevaga(tallinn, helsinki, 120, time(12, 45, 0.0), time(17, 50, 0.0)).
laevaga(tallinn, stockholm, 480, time(12, 45, 0.0), time(11, 25, 0.0)).
bussiga(tallinn, riia, 100, time(12, 45, 0.0), time(12, 46, 0.0)).
rongiga(riia, berlin, 100, time(12, 45, 0.0), time(13, 55, 0.0)).
lennukiga(tallinn, helsinki, 30, time(12, 45, 0.0), time(14, 40, 0.0)).
lennukiga(helsinki, paris, 180, time(17, 55, 0.0), time(20, 50, 0.0)).
lennukiga(paris, berlin, 120, time(15, 55, 0.0), time(20, 45, 0.0)).
lennukiga(paris, tallinn, 12, time(13, 45, 0.0), time(12, 45, 0.0)).
lennukiga(stockholm,paris,120, time(13, 45, 0.0), time(12, 45, 0.0)).
lennukiga(berlin, helsinki, 100, time(13,45, 0.0), time(12, 45, 0.0)).

tee(X, Y, Cost, lennukiga, T1, T2) :- lennukiga(X, Y, Cost, T1, T2).
tee(X, Y, Cost, rongiga, T1, T2) :- rongiga(X, Y, Cost, T1, T2).
tee(X, Y, Cost, bussiga, T1, T2) :- bussiga(X, Y, Cost, T1, T2).
tee(X, Y, Cost, laevaga, T1, T2) :- laevaga(X, Y, Cost, T1, T2).

tee(X,Y,Cost):- 
    laevaga(X,Y,Cost, _, _);
    bussiga(X,Y,Cost, _, _);
    rongiga(X,Y,Cost, _, _);
    lennukiga(X,Y,Cost, _, _).
%2. Lisa teadmusbaasile rekursiivne reegel reisi/2, mis leiab, kas on võimalik reisida ühest linnast teise. Ühenduse leidmisel võib olla vajalik kombineerida omavahel erinevaid transpordi vahendeid. 
reisi0(X,Y,_):- tee(X,Y,_,_).
reisi0(X,Z, Visited):- 
    tee(X,Y,_,_),
    Y \=Z,
    not(member(Y, Visited)),
    reisi0(Y,Z, [Y | Visited]).

reisi(X,Y):-
    distinct(reisi0(X,Y,[X])).

%3. Lisa teadmusbaasile reegel reisi/3, mis lisaks eelnevale näitab ka teel läbitavad linnad.
reisi0(X,Y,_,mine(X,Y)):- tee(X,Y,_,_).
reisi0(X,Z, Visited, mine(X,Y,Tee)):-
    tee(X,Y,_,_,_,_),
    Y \= Z,
    not(member(Y, Visited)),
    reisi0(Y,Z, [Y | Visited], Tee).

reisi(X, Y, Tee) :-
    X \= Y,
    reisi0(X, Y, [X], Tee).

%4. Lisa teadmusbaasile reegel reisi_transpordiga/3, mis lisaks eelnevale näitab ka seda, millise transpordivahendiga antud vahemaa läbitakse.
reisi_transpordiga0(X,Y,mine(X,Y,Transport), _):- tee(X,Y, _,Transport,_,_).
reisi_transpordiga0(X,Z, mine(X,Y,Transport,Tee), Visited):-
    tee(X,Y,_,Transport,_,_),
    Y \= Z,
    not(member(Y,Visited)),
    reisi_transpordiga0(Y,Z,Tee, [Y | Visited]).

reisi_transpordiga(X, Y, Tee) :-
    reisi_transpordiga0(X, Y, Tee, [X]).


%5. Lisa teadmusbaasile reegel reisi/4, mis näitab läbitavaid linnu, millise transpordivahendiga antud vahemaa läbitakse ja reisiks kuluvat aega alguspunktist lõpppunkti.
reisi0(X,Y,mine(X,Y,Transport),Hind, _):- tee(X,Y, Hind, Transport,_,_). 
reisi0(X,Z,mine(X,Y,Transport,Tee), Hind, Visited):-
    tee(X,Y,Cost,Transport,_,_),
    Y \= Z,
    not(member(Y, Visited)),
    reisi0(Y,Z,Tee,Price, [Y | Visited]),
    Hind is +(Cost,Price).

reisi(X, Y, Tee, Hind):- 
    reisi0(X, Y, Tee, Hind, [X]).

%6. Lisa teadmusbaasile reegl odavaim_reis/4, mis leiab odavaima reisi kahe punkti vahel, näitab teel läbitavaid linnu, millise transpordivahendiga antud vahemaa läbitakse ja reisi maksumust.
find_best_price([H], H).
find_best_price([H1, H2|T], Price):-
    (H1 >= H2, find_best_price([H2|T], Price));
    (H1 < H2, find_best_price([H1|T], Price)).

odavaim_reis(X, Y, Tee, Hind):-
    findall(Price, reisi(X, Y, _, Price), PriceList),
    find_best_price(PriceList, Hind),
    reisi(X, Y, Tee, Hind).

%7. Lisa teadmusbaasile reegel lyhim_reis/4, mis leiab ajaliselt lühima marsruudi kahe punkti vahel, näitab teel läbitavaid linnu, millise transpordivahendiga antud vahemaa läbitakse ja reisi maksumust.  

aegade_vahe(Aeg1, Aeg2, Vahe):-
    time(H1,M1,S1) = Aeg1,
    time(H2,M2,S2) = Aeg2,
    time(H3, M3, S3) = Vahe,
    S3 is S2 - S1,
    ((S3 < 0, S3 is S3 + 60,Minutes is M2 - M1 - 1);
    (S3 >= 0, Minutes is M2 - M1)),
    ((Minutes < 0, M3 is Minutes + 60, Hours is H2 - H1 - 1);
    (Minutes >= 0, M3 is Minutes, Hours is H2 - H1)),
    ((Hours < 0, H3 is Hours + 24);
    (Hours >= 0, H3 is Hours)).

aegade_summa(Aeg1, Aeg2, Summa):-
    time(H1,M1,S1) = Aeg1,
    time(H2,M2,S2) = Aeg2,
    time(H3, M3, S3) = Summa,
    S3 is S2 + S1,
    ((S3 < 60, Minutes is M2 + M1);
    (S3 >= 60, S3 is S3 - 60, Minutes is M2 + M1+1)),
    ((Minutes < 60, M3 is Minutes, H3 is H2 + H1);
    (Minutes >= 60, M3 is Minutes - 60, H3 is H2 + H1 + 1)).


reisi0(X, Y, mine(X,Y,Transport), Hind, Aeg, Visited):- 
    tee(X, Y, Hind, Transport, T1, T2),
    aegade_vahe(T1,T2,Aeg).
    
reisi0(X, Z, mine(X,Y,Transport,Tee), Hind, Aeg, Visited):-
    tee(X,Y,Cost,Transport,T1,T2),
    Y \= Z,
    not(member(Y, Visited)),
    aegade_vahe(T1,T2,Vahe1),
    tee(Y,W,_,_,T3,_),
    aegade_vahe(T2,T3,Vahe2),
    time(H2,_,_) = Vahe2,
    reisi0(Y,Z,Tee,Price,Time, [Y | Visited]),
    ((H2 >= 1, aegade_summa(Vahe1, Vahe2, Vahe));
    (H2 < 1, aegade_summa(Vahe1, Vahe2, Vahe3),
    aegade_summa(Vahe3, time(24,0,0),Vahe))),
    aegade_summa(Vahe,Time, Aeg),
    Hind is +(Cost,Price).

reisi(X, Y, Tee, Hind, Aeg):-
    reisi0(X, Y, Tee, Hind, Aeg, [X]).

find_shortest_time([T], T).
find_shortest_time([T1, T2|Tail], Time):-
    time(H1,M1,S1) = T1,
    time(H2,M2,S2) = T2,
    Sum1 is H1*3600 + M1*60 + S1,
    Sum2 is H2*3600 + M2*60 + S2,
    ((Sum1 >= Sum2, find_shortest_time([T2|Tail], Time));
    (Sum1 < Sum2, find_shortest_time([T1|Tail], Time))).

lyhim_reis(X, Y, Tee, Hind):-
    findall(Aeg, reisi(X, Y, _, _, Aeg), Ajad),
    find_shortest_time(Ajad, Time),
    reisi(X, Y, Tee, Hind, Time).