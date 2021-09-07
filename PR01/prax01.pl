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