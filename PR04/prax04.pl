laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).
bussiga(tallinn, riia, 300).
rongiga(riia, berlin, 680).
lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120).
lennukiga(paris, tallinn, 120).
lennukiga(stockholm,paris,120).
lennukiga(berlin, helsinki, 110).

tee(X, Y, Cost, lennukiga) :- lennukiga(X, Y, Cost).
tee(X, Y, Cost, rongiga) :- rongiga(X, Y, Cost).
tee(X, Y, Cost, bussiga) :- bussiga(X, Y, Cost).
tee(X, Y, Cost, laevaga) :- laevaga(X, Y, Cost).

tee(X,Y,Cost):- 
    laevaga(X,Y,Cost);
    bussiga(X,Y,Cost);
    rongiga(X,Y,Cost);
    lennukiga(X,Y,Cost).
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
    tee(X,Y,_,_),
    Y \= Z,
    not(member(Y, Visited)),
    reisi0(Y,Z, [Y | Visited], Tee).

reisi(X, Y, Tee) :-
    X \= Y,
    reisi0(X, Y, [X], Tee).

%4. Lisa teadmusbaasile reegel reisi_transpordiga/3, mis lisaks eelnevale näitab ka seda, millise transpordivahendiga antud vahemaa läbitakse.
reisi_transpordiga0(X,Y,mine(X,Y,Transport), _):- tee(X,Y, _,Transport).
reisi_transpordiga0(X,Z, mine(X,Y,Transport,Tee), Visited):-
    tee(X,Y,_,Transport),
    Y \= Z,
    not(member(Y,Visited)),
    reisi_transpordiga0(Y,Z,Tee, [Y | Visited]).

reisi_transpordiga(X, Y, Tee) :-
    reisi_transpordiga0(X, Y, Tee, [X]).


%5. Lisa teadmusbaasile reegel reisi/4, mis näitab läbitavaid linnu, millise transpordivahendiga antud vahemaa läbitakse ja reisiks kuluvat aega alguspunktist lõpppunkti.
reisi0(X,Y,mine(X,Y,Transport),Hind, _):- tee(X,Y, Hind, Transport). 
reisi0(X,Z,mine(X,Y,Transport,Tee), Hind, Visited):-
    tee(X,Y,Cost,Transport),
    Y \= Z,
    not(member(Y, Visited)),
    reisi0(Y,Z,Tee,Price, [Y | Visited]),
    Hind is +(Cost,Price).

reisi(X, Y, Tee, Hind):- 
    reisi0(X, Y, Tee, Hind, [X]).