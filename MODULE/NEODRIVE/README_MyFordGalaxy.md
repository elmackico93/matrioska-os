# 📌 My Ford Galaxy – Documentazione Completa 🚗📡

L’app **My Ford Galaxy** è un ecosistema digitale completo che **integra un backend cloud-based** con un’app **Android/Wear OS**, offrendo **controllo remoto avanzato del veicolo**, gestione della sicurezza e un’esperienza utente fluida e ottimizzata.

---

## 🚀 Funzionalità Attuali (Versione 1.0)
La versione **1.0** dell’app offre **tre macro-funzionalità principali**:

### 1️⃣ Controllo Remoto del Veicolo
Permette di **interagire con la Ford Galaxy** in tempo reale, sfruttando API sicure e un’infrastruttura scalabile in cloud.

✅ **Azioni disponibili**:
- 🔒 **Blocca/Sblocca Porte** (via Internet o Bluetooth/NFC).
- 🚗 **Accendi/Spegni Motore** (se supportato dal veicolo).
- 🚦 **Attiva/Disattiva Luci Esterne** per localizzare il veicolo in un parcheggio.
- 📡 **Apri Bagagliaio** da remoto.

🎯 **Tecnologie utilizzate**:
- **AWS Lambda & API Gateway** per eseguire i comandi in cloud.
- **BLE/NFC** per interazioni locali senza internet (in corso di ottimizzazione).

---

### 2️⃣ Monitoraggio e Stato del Veicolo
L’utente può controllare lo stato del veicolo **in tempo reale**.

✅ **Dati monitorati**:
- 📍 **Posizione GPS Live** (se il veicolo supporta il tracking).
- ⛽ **Livello Carburante/Batteria**.
- 🔧 **Stato Diagnostico (OBD-II)** con eventuali errori motore.
- 🚗 **Chilometraggio attuale** e storico delle percorrenze.

🎯 **Tecnologie utilizzate**:
- **Google Maps API** per visualizzare la posizione del veicolo.
- **FordPass API & OBD-II Module** per dati di diagnostica.
- **Firebase Cloud Messaging** per aggiornamenti push in tempo reale.

---

### 3️⃣ Condivisione Sicura dell’Accesso al Veicolo
Permette di **condividere l’auto con altre persone** (familiari, amici, colleghi) senza dover passare una chiave fisica.

✅ **Opzioni di condivisione**:
- 👤 **Accesso Completo**: l’utente invitato può controllare il veicolo come il proprietario.
- ⏳ **Accesso Temporaneo**: valido solo per un certo periodo di tempo.
- 🔑 **Revoca Accesso** in qualsiasi momento.

🎯 **Tecnologie utilizzate**:
- **JWT Token Authentication** per la gestione degli utenti.
- **EncryptedSharedPreferences** su Android per memorizzare in sicurezza le credenziali.

---

## 🔮 Sviluppi Futuri (Versioni 1.1 e 2.0)

### 🛠️ 1. Sblocco Senza Internet via BLE/NFC
📡 **Obiettivo:** Permettere lo **sblocco del veicolo anche offline** tramite **Bluetooth Low Energy (BLE) e NFC**, senza bisogno di una connessione internet.

🟢 **Tecnologie previste**:
- **BLE Secure Communication** con l’OBD-II o il modulo FordPass.
- **NFC Tag Personalizzato** come “chiave digitale”.

📅 **Tempistiche previste:** Integrazione completa entro la **Versione 1.1 (Marzo 2025)**.

---

### 🔔 2. Notifiche Intelligenti & Sicurezza Avanzata
📡 **Obiettivo:** Migliorare la sicurezza con notifiche **push personalizzate**.

✅ **Nuove notifiche previste**:
- 🚨 **Allarme Attivato** se il veicolo viene spostato senza autorizzazione.
- 🔋 **Batteria Scarica** o **Manutenzione Necessaria**.
- 📌 **Raggiungimento Zona Predefinita (Geofencing)** → Esempio: *Notifica quando l'auto entra/esce da un'area specifica*.

🟢 **Tecnologie previste**:
- **AI-Powered Event Detection** per riconoscere attività sospette.
- **Geofencing con Google Location Services**.

📅 **Tempistiche previste:** Versione **1.2 (Aprile 2025)**.

---

### 🗂️ 3. Storico e Analisi delle Statistiche di Guida
📊 **Obiettivo:** Integrare una sezione nell’app che permetta di **analizzare le abitudini di guida**.

✅ **Dati previsti**:
- 📈 **Statistiche settimanali/mensili sui viaggi**.
- ⛽ **Consumo medio carburante per viaggio**.
- 🏅 **Punteggio Stile di Guida (per eco-driving o sicurezza).**

🟢 **Tecnologie previste**:
- **Machine Learning** per analizzare e migliorare lo stile di guida.
- **Dashboard interattiva con grafici avanzati.**

📅 **Tempistiche previste:** Versione **2.0 (Giugno 2025)**.

---

### 📡 4. Integrazione con Smart Home & Assistenti Vocali
🎤 **Obiettivo:** Consentire il controllo del veicolo tramite **Google Assistant, Alexa e Siri**.

✅ **Esempi di comandi vocali previsti**:
- “**Ehi Google, blocca la mia auto**.”
- “**Alexa, apri il bagagliaio della Ford Galaxy**.”

🟢 **Tecnologie previste**:
- **Google Actions SDK** per Google Assistant.
- **Amazon Alexa Skills Kit** per Alexa.
- **Apple Siri Shortcuts** per iPhone.

📅 **Tempistiche previste:** Versione **2.1 (Luglio 2025).**

---

## 📆 Prossimi Step
| **Data** | **Task** | **Status** |
|----------|---------|-----------|
| 31 Gennaio | Ottimizzazioni UI/UX su Android & Wear OS | 🔄 In corso |
| 1-2 Febbraio | Debug e test su dispositivi reali | 🚧 |
| 3-5 Febbraio | BLE Unlock & Notifiche Push | 🚧 |
| 6 Febbraio | Test finale e Fix Bug Critici | 🚧 |
| 7 Febbraio | **Release Versione 1.0!** 🚀 | 🔜 |

---

## 🎯 Conclusione
✅ **Backend completato e deployato su AWS con sicurezza avanzata.**  
✅ **App mobile & smartwatch funzionante con ottima UI/UX.**  
✅ **Alexa integrata, BLE Unlock in fase finale di test.**  
🚀 **Obiettivo: Versione 1.0 in rilascio il 7 Febbraio 2025!**  

📌 **Prossimo aggiornamento:** **1 Febbraio – Stato finale UI/UX & BLE Unlock! 🚀**  

