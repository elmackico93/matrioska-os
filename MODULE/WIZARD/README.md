# Wizard di Installazione di Matrioska OS

## Introduzione

Il **Wizard di installazione di Matrioska OS** è una procedura guidata interattiva che accompagna l’utente passo dopo passo nell’installazione del sistema operativo. Grazie a un’interfaccia semplice (grafica o testuale), il wizard automatizza gran parte delle configurazioni iniziali, consentendo anche agli utenti meno esperti di installare Matrioska OS in modo facile e veloce. La sua funzione principale è di rilevare l’hardware, raccogliere le preferenze dell’utente (lingua, layout di tastiera, partizionamento, ecc.) e configurare automaticamente il sistema in base a queste scelte, riducendo al minimo gli interventi manuali.

Questo installer è progettato per **Matrioska OS** ed è compatibile con le versioni recenti del sistema. In particolare, la versione corrente del wizard supporta Matrioska OS **1.x e 2.x** (sia edizione *Desktop* che *Server*). È consigliato utilizzare sempre la versione più aggiornata del wizard fornita con la distribuzione stessa, poiché potrebbe non essere garantita la compatibilità con release molto vecchie o future non esplicitamente testate.

---

## Requisiti di Sistema

Prima di utilizzare il wizard, assicurarsi che il sistema su cui si desidera installare Matrioska OS soddisfi i requisiti minimi. Di seguito i **requisiti hardware**:

- **Minimi:** Processore single-core (architettura x86_64) da 1 GHz, 1 GB di memoria RAM e almeno **10 GB** di spazio libero su disco. Una scheda grafica e display con risoluzione **800x600** sono sufficienti per la modalità testuale; per l’interfaccia grafica è consigliata una risoluzione di almeno **1024x768**.
- **Consigliati:** Processore dual-core 2 GHz o superiore, 4 GB di RAM e **20-25 GB** di spazio su disco per un’installazione completa con interfaccia grafica. Una GPU compatibile con accelerazione 3D (**256 MB VRAM**) e connessione Internet (facoltativa ma utile per aggiornamenti durante l’installazione) garantiscono un’esperienza ottimale.

Assicurarsi inoltre di disporre di un **supporto di installazione** adeguato (es. unità USB avviabile o DVD) e di poter avviare il sistema da tale supporto (controllare le impostazioni del **BIOS/UEFI**).

Per quanto riguarda le **dipendenze software**, il wizard di installazione è incluso nel supporto di Matrioska OS e non richiede componenti aggiuntivi quando eseguito dall’ambiente live. Se si desidera eseguirlo da sorgente o personalizzarlo, sono richiesti i seguenti componenti:

- Un sistema operativo **Linux compatibile** per eseguirne il codice (es. una live di Matrioska OS).
- **Interpreter Python 3.6+** (se parti del wizard sono scritte in Python) e/o le librerie **Qt5** (se si utilizza l’interfaccia grafica Qt).
- Utility di sistema come **parted/fdisk** per il partizionamento e il gestore pacchetti di Matrioska OS (es. **APT/dpkg**) per l’installazione dei software.

---

## Architettura del Wizard

Il wizard di installazione adotta un’**architettura modulare** composta da diversi componenti principali, ciascuno responsabile di una fase specifica del processo di installazione. Questi moduli cooperano tra loro seguendo una sequenza logica predefinita e scambiandosi informazioni sulle scelte effettuate dall’utente. In generale, il wizard può essere eseguito sia in **modalità grafica** che in **modalità testuale**, in modo simile all’installer Debian.

### **Principali componenti e moduli coinvolti:**

- **Interfaccia Utente (UI):** Gestisce l’aspetto grafico (Qt5) o testuale (menu ncurses) del wizard e presenta le varie schermate all’utente.
- **Modulo di Configurazione Iniziale:** Si occupa di raccogliere le prime impostazioni (lingua, layout tastiera, fuso orario, rete).
- **Modulo Partizionamento:** Fornisce strumenti per selezionare o creare partizioni sul disco.
- **Modulo Installazione Sistema:** Copia i file di Matrioska OS sul disco e configura il sistema.
- **Modulo Configurazione Finale:** Configura account utente, rete e impostazioni finali.
- **Gestore di Bootloader:** Installa e configura il bootloader (es. GRUB) per il dual-boot.
- **Log & Error Handling:** Registra i log e gestisce gli errori critici durante l’installazione.


---

## **Guida Operativa**

### **Avvio del Wizard**

Per avviare il wizard di installazione, eseguire il boot dal supporto USB/DVD contenente Matrioska OS. Dopo il caricamento iniziale, comparirà il menu principale con l’opzione **"Installa Matrioska OS"**.

In alternativa, si può eseguire il wizard da riga di comando con:

```bash
sudo matrioska-installer
```

Per forzare la modalità testuale o preconfigurare le risposte:

```bash
sudo matrioska-installer --text-mode --preseed=risposte.cfg
```

### **Passaggi del Processo di Installazione**

1. **Preparazione:**
   - Selezione versione di Matrioska OS (Desktop/Server)
   - Creazione del supporto di installazione (es. `dd if=MatrioskaOS.iso of=/dev/sdX bs=4M status=progress && sync`)

2. **Configurazione Iniziale:**
   - Selezione lingua
   - Layout tastiera
   - Fuso orario
   - Configurazione rete

3. **Installazione Sistema:**
   - Partizionamento disco (automatico o manuale)
   - Copia dei file di sistema
   - Configurazione del bootloader (GRUB)

4. **Configurazione Post-Installazione:**
   - Creazione utenti
   - Configurazione hostname e servizi opzionali
   - Aggiornamenti opzionali

5. **Conclusione e Riavvio:**
   - Il wizard mostrerà un messaggio di conferma: *"Installazione completata con successo!"*
   - Riavviare il sistema e accedere a Matrioska OS.

---

## **Log e Debugging**

- **Posizione Log:** `/var/log/installer/`
  - `/var/log/installer/syslog` → Log generale
  - `/var/log/installer/debug` → Debug dettagliato
  - `/var/log/installer/cfg` → Configurazione salvata
- **Accesso ai Log:** `Alt+F4` per la console di log in tempo reale
- **Modalità Debug:** Avvio con `debug` o `verbose` nel boot loader

---

## **Contributi e Manutenzione**

Il **wizard di installazione di Matrioska OS** è **open-source** e accoglie contributi:

- Repository su **GitHub/GitLab**
- Bug report e richieste di feature tramite **issue tracker**
- Pull request per miglioramenti e correzioni di bug

Per contribuire, seguire le linee guida nel file `CONTRIBUTING.md`.

---

## **Licenza**

Il codice è rilasciato sotto **Licenza MIT**, permettendo l’uso, modifica e ridistribuzione senza restrizioni, a condizione di mantenere il copyright originale.

Per dettagli, consultare il file `LICENSE` nel repository.

---

Grazie per aver scelto Matrioska OS! 🚀

