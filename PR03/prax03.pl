%1. Kirjutada rekursiivne reegel viimane_element/2, mis leiab listi viimase elemendi.
viimane_element(X,[X]).
viimane_element(X,[_|Z]) :- viimane_element(X,Z).

%2. Kirjutada reegel suurim/2, mis kontrollib etteantud listist järjest paarikaupa elemente ja paneb väljundlisti elemendi, mis on antud paari elementidest suurim. Kui võrreldakse elementi ja tühilisti, siis väljundlisti tuleb panna element. 
suurim([],[]).
suurim([X], [X]).
suurim([X, Y|Z], [M|U]):- 
    M is max(X,Y),
    suurim([Y|Z], U).