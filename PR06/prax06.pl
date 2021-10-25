:- dynamic lennukiga/5.

tee(X, Y, Cost, lennukiga, T1, T2) :- lennukiga(X, Y, Cost, T1, T2).

tee(X,Y,Cost):- 
    lennukiga(X,Y,Cost, _, _).
%2. Lisa teadmusbaasile rekursiivne reegel reisi/2, mis leiab, kas on võimalik reisida ühest linnast teise. Ühenduse leidmisel võib olla vajalik kombineerida omavahel erinevaid transpordi vahendeid. 
reisi(X,Y):- tee(X,Y,_,_,_,_).
reisi(X,Z):- tee(X,Y,_,_,_,_), reisi(Y,Z,_,_).

%3. Lisa teadmusbaasile reegel reisi/3, mis lisaks eelnevale näitab ka teel läbitavad linnad.
reisi(X,Y,mine(X,Y)):- tee(X,Y,_,_,_,_).
reisi(X,Z, mine(X,Y,Tee)):-
    tee(X,Y,_,_,_,_),
    reisi(Y,Z,Tee).

%4. Lisa teadmusbaasile reegel reisi_transpordiga/3, mis lisaks eelnevale näitab ka seda, millise transpordivahendiga antud vahemaa läbitakse.
reisi_transpordiga(X,Y,mine(X,Y,Transport)):- tee(X,Y, _,Transport,_,_), !.
reisi_transpordiga(X,Z, mine(X,Y,Transport,Tee)):-
    tee(X,Y,_,Transport,_,_),
    reisi_transpordiga(Y,Z,Tee).

%5. Lisa teadmusbaasile reegel reisi/4, mis näitab läbitavaid linnu, millise transpordivahendiga antud vahemaa läbitakse ja reisiks kuluvat aega alguspunktist lõpppunkti.
reisi(X,Y,mine(X,Y,Transport),Hind):- tee(X,Y, Hind, Transport, _, _), !. 
reisi(X,Z,mine(X,Y,Transport,Tee), Hind):-
    tee(X,Y,Cost,Transport,_,_),
    reisi(Y,Z,Tee,Price),
    Hind is +(Cost,Price).

%6. Lisa teadmusbaasile reegl odavaim_reis/4, mis leiab odavaima reisi kahe punkti vahel, näitab teel läbitavaid linnu, millise transpordivahendiga antud vahemaa läbitakse ja reisi maksumust.
find_best_price([H], H).
find_best_price([H1, H2|T], Price):-
    (H1 >= H2, find_best_price([H2|T], Price));
    (H1 < H2, find_best_price([H1|T], Price)).

odavaim_reis(X, Y, Tee, Hind):-
    findall(Price, reisi(X, Y, _, Price), PriceList),
    find_best_price(PriceList, Hind), !,
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


reisi(X, Y, mine(X,Y,Transport), Hind, Aeg):- 
    tee(X, Y, Hind, Transport, T1, T2),
    aegade_vahe(T1,T2,Aeg).
    
reisi(X, Z, mine(X,Y,Transport,Tee), Hind, Aeg):-
    tee(X,Y,Cost,Transport,T1,T2),
    !,
    aegade_vahe(T1,T2,Vahe1),
    tee(Y,Z,_,_,T3,_),
    time(_,_,_) = T3,
    aegade_vahe(T2,T3,Vahe2),
    time(H2,_,_) = Vahe2,
    reisi(Y,Z,Tee,Price,Time),
    ((H2 >= 1, aegade_summa(Vahe1, Vahe2, Vahe));
    (H2 < 1, aegade_summa(Vahe1, Vahe2, Vahe3),
    aegade_summa(Vahe3, time(24,0,0),Vahe))),
    aegade_summa(Vahe,Time, Aeg),
    Hind is +(Cost,Price).

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
    find_shortest_time(Ajad, Time), !,
    reisi(X, Y, Tee, Hind, Time).