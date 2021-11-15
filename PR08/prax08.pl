auto(avz114,2021,tesla,valge,rauno).
auto(tri364,2000,porche,must,kaspar).
auto(kgb756,2006,subaru,lilla,marek).
auto(zxy326,2013,saab,must,markus).
auto(mnv774,2016,skoda,kollane,marten).
auto(ssv057,2017,subaru,valge,kaspar).
auto(rom768,2004,toyoto,punane,mari).

liik(Vanus,uus):-
    Vanus < 4.

liik(Vanus,suht_uus):-
    Vanus > 4,
    Vanus < 6.

liik(Vanus, kasutatud):-
    Vanus >= 6,
    Vanus < 9.

liik(Vanus, vana):-
    Vanus >= 9,
    Vanus < 16.

liik(Vanus, romu):-
    Vanus >= 16,
    Vanus < 21.
    
liik(Vanus, uunikum):-
    Vanus > 20.

liigitus(auto(Number,Aasta,Mark,Varv,Omanik), Liik):-
    auto(Number, Aasta, Mark, Varv, Omanik),
    Vahe is 2021 - Aasta,
    liik(Vahe, Liik).