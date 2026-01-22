# Spezifikation  
## App: *Salon der Gedanken*  
**Regionale Veranstaltungsaggregation & -kuratierung**

---

## 1. Ziel & Zweck der App

**Salon der Gedanken** ist eine mobile App (optional später Web), die Veranstaltungen aus einer definierten Region **automatisch von verschiedenen Webseiten aggregiert**, **vereinheitlicht** und **nutzerfreundlich darstellt**.

Ziel ist es, kulturelle, philosophische, gesellschaftliche oder sonstige Veranstaltungen:
- übersichtlich auffindbar zu machen,
- zeitlich filterbar darzustellen,
- nach Kosten (z. B. kostenlos) zu selektieren,
- und flexibel um neue Anbieter erweiterbar zu halten.

---

## 2. Zielgruppe

- Kultur- und Veranstaltungsinteressierte Nutzer:innen
- Menschen, die regelmäßig Veranstaltungen von *ausgewählten* Anbietern besuchen (Vorträge, Diskussionen, Lesungen, Salons, Ausstellungen)
- Nutzer:innen mit Interesse an regionalen Angeboten
- Kurator:innen oder Initiativen, die Veranstaltungen sichtbar machen wollen

---

## 3. Zentrale Use Cases

### UC-1: Veranstaltungen entdecken
Ein:e Nutzer:in möchte sehen, **welche Veranstaltungen in den nächsten Tagen** in seiner Region stattfinden.

### UC-2: Nach Datum / Woche filtern
Ein:e Nutzer:in möchte:
- entweder einen **konkreten Tag** auswählen  
- oder **alle Veranstaltungen der nächsten 7 Tage** vausgehend von einem **konkreten Tag** anzeigen lassen

### UC-3: Kostenlose Veranstaltungen finden
Ein:e Nutzer:in möchte gezielt **kostenlose oder günstige Veranstaltungen** finden.

### UC-4: Veranstaltungsdetails ansehen
Ein:e Nutzer:in möchte eine Veranstaltung antippen und **alle Details** (Beschreibung, Zeiten, Kosten, Quelle) lesen.

### UC-5: Anbieter konfigurieren
Ein:e Nutzer:in möchte:
- bestimmte Anbieter von Veranstaltungen **aktivieren oder deaktivieren**
- steuern, **welche Webseiten von Anbietern überhaupt gescannt werden**

### UC-6: Aktualisierungsintervalle anpassen
Ein:e Nutzer:in möchte einstellen,
- wie oft Veranstaltungen aktualisiert werden
- global oder pro Anbieter

---

## 4. Funktionale Anforderungen

### 4.1 Veranstaltungsdaten (Event-Modell)

Jede Veranstaltung wird intern in einer **einheitlichen Struktur** gespeichert, unabhängig von der Quelle.

**Pflichtfelder:**
- Event-ID
- Titel / Überschrift
- Beschreibung (Kurz- & Langfassung)
- Startdatum
- Startuhrzeit
- Enddatum (optional)
- Enduhrzeit (optional)
- Mehrtägig (Boolean)
- Öffnungszeiten (optional, z. B. „täglich 10–18 Uhr“)
- Kosten:
  - kostenlos / kostenpflichtig
  - Preisangabe (Text oder Zahl)
- Anbieter (Quelle)
- Orstkoordinaten aus der Adresse des Anbieters abgeleitet (optional)
- URL zur Originalveranstaltung
- Region / Ort

---

### 4.2 Event-Liste (Übersicht)

Die App zeigt eine sortierte Liste von Veranstaltungen. Standardmäßig ist die Liste **chronologisch** sortiert.


**Listenansicht enthält:**
- Titel der Veranstaltung
- Datum
- Startuhrzeit
- Kostenhinweis (z. B. „kostenlos“)
- Navigationspfeil → Detailansicht

**Sortierung (Auswahl):**
- **Zeit (Standard):**
  - Primär: Datum
  - Sekundär: Startuhrzeit
- **Nähe (ortsnah):**
  - Sortierung nach Entfernung zum aktuellen Standort (aufsteigend)
  - Voraussetzung: Standortberechtigung ist erteilt; sonst ist diese Sortierung nicht verfügbar

