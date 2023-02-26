# K&amp;H Parking App

### Motivációk
A jelenlegi parkolóhely-beosztó rendszer sok javításra szorul. Hosszadalmas a belépés, nehezen átlátható a felhasználói felület, és bonyolult helyet foglalni és felajánlani. Ki akarná végigcsinálni mindezt, csak hogy átadja a helyét valaki másnak?
Natív, modern alkalmazásunk célja a felsorolt fő **problémák orvoslása**, és a rendszer sok további módon való **kiegészítése**, fejlesztése. Ezeket a következőképpen valósítottuk meg.

### A felület
A belépést követően az alkalmazás megjegyzi a felhasználót, ezzel kiküszöbölve a folytonos jelszókeresgetést. Ez után a letisztult kezdőképernyő válik láthatóvá. Itt található a naptár, melyből egy pillantásra kiolvasható a következő hetek parkolóhely-foglalásainak állapota. Az egyes napok különböző színűek az állapotuk alapján: zöld ha lesz aznap parkolóhelyünk, sárga ha kértünk parkolóhelyet de még nincs szabad hely, tehát várólistán vagyunk, és szürke ha aznap nincs helyünk és nem is kértünk. 

A napokat ki tudjuk választani, majd a kiválasztottakat az alulról feljövő lap segítségével kezelhetjük. Tudunk helyet foglalni, vagy felajánlani a helyünket; bárkinek, a leggyakrabban válaszottaknak, vagy egyéb konkrét embernek. A felhasználó jelezhet továbbá hetente egy napot, amelyen mindenképp szeretne helyet kapni.

Ez alatt **pillantásra látható** a mai és holnapi parkolóhelyünk állapota, valamint néhány pillantanyi adat a parkoló foglaltságáról. A mai parkolóhely kódjára nyomva feljön egy grafika, mely a parkoló bejáratától a megfelelő helyhez navigál minket, ezzel a szimplán számokkal jelzett parkolók megtalálása sokkal könnyebbé válik. A kezdőképernyő alján pedig megtalálható a "Beálltak a helyemre" gomb, melyre nyomva, majd az elkövető rendszámát beírva hasonlóan átnavigál az ő helyére, és jelenti az esetet, hogy rendszeresen ne forduljon elő.

### Mindezt összekötve
Az apphoz **backend**et is írtunk nestjs segítségével, mellyel bár az app végül időkorlátok miatt nem kommunikál, ez egy-két nap extra munkával könnyen implementálható lenne. A backend aktívan tanuló **machine learning** algoritmussal jósolja meg azt, hogy az alanyi jogon parkolóhellyel rendelkező dolgozók mekkora eséllyel mennek be másnap az irodába, és ha valószínűleg otthon maradnak, akkor még aznap kapnak egy értesítést, melyen keresztül könnyedén fel tudják ajánlani a másnapi helyüket. Az értesítés szövege tartalmazza a várólista hosszát is, mely az ember lelkiismeretét megérintvén jó motiváló erővel bír. A backend sok egyéb adatot és statisztikát is előállít, melyek a cég egyéb rendszereivel együttműködésbe hozva nagy haszonnal bírhatnak. 

A várólistáról foglalási sorrendben kapnak helyet az emberek, és a másnapi állapot frissüléséről értesítés útján tájékoztatjuk is a felhasználót. Természetesen aki elektromos autót használ, az a megfelelő helyre kerül beosztásra, a beteltség szerint megfelelően elosztva a helyeket.
