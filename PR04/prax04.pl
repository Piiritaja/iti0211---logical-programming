laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).
bussiga(tallinn, riia, 300).
rongiga(riia, berlin, 680).
lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120).
lennukiga(paris, tallinn, 120).
lennukiga(stockholm,paris,120).

tee(X, Y, lennukiga) :- lennukiga(X, Y, _).
tee(X, Y, rongiga) :- rongiga(X, Y, _).
tee(X, Y, bussiga) :- bussiga(X, Y, _).
tee(X, Y, laevaga) :- laevaga(X, Y, _).

tee(X,Y):- 
    laevaga(X,Y,_);
    bussiga(X,Y,_);
    rongiga(X,Y,_);
    lennukiga(X,Y,_).
%2. Lisa teadmusbaasile rekursiivne reegel reisi/2, mis leiab, kas on võimalik reisida ühest linnast teise. Ühenduse leidmisel võib olla vajalik kombineerida omavahel erinevaid transpordi vahendeid. 
reisi(X,Y):- tee(X,Y), !.
reisi(X,Z):- tee(X,Y), reisi(Y,Z).

%3. Lisa teadmusbaasile reegel reisi/3, mis lisaks eelnevale näitab ka teel läbitavad linnad.
reisi(X,Y,mine(X,Y)):- tee(X,Y), !.
reisi(X,Z, mine(X,Y,Tee)):-
    tee(X,Y),
    reisi(Y,Z,Tee).

%4. Lisa teadmusbaasile reegel reisi_transpordiga/3, mis lisaks eelnevale näitab ka seda, millise transpordivahendiga antud vahemaa läbitakse.
reisi_transpordiga(X,Y,mine(X,Y,Transport)):- tee(X,Y, Transport), !.
reisi_transpordiga(X,Z, mine(X,Y,Transport,Tee)):-
    tee(X,Y,Transport),
    tee(X,Y),
    reisi_transpordiga(Y,Z,Tee).
