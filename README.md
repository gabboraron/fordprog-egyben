# Fordító programok őszi félév
**Tartalom:**
- [Példakód](https://github.com/gabboraron/fordprog-egyben#példakód)
- [A nyelv definíciója](https://github.com/gabboraron/fordprog-egyben#a-nyelv-definíciója)
- [Lexikális elemző ~ 1. beadandó](https://github.com/gabboraron/fordprog-egyben#lexikális-elemző-1-beadandó)
  - [A lexikális elemző érdekesebb részei](https://github.com/gabboraron/fordprog-egyben#megoldás-érdekes-részei)
  - [regex összefoglaló](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#ezekhez-felhasználjuk-a-regexeket)
  - [csttabi féle youtube tutorial](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#csttabi-féle-youtube-tutorial)
- [Szintaktikus elemző ~ 2. beadandó](https://github.com/gabboraron/fordprog-egyben#szintaktikus-elemző-2-beadandó)
  - [gyakori hibaüzenetek](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#hibaüzenetek)
- [Szemantikus ellenörző ~ 3. beadandó](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#szemantikus-elemző-3beadandó)
  - [Tutorial](https://github.com/gabboraron/fordprog-egyben#tutorial): [1](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#1-lépés), [2](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#2-lépés), [3](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#3-lépés), [4](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#4-lépés), [5](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#5-lépés) 
  - [Összefoglalás](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#összefoglalás-a-szemantikus-ellenőrzésről)
- [Kódgenerálás ~ 4. beadandó](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#kódgenerálás)
- [Irodalom, jegyzetek, példák, előadás anyag, könyvek](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#irodalom)

---

## Példakód:
**Példaprogram:** 
````
# A legkisebb valodi oszto meghatarozasa.
PROGRAM oszto
VALTOZOK:
  EGESZ a
  EGESZ i
  EGESZ oszto
  LOGIKAI vanoszto
UTASITASOK:
  BE: a
  vanoszto := HAMIS
  i := 2
  CIKLUS AMIG NEM vanoszto ES i < a
    HA a % i = 0 AKKOR
      vanoszto := IGAZ
      oszto := i
    HA_VEGE
    i := i+1
  CIKLUS_VEGE
  HA vanoszto AKKOR
    KI: vanoszto
    KI: oszto
  KULONBEN
    KI: vanoszto
  HA_VEGE
PROGRAM_VEGE
````
Még több példa a [tesztfájlokban](https://github.com/gabboraron/fordprog-egyben/blob/master/plang-2019-tesztfajlok.zip)

## A nyelv definíciója
eredeti leírás és bővebben: https://deva.web.elte.hu/pubwiki/doku.php?id=fordprog:plang2019

a PLanG nyelvről bővebben: http://digitus.itk.ppke.hu/~flugi/bevprog_1415/plang.html

### Karakterek

A forrásfájlok a következő `ASCII` karaktereket tartalmazhatják:

- az angol abc kis és nagybetűi
- számjegyek (0-9)
- `():+-*/%<>=_#`
- szóköz, tab, sorvége
- megjegyzések belsejében pedig tetszőleges karakterek állhatnak
Minden más karakter esetén hibajelzést kell adnia a fordítónak. A nyelv case-sensitive, azaz számít a kis és nagybetűk közötti különbség.

### Kulcsszavak

A nyelv kulcsszavai a következők: `PROGRAM`, `PROGRAM_VEGE`, `VALTOZOK:`, `UTASITASOK:`, `EGESZ`, `LOGIKAI`, `IGAZ`, `HAMIS`, `ES`, `VAGY`, `NEM`, `SKIP`, `HA`, `AKKOR`, `KULONBEN`, `HA_VEGE`, `CIKLUS`, `AMIG`, `CIKLUS_VEGE`, `KI:`, `BE:`

### Azonosítók

A változók nevei, illetve a program neve kis- és nagybetűkből, _ jelből és számjegyekből állhatnak, de nem kezdődhetnek számjeggyel, és nem ütközhetnek egyik kulcsszóval sem.

### Típusok

- `EGESZ`: négy bájtos, előjel nélküli egészként kell megvalósítani; konstansai számjegyekből állnak, és nincs előttük előjel
- `LOGIKAI`: egy bájton kell ábrázolni, értékei: `HAMIS`, `IGAZ`

### Megjegyzések

A `#` karakteretől a sor végéig. Megjegyzések a program tetszőleges pontján előfordulhatnak, a fordítást és a keletkező programkódot nem befolyásolják.

### A program felépítése

A `PROGRAM` kulcsszóval kezdődik (amit egy tetszőleges azonosító, a program neve követ) és a `PROGRAM_VEGE` kulcsszóval fejeződik be. (Ezek előtt illetve után csak megjegyzések állhatnak.) A változódeklarációk a program elején találhatóak, és a `VALTOZOK:` szöveg vezeti be őket. A deklarációs rész opcionális, de ha a `VALTOZOK:` szöveg megjelenik, akkor legalább egy változót deklarálni kell. A deklarációk után a program utasításai következnek, ezt a részt az `UTASITASOK:` szöveg vezeti be, és legalább egy utasítást tartalmaznia kell.

### Változódeklarációk

Minden változót a típusának és nevének megadásával kell deklarálni, több azonos típusú változó esetén mindegyikhez külön ki kell írni a típust.

### Kifejezések

- `EGESZ` típusú kifejezések: számkonstansok, `EGESZ` típusú változók és az ezekből a `+` (összedás), `-` (kivonás), `*` (szorzás), `/`  (egészosztás), `%` (maradékképzés) infix operátorokkal és zárójelekkel a szokásos módon felépített kifejezések.
- `LOGIKAI` típusú kifejezések: az `IGAZ` és `HAMIS` literálok, `LOGIKAI` típusú változók, két `EGESZ` típusú kifejezésből az `=` (egyenlőség), `<` (kisebb), `>` (nagyobb), `<=` (kisebbegyenlő), `>=` (nagyobbegyenlő) infix operátorokkal előállított, valamint az ezekből `ES` (konjunkció), `VAGY` (diszjunkció), `=` (egyenlőség) infix és a `NEM` (negáció) **prefix** operátorral és zárójelekkel a szokásos módon felépített kifejezések.
- Az infix operátorok mind balasszociatívak és a precedenciájuk növevő sorrendben a következő:
  - `VAGY`
  - `ES`
  - `=`
  - `< > <= >=`
  - `+ -`
  - `* / %`

### Utasítások

- `SKIP` utasítás: a változók értékeinek megváltoztatása nélküli továbblépés.
- Értékadás: az `:=` operátorral. Baloldalán egy változó, jobboldalán egy - a változóéval megegyező típusú - kifejezés állhat.
- Olvasás: A `BE:` utasítás a megadott változóba olvas be egy megfelelő típusú értéket a standard bementeről. (Megvalósítása: meg kell hívni a be eljárást, amit a negyedik beadandó kiírásához mellékelt C fájl tartalmaz. A beolvasott érték `EGESZ` típus esetén az eax, `LOGIKAI` típus esetén az al regiszterben lesz.)
- Írás: A `KI:` utasítás a megadott kifejezés értékét a standard kimenetre írja (és egy sortöréssel fejezi be). (Megvalósítása: meg kell hívni a `ki_egesz` (vagy a `ki_logikai`) eljárást, amit a 4. beadandó leírásához mellékelt C fájl tartalmaz. Paraméterként a kiírandó értéket (mindkét esetben 4 bájtot) kell a verembe tenni.)
- Ciklus: `CIKLUS AMIG feltétel utasítások CIKLUS_VEGE` alakú. A feltétel logikai kifejezés. A ciklus utasításlistája nem lehet üres. A megszokott módon, elöltesztelős ciklusként működik.
- Elágazás: `HA feltétel AKKOR utasítások HA_VEGE` vagy `HA feltétel AKKOR utasítások` `KULONBEN utasitasok HA_VEGE` alakú. A feltétel logikai kifejezés. Az egyes ágak utasításlistái nem lehetnek üresek. A megszokott módon működik.

---

## Lexikális elemző (1. beadandó)
**Feladat:**
> Lexikális hiba észlelése esetén hibajelzést kell adni, ami tartalmazza a hiba sorának számát; ezután a program befejeződhet, nem kell folytatni az elemzést.
> 
> a megoldáshoz szükséges egy `flex` és egy `C++` fájl

**Fájlok:** [saját megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/elso_beadando) illetve [múlt félévből](https://github.com/gabboraron/fordprog-beadando1) valamint a [hivatalos példaprogram](https://github.com/gabboraron/fordprog-egyben/blob/master/lexikalis-pelda%20(2).zip), [hivatalos, tanári megoldás](https://github.com/gabboraron/fordprog-egyben/blob/master/1-lexikalis%20(1).zip), [régebbi WHILE feladatra adott megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/1-lexikalis)

**Flex tutorial** [kifejtve futtatható példaprogramokkal itt](https://github.com/gabboraron/fordprog-1-flex)

**Teszteléshez** a [hivatalos tesztfájlok](https://github.com/gabboraron/fordprog-egyben/blob/master/plang-2019-tesztfajlok.zip)at érdemes lehet [kiegészíteni még pár fájllal](https://github.com/gabboraron/fordprog-egyben/commit/70970ef1c854e79de35469b18a769154fcd1c870)
### Fordítás és futtatás
- futtassuk: `flex flex1.l`
- keletkezik egy `lex.yy.cc` fájl benne `C++` kóddal
- fordítsuk: `g++ -o flex1 lex.yy.cc`
- a fordítás eredménye `flex1` futtatható állomány
- futtassuk paraméterezve `input.txt`:ekkor az `input.txt` tartalma jelenik meg standar kimeneten

### Megoldás érdekes részei:
Ezekhez a formákhoz igen hasznosak a [Flex regexei](https://github.com/gabboraron/fordprog-1-flex#flex-regex). 
> A legegyszerűbb, legelemibb elemeket megadjuk [makrónak](https://github.com/gabboraron/fordprog-1-flex#flex)
````
DIGIT		    [0-9]
WS  			  [ \t\n]
CHAR  			[a-zA-Z]
UNDERSCORE	"_"
````
> A [kulcsszavakat](https://github.com/gabboraron/fordprog-egyben#kulcsszavak), [kifejezéseket](https://github.com/gabboraron/fordprog-egyben#kifejezések), [típusokat](https://github.com/gabboraron/fordprog-egyben#típusok) stb, egyéb a nyelvben konkrétan szereplő szavakat lekezeljük az alábbi módon:
````
PROGRAM_VEGE      std::cout << "kulcsszo: PROGRAM_VEGE" << std::endl;
VALTOZOK:         std::cout << "kulcsszo: VALTOZOK:"	<< std::endl;
UTASITASOK:       std::cout << "kulcsszo: UTASITASOK:" 	<< std::endl;
````
> Reguláris kifejezésekkel megadhatjuk a komplexebb konstrukciókat, pl: a [karakterek](https://github.com/gabboraron/fordprog-egyben#karakterek) formáit, vagy a whitespacek kezelését, illetve a [megjegyzéseket](https://github.com/gabboraron/fordprog-egyben#megjegyzések)
````
{DIGIT}+   		std::cout << "karakter(ek): " 		 << YYText()<< std::endl;
{WS}+    		  std::cout << "ureskarakter(ek): "  << YYText()<< std::endl;
"#"+.*+\n	 	  std::cout << "megjegyzes: "   	   << YYText()<< std::endl;
````
> ugyanígy megadhatjuk az [azonosítókat](https://github.com/gabboraron/fordprog-egyben#azonosítók) is
```
({CHAR}|{UNDERSCORE})+({CHAR}|{DIGIT}|{UNDERSCORE})*			std::cout << "azonosito: " << YYText() << std::endl;
```

### Ezekhez felhasználjuk a regexeket.
>
> Regexekről bővebben: [részletes regex](https://github.com/gabboraron/fordprog-1-flex#flex-regex)
> 
> _**Fontosabb regexek:**_
>
> **`\`   - escape operátor**
>
> `.`     - bármi kivéve új sor
>
> `[abc]` - bármiylen karakter ezek között, megfelel ennek: `[a-c]`
>
> `(r)`   - `r`re illeszkedik a precedencia felülírásával
>
> `a?`    - 0 vagy 1 `a`
>
> `a+`    - 1 vagy több `a`
>
> `a*`    - 0 vagy több `a`
>
> `^a`    - `a` karakter a sor **elején**
> 
> `a$`    - `a` karkater a sor **végén**
> 
> `a/b`    - `a` de csak ha `b` követi


### csttabi féle Youtube tutorial
#### Fordítóprogramok flex lexikális elemzés 01 - csttabi
<a href="http://www.youtube.com/watch?feature=player_embedded&v=6xn36w6x0kg
" target="_blank"><img src="http://img.youtube.com/vi/6xn36w6x0kg/0.jpg" 
alt=" Fordítóprogramok flex lexikális elemzés 01 - csttabi" width="300" height="150" border="10" /></a>

#### Fordítóprogramok flex lexikális elemzés 02 - csttabi
<a href="http://www.youtube.com/watch?feature=player_embedded&v=xB-Xj520OEs
" target="_blank"><img src="http://img.youtube.com/vi/xB-Xj520OEs/0.jpg" 
alt=" Fordítóprogramok flex lexikális elemzés 02 - csttabi" width="300" height="150" border="10" /></a>

#### Fordítóprogramok flex lexikális elemzés 03 - csttabi
<a href="http://www.youtube.com/watch?feature=player_embedded&v=B1I7C8INTCA
" target="_blank"><img src="http://img.youtube.com/vi/B1I7C8INTCA/0.jpg" 
alt=" Fordítóprogramok flex lexikális elemzés 03 - csttabi" width="300" height="150" border="10" /></a>

#### Fordítóprogramok flex lexikális elemzés 04 - csttabi
<a href="http://www.youtube.com/watch?feature=player_embedded&v=PuHJY9JQCyk
" target="_blank"><img src="http://img.youtube.com/vi/PuHJY9JQCyk/0.jpg" 
alt=" Fordítóprogramok flex lexikális elemzés 04 - csttabi" width="300" height="150" border="10" /></a>

#### Fordítóprogramok flex lexikális elemzés 05 - csttabi
<a href="http://www.youtube.com/watch?feature=player_embedded&v=AVuIyG6peNQ
" target="_blank"><img src="http://img.youtube.com/vi/AVuIyG6peNQ/0.jpg" 
alt=" Fordítóprogramok flex lexikális elemzés 05 - csttabi" width="300" height="150" border="10" /></a>

#### Fordítóprogramok flex lexikális elemzés 06 - csttabi
<a href="http://www.youtube.com/watch?feature=player_embedded&v=i5xEkDzoe6g
" target="_blank"><img src="http://img.youtube.com/vi/i5xEkDzoe6g/0.jpg" 
alt=" Fordítóprogramok flex lexikális elemzés 06 - csttabi" width="300" height="150" border="10" /></a>

#### Fordítóprogramok flex lexikális elemzés 07 - csttabi
<a href="http://www.youtube.com/watch?feature=player_embedded&v=uhrSQyY2hX8
" target="_blank"><img src="http://img.youtube.com/vi/uhrSQyY2hX8/0.jpg" 
alt=" Fordítóprogramok flex lexikális elemzés 07 - csttabi" width="300" height="150" border="10" /></a>

---

## Szintaktikus elemző (2. beadandó)
**Feladat:**
> a programnak parancssori paraméterben lehessen megadni az elemzendő fájl nevét
>
> a program minden alkalmazott szabályhoz egy sort írjon a képernyőre, például
>
> a tesztfájlok közül a `lexikalis_hibas` és `szintaktikus_hibas` kiterjesztésű fájlokra kell hibát jelezni, a többit el kell fogadni.


a PLanG nyelv összes szükséges szabályátirata: http://digitus.itk.ppke.hu/~flugi/bevprog_1415/atiras.html

**Fájlok:** [saját megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/szintaktikus-pelda-ver2), [mintaprogram, amiből érdemes kiindulni](https://github.com/gabboraron/fordprog-egyben/blob/master/szintaktikus-pelda%20(1).zip), [hivatalos tanári megoldás](https://github.com/gabboraron/fordprog-egyben/blob/master/2-szintaktikus.zip), illetve [korábbi félév anyagai](https://github.com/gabboraron/fordprog-2-bisoncpp), [régebbi WHILE feladatra adott megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/2-szintaktikus)
### Fordítás és futtatás
**Fordítás:** 
```
flex calculate.l
bisonc++ calculate.y
g++ -ocalculate calculate.cc parse.cc lex.yy.cc
```
**Futtatás:**
`./calculate example.calculate`

### Hibaüzenetek
[Gyakori hibaüzenetek kifejtése korábbról](https://github.com/gabboraron/fordprog-2-bisoncpp#hibaüzenetek-errorok)

#### `yyparse/yylex/yyerror was not declared in this scope`
> az `y` fájlban figyeljünk a `%` lezárásokra [stackowerflow](https://stackoverflow.com/questions/38143828/yyparse-yylex-yyerror-was-not-declared-in-this-scope-flex-bison)

#### `warning, rule cannot be matched`
> van korábban illeszkedő minta a mintánkra az **`l` fájlban** , pl: *kulcsszavak* előtt *változónév*, sorrendmegfordítás megoldja. [Bővebben kifejtve](https://github.com/gabboraron/fordprog-2-bisoncpp#warning-rule-cannot-be-matched)

#### `Shift/Reduce Conflicts` ~ léptetés-redukálás konfliktus
> korábban illeszkedő minta a szabályok között az **`y` fájlban**. [Bővebben kifejtve](https://github.com/gabboraron/fordprog-2-bisoncpp#shiftreduce-conflicts)

#### `Reduce/Reduce Conflicts` ~ redukálás-redukálás konfliktus
> Többféle úton jut el ugyanahhoz a *terminális*hoz, [bővebben kifejtve](https://github.com/gabboraron/fordprog-2-bisoncpp#reducereduce-conflicts)

### `error: ‘d_scanner’ was not declared in this scope return d_scanner.lex();`
> még nem jöttem rá


> Továbbá érdemes odafigyelni, hogy a megfelelő [megfelelő header fájlokat használjuk](https://github.com/gabboraron/fordprog-egyben/blob/master/szintaktikus-pelda-ver2/Parser.h).

---

## Szemantikus elemző (3.beadandó)
**Feladat:**
> A kód szemantikai ellenőrzése

**Fájlok:** [példakód](https://github.com/gabboraron/fordprog-egyben/blob/master/szemantikus-pelda.zip), [régebbi WHILE feldatra adott megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/3-szemantikus), [előző félév anyaga](https://github.com/gabboraron/fordprog-osszefoglalo#3---szemantikus), [mintamegoldás](https://github.com/gabboraron/fordprog-egyben/blob/master/3-szemantikus.zip), [saját megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/szemantikus-ellenorzo)

### Tutorial:
forrás: [deva.web.elte.hu/szemantikus.hu.html](http://deva.web.elte.hu/szemantikus.hu.html)
eredeti tutorial fájlok és teszteseteik: [tutorial](https://github.com/gabboraron/fordprog-egyben/commit/c4015e3a14d0a38ff07b659307377892d982bb53) 

#### 1. lépés

Ebben a tananyagban egy olyan nyelvet fogunk használni, amelynek alapelemei a nemnegatív egész számok, a logikai literálok és változók. A változókat a program elején kell deklarálni. A deklarációk után értékadások sorozata következik. Ezek bal oldalán egy változó, jobb oldalán egy változó vagy egy literál szerepel. Egy példaprogram:

````
natural n
natural m
boolean b
n := 0
b := true
m := n
````

- Töltsd le a nyelv [lexikális és szintaktikus elemzőjét](https://github.com/gabboraron/fordprog-egyben/tree/master/assign1) valamint a [tesztfájlokat](https://github.com/gabboraron/fordprog-egyben/tree/master/assign1/peldak)!
- Nézd át a flex forrást ([assign.l](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/assign.l)) és a bisonc++ forrást ([assign.y](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/assign.y))!
- A [Parser.h](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/Parser.h) és [Parser.ih](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/Parser.ih) fejállományokat a bisonc++ generálta az első futtatásakor, de ezekbe beleírhatunk.
- A [Parser.h](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/Parser.h) fejállományba felvettük a lexikális elemzőt adattagként, és hozzáadtunk egy konstruktort, ami inicializálja azt.
- A [Parser.ih](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/Parser.ih) implementációs fejállományban implementáltuk a lex függvényt, ami továbbítja lexikális elemző által felismert tokeneket a szintaktikus elemzőnek, és beállítja a szintaktikus elemző `d_loc__` mezőjét arra pozícióra, ahol az elemzés éppen tart a forrásszövegben! Ugyanebben a forrásfájlban a hibakezelést végző `error` függvényt is módosítottuk.
- Fordítsd le a projektet a `make` paranccsal (vagy "kézzel", a flex, bisonc++ és g++ segítségével)!
- Futtasd a programot a helyes, a [lexikális hibás](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/peldak/2.lex-hibas) és a [szintaktikus hibás](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/peldak/3.szintaktikus-hibas) példákra!
- Figyeld meg, hogy a program nem jelez hibát a [szemantikus hibás](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/peldak/4.szemantikus-hibas) példákra! Ennek a feladatsornak az a célja, hogy kiszűrjük ezeket a hibákat.

#### 2. lépés

Szimbólumtáblát szeretnénk létrehozni. Az egyszerűség kedvéért ezt a C++ standard könyvtárának `map` adattípusával fogjuk megvalósítani. A map kulcsa a változó neve (`string`) lesz, a hozzárendelt érték pedig tartalmazni fogja a változó típusát és a deklarációjának sorát. A szükséges C++ kódot egy új fejállományba, a [semantics.h]() fájlba írjuk.

- A [semantics.h](https://github.com/gabboraron/fordprog-egyben/commit/c5f8c306f3a443d8826dbf9505335e732c9ccfcf#diff-4372faf2015e5853c06e90c1b95d6c33) fájlban include-old az `iostream`, `string` és `map` standard fejállományokat!
- Hozz létre ugyanitt egy felsorolási típust a programnyelvben előforduló két típus reprezentálásához!
  `enum type { natural, boolean };`
- Készíts egy `var_data` nevű rekord típust, amit az egyes változókhoz hozzárendelt adatok tárolására fogunk használni. Két mezője legyen:
  - `decl_row` azt fogja tárolni, hogy az adott változó a program hányadik sorában volt deklarálva.
  - `var_type` a változó típusát tárolja. Ez a mező az imént definiált type típusú legyen!
- Írj a `var_data` rekordhoz egy két paraméteres konstruktort is, hogy könnyen lehessen inicializálni az ilyen típusú objektumokat létrehozásukkor. Legyen továbbá egy nulla paraméteres (üres törzsű) konstruktor is, mert erre majd szükség lesz akkor, amikor ilyen típusú elemeket akarunk egy `map`-ben tárolni!
- A *[Parser.h](https://github.com/gabboraron/fordprog-egyben/commit/c5f8c306f3a443d8826dbf9505335e732c9ccfcf#diff-225c1abddd1957a6be382bcc2a7df431)* fejállományban add hozzá a Parser osztály privát adattagjai közé a szimbólumtáblát:
  `std::map<std::string,var_data> szimbolumtabla;`
- Az *[assign.y](https://github.com/gabboraron/fordprog-egyben/commit/c5f8c306f3a443d8826dbf9505335e732c9ccfcf#diff-8fc56131b7aa5e0826468f24b4798841)* fájl elején cseréld le a `%baseclass-preinclude` direktívában az `<iostream>` fejállományt `"semantics.h"`-ra, hogy az imént készített fejállomány része legyen a projektnek!
Próbáld lefordítani a projektet, és javítsd az esetleges hibákat!

#### 3. lépés

Az [assign.y](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/assign.y) fájlban a deklarációk szintaxisát leíró szabályhoz szeretnénk majd egy olyan akciót írni, ami az adott változót beszúrja az adataival együtt a szimbólumtáblába. Ehhez a következőkre van szükség:
- A deklaráció sorának száma: ez a `d_loc__.first_line` érték lesz, amit a `lex` függvény állít be. ([Lásd az 1. lépést!](https://github.com/gabboraron/fordprog-egyben/blob/master/README.md#1-lépés))
- A változó típusa: ez onnan derül ki, hogy éppen melyik szabály-alternatíva az aktív (`NATURAL IDENT` vagy `BOOLEAN IDENT`).
- A változó neve: ezt csak a lexikális elemző tudja! El kell érnünk, hogy ez továbbításra kerüljön a szintaktikus elemzőhöz.
A bisonc++ megengedi, hogy tetszőleges (terminális vagy nemterminális) szimbólum mellé egy ún. szemantikus értéket (lásd az előadás anyagában: [attribútum](http://deva.web.elte.hu/fordprog/11-ATG-handout.pdf)) rendeljünk. Mivel különböző szimbólumokhoz különböző típusú szemantikus érték rendelhető, ezért létre kell hoznunk egy unió típust ezekhez. Erre a bisonc++ külön szintaxist biztosít, amiből majd egy valódi C++ unió típust fog generálni. Ennek most egyetlen sora lesz, hiszen kezdetben csak a változókhoz szeretnénk szemantikus információként hozzárendelni a nevüket.
- Az assign.y fájlhoz az első `%token` deklaráció elé add hozzá a következőt:
```
%union
{
  std::string *szoveg;
}
```
- Ennek az uniónak a mezőneveit használhatjuk arra, hogy meghatározzuk az egyes szimbólumokhoz rendelt szemantikus értékek típusát. Egészítsd ki az azonosító tokent így: `%token <szoveg> IDENT;`
- Az azonosító tokeneknek most már lehet szemantikus értéke (string), de ezt be is kell állítanunk valahol. A terminálisok szemantikus értékét a lex függvény tudja beállítani. (Lásd az előadás anyagában: *kitüntetett szintetizált attribútum*.) Egészítsd ki a [lex függvényt (még a return előtt)](https://github.com/gabboraron/fordprog-egyben/commit/9199980f1e9a4339f950055f7d740ad699dae8a6#diff-682b9c0994e5c0cdfc7c9aa502ae653e) a következő sorokkal:
```
if( ret == IDENT )
{
  d_val__.szoveg = new std::string(lexer.YYText());
}
```
*(Az `YYText()` függvénnyel lehet elkérni a flex-től a felismert token szövegét. Ebből létrehozunk egy `string`-et. A Parser osztály `d_val__` adattagja olyan unió típusú, amit az imént az assign.y fájlba írtunk. Ennek a szoveg mezőjébe írhatjuk a szöveget.)*

Most már elérjük az [assign.y](https://github.com/gabboraron/fordprog-egyben/commit/9199980f1e9a4339f950055f7d740ad699dae8a6#diff-8fc56131b7aa5e0826468f24b4798841) fájlban a szabályok mögé írható akciók belsejében az azonosítókhoz tartozó szövegeket. Az `a: A B C` szabály esetén az `A` szimbólum szemantikus értékére `$1`, a `B` szimbóluméra `$2`, a `C` szimbóluméra `$3` hivatkozik. Ezek típusának megállapításához meg kell néznünk, hogy az unió típusnak melyik mezőjét rendeltük hozzá az adott szimbólumhoz. Ennek a mezőnek a típusa lesz a szemantikus érték típusa. (Esetünkben `string*`.)
- A deklarációkra vonatkozó szabályalternatívákat egészítsd ki úgy, hogy kiírják a standard kimenetre az éppen deklarált változó nevét!
```
NATURAL IDENT
{
  std::cout << *$2 << std::endl;
}
```
- Futtasd a helyes példára a programot!

#### 4. lépés

Ahelyett, hogy a standard kimenetre írnánk a deklarált változók nevét, most betesszük az adataikat a szimbólumtáblába. A `map` adattípusnak van `[]` operátora, ennek segítségével lehet beállítani és lekérdezni az adott kulcshoz tartozó értéket.
- Írd át a [deklarációkhoz tartozó szabályalternatívák programját](https://github.com/gabboraron/fordprog-egyben/commit/3bae4cd96415afc6442f47598f50609e11c160bd#diff-8fc56131b7aa5e0826468f24b4798841) úgy, hogy a változót és adatait szúrja be a szimbólumtáblába!

```
NATURAL IDENT
{
  szimbolumtabla[*$2] = var_data( d_loc__.first_line, natural );
}
```

- Ellenőrizzük le a beszúrás előtt, hogy nem volt-e már ugyanezzel a névvel korábban deklaráció! A map adattípus `count` függvénye megadja, hogy egy adott kulcshoz hány elem van a map-ben (`0` vagy `1`).

```
  if( szimbolumtabla.count(*$2) > 0 )
  {
    std::stringstream ss;
    ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
    << "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
    error( ss.str().c_str() );
  }
  ```

A hibaüzenet szövegének összegyűjtéséhez és a korábbi deklaráció sorának szöveggé konvertálásához a `stringstream` osztályt használtuk. Ehhez be kell `include`-olni a [semantics.h](https://github.com/gabboraron/fordprog-egyben/commit/3bae4cd96415afc6442f47598f50609e11c160bd#diff-4372faf2015e5853c06e90c1b95d6c33) fájlba a `sstream` standard fejállományt!
A `stringstream` típusú `ss`-ből a `str()` tagfüggvénnyel lehet lekérni a benne összegyűlt `string`-et. Mivel az `error` függvény (lásd a [Parser.ih](https://github.com/gabboraron/fordprog-egyben/blob/master/assign1/Parser.ih)-ban!) string helyett `C` stílusú karakterláncot vár paraméterként, ezért a `c_str()` függvény segítségével konvertálunk.
- Töltsd ki hasonlóan a logikai változók deklarációjához tartozó szabályalternatívát is, de ott a szimbólumtáblába logikai változót szúrj be!
- A programnak most már a 4.szemantikus-hibas fájlra hibát kell jeleznie.

#### 5. lépés

Azt is szeretnénk ellenőrizni, hogy az értékadásokban használt változók deklarálva vannak-e.
- Egészítsd ki az értékadásokat és a kifejezéseket leíró szabályoknak az `IDENT`-et tartalmazó alternatíváit úgy, hogy hibaüzenetet kapjunk nem deklarált változók esetén!
- Ellenőrizd, hogy az 5. és 6. szemantikus hibás tesztfájlra valóban hibaüzenetet ad-e a fordító!

Az értékadások típushelyességének ellenőrzéséhez szükséges, hogy szemantikus értéket adjunk a kifejezésekhez. A konkrét esetben ez lehet a korábban definiált type felsorolási típusú érték. A kifejezéseket leíró szabályokban be fogjuk állítani a kifejezés szemantikus értékét (a kifejezés típusát) a szabály jobboldala alapján (lásd az előadás anyagában: szintetizált attribútum). A szabály baloldalának szemantikus értékére a `$$` jelöléssel hivatkozhatunk az akciókban. Ha nemterminálisokhoz szeretnénk szemantikus értéket hozzárendelni, akkor ezt is fel kell tüntetni a fájl elején. Mivel ez már nem token, ezért a `%type <unió_megfelelő_mezője> nemterminális_neve` szintaxist kell használni.

- Egészítsd ki az [assign.y](https://github.com/gabboraron/fordprog-egyben/commit/322c7e6baa648aa0ac13b8b69735d65b2c7becba) fájlban korábban definiált uniót egy `type*` típusú mezővel, és tüntesd fel az `expr` nemterminálishoz rendelt szemantikus érték típusát az unióban létrehozott új mezőnév segítségével!
- Egészítsd ki a kifejezéseket leíró négy szabályalternatíva akcióit olyan utasításokkal, amelyek beállítják a szabály baloldalának szemantikus értékét (a kifejezés típusát)!
Például az `IDENT` alternatíva esetén a szimbólumtáblából kérhetjük le az azonosító típusát:

`$$ = new type(szimbolumtabla[*$1].var_type);`
A `TRUE` alternatíva még egyszerűbb:
`$$ = new type(boolean);`
Használd fel az `expr` nemterminálisokhoz most beállított szemantikus értékeket az értékadásra vonatkozó szabályban: ellenőrizd, hogy az értékadás két oldala azonos típusú-e!
```
if( szimbolumtabla[*$1].var_type != *$3 )
{
  error( "Tipushibas ertekadas.\n" );
}
```
- Most már valamennyi szemantikus hibás példára hibát kell jeleznie a programnak.
- Az `IDENT` és `expr` szimbólumok szemantikus értékeit minden esetben (a lex függvényben és a szabályokhoz csatolt akciókban is) a new kulcsszó segítségével, dinamikus memóriafoglalással hoztuk létre. Azokban az akciókban, ahol ezek a szimbólumok a szabály jobb oldalán állnak, felhasználtuk az értékeket. A program memóriahatékonyságának érdekében azonban a felhasználás után fel kell szabadítani a lefoglalt memóriát, hogy elkerüljük a memóriaszivárgást. Nézd végig az összes szabályt, és ahol a jobb oldalon `IDENT` vagy `expr` áll, ott az akció végére írd be a következő utasítást: `delete $i` (ahol `i` az `IDENT` vagy `expr` sorszáma).

### Összefoglalás a szemantikus ellenőrzésről
#### I.
A [lexikális](https://github.com/gabboraron/fordprog-egyben#lexik%C3%A1lis-elemz%C5%91-1-beadand%C3%B3) elemző és [szintaktikus](https://github.com/gabboraron/fordprog-egyben#szintaktikus-elemző-2-beadandó) ellenörző nélkül nem működőképes rendszer, így előbb annak kell működnie.
#### II.
- A [`Parser.h`ban egy `map` formájá](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/Parser.h#L33)ban létrehozzuk a szimbólumtáblát.
- A `semantics.h`ban [meghatározzuk a használt típusokat egy `enum`ban](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/semantics.h#L9) ezt követően, meghatározzuk a használt [kifejezésmintákat és azok típusait, meghatározásait `struct`okban](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/semantics.h#L12).
  - itt mindig meg kell adni [a sor számát *(`decl_row`)*](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/semantics.h#L14), ami `int`.
  - és meg kell adjuk az adott [kifejezés típusát is *(`var_type`)*](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/semantics.h#L15)
#### III.
- Először biztosítanunk kell, hogy lássuk a [yacc fájl](https://github.com/gabboraron/fordprog-egyben/blob/master/szemantikus-ellenorzo/calculate.y)ban ezeket, így [egy `union`ként meghatározzuk az előbb megadott mintákat](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/calculate.y#L4), majd azokat később [a kifejezésekhez társítjuk, még a program legeljén](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/calculate.y#L51)
- fontos, hogy a sorokat olvasó, [Parser.ih-ban](https://github.com/gabboraron/fordprog-egyben/blob/master/szemantikus-ellenorzo/Parser.ih) található [`lex` függvény](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/Parser.ih#L16)ünk [visszadja nekünk a sorok tartalmát, méghozzá feldarabolva](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/Parser.ih#L22): `d_val__.szoveg = new std::string(lexer.YYText());`
- ezután már tudunk a [darabokra egyenként hivatkozni és azokat lekezelhetjük](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/calculate.y#L217), azaz, ha a kapott forma `A B C D` akkor hivatkoznk rá `$1 $2 $3 $4` formában, illetve mostmár leérhető a `d_loc__.first_line` is, amivel visszadhatjuk a sort amit épp vizsgálunk
#### IV.
Mindez mit sem ér ha nem tesszük be az egészet a szimbolóumtáblába, például így: [`szimbolumtabla [*$`*`i`*`] = var_data(d_loc__.first_line, `*`típus`*`)` ](https://github.com/gabboraron/fordprog-egyben/blob/7a916e56da6124014c2f22e3b0f83f7f9b5589a8/szemantikus-ellenorzo/calculate.y#L128)
#### V.
Ezek után a típusok helyességét kell ellenőriznünk, hogy megfelelően van-e megadva pl egy matematikai művelet és nem pl egy logikai értékhez szeretnénk hozzáadni valamit. A szabályok baloldalának szemantikai értékét a `$$`al érjük el, a nemterminálist (kifejezés, stb) az `union`on keresztül érjük el, ahogy azt fent megadtuk.

## Kódgenerálás

**Fájlok:**[régebbi WHILE feladatra adott megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/4-kodgen), [előző félév anyaga](https://github.com/gabboraron/fordprog-osszefoglalo#4---kódgenerátor), [mintaprogram, amiből érdemes kiindulni](https://github.com/gabboraron/fordprog-egyben/blob/master/kodgen-pelda.zip)

## Irodalom
- [Előadás anyaga eredeti](https://deva.web.elte.hu/pubwiki/doku.php?id=fporak)
- [Előadás anyag itt](https://github.com/gabboraron/fordprog-egyben/tree/master/ea)
- [Fordítóprogramok és formális nyelvek - Király Roland 2007](https://github.com/gabboraron/books/blob/master/Ford%C3%ADt%C3%B3programok.%20%C3%A9s%20form%C3%A1lis%20nyelvek.pdf)
- [Assembly programozás - Kitlei Róbert 2007](https://github.com/gabboraron/books/blob/master/Kitlei_Robert-Assembly_prgramozas.pdf)
- [egybefűzve az előadás, a tesztkérdések és gyakorlófeladatok](https://github.com/gabboraron/fordprog-egyben/blob/master/ea/fordprog_egybefuzve.pdf)
- [feladatmegoldások ~ Nagy Krisztián](https://github.com/gabboraron/fordprog-egyben/blob/master/ea/fordprog_gy_zh1.pdf)

### XXI. századi fordító programok (YOUTUBE)
<a href="http://www.youtube.com/watch?feature=player_embedded&v=fbG2P1jCALU
" target="_blank"><img src="http://img.youtube.com/vi/fbG2P1jCALU/0.jpg" 
alt="KMP" width="300" height="150" border="10" /></a>


