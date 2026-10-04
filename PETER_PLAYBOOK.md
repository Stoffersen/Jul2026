# Peter Playbook

> Genbrugelig arbejds- og produktplaybook, skabt under **Jul i den gamle Humlehave / Jul2026**.
>
> Når et nyt projekt starter, kan Peter referere til denne fil og bede om at bruge "Peter Playbook".

## 1. Arbejdsform

- Start hurtigt med en fungerende prototype. Vent ikke på en perfekt kravspecifikation.
- Arbejd autonomt videre, når retningen er tydelig. Stop kun når der mangler en reel beslutning, adgang eller information fra Peter.
- Vis fremdrift i små, stabile leverancer frem for store risikable omskrivninger.
- Efter hver meningsfuld kodeændring: commit, deploy og verificer at build/deployment er grøn.
- Sig aldrig at noget er live, før deployment faktisk er kontrolleret.
- Bevar fungerende flows. Forbedr dem lagvist: funktion -> data -> sikkerhed -> UX -> mobil -> polish.
- Når et værktøj blokerer en stor ændring, del den op i mindre commits i stedet for at presse igennem.
- Foretræk konkrete resultater frem for projektstyringssprog.

## 2. Produktprincipper

- Appen skal føles som et produkt, ikke som et administrationssystem.
- Design først til mobil, men lad desktop fungere naturligt.
- Hold brugerens vigtigste handlinger tæt på tommelfingeren og med gode trykflader.
- Brug varme, menneskelige tekster frem for tekniske labels.
- Skjul kompleksitet. Vis kun det brugeren har brug for i øjeblikket.
- Gør tomme tilstande nyttige og forklarende.
- Brug progress/status med måde; det må ikke skabe unødigt pres.
- Bevar personlighed og små overraskelser, når det passer til produktet.
- Nye features skal have en tydelig grund. Når kerneoplevelsen er stærk, prioriter polish frem for feature-bloat.

## 3. Standard teknisk retning

Udgangspunktet er ikke et krav, men fungerede godt i Jul2026:

- React + TypeScript + Vite til en let webapp.
- GitHub som versionsstyring.
- GitHub Actions til automatisk build/deploy.
- GitHub Pages til enkle statiske/PWA-projekter.
- Supabase til login, database, Row Level Security og serverfunktioner/RPC, når projektet kræver fælles data.
- PWA når appen skal føles installerbar på iPhone/Android uden app-store-friktion.
- Hold browserens public/publishable credentials adskilt fra egentlige secrets. Commit aldrig service-role keys, passwords eller private nøgler.

## 4. Data og sikkerhed

- Design adgangskontrol i databasen, ikke kun i UI'et.
- Brug RLS til brugerdata og private data.
- Antag at klientkode kan læses og manipuleres.
- Konkurrence-/quizlogik, hemmelige svar, autoritative tider og lignende bør ligge server-side, hvis fairness betyder noget.
- Serveren bør være autoritativ for handlinger, der ikke må kunne snydes med fra browseren.
- Test privacy-flows eksplicit: "Hvad kan bruger A se om bruger B?"
- Demo/testtilstand må ikke utilsigtet skrive til eller læse private produktionsdata.
- Bed ikke brugeren om database-password/service-role credentials, hvis en public browser key og korrekt RLS er nok.

## 5. UX-læringer fra Jul2026

- En sikker test/demo-knap er værdifuld, når login ellers gør iteration besværlig.
- Testtilstand skal være tydeligt markeret.
- Delte data og private data skal være visuelt adskilt, ikke kun teknisk adskilt.
- En generisk checklist er ofte mindre god end en specialiseret visning. Eksempel: juleaften blev bedre som en rolig tidslinje end som endnu en liste.
- Samtidig er en simpel fri liste god som supplement, når brugeren selv skal kunne tilføje ting.
- Vis information dér hvor beslutningen tages. Eksempel: modtagerens ønskeliste vises direkte ved den private gaveplan.
- Små skærme kræver særskilt polish: safe-area, bundnavigation, touch targets, billedhøjde og kompakte grids.
- Respekter prefers-reduced-motion.
- Service workers skal versionsstyres og rydde gammel cache, ellers kan installerede PWA'er se forældede ud.
- Store billeder bør optimeres før de lægges i en PWA.

## 6. Deployment-disciplin

For hver ændring:

1. Hent den aktuelle fil/version før redigering.
2. Lav en lille, fokuseret ændring.
3. Commit med en beskrivende commit message.
4. Vent på CI/deployment.
5. Kontrollér status/resultat.
6. Fortsæt først derefter med næste risikable ændring.

Hvis build fejler:
- Find den konkrete fejl.
- Ret mindst muligt.
- Deploy igen.
- Bekræft success før der kommunikeres "færdig".

## 7. Samarbejdsstil med Peter

