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