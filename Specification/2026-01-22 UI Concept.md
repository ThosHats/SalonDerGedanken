# UI Description  
## App: *Salon der Gedanken*  
**Light Mode – Interface Overview**

Dieses Dokument beschreibt die zentralen User Interfaces (UIs) der App *Salon der Gedanken* auf Basis des aktuellen UI-Designs. Ziel ist es, die Funktion und Intention der einzelnen Screens klar zu dokumentieren und als Referenz für Design, Entwicklung und Weiterentwicklung zu dienen.

---

## 1. Event Discovery List  
*(Compact Event List – Light Mode)*

Die **Event Discovery List** ist der zentrale Einstiegspunkt der App und dient der schnellen Übersicht über kommende Veranstaltungen.

### Beschreibung
- Kompakte, **bildfreie Listenansicht**, um möglichst viele Events gleichzeitig darzustellen
- Heller Hintergrund mit klarer, gut lesbarer Typografie
- Fokus auf schnelle Erfassbarkeit von Zeit, Titel und Kosten
- Geeignet für den täglichen, wiederholten Gebrauch

### Inhalte
- Datumsauswahl (z. B. einzelne Tage oder fortlaufende Tage)
- Event-Einträge mit:
  - Start- und Endzeit
  - Titel der Veranstaltung
  - Kostenhinweis (z. B. *Free*)
  - Veranstaltungsort / Anbieter (kurz)
- Pfeil-Navigation zur Detailansicht
- Filteroptionen (z. B. *Free only*, *Next 7 Days*, Themen)

### Ziel
Schnelles Scannen und Entdecken relevanter Veranstaltungen ohne visuelle Ablenkung.

---

## 2. Event Details View  
*(Event Details – Light Mode)*

Die **Event Details View** stellt alle verfügbaren Informationen zu einer einzelnen Veranstaltung dar.

### Beschreibung
- Luftiges, textfokussiertes Layout
- Helles Farbschema zur Unterstützung längerer Lesephasen
- Visuelle Zurückhaltung zugunsten von Inhalt und Struktur

### Inhalte
- Titel der Veranstaltung
- Kategorien / Tags (z. B. *Philosophy*, *Free of Charge*)
- Datum und Uhrzeit (inkl. Mehrtägigkeit, falls zutreffend)
- Veranstaltungsort mit Adresse
- Ausführliche Beschreibung des Events
- Informationen zum Veranstalter
- Link zur Originalquelle
- Optionale Aktionen (z. B. *Register for Free*, Teilen)

### Ziel
Vertieftes Verständnis des Events und fundierte Entscheidungsgrundlage für die Teilnahme.

---

## 3. Provider Management  
*(Provider Configuration – Light Mode)*

Das **Provider Management** ermöglicht die individuelle Steuerung der angebundenen Veranstaltungsanbieter.

### Beschreibung
- Aufgeräumtes, freundliches Layout
- Fokus auf Klarheit und Kontrolle
- Einstellungen sind bewusst einfach und erklärend gestaltet

### Inhalte
- Einstellbarer **Discovery Radius** (Entfernung in km)
- Liste verfügbarer Anbieter mit:
  - Name des Anbieters
  - Entfernung zum aktuellen Standort
  - Aktivierungs-/Deaktivierungs-Schalter
- Sammelaktionen (z. B. *Select All*)
- Bestätigungsaktion (*Apply Changes*)

### Ziel
Transparente Kontrolle darüber, welche Anbieter berücksichtigt werden und aus welchem räumlichen Umfeld Veranstaltungen angezeigt werden.

---

## 4. Initial Setup & Region Selection  
*(Onboarding – Light Mode)*

Das **Onboarding** dient der erstmaligen Einrichtung der App und legt die räumliche und inhaltliche Grundlage für die Eventsuche.

### Beschreibung
- Einladendes, reduziertes Design
- Klare visuelle Führung
- Minimale kognitive Belastung beim Einstieg

### Inhalte
- Regionale Standortsuche (z. B. Stadt, Gebiet)
- Kartenansicht zur Orientierung
- Einstellung des Suchradius
- Kurze erklärende Texte zur Funktionsweise
- Primäre Call-to-Action (*Start Exploring*)

### Ziel
Ein schneller, verständlicher Einstieg ohne technische Hürden oder Überforderung.

---

## 5. Sync & Cache Settings  
*(Sync & Cache Settings – Light Mode)*

Die **Sync & Cache Settings** geben dem User volle Kontrolle über Aktualisierung, Datenverbrauch und Offline-Nutzung.

### Beschreibung
- Klar strukturierte Einstellungsseite
- Technische Funktionen verständlich erklärt
- Trennung zwischen globalen und anbieterspezifischen Einstellungen

### Inhalte
- Manueller Refresh-Button mit Zeitstempel der letzten Aktualisierung
- **Globale Einstellungen**
  - Update-Intervall (z. B. 6h, 12h, 24h)
- **Source Overrides**
  - Individuelle Update-Intervalle pro Anbieter
- **Cache Management**
  - Anzeige des belegten Speichers
  - Möglichkeit zum Löschen des lokalen Caches
  - Hinweis auf Offline-Auswirkungen

### Ziel
Balance zwischen Aktualität, Performance und Datenkontrolle – angepasst an individuelle Nutzerpräferenzen.

---

## Zusammenfassung

Das UI von *Salon der Gedanken* folgt konsequent dem Prinzip:
> **Weniger visuelle Ablenkung – mehr geistiger Raum für Inhalte.**

Alle Interfaces sind:
- funktional klar getrennt,
- visuell ruhig gestaltet,
- auf wiederkehrende Nutzung optimiert,
- und konsequent auf Lesbarkeit, Orientierung und Kontrolle ausgerichtet.

Dieses Design unterstützt den Anspruch der App, ein **digitaler Salon für Gedanken, Austausch und kulturelle Orientierung** zu sein.