- Dansk som standardsprog.
- Kort, konkret og fremadrettet kommunikation.
- Når Peter siger "kør", "kør videre" eller lignende, betyder det normalt: fortsæt selvstændigt efter den aftalte retning.
- Stil ikke spørgsmål, hvis et fornuftigt standardvalg kan træffes sikkert og reversibelt.
- Spørg når beslutningen er personlig, irreversibel, dyr, sikkerhedskritisk eller reelt ændrer produktets retning.
- Peter foretrækker at se et fungerende resultat og derefter justere.
- Hold løbende status kort: hvad der ændres, hvorfor, og om deployment er verificeret.

## 8. Ting der bør gøres tidligere næste gang

- Etabler auth/data/privacy-modellen tidligt, hvis appen fra starten skal være multi-user.
- Lav demo/test-mode tidligt, så udvikling ikke bremses af login.
- Definér PWA-cache-strategi og cache-versionering fra starten.
- Hold hemmelig/autorativ spil-logik ude af klientbundle fra første version, hvis fairness er et krav.
- Planlæg billeder/assets med endelig mappestruktur tidligt.
- Lav mobil-safe-area og touch-standarder som basis-CSS i starten.
- Lav specialiserede kerneflows tidligt; undgå at alt starter som den samme generiske CRUD-liste.

## 9. Kvalitetscheck før et projekt kaldes modent

- Kerneflow kan gennemføres på mobil uden forklaring.
- Login/logout og første-gangs-flow virker.
- Privacy er testet mellem flere brugere.
- Demo/test-mode kan ikke lække private data.
- Tomme tilstande giver mening.
- Loading/error states er forståelige.
- PWA opdaterer korrekt efter deploy.
- Installeret version håndterer safe-area.
- Ingen secrets ligger i repo eller browserbundle.
- CI/deployment er grøn.
- Produktet føles sammenhængende i sprog, navigation og visuel stil.
- Nye features er mindre værd end polish, hvis kernebehovene allerede er dækket.

## 10. Sådan bruges playbooken i et nyt projekt

Eksempel på besked:

> Brug Peter Playbook fra Jul2026 som arbejdsform. Byg en første fungerende version, tag fornuftige reversible beslutninger selv, deploy i små verificerede skridt, og stop kun når du reelt har brug for min beslutning.

Playbooken er levende dokumentation. Nye generelle læringer kan føjes til den, når de er værdifulde på tværs af projekter.

## 11. Ny læring: tomme tilstande

- En tom skærm er sjældent en god tom tilstand. Fortæl kort hvad der mangler, hvad brugeren kan gøre nu, og — når relevant — hvem der kan se dataene.
- Prioriter især tomme tilstande i flerbrugerflows; den første bruger skal kunne forstå funktionen uden at nogen andre allerede har lagt data ind.

## 12. Ny læring: testfunktioner i produktion

- Test- og preview-funktioner må ikke ændre fairness-regler eller give adgang til fremtidigt/hemmeligt konkurrenceindhold.
- Hold visuel preview adskilt fra autorisation og serverregler. Et testflag må gerne ændre præsentation, men bør ikke være det, der giver adgang til beskyttet data eller handlinger.

## 13. Ny læring: dato- og tidsregler

- Dato- og tidslåse for konkurrencer skal håndhæves server-side i den relevante lokale tidszone; browserens ur og UI-lås er kun præsentation.
- Skriv tidszonen eksplicit i serverlogik, når en regel følger en lokal kalenderdag. Undgå at lade serverens standardtidszone bestemme produktregler implicit.

## 14. Ny læring: loading før empty state

- En tom tilstand må først vises, når dataindlæsningen er afsluttet. En tom array-værdi under netværkskald er ikke det samme som bekræftet “ingen data”.
- I flerbrugerflows bør loading, tom, fejl og data være fire tydelige tilstande; ellers kan langsomt netværk få rigtige data til kortvarigt at se slettede ud.


## 15. Ny læring: PWA-releases på rigtige enheder

- En grøn web-deployment betyder ikke automatisk, at en installeret PWA kører samme version. Test både browserudgaven og den installerede app.
- Hav en eksplicit update-strategi fra starten: ny cache-version ved behov, `skipWaiting()`, `clients.claim()` og aktiv service-worker update-kontrol. Undgå at browsercache skjuler nye releases.

## 16. Ny læring: betinget rendering af specialvisninger

- Når en generisk visning ekskluderer en side, må sidens specialkomponent ikke ligge inde i samme wrapper. En condition som `page!=='eve'` kan ellers gøre en indlejret `page==='eve'` umulig at vise.
- Efter ændringer i JSX-conditions bør kernevisningen testes direkte, ikke kun buildes.

## 17. Ny læring: auth-fejl og recovery

- Slå ikke alle loginfejl sammen til “forkert password”. Skeln mellem ugyldige credentials, ubekræftet e-mail, rate limits og generelle system/netværksfejl, men vis familievenlige tekster i produktion.
- Midlertidig diagnostik må gerne vise sikker fejlkode/status under fejlsøgning, men fjernes igen efter årsagen er fundet.
- Password recovery skal testes end-to-end med den rigtige produktions-redirect; en lokal Site URL kan få ellers korrekte reset-mails til at lande på localhost.
