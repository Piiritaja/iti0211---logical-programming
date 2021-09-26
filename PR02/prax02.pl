male(ulo).
male(aavo).
male(ksapar).
male(martin).
male(lauri).
male(joonas).
male(mihkel).
male(juss).
male(mati).
male(heino).
male(vello).

female(maris).
female(aari).
female(angela).
female(maie).
female(helga).
female(maarika).

mother(kaspar,maris).
mother(martin,maris).
mother(lauri, aari).
mother(joonas, aari).
mother(mihkel, angela).
mother(juss, angela).
mother(maris, helga).
mother(aavo, helga).
mother(aari, helga).
mother(mati, maie).
mother(maarika, maie).

married(maris,mati).
married(angela,aavo).
married(aari, ulo).
married(maie, vello).
married(helga, heino).

father(Child, Father):- mother(Child,Mother), married(Mother, Father), male(Father).
brother(Child, Brother):- male(Brother), ((mother(Child, Mother), mother(Brother, Mother))), not(Child=Brother).
sister(Child, Sister):- female(Sister), ((mother(Child, Mother), mother(Sister, Mother))), not(Sister=Child).
parent(Child, Parent):- mother(Child, Parent); father(Child, Parent).
aunt(Child, Aunt):- parent(Child, Parent), sister(Parent, Aunt).
uncle(Child, Uncle):- parent(Child, Parent), brother(Parent, Uncle).
grandfather(Child, Grandfather):- (father(Child, Father), father(Father, Grandfather));(mother(Child, Mother), father(Mother, Grandfather)).
grandmother(Child, Grandmother):- mother(Child, Mother), mother(Mother, Grandmother);(father(Child, Father), mother(Father, Grandmother)).

%2. Lisa teadmusbaasile rekursiivne reegel ancestor/2, mis leiab isiku kõik esivanemad.
ancestor(Child, Parent) :- 
    parent(Child, Parent). 

ancestor(Child, Ancestor) :-
    parent(Child, Parent),
    ancestor(Parent, Ancestor). 

%3. Lisa teadmusbaasile rekursiivne reegel male_ancestor/2, mis leiab meessoost esivanemad.
male_ancestor(Child, Parent):- ancestor(Child, Parent), male(Parent).

%4. Lisa teadmusbaasile rekursiivne reegel female_ancestor/2, mis leiab naissoost esivanemad. 
female_ancestor(Child, Parent):- ancestor(Child, Parent), female(Parent).

%5. Lisa teadmusbaasile reegel ancestor1/3, mis leiab N-nda sugupõlve esivanemad (nii mees- kui ka naissoost). 
ancestor1(Child, Ancestor, N) :- N == 1, parent(Child, Ancestor).

ancestor1(Child, Ancestor, N) :-
    X is -(N, 1),
    parent(Child, Parent),
    ancestor1(Parent, Ancestor, X).


%6. Lisa teadmusbaasile reegel ancestor2/3, mis leiab esivanemad, kellel on rohkem kui X last.
ancestor2(Child, Parent, X):-
    bagof(Child, parent(Child, Parent), Bag),
    length(Bag, Lenght),
    Lenght > X.

ancestor2(Child, Parent, X):- 
    parent(Child, Y),
    ancestor2(Y, Parent, X).
