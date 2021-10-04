%1. Kirjutada rekursiivne reegel viimane_element/2, mis leiab listi viimase elemendi.
viimane_element(X,[X]).
viimane_element(X,[_|Z]) :- viimane_element(X,Z).

%2. Kirjutada reegel suurim/2, mis kontrollib etteantud listist järjest paarikaupa elemente ja paneb väljundlisti elemendi, mis on antud paari elementidest suurim. Kui võrreldakse elementi ja tühilisti, siis väljundlisti tuleb panna element. 
suurim([],[]).
suurim([X], [X]).
suurim([X, Y|Z], [M|U]):- 
    M is max(X,Y),
    suurim([Y|Z], U).

%3. Kirjutada reegel paki/2, mis elimineerib listist üksteisele vahetult järgnevad korduvad elemendid.
paki([],[]).
paki([X],[X]).
paki([H1, H2|T1], [H1|T2]):-
    H1 == H2,
    paki([H2|T1],[H1|T2]);
    H1 \= H2,
    paki([H2|T1],T2).

%4. Kirjutada reegel duplikeeri/2, mis kahekordistab elemendid etteantud listis.

duplikeeri([],[]).
duplikeeri([H1| T1], [H1,H1|T2]):- duplikeeri(T1, T2).

%5. Kirjutada reegel kordista/3, mis kordistab listi kõiki elemente etteantud arv korda.
list_of_n(_, 0, []). 
list_of_n(El, N, L):- NewN is N-1, append([El], A, L), list_of_n(El,NewN,A).
kordista([],_,[]).
kordista([H|T], N, L):-
    list_of_n(H, N, A),
    append(A,Y,L),
    kordista(T,N,Y).

%6. Kirjutada reegel vordle_predikaadiga/3, mis võrdleb etteantud predikaadiga listi kõiki liikmeid ja paneb väljundlisti need elemendid, mis vastavad tingimustele. Võrdluspredikaadid on: - paaritu_arv - paaris_arv - suurem_kui(X) Võrdluspredikaadid tuleb ise implementeerida.
paaris_arv(X):-
    X rem 2 =:= 0.

paaritu_arv(X):-
    X rem 2 =:= 1.

suurem_kui(X, Y):-
    write(X),
    write(' > '),
    write(Y),
    nl,
    X < Y.


vordle_predikaadiga([], _, []).
vordle_predikaadiga([H|T], Action, X):-
    append(Action, [H], List),
    Pred =.. List,
    Pred,
    append([H],Y,X),
    vordle_predikaadiga(T,Action,Y),
    !.

vordle_predikaadiga([_|T], Action, X) :-
        vordle_predikaadiga(T, Action, X).