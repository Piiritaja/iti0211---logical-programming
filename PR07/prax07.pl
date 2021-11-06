% is_a(SubClass, Class).
is_a(roovloomad,elusolend).
is_a(mitte-roovloomad,elusolend).
is_a(veeimetajad,roovloomad).
is_a(kalad,roovloomad).
is_a(saarmas,veeimetajad).
is_a(kobras,veeimetajad).
is_a(ahven,kalad).
is_a(haug,kalad).
is_a(zooplankton,mitte-roovloomad).
is_a(veetaimed,mitte-roovloomad).
is_a(vesikatk,veetaimed).
is_a(vetikas,veetaimed).


% 2) Defineerige seosed kes keda sööb kasutades predikaati eats/2. 
eats(zooplankton,veetaimed).
eats(kalad,zooplankton).
eats(veeimetajad,kalad).

% 3) Programmeerige predikaat count_terminals(Node,Terminals,Count), mis leiab terminaalsete tippude arvu.


inherits(SubClass, Class):-
    is_a(SubClass, Class).

inherits(SubClass, Class):-
    is_a(Y, Class),
    inherits(SubClass, Y).

terminal(SubClass, Class):-
    inherits(SubClass, Class),
    not(is_a(_, SubClass)).

terminal(SubClass, Class):-
    inherits(Y, Class),
    not(is_a(SubClass, Y)),
    terminal(SubClass,Y).

count_terminals(Node, [Node], 1):-
    not(is_a(_, Node)), !.

count_terminals(Node, Terminals, Count):-
    findall(Terminal, terminal(Terminal, Node), Terminals),
    length(Terminals, Count).

% 4) Programmeerige predikaat extinction(Who,What_spieces,How_many), mis leiab väljasurevad liigid ja nende arvu, kui anda ette algselt häviv liik. 

inherits_eats(Who, Whom):-
    eats(Who, Whom).

inherits_eats(Z, Whom):-
    eats(Z, W),
    inherits_eats(W, Whom).

get_spieces_from_parents([],[]).
get_spieces_from_parents([Parent | Parents], Children):-
    count_terminals(Parent, Y, _),
    append(Y, Ultimate, Children),
    get_spieces_from_parents(Parents, Ultimate).


extinction(Who, Spieces, Count):-
    is_a(Who,_),
    findall(Spiece, inherits_eats(Spiece, Who), Parents),
    get_spieces_from_parents([Who | Parents], Spieces),
    length(Spieces, Count).

% Lisa reegel find_most_sensitive_species/3 Lisatud reegel peab leidma liigi, mille väljasuremine tekitaks toitumisahela kaudu liigilisele mitmekesisusele kõige suuremat kahju.

:-dynamic best/3.

find_extinction:-
    extinction(Who, Spieces, Count),
    best(_,_,C),
    Count > C, retractall(best(_,_,_)),
    asserta(best(Who,Spieces,Count)).

find_most_sensitive_species(L,C,T):-
    retractall(best(_,_,_)),
    asserta(best(_,_,0)),
    findall(_,find_extinction,_),
    best(L,T,C).



