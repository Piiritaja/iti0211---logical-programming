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