---

### 4.3 Filter & Suche

**Filteroptionen:**
- 📅 Datum (konkreter Tag)
- 📆 Nächste 7 Tage nach einem konkreten Tag
- 💶 Kosten:
  - alle
  - kostenlos
  - kostenpflichtig
- 🔌 Anbieter (nur aktive Anbieter)

Filter sind **kombinierbar**.

---

### 4.4 Detailansicht einer Veranstaltung

Die Detailseite zeigt:
- Titel
- Vollständige Beschreibung
- Datum & Uhrzeit(en)
- Mehrtägige Logik verständlich aufbereitet
- Kosten
- Anbietername
- Link zur Originalquelle

---

## 5. Anbieter- & Plugin-Konzept (Kernarchitektur)

### 5.1 Grundidee

Jede externe Webseite wird über ein **eigenständiges Anbieter-Modul (Plugin)** angebunden.

👉 **Ein Anbieter = ein Modul**

Diese Module sind:
- technisch gekapselt
- austauschbar
- unabhängig vom restlichen System

---

### 5.2 Anbieter-Modul 

Jedes Modul erfüllt eine **klar definierte Schnittstelle**, z. B.:


---

### 5.3 Erweiterbarkeit

- Neue Anbieter werden durch **Hinzufügen eines neuen Moduls** integriert
- Keine Änderungen am Core-System notwendig
- Module können versioniert und separat getestet werden

---

## 6. Anbieter-Aktivierung & Präferenzen

### 6.1 Anbieter an- / ausschalten

In den App-Einstellungen kann der User:
- Anbieter aktivieren ✅
- Anbieter deaktivieren ❌

**Effekt:**
- deaktivierte Anbieter werden **nicht gescannt**
- keine Events dieses Anbieters erscheinen in der Liste
- keine Netzwerk- oder Analyse-Kosten

---

### 6.2 Update- & Cache-Strategie

**Caching:**
- Alle Events werden lokal gecached
- Anzeige erfolgt primär aus dem Cache

**Update-Intervalle:**
- Globales Standard-Intervall (z. B. alle 24 h)
- Optional pro Anbieter überschreibbar (z. B. alle 6 h, 48 h)
- Jedes Modul kann eine default Intervall definieren, das den globalen Standard überschreibt 

**Regeln:**
- Nur aktive Anbieter werden aktualisiert
- Updates erfolgen:
  - beim App-Start (wenn Intervall überschritten)
  - optional im Hintergrund
  - manuell per „Aktualisieren“

---

## 7. User Workflow (typischer Ablauf)

### Erstnutzung
1. App starten
2. Region auswählen
3. Anbieter-Auswahl:
   - Die Anbieter sind sortiert nach der Nähes zum Standort
   - Die Anbieter in einem bestimmten Umkreis sind vorausgewählt
   - Der Umkreis kann von dem User interaktiv verändert werden
4. Standard-Update-Intervall festlegen

---

### Regelmäßige Nutzung
1. App öffnen
2. Event-Liste für „Heute“ oder „Nächste 7 Tage“ ansehen
3. Optional:
   - Filter setzen (kostenlos, Datum)
4. Event auswählen
5. Details lesen
6. Optional: zur Originalseite wechseln

---

### Konfiguration
1. Einstellungen öffnen
2. Anbieter aktivieren / deaktivieren
3. Update-Intervalle anpassen
4. Cache manuell aktualisieren

---

## 8. Nicht-funktionale Anforderungen (Ausblick)

- Gute Performance durch Caching
- Erweiterbarkeit ohne Refactoring
- Fehlertoleranz (ein defektes Plugin blockiert nicht die App)
- Transparenz für den User (Quelle jedes Events sichtbar)
- Datenschutzfreundlich (keine Nutzertracking-Pflicht)
- Einfaches, moderne UI ohne viel Schnick-Schnack 

---

## 9. Optionaler Ausblick (später)

- Favoriten / Merkliste
- Push-Benachrichtigungen
- Kategorien (Philosophie, Kultur, Politik …)
- Copy Funktion in die Ablage um es in einer Message zu teilen  

