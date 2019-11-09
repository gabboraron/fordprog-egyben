# Fordító programok őszi félév
**Tartalom:**
- [Példakód](https://github.com/gabboraron/fordprog-egyben#példakód)
- [A nyelv definíciója](https://github.com/gabboraron/fordprog-egyben#a-nyelv-definíciója)
- [Lexikális elemző ~ 1. beadandó](https://github.com/gabboraron/fordprog-egyben#lexikális-elemző-1-beadandó)
  - [A lexikális elemző érdekesebb részei](https://github.com/gabboraron/fordprog-egyben#megoldás-érdekes-részei)
- [Szintaktikus elemző ~ 2. beadandó](https://github.com/gabboraron/fordprog-egyben#szintaktikus-elemző-2-beadandó)

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

## Lexikális elemző (1. beadandó)
**Feladat:**
> Lexikális hiba észlelése esetén hibajelzést kell adni, ami tartalmazza a hiba sorának számát; ezután a program befejeződhet, nem kell folytatni az elemzést.
> 
> a megoldáshoz szükséges egy `flex` és egy `C++` fájl

**Fájlok:** [saját megoldás](https://github.com/gabboraron/fordprog-egyben/tree/master/elso_beadando) illetve [múlt félévből](https://github.com/gabboraron/fordprog-beadando1) valamint a [hivatalos példaprogram](https://github.com/gabboraron/fordprog-egyben/blob/master/lexikalis-pelda%20(2).zip)

**Flex tutorial** [kifejtve futtatható példaprogramokkal itt](https://github.com/gabboraron/fordprog-1-flex)

**Teszteléshez** a [hivatalos tesztfájlok](https://github.com/gabboraron/fordprog-egyben/blob/master/plang-2019-tesztfajlok.zip)at érdemes lehet [kiegészíteni még pár fájllal](https://github.com/gabboraron/fordprog-egyben/commit/70970ef1c854e79de35469b18a769154fcd1c870)

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
> A makrók segítségével könnyen megadhatjuk a komplexebb konstrukciókat, pl: a [karakterek](https://github.com/gabboraron/fordprog-egyben#karakterek) formáit, vagy a whitespacek kezelését, illetve a [megjegyzéseket](https://github.com/gabboraron/fordprog-egyben#megjegyzések)
````
{DIGIT}+   		std::cout << "karakter(ek): " 		 << YYText()<< std::endl;
{WS}+    		  std::cout << "ureskarakter(ek): "  << YYText()<< std::endl;
"#"+.*+\n	 	  std::cout << "megjegyzes: "   	   << YYText()<< std::endl;
````
> ugyanígy megadhatjuk az [azonosítókat](https://github.com/gabboraron/fordprog-egyben#azonosítók) is
```
({CHAR}|{UNDERSCORE})+({CHAR}|{DIGIT}|{UNDERSCORE})*			std::cout << "azonosito: " << YYText() << std::endl;
```

## Szintaktikus elemző (2. beadandó)
**Feladat:**
> a programnak parancssori paraméterben lehessen megadni az elemzendő fájl nevét
>
> a program minden alkalmazott szabályhoz egy sort írjon a képernyőre, például
>
> a tesztfájlok közül a `lexikalis_hibas` és `szintaktikus_hibas` kiterjesztésű fájlokra kell hibát jelezni, a többit el kell fogadni.

**Fájlok:** [mintaprogram, amiből érdemes kiindulni](https://github.com/gabboraron/fordprog-egyben/blob/master/szintaktikus-pelda%20(1).zip), illetve [korábbi félév anyagai](https://github.com/gabboraron/fordprog-2-bisoncpp)
### Fordítás és futtatás
**Fordítás:** 
```
flex calculate.l
bisonc++ calculate.y
g++ -ocalculate calculate.cc parse.cc lex.yy.cc
```
**Futtatás:**
`./calculate example.calculate`
