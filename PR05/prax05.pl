laevaga(tallinn, helsinki, 120, time(12, 45, 0.0), time(14, 45, 0.0)).
laevaga(tallinn, stockholm, 480, time(12, 45, 0.0), time(11, 25, 0.0)).
bussiga(tallinn, riia, 300, time(12, 45, 0.0), time(12, 46, 0.0)).
rongiga(riia, berlin, 680, time(12, 45, 0.0), time(13, 55, 0.0)).
lennukiga(tallinn, helsinki, 30, time(12, 45, 0.0), time(19, 40, 0.0)).
lennukiga(helsinki, paris, 180, time(12, 45, 0.0), time(15, 55, 0.0)).
lennukiga(paris, berlin, 120, time(12, 45, 0.0), time(20, 45, 0.0)).
lennukiga(paris, tallinn, 12, time(13, 45, 0.0), time(12, 45, 0.0)).


tee(X, Y, Cost, lennukiga) :- lennukiga(X, Y, Cost, _, _).
tee(X, Y, Cost, rongiga) :- rongiga(X, Y, Cost, _, _).
tee(X, Y, Cost, bussiga) :- bussiga(X, Y, Cost, _, _).
tee(X, Y, Cost, laevaga) :- laevaga(X, Y, Cost, _, _).

tee(X,Y,Cost):- 
    laevaga(X,Y,Cost, _, _);
    bussiga(X,Y,Cost, _, _);
    rongiga(X,Y,Cost, _, _);
    lennukiga(X,Y,Cost, _, _).
%2. Lisa teadmusbaasile rekursiivne reegel reisi/2, mis leiab, kas on võimalik reisida ühest linnast teise. Ühenduse leidmisel võib olla vajalik kombineerida omavahel erinevaid transpordi vahendeid. 
reisi(X,Y):- tee(X,Y,_,_), !.
reisi(X,Z):- tee(X,Y,_,_), reisi(Y,Z,_,_).

%3. Lisa teadmusbaasile reegel reisi/3, mis lisaks eelnevale näitab ka teel läbitavad linnad.
reisi(X,Y,mine(X,Y)):- tee(X,Y,_,_), !.
reisi(X,Z, mine(X,Y,Tee)):-
    tee(X,Y,_,_),
    reisi(Y,Z,Tee).

%4. Lisa teadmusbaasile reegel reisi_transpordiga/3, mis lisaks eelnevale näitab ka seda, millise transpordivahendiga antud vahemaa läbitakse.
reisi_transpordiga(X,Y,mine(X,Y,Transport)):- tee(X,Y, _,Transport), !.
reisi_transpordiga(X,Z, mine(X,Y,Transport,Tee)):-
    tee(X,Y,_,Transport),
    reisi_transpordiga(Y,Z,Tee).

%5. Lisa teadmusbaasile reegel reisi/4, mis näitab läbitavaid linnu, millise transpordivahendiga antud vahemaa läbitakse ja reisiks kuluvat aega alguspunktist lõpppunkti.
reisi(X,Y,mine(X,Y,Transport),Hind):- tee(X,Y, Hind, Transport), !. 
reisi(X,Z,mine(X,Y,Transport,Tee), Hind):-
    tee(X,Y,Cost,Transport),
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