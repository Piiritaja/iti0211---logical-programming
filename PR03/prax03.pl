%1. Kirjutada rekursiivne reegel viimane_element/2, mis leiab listi viimase elemendi.
viimane_element(X,[X]).
viimane_element(X,[_|Z]) :- viimane_element(X,Z).