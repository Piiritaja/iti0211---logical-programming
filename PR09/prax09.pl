/*
Ülesanne 3: Koostada järgmiste eesti keele lausete parsimiseks ühine grammatika puu, mis kirjeldab kõigi kolme antud lausete süntaksi: 

    veerevale kivile sammal ei kasva (juursümbol: 'lihtlause') 
    uhkus ajab upakile (juursümbol: 'lihtlause')
    raha tuleb, raha laheb, volad jaavad (juursümbol: 'liitlause') 

▪ NB! komad on ka lause osad 
▪ Reegel 'liitlause' peab olema rekursiivne e. tunnistama peab ka lause “raha tuleb, raha tuleb, raha laheb, volad jaavad”
*/

lihtlause --> nimisonafraas, tegusonafraas.
nimisonafraas --> maarsonafraas, nimisona.
nimisonafraas --> maarsonafraas, nimisona.
maarsonafraas --> omadussona, maarsona ; [].
tegusonafraas --> [ei], tegusona, maarsonafraas.
tegusonafraas --> tegusona, maarsonafraas.
liitlause --> lihtlause, [,], (lihtlause ; liitlause).

nimisona --> [sammal] ; [uhkus] ; [raha] ; [volad].
maarsona --> [kivile] ; [upakile].
omadussona --> [veerevale]; [].
tegusona --> [kasva] ; [ajab] ; [tuleb] ; [laheb] ; [jaavad].

/*
phrase(lihtlause, [veerevale, kivile, sammal, ei, kasva]).
phrase(lihtlause, [uhkus, ajab, upakile]).
phrase(liitlause, [raha, tuleb, ',', raha, laheb, ',', volad, jaavad]).

*/