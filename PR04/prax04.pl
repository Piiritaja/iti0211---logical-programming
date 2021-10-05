laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).
bussiga(tallinn, riia, 300).
rongiga(riia, berlin, 680).
lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120).
lennukiga(paris, tallinn, 120).
lennukiga(stockholm,paris,120).

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