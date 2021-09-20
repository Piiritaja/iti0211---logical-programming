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

ancestor(Child, Parent) :- 
    parent(Child, Parent). 

ancestor(Child, Ancestor) :-
    parent(Child, Parent),
    ancestor(Parent, Ancestor). 

male_ancestor(Child, Parent):- ancestor(Child, Parent), male(Parent).
female_ancestor(Child, Parent):- ancestor(Child, Parent), female(Parent).

ancestor1(Child, Ancestor, N) :- N == 1, parent(Child, Ancestor).

ancestor1(Child, Ancestor, N) :-
    X is -(N, 1),
    parent(Child, Parent),
    ancestor1(Parent, Ancestor, X).
