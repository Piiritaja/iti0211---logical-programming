laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).
bussiga(tallinn, riia, 300).
rongiga(riia, berlin, 680).
lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120).
lennukiga(paris, tallinn, 120).


tee(X,Y):- laevaga(X,Y,_); bussiga(X,Y,_); rongiga(X,Y,_); lennukiga(X,Y,_).
%2. Lisa teadmusbaasile rekursiivne reegel reisi/2, mis leiab, kas on võimalik reisida ühest linnast teise. Ühenduse leidmisel võib olla vajalik kombineerida omavahel erinevaid transpordi vahendeid. 
reisi(X,Y):- tee(X,Y).
reisi(X,Z):- tee(X,Y), reisi(Y,Z).