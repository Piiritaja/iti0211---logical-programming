mother(liis,maris).
mother(ago,liis).
mother(mikk, evelin).

married(evelin,ago).
married(liis,mikk).

male(sedrik).
male(ago).
male(kaspar).
male(mikk).

female(maris).
female(liis).
female(evelin).

father(Child, Father):- mother(Child,Mother), married(Mother, Father), male(Father).
brother(Child, Brother):- male(Brother), ((mother(Child, Mother), mother(Brother, Mother));(father(Child, Father), father(Brother, Father))), not(Child=Brother).
sister(Child, Sister):- female(Sister), ((mother(Child, Mother), mother(Sister, Mother));(father(Child, Father), father(Sister, Father))), not(Sister=Child).
parent(Child, Parent):- mother(Child, Parent); father(Child, Parent).
aunt(Child, Aunt):- parent(Child, Parent), sister(Parent, Aunt).
uncle(Child, Uncle):- parent(Child, Parent), brother(Parent, Uncle).
grandfather(Child, Grandfather):- father(Child, Father), father(Father, Grandfather).
grandmother(Child, Grandmother):- mother(Child, Mother), mother(Mother, Grandmother).