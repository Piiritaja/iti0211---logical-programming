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
eats(kalad,zooplanton).
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


count_terminals(Node, Terminals, Count):-
    findall(Terminal, terminal(Terminal, Node), Terminals),
    length(Terminals, Count).
