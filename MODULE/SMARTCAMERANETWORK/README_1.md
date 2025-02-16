Perfetto! Creerò un documento **Markdown super dettagliato** per Smart Camera Network, destinato a **sviluppatori**, con una base **tecnica avanzata** e cenni strategici. Includerò **tutte le funzionalità**, dagli **algoritmi di scansione telecamere**, alla **dashboard e UI/UX**, fino alla **sicurezza, AI e automazione**.

Il documento conterrà:
- **README.md completo** per una visione chiara del progetto.
- **API Documentation** per facilitare l’integrazione e lo sviluppo rapido.
- **Architettura dettagliata**, con flussi tecnici, protocolli e processi.
- **Esempi di codice e diagrammi** per rendere il tutto più concreto e immediato.

Ti aggiorno appena pronto! 🚀

# Smart Camera Network

## Introduzione e Obiettivi
**Smart Camera Network** è un progetto di sorveglianza di nuova generazione pensato per le **smart city** e ambienti IoT. Combina una rete di telecamere IP con algoritmi avanzati e integrazione IoT, offrendo a sviluppatori e operatori una piattaforma unificata per monitorare, analizzare e automatizzare la sicurezza in tempo reale. Il sistema sfrutta **standard aperti** (come ONVIF e RTSP) per garantire l'interoperabilità tra dispositivi di diversi produttori ([What is an ONVIF Camera? Guide to Protocols & Profiles](https://www.pelco.com/blog/onvif-guide#:~:text=What%20is%C2%A0ONVIF%3F)), ed è progettato con un'architettura modulare per facilitare l'espansione e la manutenzione.

**Obiettivi principali del progetto:**
- **Rilevamento automatico delle telecamere**: Scansione della rete per individuare telecamere IP disponibili e semplificarne l'aggiunta al sistema.
- **Dashboard unificata in tempo reale**: Fornire un’interfaccia utente intuitiva per visualizzare flussi video live, controllare le telecamere e gestire configurazioni.
- **Analisi intelligente dei video**: Implementare moduli di AI per rilevare movimenti, riconoscere volti e targhe, generando allarmi automatici e riducendo la necessità di monitoraggio manuale.
- **Integrazione con dispositivi IoT**: Collegare la rete di telecamere con l’illuminazione urbana e altri sensori (smart lighting) per automatizzare azioni (es. accensione luci) basate su eventi rilevati.
- **Sicurezza e privacy by-design**: Garantire comunicazioni cifrate, autenticazione robusta, gestione dei log di accesso e rispetto delle normative (es. GDPR) per proteggere i dati raccolti.
- **Architettura scalabile e modulare**: Suddividere il sistema in componenti indipendenti (microservizi) per consentire facile scalabilità orizzontale e integrazione di nuovi moduli senza impattare l’intero sistema.
- **Approccio disruptive**: Creare una piattaforma flessibile in grado di sconvolgere il mercato tradizionale della videosorveglianza, favorendo interoperabilità e ampliando le possibilità di utilizzo (sicurezza, analisi traffico, automazione urbana).

## Panoramica Funzionale
In sintesi, **Smart Camera Network** offre le seguenti funzionalità chiave:

- **Scoperta automatica delle telecamere** – Il sistema effettua la scansione della rete locale per individuare telecamere IP compatibili, sfruttando protocolli standard (WS-Discovery ONVIF) e scansioni su porte note. L’aggiunta di nuove telecamere è semplificata attraverso rilevamento automatico e configurazione guidata.
- **Streaming video in tempo reale** – Le telecamere rilevate possono essere visualizzate live sulla dashboard. Il backend recupera i flussi tramite RTSP e li rende disponibili al front-end (via protocolli web streaming come WebRTC o HLS) per una visualizzazione fluida e a bassa latenza.
- **Controllo remoto e PTZ** – La dashboard consente di controllare le telecamere remotamente: movimento **Pan-Tilt-Zoom** per telecamere motorizzate, regolazione dello **zoom**, messa a fuoco, snapshot istantanei, e configurazione di parametri (qualità video, framerate) tramite le API ONVIF standard.
- **Gestione centralizzata** – Un modulo di gestione tiene traccia di tutte le telecamere (metadati, indirizzi IP, stato online/offline), delle credenziali di accesso (cifrate) e delle impostazioni. Gli utenti possono organizzare le telecamere per zone o categorie (es. per area geografica in una città).
- **Rilevazione eventi e allarmi** – Il sistema analizza i flussi video in tempo reale (o su frame estratti) per rilevare eventi di interesse: movimento in aree sensibili, ingressi non autorizzati, oggetti abbandonati, ecc. Al verificarsi di un evento, vengono generati allarmi con notifiche sulla dashboard (e opzionalmente via email/SMS).
- **Integrazione Smart Lighting** – In caso di rilevazione di persone o veicoli in orari prestabiliti (es. di notte), il sistema può attivare automaticamente l’illuminazione intelligente nelle vicinanze. La comunicazione avviene tramite protocolli IoT (ad es. pubblicazione di messaggi MQTT a cui i lampioni smart sono sottoscritti).
- **Moduli AI avanzati** – Oltre al motion detection base, moduli avanzati di intelligenza artificiale permettono il **riconoscimento facciale** (identificando persone di interesse se presenti in un database autorizzato) e **riconoscimento targhe** dei veicoli. Questi moduli producono metadati strutturati (es. ID persona, numero targa) collegati agli eventi video.
- **Sicurezza end-to-end** – Tutte le comunicazioni tra componenti avvengono in modo sicuro (HTTPS/TLS per l’API e la dashboard, possibilità di RTSP su TLS per streaming). L’accesso al sistema è protetto da autenticazione con ruoli, e viene mantenuta una traccia di audit (log) delle operazioni critiche. Meccanismi di **autorizzazione** assicurano che ogni utente possa accedere solo alle risorse consentite.
- **API aperte** – Il backend espone API RESTful (o GraphQL) documentate che permettono l’integrazione con sistemi terzi, ad esempio per incorporare flussi video in applicazioni esterne, o per far interagire gli allarmi con piattaforme di monitoraggio differenti. Questo favorisce l’estendibilità e l’adozione della piattaforma in diversi scenari.
- **Scalabilità e distribuzione** – L’architettura supporta il deployment su server on-premise o cloud. È possibile distribuire componenti su nodi diversi (ad es. un nodo dedicato per l’elaborazione AI con GPU). L’aggiunta di telecamere o moduli extra non richiede modifiche sostanziali: la piattaforma può crescere in modo lineare aggiungendo risorse hardware e istanze dei servizi.

Le sezioni seguenti descrivono in dettaglio la tecnologia, l’architettura e l’implementazione di ciascun aspetto del sistema, fornendo approfondimenti tecnici e snippet di codice utili allo sviluppatore.

## Scansione e Rilevamento delle Telecamere
Uno dei primi passi del sistema è **individuare automaticamente le telecamere IP** presenti nella rete. Per farlo, Smart Camera Network adotta un approccio ibrido che combina **algoritmi di scansione attiva** e **protocolli standard di discovery**:

### Algoritmi di scansione e discovery
- **WS-Discovery (ONVIF)**: Il metodo principale per la scoperta è utilizzare Web Services Discovery, lo standard impiegato da ONVIF per l'autodiscovery dei dispositivi. Il modulo di **Camera Discovery** invia messaggi *Probe* multicast UDP sull’indirizzo e porta standard (239.255.255.250:3702) ([WS-Discovery - Wikipedia](https://en.wikipedia.org/wiki/WS-Discovery#:~:text=Web%20Services%20Dynamic%20Discovery%20%28WS,standards%2C%20notably%20%2044)). Tutte le telecamere compatibili con ONVIF sulla sottorete rispondono con le proprie informazioni di servizio (endpoint SOAP, indirizzo IP, nome dispositivo, ecc). Questo meccanismo è efficiente perché richiede un singolo broadcast e raccoglie risposte da più dispositivi contemporaneamente ([How does WS-Discovery work? - EdgeX Foundry Documentation](https://docs.edgexfoundry.org/2.3/microservices/device/supported/device-onvif-camera/supplementary-info/ws-discovery/#:~:text=ONVIF%20devices%20support%20WS,to%20find%20ONVIF%20capable%20devices)) ([How does WS-Discovery work? - EdgeX Foundry Documentation](https://docs.edgexfoundry.org/2.3/microservices/device/supported/device-onvif-camera/supplementary-info/ws-discovery/#:~:text=Probe%20messages%20are%20sent%20over,address%20and%20UDP%20port%20number)). *Nota:* WS-Discovery funziona solo entro lo stesso segmento di rete (pacchetti multicast di solito non attraversano router) ([How does WS-Discovery work? - EdgeX Foundry Documentation](https://docs.edgexfoundry.org/2.3/microservices/device/supported/device-onvif-camera/supplementary-info/ws-discovery/#:~:text=WS,typically%20do%20not%20traverse%20routers)), quindi per reti più grandi o segmentate si adotteranno strategie supplementari.
- **Scansione IP (fallback)**: In aggiunta a WS-Discovery, il sistema può eseguire una scansione mirata degli indirizzi IP configurati (o di un range definito dall’utente) alla ricerca di servizi noti. Questo comporta ad esempio:
  - Ping degli host per vedere quali IP sono attivi.
  - **Port scanning leggero** su porte tipiche di telecamere: 80/443 (HTTP/HTTPS per interfacce web), 554 (RTSP), 8000...9000 (alcuni produttori usano porte proprietarie), 3702 (WS-Discovery SOAP UDP).
  - Tentativi di connessione HTTP: per ogni host attivo, il sistema può inviare richieste HTTP GET a `/onvif/device_service` (per vedere se risponde un servizio ONVIF) o a URL comuni (`/videostream.asf`, `/snapshot.jpg`, ecc.) che alcuni modelli espongono. Anche senza autenticazione, una risposta o intestazione può rivelare marca/modello (via `Server` header o contenuto HTML).
  - **Identificazione UPnP/SSDP**: alcune telecamere annunciano la propria presenza via SSDP/UPnP. Il sistema può ascoltare messaggi di questi protocolli per aggiungere ulteriori dispositivi (anche se ONVIF/WS-Discovery copre gran parte di quelli moderni).
- **Parallelizzazione e timeout**: La scansione utilizza tecniche asincrone/multithread per velocizzare il processo, soprattutto nella scansione IP range. Sono impostati timeout brevi sulle connessioni, per evitare di rallentare in caso di host non responsivi. I risultati (dispositivi trovati) vengono consolidati, eliminando duplicati (una stessa camera potrebbe essere trovata via WS-Discovery e HTTP).

*Esempio di flusso di scansione ONVIF:*
1. Il servizio di discovery invia un messaggio Probe WS-Discovery in multicast sulla rete locale.
2. Telecamere ONVIF rispondono con un messaggio contenente il loro **XAddr** (indirizzo del servizio ONVIF) e informazioni di capacità.
3. Il servizio di discovery crea una lista preliminare di dispositivi rilevati. Per ciascuno, tenta una connessione al servizio ONVIF di Device Management (via HTTP/SOAP) per ricavare dettagli (marca, modello, numero seriale).
4. Se il dispositivo richiede autenticazione ONVIF, verrà contrassegnato come “richiede credenziali” in attesa che l’utente fornisca username/password per completare la registrazione.
5. In parallelo, se abilitato, il sistema esegue scansioni sulle porte di IP non risposti, tentando di individuare flussi RTSP o pagine web che indichino la presenza di una telecamera (ad esempio, molti dispositivi forniscono una pagina web di login su porta 80).
6. Tutte le telecamere individuate (con o senza ONVIF) sono elencate per l’utente, che può selezionare quali aggiungere al monitoraggio attivo e inserire eventuali credenziali necessarie.

### Protocolli utilizzati (RTSP, ONVIF, HTTP)
Il sistema supporta i principali protocolli standard che le telecamere IP utilizzano:
- **ONVIF (Open Network Video Interface Forum)** – È uno **standard** di interoperabilità che definisce un insieme di servizi per telecamere di sicurezza IP ([What is an ONVIF Camera? Guide to Protocols & Profiles](https://www.pelco.com/blog/onvif-guide#:~:text=What%20is%C2%A0ONVIF%3F)). Tramite ONVIF, il sistema può eseguire:
  - *Discovery* dei dispositivi (Device Discovery, basato su WS-Discovery).
  - *Device Management*: recuperare info sul dispositivo (modello, firmware), impostare parametri, orologi, utenti, ecc.
  - *Media Service*: ottenere gli URI dei flussi video (RTSP) o snapshot, configurare flussi (risoluzione, codec) e recuperare stream RTSP pubblicati dal dispositivo.
  - *PTZ Service*: controllare i movimenti Pan/Tilt/Zoom per telecamere motorizzate.
  - *Event Service*: alcune telecamere inviano eventi (motion detection integrato, ingressi digitali) via ONVIF. Il nostro sistema può sottoscriversi a tali eventi per reagire in tempo reale.
  - ONVIF opera principalmente su HTTP usando SOAP/XML (tipicamente su porta 80/HTTP o 443/HTTPS del dispositivo) per i comandi, e utilizza porte RTP/RTSP per i media stream. **Nota:** ONVIF non trasmette direttamente il video, ma fornisce gli URL (spesso RTSP) a cui connettersi per il flusso.
- **RTSP (Real Time Streaming Protocol)** – È il protocollo standard per controllare lo streaming di contenuti multimediali su rete, ampiamente usato per il video delle telecamere IP. In pratica, RTSP fornisce comandi tipo **DESCRIBE, SETUP, PLAY, PAUSE, TEARDOWN** per negoziare e mantenere uno streaming video/audio. Il flusso vero e proprio viaggia tipicamente su RTP/UDP oppure RTP/TCP. Il nostro sistema utilizza RTSP per prelevare i feed video delle telecamere da visualizzare o analizzare. Ad esempio, una telecamera fornirà un URL del tipo `rtsp://<ip_cam>/Streaming/Channels/1` che il modulo streaming userà per aprire il flusso. RTSP è un protocollo a livello applicativo pensato per il **controllo della trasmissione** di dati con requisiti real-time (es. video) ([RFC 2326:  Real Time Streaming Protocol (RTSP) ](https://www.rfc-editor.org/rfc/rfc2326.html#:~:text=The%20Real%20Time%20Streaming%20Protocol%2C,a%20means%20for%20choosing%20delivery)). È supportato da quasi tutte le IP camera; il sistema garantisce compatibilità con RTSP 1.0 (RFC2326) ed eventualmente RTSP 2.0 se richiesto. Per telecamere che supportano **RTSPS** (RTSP su TLS) si privilegia quello, altrimenti ci si può connettere in chiaro su RTSP e gestire la cifratura a livello rete (VPN).
- **HTTP/HTTPS** – Molte telecamere espongono funzionalità via HTTP:
  - Interfaccia di amministrazione web (da cui l’utente umano configura la camera).
  - **Snapshot JPEG**: un URL (es. `http://<ip_cam>/snapshot.jpg`) che restituisce l’ultima immagine catturata. Il nostro sistema può usare ciò per mostrare anteprime o per rilevare il funzionamento della camera (se RTSP non è facilmente verificabile).
  - **MJPEG stream**: alcune telecamere offrono streaming Motion JPEG su HTTP (es. `http://<ip_cam>/video.mjpg`), utile per compatibilità browser senza plugin. Tuttavia, questo è meno efficiente di RTSP e viene usato raramente nel nostro contesto (potrebbe servire come fallback in caso RTSP non funzionasse o per integrazioni semplici).
  - **ONVIF over HTTP**: come detto, i servizi ONVIF sono invocati via HTTP(S) SOAP. Quindi, la comunicazione di controllo col dispositivo avviene tramite richieste HTTP POST contenenti XML SOAP.
  - **API proprietarie**: se una telecamera non supporta ONVIF, spesso ha API REST proprietarie (documentate dal produttore) per ottenere flusso, configurare parametri, ecc. Il design modulare prevede la possibilità di aggiungere **adapter** per protocolli proprietari se necessario, ma ONVIF copre la maggior parte dei casi.

In fase di *rilevamento*, quindi, la combinazione di ONVIF e scansione consente di:
- Individuare **tutte** (o quasi) le telecamere IP in rete, indipendentemente dal produttore.
- Ottenere *automaticamente* gli URL RTSP e altre info senza doverle cercare manualmente.
- Uniformare la gestione grazie allo standard ONVIF, evitando di scrivere codice specifico per marche diverse.

### Autenticazione e bypass delle credenziali
La maggior parte delle telecamere IP protegge l’accesso ai propri flussi e servizi con autenticazione. Il sistema deve gestire correttamente le credenziali per poter connettersi alle camere. Ecco come viene affrontato questo aspetto:
- **Metodi di autenticazione supportati**: 
  - *Basic Auth (HTTP Basic)*: username e password vengono inviati in chiaro (base64) nell'header HTTP **Authorization**. È semplice ma poco sicuro senza TLS; molte telecamere meno recenti lo implementano. Il nostro sistema lo supporta (soprattutto per flussi RTSP in cui l’autenticazione basic è comune).
  - *Digest Auth (HTTP Digest)*: metodo più sicuro in cui la password non viaggia mai in chiaro ma viene usato un challenge nonce e hash MD5. ONVIF **richiede** digest auth per le chiamate SOAP in molti casi, e anche RTSP spesso è configurato in digest mode. Il client (il nostro sistema) riceve un “401 Unauthorized” con nonce e realm, quindi calcola la risposta hash e ripete la richiesta. Il modulo di connessione include librerie o implementazioni per gestire questo handshake automaticamente.
  - *ONVIF WS-Security*: le specifiche ONVIF permettono l’autenticazione anche a livello di messaggio SOAP (ad es. *UsernameToken* con password digestata). Spesso però è mappata sull’HTTP Digest sottostante. In pratica, fornendo le credenziali corrette, il client ONVIF library si occuperà dei dettagli di WS-Security.
  - *Autenticazione integrata nel URL RTSP*: molti sistemi permettono di fornire credenziali nell’URL (es. `rtsp://user:pass@ip_cam/...`). Il nostro sistema utilizza questa sintassi quando passa l’URL ai player video o ai moduli di streaming (ovviamente evitando di esporre la password in chiaro in frontend; questa costruzione viene usata solo internamente lato server o in stream protetti).
- **Gestione delle credenziali nel sistema**: Quando una telecamera viene aggiunta, all’utente è richiesto di inserire *username* e *password* di accesso. Queste credenziali vengono **salvate in modo sicuro** nel database (idealmente cifrate o almeno hashate se non serve riutilizzarle in chiaro). Il sistema le utilizza per:
  - Autenticarsi alle API ONVIF (Device Management, Media, PTZ...).
  - Costruire gli URI RTSP autenticati per il modulo streaming.
  - Accedere a snapshot HTTP se necessario.
  - Queste credenziali non sono mai inviate a client finali, restano sul server. L’accesso ai flussi per l’utente avviene tramite il server stesso, che funge da intermediario (così le credenziali della camera non vengono esposte ai browser).
- **Bypass e casi particolari**:
  - *Telecamere senza autenticazione*: alcune telecamere economiche o in configurazioni custom non richiedono login per lo stream (es. flussi pubblici). Il sistema rileva se un flusso RTSP o HTTP è accessibile senza credenziali; in tal caso marca la camera come “open”. Sebbene non sia consigliato tenere telecamere non autenticate, il sistema lo supporta.
  - *Credenziali di default*: molte IP camera escono con credenziali di fabbrica note (es. *admin/admin*). Durante la scansione iniziale, il sistema potrebbe provare in automatico un elenco di credenziali comuni su dispositivi trovati (feature opzionale, disabilitata di default per ragioni di sicurezza) per segnalare all’utente telecamere potenzialmente accessibili con password di default. In ogni caso, **si raccomanda vivamente** di cambiare le password di default su ogni dispositivo per evitare accessi indesiderati.
  - *Bypass di autenticazione non intenzionale*: esistono casi documentati di falle in firmware di telecamere che consentono di ottenere immagini o flussi senza login (ad esempio URL nascosti o stream secondari non protetti). Il nostro sistema non fa uso attivo di exploit, sia per etica che per stabilità, ma avere telecamere con tali vulnerabilità rappresenta un rischio; in ottica **security hardening** si consiglia di aggiornare i firmware e applicare credenziali robuste. 
  - *Telecamere con autenticazione a più fattori o certificati*: raramente, alcuni dispositivi professionali possono richiedere certificati client o avere meccanismi di OAuth2 per API cloud. Il progetto al momento si concentra su autenticazione base/digest locale. In ambienti enterprise, l’integrazione di certificati (es. 802.1x network access, certificato TLS client) potrà essere aggiunta, mantenendo l’architettura modulare (ad esempio, un plugin specifico per telecamere Bosch con certificate-based auth).
- **Esperienza utente nell’aggiunta**: Quando una telecamera viene trovata ma richiede autenticazione, la dashboard la mostrerà come "Trovata: Modello XYZ (Credenziali richieste)". L’utente potrà cliccare e inserire username/password per completare la registrazione. Dopo verifica, la camera passerà a stato “Online” sul sistema.

In sintesi, il modulo di scansione e rilevamento assicura che l’**onboarding** delle telecamere nel sistema sia il più automatico e rapido possibile, sfruttando protocolli standard e discovery, ma consentendo all’utente di intervenire per fornire credenziali dove necessario. Questo riduce drasticamente il tempo di configurazione iniziale in confronto ai sistemi tradizionali in cui ogni camera andrebbe aggiunta manualmente.

## Dashboard e UI/UX
La **dashboard** è il punto di controllo centrale per gli utenti e amministratori del Smart Camera Network. È progettata con un approccio **web-based** (accessibile tramite browser su desktop o dispositivo mobile) privilegiando un’esperienza intuitiva, reattiva e informativa. Di seguito, descriviamo gli aspetti principali di design e interazione della UI, insieme alle API sottostanti che la supportano.

### Design della Dashboard
- **Layout generale**: La dashboard presenta una panoramica delle telecamere disponibili in un’interfaccia tipo *control panel*. Nella schermata principale, si può avere una **griglia di riquadri video** (multi-cam view) mostrando il live di più telecamere contemporaneamente. Ogni riquadro include il nome della telecamera, stato (online/offline), e controlli rapidi (es. per scattare uno snapshot, o espandere a schermo intero).
- **Vista dettaglio camera**: Cliccando su una singola telecamera, si apre la vista dedicata: un player video live più grande, con a fianco controlli PTZ (se supportati), informazioni dettagliate (posizione, risoluzione streaming corrente, bitrate) e la timeline degli eventi rilevati per quella camera (es. marcatori temporali di motion detect, volti riconosciuti di recente, ecc).
- **Navigazione**: Un menu laterale consente di navigare tra sezioni: *Dashboard* (overview telecamere), *Eventi* (lista globale degli eventi/allarmi recenti), *Impostazioni* (configurazioni di sistema, utenti, integrazioni IoT), *Telecamere* (lista gestionale di tutte le telecamere con possibilità di aggiungere/modificare).
- **Stile e usabilità**: Si adotta un design pulito, con palette colori scura (dark mode) per affaticare meno la vista in una sala controllo, e contrasto elevato per evidenziare allarmi (es. riquadro lampeggiante in rosso se c'è un allarme su quella camera). Le informazioni critiche (come un movimento rilevato) compaiono sia come notifica pop-up che come evidenziazione sul video (ad esempio, disegnando un riquadro intorno all'oggetto in movimento se fornito dal modulo AI).
- **Mappa interattiva** (opzionale): Per implementazioni su scala cittadina, potrebbe esserci una mappa della città con indicatori delle telecamere geolocalizzate. Cliccando un punto mappa si apre la camera corrispondente. Questo è utile per smart city dashboard dove la posizione geografica è rilevante.
- **Responsive**: L’interfaccia è responsive, adattandosi a schermi più piccoli. Su mobile, potrebbe mostrare una camera per volta con lista a scorrimento. Funzioni PTZ e notifiche rimangono accessibili con gesture semplificate.

### Flussi utente principali
- **Aggiunta di una nuova telecamera**: L’utente (amministratore) sceglie “Aggiungi Telecamera”. Si apre un wizard che propone:
  1. *Scansione automatica*: il sistema elenca le telecamere trovate in rete non ancora registrate (con identificativo e IP). L’utente ne seleziona una, inserisce username/password se richiesto, assegna un nome “amichevole” (es. *Ingresso Nord*) e conferma. La telecamera viene aggiunta al database e immediatamente appare in dashboard.
  2. *Aggiunta manuale*: se la telecamera non compare (ad esempio è su una subnet diversa o discovery disabilitato), l’utente può inserire manualmente l’IP/hostname, porta, e credenziali. Il sistema tenta la connessione ONVIF; in caso di successo recupera i dati e registra il dispositivo.
- **Visualizzazione in live streaming**: Quando l’utente accede alla dashboard, il front-end effettua chiamate API per ottenere l’elenco telecamere e le relative anteprime. I flussi video live possono essere caricati automaticamente (in una griglia 2x2, 3x3, configurabile) o su richiesta (cliccando “Play” su un riquadro). Il **player video** nel browser utilizza tecnologie HTML5:
  - Se il server fornisce uno stream in formato HLS (HTTP Live Streaming), viene usato un elemento `<video>` con il manifesto `.m3u8`.
  - Per latenza più bassa, potrebbe essere usato WebRTC: in tal caso il client scambia una sessione WebRTC col server (via WebSocket signaling) e riceve il flusso con <200ms di latenza.
  - In ogni caso, l’utente può mettere in pausa un feed, mutare l’audio (se presente), passare a schermo intero o chiudere un riquadro per liberare risorse.
- **Controlli PTZ e comandi camera**: Nella vista dettaglio o nel riquadro di una telecamera PTZ, l’utente può usare controlli direzionali (su/giù/sinistra/destra) e zoom. Quando l’utente preme ad esempio la freccia destra, il front-end chiama l’API REST del backend per comando PTZ (es. `POST /api/cameras/5/ptz` con payload `{pan: 1.0, tilt: 0.0}` per muovere verso destra). Il backend traduce in richiesta ONVIF `ContinuousMove` o `RelativeMove` sul dispositivo. Questo avviene in tempo reale, e la camera reagisce muovendosi; l’utente vede il cambiamento nel video. Altri comandi: messa a fuoco, iris, preset (vai a posizione predefinita), avvio/arresto tour.
- **Gestione allarmi ed eventi**: Se il modulo AI rileva un evento (es. persona sconosciuta), la dashboard notifica immediatamente l’utente. Un **pop-up di notifica** appare con descrizione (es. "Movimento rilevato nel Parcheggio alle 03:21"), cliccandolo l’utente viene portato alla vista della relativa telecamera con il video live e magari un clip registrato di qualche secondo attorno all’evento. Esiste anche una sezione *Eventi* dove l’operatore può rivedere tutti gli eventi in ordine cronologico, filtrare per tipo (allarme intrusione, riconoscimento facciale, ecc) e confermare o annotare (ad esempio marcare un evento come gestito).
- **Configurazione e impostazioni**: L’utente amministratore può attraverso la UI aggiungere/rimuovere utenti del sistema, definire i ruoli (es. un utente “osservatore” può solo vedere i video ma non aggiungere telecamere né modificare impostazioni). Può anche configurare parametri globali: ad esempio, attivare/disattivare la funzionalità di accensione luci automatica, impostare fasce orarie in cui certe telecamere inviano allarmi, regolare la sensibilità del motion detection se il modulo lo permette, etc. Ogni modifica invia richieste API al server per aggiornare il database e i servizi coinvolti.
- **Integrazione mappe e tracking**: In scenari avanzati, l’utente può selezionare un oggetto in movimento su una telecamera e attivare il *tracking multi-camera*. Ad esempio, se una persona sospetta si muove attraverso aree coperte da diverse telecamere, il sistema può passare automaticamente da una camera all’altra seguendo l’oggetto (basato su analisi AI e calibrature di posizione). L’interfaccia mostrerebbe dinamicamente la vista della telecamera successiva. Questo è un flusso avanzato che illustra il potenziale di integrazione tra moduli (visione e controllo camere); la UI deve renderlo semplice, ad esempio con un pulsante "track" sul target rilevato.

### Logica di interazione e API coinvolte
La dashboard comunica con il backend esclusivamente tramite **API web sicure**. Questo decoupling permette anche di controllare il sistema via script esterni o integrazioni, se autorizzati. Alcuni aspetti tecnici:
- **Architettura front-end**: È sviluppata come **Single Page Application (SPA)** usando un framework moderno (React, Angular o Vue). Ciò consente aggiornamenti in tempo reale e una UX fluida, caricando i dati via API senza refresh completo della pagina.
- **Chiamate RESTful principali**: Il backend espone endpoint chiari per tutte le operazioni. Ad esempio:
  - `GET /api/cameras` – Restituisce l'elenco delle telecamere registrate con dettagli (id, nome, stato, snapshot thumbnail URL).
  - `POST /api/cameras` – Aggiunge una nuova telecamera (body JSON con indirizzo IP, credenziali, nome, ecc). Innesca la procedura di connessione ONVIF e, in caso di successo, salva la camera.
  - `GET /api/cameras/{id}/stream` – (se non si usa direttamente un player HLS/WebRTC) questo endpoint può restituire un URL di streaming o avviare una sessione. Alternativamente, potrebbe negoziare una connessione WebRTC offrendo SDP.
  - `POST /api/cameras/{id}/ptz` – Invia un comando PTZ. Il corpo contiene il tipo di comando (move, zoom, preset) e parametri (velocità, coordinate o nome preset). Il server esegue il comando via ONVIF.
  - `GET /api/events?camera={id}` – Elenca eventi storici (es. ultimi N eventi per quella camera).
  - `POST /api/lights/{light_id}` – Comanda un dispositivo di illuminazione (on/off o dimmer) collegato, se si espone controllo manuale anche delle luci.
  - `POST /api/login` e `POST /api/logout` – Gestione sessione utente (alternativamente potrebbe essere JWT token-based).
- **Notifiche in tempo reale**: Per aggiornamenti immediati (come allarmi o cambio stato camera), l’app front-end apre una connessione WebSocket o SSE (Server-Sent Events) al server. Ad esempio, quando il modulo AI genera un evento, il backend lo invia sul WebSocket; la UI, ascoltando sul canale appropriato (es. `/ws/events`), riceve l’evento e può mostrarlo entro frazioni di secondo. Questo è fondamentale per allarmi, dove la reattività è cruciale.
- **Gestione dei flussi video**: A seconda dell’implementazione, ci sono due strade:
  1. *Streaming via backend*: Il server backend funge anche da proxy per i flussi video, convertendoli se necessario. In questo caso l’API potrebbe fornire un endpoint HLS (`GET /api/streams/{cam_id}/playlist.m3u8`) o aprire uno stream WebRTC. Il vantaggio è che il backend può applicare autenticazione e transcodifica centralmente. La UI ottiene un URL (autenticato) o una stream session per visualizzare.
  2. *Streaming diretto P2P*: Nel caso di WebRTC, dopo la signaling iniziale via API, il flusso viaggia direttamente dal server media (che può essere distinto dal core API server) al client, cifrato via DTLS/SRTP. La UI gestisce la resa tramite elementi video o canvas.
- **Feedback e stati**: La UI guida l’utente nelle operazioni mostrando stati di avanzamento. Ad esempio, dopo aver inviato `POST /api/cameras` per aggiungere una camera, mostrerà "Connessione in corso..." finché il backend non risponde con successo. In caso di errore (telecamera non raggiungibile, credenziali errate), un messaggio chiaro verrà mostrato (es. "Credenziali non valide o telecamera non compatibile").
- **API per IoT e integrazioni**: Oltre alle luci, se il sistema integra altri sensori (es. sensore di movimento PIR indipendente, sirene, ecc.), saranno presenti endpoint simili (`/api/sensors`, `/api/actuators` ecc.) e possibilità di configurare regole (via API o UI) che li leghino con le telecamere. L’architettura API-centric facilita l’aggiunta di queste componenti senza stravolgere il frontend – le nuove funzionalità appaiono come nuove sezioni o opzioni sulla dashboard.
- **Sicurezza API**: Tutte le chiamate richiedono un token di autenticazione (es. token di sessione utente). Viene seguito il principio di **autorizzazione** sul server: anche se la UI nasconde i bottoni non permessi a certi ruoli, il backend verifica sempre che l’utente abbia i permessi adeguati (es. un utente solo-lettura non può chiamare POST /api/cameras). Le API sono esposte solo su HTTPS, evitando attacchi man-in-the-middle.

In generale, l’interazione UI-backend è disegnata per essere **chiara e prevedibile**, usando convenzioni RESTful e fornendo messaggi di errore/utilità dettagliati (codici HTTP appropriati, payload JSON con dettagli). Questo aiuta gli sviluppatori sia a estendere la dashboard che a utilizzare direttamente le API per integrazioni.

## Sicurezza e Privacy
La sicurezza è un elemento fondamentale di Smart Camera Network, data la natura sensibile dei dati trattati (flussi video di sorveglianza e informazioni personali). Il sistema è progettato con il principio di **“secure by design”**, implementando misure di sicurezza a più livelli: dalla cifratura delle comunicazioni, all’autenticazione robusta, fino alla protezione dei dati memorizzati e alla conformità normativa sulla privacy. In questa sezione dettagliamo gli aspetti di sicurezza e privacy, nonché gli standard e best practice adottati.

### Cifratura delle comunicazioni
Tutte le comunicazioni tra componenti avvengono in modo **cifrato** per prevenire intercettazioni:
- **Dashboard e API (HTTPS)**: Il frontend e le API interagiscono esclusivamente tramite HTTPS (TLS 1.2+). Ciò garantisce che credenziali utente, dati di configurazione e eventi transitino in modo sicuro. Vengono usati certificati SSL validi; in contesti chiusi (LAN) si può usare un PKI interno. ONVIF stesso supporta WS-Discovery e servizi via HTTPS, dunque quando possibile le chiamate ONVIF dal server alle telecamere usano TLS (molte telecamere offrono `http://ip/onvif` e `https://ip/onvif`).
- **Streaming video**: Il protocollo RTSP di base non prevede cifratura, ma ci sono contromisure:
  - Se le telecamere supportano **RTSP over TLS** (anche detto RTSPS), il sistema userà quell’endpoint (solitamente su porta 322,  has `rtsps://` URI). In caso contrario, per flussi su reti non fidate si raccomanda di far passare i flussi in tunnel VPN o utilizzare protocollo SRTP. Nel nostro caso, se il server e le telecamere stanno su una LAN dedicata e isolata, RTSP può viaggiare in chiaro internamente mentre l’accesso esterno è protetto.
  - Quando il backend ritrasmette i flussi verso i client, utilizza protocolli cifrati: *WebRTC* (che cifra i media con DTLS/SRTP end-to-end) o *HLS su HTTPS* (i segmenti .ts sono scaricati via HTTPS). Inoltre, è possibile applicare **cifratura a livello applicativo** sui flussi HLS (AES-128) per evitare che eventuali cache/proxy possano vedere i contenuti.  
- **MQTT e IoT**: La comunicazione con i dispositivi IoT (es. broker MQTT) avviene su canali sicuri. MQTT supporta TLS e autenticazione: il sistema può connettersi al broker via `mqtts://` con certificato, specialmente se è un broker cloud o esterno. In un contesto locale, se il broker è interno e protetto da firewall, si può anche usare MQTT in chiaro su LAN ma è comunque preferibile abilitare TLS e autenticazione sul broker.
- **Database e dati a riposo**: I dati salvati (configurazioni, log, eventualmente videoclips) sono protetti:
  - Il database è preferibilmente ospitato sullo stesso server o subnet segregata, non esposto pubblicamente. Le connessioni al DB dal backend possono essere configurate su TLS (molti DB supportano cifratura client-server).
  - I file di log o spezzoni video salvati su disco possono essere cifrati a livello di file system (es. con LUKS su Linux) se si teme accesso fisico al server.
- **VLAN e rete segregata**: Best practice suggerita: mantenere la rete delle telecamere separata dalla rete IT generale. Ad esempio, porre telecamere e server su una VLAN dedicata, isolata da internet. Questo riduce la superficie d’attacco. ONVIF raccomanda di **non esporre telecamere o NVR direttamente su Internet se non necessario** ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Secure%20your%20network)) e di usare VLAN e firewall per segmentare la rete ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Secure%20your%20network)).

*(Riferimento best practice: "Usare connessioni criptate (HTTPS) quando possibile, anche su reti locali" ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Secure%20your%20network)).)*

### Autenticazione e autorizzazione degli utenti
- **Gestione account**: L’accesso alla dashboard richiede autenticazione utente. Il sistema gestisce account multipli con ruoli:
  - *Amministratore*: può aggiungere/rimuovere telecamere, utenti, modificare impostazioni di sicurezza, vedere tutti i flussi.
  - *Operatore*: può vedere i flussi live e gli eventi, controllare PTZ, ma non modificare configurazioni critiche.
  - *View-only*: accesso in sola lettura a specifiche telecamere (utile per condividere feed con forze dell’ordine o terze parti in modo limitato).
- **Password policy**: È richiesto l’uso di password complesse. In configurazione di default, il sistema impone password di almeno 8 caratteri con numeri e simboli (personalizzabile). Si incoraggia l’uso di password uniche per ogni utente e la rotazione periodica ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Review%20Your%20Security%20and%20Password,Policies)). Se un utente tenta di usare una password debole, l’interfaccia lo avvisa e rifiuta. Alla *prima installazione*, l’account admin di default deve essere cambiato con una nuova password (non è permesso restare con le credenziali di fabbrica) ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=,based%20authentication)).
- **Protezione autenticazione**: Per prevenire attacchi a forza bruta, dopo N tentativi falliti su un account, questo può essere temporaneamente bloccato o si può richiedere un CAPTCHA. È possibile integrare anche **2FA (due-factor)** per account amministrativi: ad esempio, codice OTP via app o email per login.
- **Autorizzazione granular**: Ogni risorsa (telecamera, impostazione) può avere permessi associati. Ad esempio, si può configurare che un operatore di una certa sede veda solo le telecamere di quella sede. Questo è implementato nel backend verificando i ruoli e attributi utente su ogni chiamata API. Le interfacce utente mostrano solo ciò che è consentito, ma il controllo vero è server-side (principio di *defense in depth*).
- **Audit e accountability**: Ogni azione sensibile compiuta da un utente viene loggata con timestamp e username. Ad esempio: login/logout, aggiunta o rimozione di una camera, modifica configurazione, esportazione di un video. Questo consente di avere traccia di chi ha fatto cosa (fondamentale in ambito sicurezza).

*(Riferimento best practice: "Assegnare ad ogni persona il proprio username e password, garantendo responsabilizzazione individuale" ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Review%20Your%20Security%20and%20Password,Policies)).)*

### Gestione dei log e monitoraggio
- **Log di sistema**: Il backend mantiene log dettagliati:
  - Log applicativo (informazioni, warning, errori) per debug e monitoraggio salute del sistema.
  - Log di accesso utente (chi si è loggato, tentativi falliti).
  - Log di accesso alle risorse: ad esempio "Utente X ha visualizzato il video della Camera 5 dalle 10:30 alle 10:45".
  - Log degli eventi di sicurezza: es. "Telecamera 3 offline", "Connessione rifiutata a telecamera 4 (autenticazione fallita)".
  - Questi log sono archiviati in formato testuale o JSON e ruotati periodicamente (per non riempire il disco). È possibile inviarli a un server syslog centralizzato o un SIEM per analisi avanzate.
- **Privacy dei log**: I log non contengono dati sensibili in chiaro oltre al minimo necessario. Ad esempio, non si loggano password (solo eventuali hash), e per eventi come riconoscimento facciale si logga un identificativo anonimo o un riferimento a record interni e non il nome della persona, a meno che sia necessario. Questo per rispetto della privacy se i log fossero consultati da amministratori di sistema che non dovrebbero vedere certe info.
- **Accesso ai log**: Solo utenti con ruolo di amministratore di sistema possono accedere ai log completi. Si può prevedere una maschera di visualizzazione log nella dashboard oppure richiedere di scaricarli da server. I log stessi possono essere protetti a livello file system (permessi ristretti).
- **Monitoraggio attivo**: In un contesto di produzione, si raccomanda di monitorare continuamente lo stato del sistema: un modulo di *Health Check* potrebbe inviare notifiche se una telecamera risulta offline o se un servizio backend si arresta. Questo si integra con la sicurezza perché consente reazioni rapide a possibili incidenti (es. se improvvisamente tutte le telecamere vanno offline, potrebbe indicare un problema di rete o un attacco DoS in corso).

### Prevenzione di accessi non autorizzati
- **Isolamento delle telecamere**: Come accennato, le telecamere dovrebbero stare su una rete isolata. Il server Smart Camera Network agisce da intermediario. Ciò significa che i client esterni non accedono mai direttamente alle telecamere, ma sempre passando dall’autenticazione del server. In pratica, le telecamere non espongono servizi verso Internet, riducendo il rischio di exploit diretti ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Secure%20your%20network)). Un firewall deve bloccare accessi esterni alle porte delle cam, consentendo solo al server di comunicare con esse ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Secure%20your%20network)).
- **Aggiornamenti e patch**: Mantenere aggiornati sia il software del server che i firmware delle telecamere è cruciale. Il sistema può includere notifiche per l’amministratore quando rileva versioni firmware note come vulnerabili o non aggiornate. Si aderiscono alle linee guida CVE per sapere se qualche modello di camera ha falle pubbliche.
- **Hardening dei dispositivi**: ONVIF consiglia di **disabilitare servizi non necessari sui dispositivi** ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=,or%20a%20media%20proxy)). Ad esempio, UPnP sulle telecamere potrebbe essere disattivato se non serve, per evitare che espongano informazioni in rete. Anche funzionalità come Telnet/SSH sui dispositivi dovrebbero essere spente se non utilizzate. Il nostro sistema può fornire note all’utente su queste pratiche (es. nella pagina di info di una telecamera, indicare “UPnP attivo: sarebbe opportuno disattivarlo”).
- **Sicurezza del server**: Il server applicativo stesso deve essere messo in sicurezza:
  - Configurare correttamente CORS, rate limiting sulle API se pubbliche, prevenire attacchi comuni web (XSS, CSRF, SQL injection) seguendo OWASP Top 10. Si usano framework sicuri e si validano sempre i dati in ingresso.
  - Eseguire l'applicazione con privilegi minimi sul sistema operativo, isolare i servizi (ad esempio container Docker per i singoli moduli, limitando le risorse e accessi di ogni container).
  - Abilitare logging di sicurezza sul sistema operativo, per rilevare tentativi di accesso al server stesso.
- **Crittografia e gestione chiavi**: Oltre alla cifratura delle comunicazioni, assicurarsi che le **chiavi** e i certificati siano gestiti correttamente. Le password nel database sono **hashate** (es. bcrypt). Le credenziali delle telecamere, che devono essere riutilizzate in chiaro per connettersi, sono cifrate nel database con una chiave che risiede sul server (es. usando un keystore protetto, o almeno non versionando la chiave con il codice). In ambienti enterprise, si può integrare un sistema di segreti (come HashiCorp Vault) per gestire queste informazioni sensibili.
- **Privacy e conformità**: Dal punto di vista privacy, è importante prevedere:
  - **Controllo accessi ai video**: Solo personale autorizzato può vedere i flussi. Inoltre il sistema potrebbe supportare modalità di **mascheramento**: ad esempio, oscurare o pixelare zone dell’immagine considerate private (come finestre di abitazioni adiacenti) – questo è spesso richiesto da normative locali.
  - **Retention dei dati**: Implementare regole di conservazione per registrazioni ed eventi. Se il sistema registra clip video su allarme, può esserci un’impostazione per cancellarli automaticamente dopo X giorni, in linea con GDPR (principio di limitazione della conservazione).
  - **Informativa e consenso**: Sebbene questo esuli dall’implementazione tecnica interna, il sistema può prevedere moduli per memorizzare le policy privacy applicate (ad esempio, loggando che l’amministratore ha confermato di avere segnalato con cartelli l’area videosorvegliata, ecc., come promemoria di compliance).

*(Riferimento best practice ONVIF: "Non lasciare impostazioni di default, abilitare protezioni, e ridurre l'esposizione permettendo l'accesso alle camere solo tramite il sistema VMS o proxy" ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=,or%20a%20media%20proxy)).)*

In definitiva, la sicurezza di Smart Camera Network è ottenuta attraverso una stratificazione di misure. Ogni livello (dall’utente, al software, alla rete, ai dispositivi) è considerato e protetto. I riferimenti agli standard di settore (come le raccomandazioni ONVIF ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Secure%20your%20network)) ([ONVIF Recommendations for Cybersecurity Best Practices for IP-based Physical Security Products - ONVIF](https://www.onvif.org/profiles/whitepapers/onvif-recommendations-for-cybersecurity-best-practices-for-ip-based-physical-security-products/#:~:text=Review%20Your%20Security%20and%20Password,Policies)), guide OWASP, normative GDPR) assicurano che il sistema segua **best practice riconosciute**, offrendo fiducia sia ai sviluppatori che ai gestori finali sul fatto che il sistema sia robusto e affidabile.

## Smart Lighting e IoT
Un elemento distintivo di Smart Camera Network è la stretta **integrazione con l’Internet of Things (IoT)**, in particolare con i sistemi di **illuminazione intelligente urbana**. Ciò consente scenari di automazione innovativi: ad esempio, una telecamera che rileva movimento in una zona buia può attivare automaticamente i lampioni stradali in quell’area, migliorando sicurezza ed efficienza energetica. In questa sezione descriviamo come avviene l’integrazione con lo **smart lighting**, i protocolli coinvolti e la logica di automazione basata su eventi.

### Integrazione con l’illuminazione urbana
Il sistema supporta la connessione a lampioni o fari smart presenti nella città (o in un’azienda, campus, etc.). L’**integrazione** avviene tramite un modulo IoT dedicato, il quale può comunicare con i controller delle luci. Esistono due modalità principali:
- **Via piattaforma esistente**: molte città hanno una piattaforma di gestione illuminazione (es. centraline che controllano gruppi di lampioni). In tal caso, Smart Camera Network espone/chiama API verso quella piattaforma. Ad esempio, se c’è un sistema centrale con API REST o SOAP per accendere luci, il nostro modulo IoT effettuerà le chiamate necessarie.
- **Direttamente sui dispositivi**: in contesti più piccoli o sperimentali, ogni lampione smart potrebbe essere dotato di connettività (WiFi, Zigbee, LoRaWAN...). Il nostro sistema può comunicare direttamente con essi usando protocolli IoT standard, descritti di seguito.

### Protocolli di comunicazione (MQTT, Zigbee, WiFi)
Abbiamo a disposizione diversi protocolli e tecnologie per collegare server, telecamere e attuatori (luci):
- **MQTT (Message Queuing Telemetry Transport)**: è un protocollo leggero di messaggistica *publish-subscribe*, molto diffuso in ambito IoT ([MQTT - Wikipedia](https://en.wikipedia.org/wiki/MQTT#:~:text=MQTT%20,ISO%2FIEC%2020922)). Si basa su un **broker** centrale a cui i client si connettono (le telecamere/analitiche possono agire da publisher di eventi, le unità di illuminazione o i loro controller come subscriber). Ad esempio, il nostro sistema (publisher) invia un messaggio sul topic `city/zone1/lights` con payload `"ON"`; i lampioni della zona 1 sono sottoscritti a quel topic e all’arrivo del messaggio accendono le luci. MQTT è affidabile su connessioni instabili, ha overhead minimo e supporta livelli di QoS (dal *fire-and-forget* a consegna garantita). È ideale per collegare decine/centinaia di dispositivi in tempo reale. Il nostro modulo IoT include un client MQTT configurabile: può operare con broker pubblici/cloud o con un broker locale.
- **Zigbee**: è uno standard wireless per reti mesh a basso consumo, usato spesso per illuminazione smart (es. Zigbee Light Link, Zigbee 3.0) ([Zigbee - Wikipedia](https://en.wikipedia.org/wiki/Zigbee#:~:text=Zigbee%20is%20an%20IEEE%20802,wireless%20ad%20hoc%20network)). Molti lampioni intelligenti usano Zigbee per comunicare con un **gateway** centrale (un dispositivo che fa da ponte tra la rete Zigbee e IP). Il sistema può interfacciarsi con tale gateway. In pratica, il modulo IoT potrebbe inviare comandi al gateway (via MQTT o API specifica) che a sua volta inoltra via Zigbee ai lampioni. Zigbee offre vantaggi come il **mesh networking** (i dispositivi ritrasmettono i segnali, coprendo grandi aree) e la sicurezza integrata con chiavi simmetriche a 128-bit ([Zigbee - Wikipedia](https://en.wikipedia.org/wiki/Zigbee#:~:text=Its%20low%20power%20consumption%20limits,data%20transmissions%20from%20a%20sensor)). Ad esempio, un lampione Zigbee riceve un comando “On” e lo esegue in meno di un secondo, anche se originato da un server distante, grazie alla catena: Server -> Gateway IP/Zigbee -> Lampione (mesh). 
- **Wi-Fi**: Alcune soluzioni di illuminazione (soprattutto per interni o retrofit) usano moduli Wi-Fi. In quel caso, i lampioni sono essi stessi nodi IP nella rete LAN. Il nostro sistema potrebbe inviare comandi direttamente a ciascun lampione via HTTP (se espone un endpoint REST) o via protocolli come CoAP. Tuttavia, su larga scala il Wi-Fi ha limiti (numero di dispositivi, consumo energetico). Nelle smart city generalmente i lampioni usano Zigbee o tecnologie LPWAN, ma il sistema è flessibile. Anche telecamere wireless potrebbero essere collegate via Wi-Fi a hotspot cittadini, e il sistema le gestisce allo stesso modo delle cablate.
- **Altri protocolli IoT**: Oltre a quelli richiesti, vale la pena menzionare che l’architettura può estendersi a protocolli come **LoRaWAN** (bassa velocità, lunghissimo raggio), **NB-IoT** (sulle reti cellulari), o protocolli cablati standard tipo **DALI** (usato per controllo lampade). Ciò significa che l’integrazione IoT non è limitata a luci: lo stesso meccanismo potrebbe inviare comandi ad allarmi sonori, aprire cancelli, ecc.

*(Nota:* MQTT è standard OASIS e ISO/IEC 20922, pensato proprio per dispositivi con risorse limitate in IoT ([MQTT - Wikipedia](https://en.wikipedia.org/wiki/MQTT#:~:text=MQTT%20,ISO%2FIEC%2020922)).*)*

### Automazione basata su eventi
Il fulcro dell’integrazione sta nella definizione di **regole automatiche** che legano gli eventi delle telecamere alle azioni sui dispositivi IoT. Alcuni esempi di automazione implementate:
- **Accensione luci su movimento**: L’esempio classico: durante le ore notturne, se una telecamera rileva movimento o presenza umana in una zona poco illuminata, il sistema attiva immediatamente i lampioni di quell’area. Si possono definire soglie orarie (es. attiva automazione dalle 22:00 alle 05:00) e soglie di luminosità (integrando magari un sensore crepuscolare). Il flusso è:
  1. Modulo AI su Camera X rileva una persona alle 23:30 -> genera evento "persona rilevata Camera X".
  2. Modulo Eventi verifica le regole: trova che per Camera X di notte va acceso gruppo luci Y.
  3. Modulo IoT pubblica messaggio MQTT sul topic `lights/areaY/cmd` con payload `ON` (o chiama API gateway luci).
  4. I dispositivi dell'area Y ricevono e accendono le lampade al 100% di intensità.
  5. Dopo un tempo configurato (es. 5 minuti di nessun movimento ulteriore), il sistema spegne o dimma di nuovo le luci (messaggio `OFF`).
- **Allarme sonoro su intrusione**: In un deposito, se di notte una telecamera rileva movimento, oltre ad accendere le luci il sistema potrebbe attivare un allarme acustico o un messaggio via altoparlante. Il principio è lo stesso: evento -> comando IoT (magari un relè collegato a sirena).
- **Notifica a pattuglia**: Si può integrare l’IoT anche inviando notifiche a dispositivi mobili del personale (non proprio IoT, ma push notification). Ad esempio via MQTT o HTTP il sistema invia un messaggio all’app di servizio della guardia per avvisarla di un evento e magari contestualmente accende una luce rossa su un quadro sinottico.
- **Ottimizzazione energetica**: Se dopo una certa ora non c'è più movimento in un’area per lungo tempo, il sistema potrebbe anche spegnere completamente l’illuminazione e riaccenderla solo su evento (questo però va bilanciato con norme di sicurezza stradale). L’idea è usare i dati delle cam per adattare l’ambiente in modo dinamico.
- **Flusso di comando**: Per orchestrare queste automazioni, internamente c’è un *Event Manager* o *Rules Engine*. Può essere implementato con un motore di regole (ad es. utilizzando qualcosa come **Node-RED** o componenti custom) che permette all’admin di configurare visivamente "IF evento_X AND condizioni -> THEN azione_Y". In alternativa, le regole possono essere hardcoded in configurazioni JSON. Il sistema di default offre alcune regole predefinite (es. movimento->luci) che l’utente può attivare con semplici toggle dalla UI.
- **Feedback e verifica**: Dopo aver mandato un comando IoT, il modulo aspetta (ove possibile) un feedback. Ad esempio, se i lampioni sono dotati di sensori di corrente o conferma di accensione, il sistema può ricevere un messaggio di ritorno "Lampione A acceso con successo". Questo viene loggato e può essere mostrato in UI (es. un’icona sullo stato del lampione). Se non c’è feedback (molti sistemi di illuminazione non lo danno in tempo reale), il sistema può comunque assumere l’esecuzione ma eventualmente segnalare se la condizione desiderata non sembra raggiunta (ad es., la telecamera continua a vedere buio -> forse la luce non si è accesa, allora reinvia comando o allerta manutenzione).

Dal punto di vista **implementativo**, il modulo IoT si iscrive agli eventi interni del sistema (ad es. tramite un bus di messaggi interno o hooking nelle routine di analisi). Quando riceve un evento rilevante, esegue le azioni corrispondenti. La comunicazione con dispositivi IoT può essere parallela o sincrona: generalmente è veloce (sub-secondo) quindi per l’utente sembra istantanea la reazione.

### Standard e interoperabilità
Si privilegiano protocolli standard aperti per garantire interoperabilità:
- MQTT è open e ampiamente supportato (client disponibili in molti linguaggi, e broker come Eclipse Mosquitto facilmente deployabili).
- Zigbee è standardizzato (IEEE 802.15.4) e diffuso in ambito lighting (supportato da produttori diversi: Philips Hue, Osram Lightify, ecc). Il sistema può integrarsi con qualunque gateway Zigbee standard. Inoltre Zigbee supporta reti **mesh sicure con chiavi AES-128** ([Zigbee - Wikipedia](https://en.wikipedia.org/wiki/Zigbee#:~:text=Its%20low%20power%20consumption%20limits,data%20transmissions%20from%20a%20sensor)), garantendo privacy e resistenza ad intrusioni remote.
- Dove possibile si utilizzano **profili standard**: ad esempio, se integrando luci stradali che supportano il protocollo TALQ (uno standard per gestione unificata di illuminazione pubblica), il sistema può essere esteso per parlare TALQ, evitando lock-in.
- L’uso di **JSON MQTT messages** o **REST API** rende più semplice per sviluppatori esterni aggiungere dispositivi custom. Ad esempio, un maker potrebbe aggiungere un dispositivo IoT che aziona un cancello quando riceve `{"open": true}` su MQTT topic `gate/ingresso`. Una volta noto il topic e payload, si può aggiungere una regola nel sistema "if veicolo autorizzato rilevato -> publish gate/ingresso open:true".
  
In conclusione, il modulo Smart Lighting e IoT amplia le capacità della piattaforma oltre la semplice videosorveglianza, rendendola un vero **sistema di automazione cittadina**. La scelta di protocolli come MQTT e Zigbee assicura affidabilità, tempi di risposta brevi e integrazione con l’ecosistema di dispositivi IoT esistente o futuro. Ciò rappresenta un importante elemento di **innovazione**: non solo si sorveglia passivamente, ma si reagisce e adatta l’ambiente in modo **intelligente** agli eventi rilevati.

## Moduli Avanzati (AI Video Analysis e Automazione)
L'intelligenza artificiale gioca un ruolo cruciale nel rendere la rete di telecamere **"smart"**. Oltre alla semplice visualizzazione, i moduli avanzati permettono di analizzare automaticamente i flussi video per estrarre informazioni utili e attivare azioni. In questa sezione, esploriamo i moduli di **analisi video basata su AI**, tra cui il riconoscimento facciale e delle targhe, e come questi abilitano l’**automazione della sorveglianza**.

### Analisi Video con AI
Il modulo di analisi video utilizza algoritmi di **computer vision** e **deep learning** per interpretare i contenuti dei flussi video in tempo reale. Ecco alcune capacità fornite:
- **Rilevamento di movimento avanzato**: Sebbene molte telecamere offrano motion detection basica integrata (per differenza frame), il nostro sistema implementa algoritmi più avanzati per ridurre falsi positivi. Ad esempio, analisi di background subtraction con filtri per ignorare cambi di luce graduali, oppure reti neurali che distinguono movimenti pertinenti (di persone/veicoli) dal rumore (foglie al vento, ombre).
- **Object detection**: Utilizzando modelli di deep learning (es. **YOLO - You Only Look Once**, SSD, o RetinaNet), il sistema può individuare e classificare oggetti nel video. I modelli sono addestrati su classi di interesse per la sorveglianza: persone, automobili, motocicli, biciclette, animali, ecc. Una volta integrato, il sistema può segnalare: "2 persone e 1 veicolo presenti nella zona A".
- **Zone di interesse e linee virtuali**: L’analisi permette di definire aree specifiche nell’inquadratura (es. oltre la recinzione) o linee virtuali. Se un oggetto entra in un’area riservata o attraversa una linea (tripwire), il sistema genera un evento. Questo è utile per perimetrazione (intrusion detection perimetrale).
- **Conteggio oggetti**: In scenari urbani, si può contare il numero di persone in una piazza o di veicoli in un incrocio tramite le telecamere. Ciò può servire per statistiche di flusso o per attivare azioni (es. troppa folla -> apri uscite di emergenza).
- **Rilevamento comportamento anomalo**: Con AI si possono cercare pattern anomali, tipo una persona che corre (potrebbe indicare inseguimento o emergenza) vs persone che camminano, oppure qualcuno che rimane fermo troppo a lungo in una zona (loitering), o cadute a terra (detection di persona caduta, utile in ambito urbano per soccorso).

L’implementazione tecnica di questi moduli sfrutta librerie come **OpenCV** per operazioni base e framework come **TensorFlow/PyTorch** per l’esecuzione di reti neurali. Il modulo di analisi può utilizzare l'hardware GPU per gestire più flussi simultanei in tempo reale. Tipicamente:
- Si estraggono frame dai flussi video (es. 5 frame al secondo per analisi, adattabile).
- I frame vengono passati ai modelli AI caricati in memoria. Ad esempio, un modello YOLOv5 pre-addestrato scansiona l’immagine e restituisce bounding box e classi di oggetti rilevati.
- Il modulo traduce queste informazioni in **metadati** strutturati (es. lista di oggetti con coordinate, tipo e confidenza).
- I metadati possono essere salvati nel database (per storicità) e servono per generare gli eventi (es. se c’è una persona dove non dovrebbe -> evento allarme).

### Riconoscimento Facciale e Riconoscimento Targhe
**Riconoscimento Facciale**: È il processo di identificare o verificare persone a partire dal volto catturato dalla telecamera. Il sistema può includere un database di volti di interesse (ad esempio, personale autorizzato, VIP, o al contrario blacklist di individui segnalati). Quando il modulo AI rileva un volto in un frame:
- Estrae una *feature vector* (embedding numerico) attraverso una rete neurale (tipicamente una CNN tipo FaceNet o ResNet addestrata su milioni di volti).
- Confronta questo vettore con quelli nel database usando una misura di distanza. Se la distanza è sotto una certa soglia, viene trovata una corrispondenza e la persona viene identificata (es. "Mario Rossi riconosciuto nell'area 1").
- In caso di match con una persona non autorizzata/blacklist, scatta un allarme di sicurezza. In caso di persona autorizzata, l’evento può essere loggato solo per registro (es. "Dipendente X entrato alle 9:00").
- Tutto il processo deve avvenire rispettando privacy: spesso si evita di fare riconoscimento facciale senza giusta causa. Il sistema può essere configurato per anonimizzare volti di chi non è in lista (per es., blur automatico se richiesto).

**Riconoscimento Targhe (ANPR - Automatic Number Plate Recognition)**: Le telecamere rivolte verso aree di transito veicoli possono estrarre le targhe:
- Si utilizzano algoritmi dedicati o librerie open source come **OpenALPR** che semplificano molto il compito. OpenALPR, ad esempio, fornisce funzioni per individuare la targa nell'immagine e applicare OCR (Optical Character Recognition) sui caratteri ([OpenALPR - Wikipedia](https://en.wikipedia.org/wiki/OpenALPR#:~:text=OpenALPR%20is%20an%20automatic%20number,11)). 
- Il modulo riceve frame (idealmente da telecamere posizionate frontalmente ai veicoli, magari ingressi parcheggi). Attraverso computer vision individua il rettangolo della targa, lo normalizza (correzione prospettica) e poi riconosce il testo alfanumerico.
- Una volta ottenuto il numero di targa come stringa, lo confronta con liste: lista autorizzati (ad esempio residenti, dipendenti) o lista veicoli rubati/seguiti. 
- Può quindi aprire automaticamente una barriera se il veicolo è autorizzato, oppure lanciare allarme se una targa segnalata viene rilevata.
- Anche qui, precisione e velocità sono chiave: con buone telecamere e buon algoritmo, si possono ottenere >95% di accuratezza in condizioni di luce adeguate ([OpenALPR - Wikipedia](https://en.wikipedia.org/wiki/OpenALPR#:~:text=)). Vengono gestiti casi di incertezza (più possibili letture per una targa, da verificare manualmente o con confronti incrociati).
- Il sistema può immagazzinare le targhe transitate con timestamp, utile ad es. per consultazioni successive (forensics, "chi è entrato ieri alle 22:00").

*(Esempio libreria: OpenALPR è una libreria open source in C++/Python per riconoscimento targhe che usa OpenCV e Tesseract OCR ([OpenALPR - Wikipedia](https://en.wikipedia.org/wiki/OpenALPR#:~:text=OpenALPR%20is%20an%20automatic%20number,11)), facilmente integrabile nel modulo.*)

### Automazione della sorveglianza
Grazie ai dati forniti dai moduli AI, il sistema può intraprendere **azioni automatiche** senza intervento umano:
- **Allarmi automatici**: Come già descritto, eventi come intrusione, volto non riconosciuto, veicolo sospetto generano immediatamente allarmi (notifiche, sirene, luci, ecc). Questo trasforma la sorveglianza da reattiva a proattiva.
- **Tracking automatico multi-camera**: In una rete di più telecamere con sovrapposizione di campo visivo, il sistema può seguire un soggetto spostandosi da una camera all'altra. Ad esempio, se una persona si muove fuori dall'inquadratura della Camera 1, ma entra in Camera 2, l’AI può correlare che è lo stesso soggetto (tramite vestiti o volto) e la dashboard potrebbe automaticamente mostrare Camera 2 all’operatore. Questo è un aiuto enorme nelle inseguimenti in tempo reale.
- **Controllo PTZ automatizzato**: Per telecamere mobili, l’AI può pilotarle attivamente. Esempio: una dome camera 360° rileva movimento nella porzione NE -> il sistema comanda la camera a orientarsi e zoomare su quel movimento (auto-tracking). Oppure, se deve riconoscere un volto, può fare zoom sul viso della persona per migliorare la precisione. Questo è come avere un operatore virtuale che muove le cam in base a ciò che “vede”.
- **Filtraggio falsi allarmi**: L'automazione non serve solo ad agire, ma anche a *non agire* quando non necessario. L’AI può riconoscere quando un movimento non è una minaccia (es. un gatto che passa) e quindi evitare di attivare sirene o notificare continuamente gli operatori. Questo riduce “l’assuefazione da allarme” e fa sì che quando arriva una notifica, sia più probabile che sia importante.
- **Report e statistiche intelligenti**: Oltre alla sorveglianza immediata, i moduli avanzati consentono analisi aggregate nel tempo. Ad esempio:
  - Report giornaliero: numero di persone passate da un varco, veicoli entrati, tempo medio di permanenza in un’area.
  - Heatmap oraria: fasce orarie di maggior movimento per ottimizzare pattugliamenti o illuminazione.
  - Rilevamento trend: ad esempio, confronto settimana su settimana per valutare se certi eventi stanno aumentando.
  - Queste informazioni possono essere presentate su dashboard analitiche separate, aiutando a **ottimizzare le risorse** (sicurezza e non solo, anche marketing o urbanistica in contesto cittadino).
- **Integrazione con altri sistemi di sicurezza**: La piattaforma può esportare eventi a sistemi esterni di gestione sicurezza (PSIM, centrali operative) seguendo standard come ONVIF Profile G/M o formati JSON. In pratica, funge da cervello locale e collabora con sistemi superiori.

### Implementazione modulare e best practice AI
Il modulo AI è generalmente separato in uno o più servizi:
- Un **servizio di inferenza AI** che riceve frame (o flussi video) come input e restituisce risultati analitici. Ciò potrebbe essere un microservizio containerizzato (magari usando GPU via CUDA). Questo servizio potrebbe implementare gRPC o ZeroMQ per comunicare internamente col core.
- Un **servizio di gestione eventi** che prende i risultati grezzi dell’AI e li trasforma in eventi di alto livello applicando filtri e regole (es. un oggetto rilevato: se persona e area protetta -> evento intrusione).
- Database per **metadati**: se si salvano anche i risultati analitici (utile per ricerche forensi, es. trovare tutti momenti in cui una persona X appare), serve un database ottimizzato per query di questo tipo.
- Per garantire accuratezza e equità negli algoritmi di riconoscimento facciale, si seguono linee guida etiche: modelli addestrati su dataset ampi e bilanciati per minimizzare bias, e threshold di confidenza tarati per ridurre falsi riconoscimenti. Inoltre, se usato in contesti pubblici, devono essere rispettate le leggi locali (spesso il riconoscimento facciale è limitato o richiede autorizzazioni).

*(Evoluzione futura: ONVIF Profile M è un nuovo profilo che standardizza la metadata analytics delle telecamere, facilitando l'interoperabilità tra sistemi AI e VMS. Il nostro sistema può in futuro supportare Profile M per ricevere/inviare metadati analitici in formato standard.)*

In conclusione, i moduli avanzati di Smart Camera Network trasformano un insieme di telecamere in un **sistema di sorveglianza intelligente** e autonomo. La combinazione di rilevamento in tempo reale, riconoscimento di entità (volti, targhe) e automazione di risposta rende il sistema altamente efficace e in grado di scalare il controllo di vaste aree con intervento umano ridotto. Per gli sviluppatori, questi moduli rappresentano anche la parte più complessa ma affascinante: richiedono competenze di AI e ottimizzazione, ma il framework modulare del progetto permette di integrarle gradualmente e migliorarle nel tempo senza riscrivere l’intera piattaforma.

## Diagrammi di Architettura
Di seguito sono presentati i **diagrammi architetturali e i flussi principali** della piattaforma Smart Camera Network. L'obiettivo è illustrare in modo chiaro i componenti del sistema e le interazioni tra di essi, nonché il percorso dei dati dal dispositivo (telecamera o sensore) fino all'utente finale e viceversa. 

L'architettura è suddivisa in livelli e moduli per separare le responsabilità e facilitare la scalabilità:

- **Livello Dispositivi (Edge)**: include le **Telecamere IP** e i **dispositivi IoT** (es. lampioni smart, sensori). Questi sono i produttori di dati (video, eventi) e attuatori di comandi nell'ambiente reale.
- **Livello di Rete/Trasporto**: concerne i protocolli di comunicazione che collegano i dispositivi al core (Ethernet/WiFi per le telecamere, Zigbee/WiFi per IoT, IP per tutto il traffico dati, con cifratura TLS dove indicato).
- **Livello Server (Core Platform)**: costituito da vari **moduli backend**:
  - *Discovery & Management Service* (gestione telecamere),
  - *Streaming/Media Service*,
  - *AI Analytics Service*,
  - *IoT Integration Service*,
  - *Database*,
  - *API Backend* (che espone servizi al frontend e coordina gli altri moduli).
- **Livello Applicazione (Client)**: la **Dashboard UI** e eventuali applicazioni esterne integrate via API.

Per maggiore chiarezza, descriviamo alcuni flussi specifici con passi numerati:

### Flusso di Scoperta e Registrazione Telecamere
1. **Scoperta**: Il **Discovery Service** (parte del backend) invia un messaggio WS-Discovery multicast nella LAN. Ogni **Telecamera IP** compatibile risponde con le proprie informazioni (endpoint ONVIF).
2. **Raccolta info**: Il Discovery Service chiama l’API ONVIF *GetDeviceInformation* su ogni telecamera trovata, ottenendo dettagli (modello, numero seriale, capacità).
3. **Salvataggio**: I dati base della telecamera vengono salvati nel **Database** (tabella `cameras`), con stato "discovered". Se la telecamera richiede credenziali, rimane inattiva finché l’utente non le fornisce.
4. **Registrazione via UI**: L'**utente amministratore** vede nell'UI la lista di nuovi dispositivi trovati. Tramite la **Dashboard** (frontend) invia al **Backend API** i dati per aggiungere la telecamera (es. ID scoperta + credenziali + nome assegnato).
5. **Verifica credenziali**: Il Management Service tenta un login ONVIF con user/password forniti. Se ha successo, marca la camera come "attiva".
6. **Configurazione iniziale**: Il sistema crea entry di configurazione default: quale profilo streaming usare, se attivare analisi AI su quella camera, ecc., personalizzabili poi dall’utente.
7. **Pronta all’uso**: La telecamera appare ora nella Dashboard come *Online*. Il **Streaming Service** può immediatamente iniziare a estrarre il flusso video se richiesto, e l’**Analytics Service** inizia (se abilitato) a elaborare quel flusso.

### Flusso di Streaming Video Live (User viewing)
1. **Richiesta utente**: L’utente seleziona dalla Dashboard la telecamera da visualizzare live. Il front-end invia una richiesta al `Backend API` (es. `GET /api/cameras/5/stream`).
2. **Handshake**: Il **API Backend** autentica la richiesta (utente ha accesso?) quindi interagisce con il **Streaming/Media Service**:
   - Se si usa WebRTC, il server genera un SDP offer e la invia al client, aspettando l’answer e configurando la connessione peer-to-peer sicura.
   - Se si usa HLS, il server fornisce un URL (playlist .m3u8) da cui il client inizierà a caricare segmenti.
3. **Recupero del flusso**: Il Media Service apre la connessione RTSP alla **Telecamera IP** (usando credenziali dal Database). Riceve il flusso video (RTP) e:
   - O lo **ritrasmette** direttamente al client (nel caso WebRTC, rigira il pacchetti come media server SFU, o li converte in WebRTC MediaStream).
   - Oppure lo **transcodifica**/segmenta in HLS: pacchettizza in chunk di pochi secondi e li rende disponibili via HTTP.
4. **Visualizzazione**: Sul browser dell’utente, il player video inizia a riprodurre il flusso live. Se l'utente disconnette o chiude il player, il front-end comunica al backend di chiudere quella sessione (liberando risorse RTSP).
5. **PTZ (se applicabile)**: Eventuali comandi PTZ mentre si guarda il video (es. l'utente muove la camera) seguono un flusso parallelo: front-end invia comando REST, il **Backend API** inoltra al **PTZ Controller** (parte del Management Service) che invia il comando ONVIF alla telecamera. La telecamera si muove e il cambiamento è subito visibile nel video in corso.
6. **Eventi in overlay**: Se il **Analytics Service** genera metadati (ad es. rileva una persona e disegna un bounding box), questi vengono inviati in tempo reale al front-end (via WebSocket). La Dashboard può sovrapporre grafica al video (es. riquadri, icone) per mostrare tali informazioni live all'utente.

### Flusso di Analisi e Automazione IoT (Evento -> Azione)
1. **Input AI**: Il **Analytics Service** riceve costantemente frame/video dalla **Telecamera** (direttamente via RTSP secondario, o dal Media Service che duplica il flusso per analisi). Su questi frame esegue l’**AI Video Analysis**.
2. **Detezione evento**: Supponiamo che il modulo AI rilevi un **evento** (es: persona non autorizzata di notte). Il Analytics Service crea un oggetto evento con dettagli (tipo, timestamp, camera, magari un'immagine ritagliata del volto).
3. **Notifica evento**: Questo evento viene inviato al **Event Manager** interno:
   - Salvato nel **Database** (tabella `events` con tipo, orario, riferimenti a eventuali file snapshot).
   - Propagato via **WebSocket**/notifica alla **Dashboard UI** (così compare in lista eventi immediatamente).
   - Passato al **Rules Engine** per valutare azioni automatiche.
4. **Regola IoT scatenata**: Il Rules Engine verifica che l’evento “persona rilevata” in orario notturno e area X corrisponde a una regola di automazione "Accendi luci area X". Allora coinvolge il **IoT Integration Service**.
5. **Comando IoT**: Il IoT Service pubblica un messaggio MQTT al **Broker** con topic associato alle luci dell'area X (oppure chiama l’API del gateway Zigbee locale). Il payload indica di accendere le luci a piena intensità.
6. **Azionamento**: I **Lampioni Smart** dell'area X, iscritti al topic o collegati al gateway, ricevono il comando e si accendono. Se previsti, inviano un feedback (es. conferma accensione) al broker, che il IoT Service intercetta e logga.
7. **Feedback utente**: La Dashboard potrebbe aggiornare una sezione "Stato IoT" indicando che l’azione (luci accese) è stata eseguita. In caso di mancata conferma, potrebbe allertare l’operatore (es. "Luci area X non rispondono").
8. **Escalation**: Contestualmente, il sistema può eseguire altre azioni: inviare una notifica push a un addetto, attivare una registrazione video continua sull'evento, ecc., a seconda della configurazione delle regole.

**Schema riassuntivo dei componenti e interazioni (rappresentazione testuale):**

```
[ Telecamere IP ]  <-- video (RTSP) -->  [ Streaming Service ]  <-- video (HLS/WebRTC) -->  [ Dashboard UI ]
     |    \                              |                                         ^
     |     \-- controllo (ONVIF PTZ) --> |                                         |  (HTTPS/WebSocket)
     |                                  |                            eventi/alert |
     |    -- discovery (WS-Discovery) --> [ Discovery/Management Service ]         |
     |                                  |         |                     ^          |
     |                                  |         | (DB queries)        |          |
     |                                  |         v                     |          |
     |                                  |      [ Database ]            |          |
     |                                  |                              |          |
     |                                  |-- metadata --> [ Analytics/AI Service ]  |
     |                                                   (analizza video)    |     |
     |                                                        |             |     |
     \-- ingressi digitali (allarmi) --> [ Event Manager ] <--/             |     |
                                          |    \___ regole ___ [ IoT Service ] --/      (MQTT)
                                          |               \__ comandi __ [ Smart Lights ]
                                          \__ notifiche __→ [ Dashboard UI ]
```

*(Legenda: linee continue rappresentano flussi dati principali; linee tratteggiate azioni di controllo o flussi interni. Ad esempio, Telecamere → Streaming Service è il flusso video RTSP; Dashboard UI ↔ Backend sono API/WS; Analytics Service ↔ IoT/Events sono flussi di eventi interni.)*

In termini di **infrastruttura**, tutti questi componenti possono risiedere su uno o più server:
- In un'installazione minima, un unico server fisico/vm esegue tutti i servizi (Discovery, Streaming, AI, IoT, DB, API).
- In ambienti più grandi, si scalano separatamente: ad esempio un server GPU dedicato all'AI, istanze multiple del Streaming Service dietro un load balancer per servire molti client, un cluster del database per alta affidabilità.
- I moduli comunicano su una rete locale ad alta velocità. L’uso di container e orchestratori (Docker/Kubernetes) è possibile per gestire i microservizi e garantirne il riavvio/monitoraggio continuo.

**Interazioni tra moduli principali:**
- Il **Backend API** è il gatekeeper: riceve richieste UI e coordina Discovery, DB, Streaming, IoT. È stateless (scala orizzontalmente se servono più accessi concorrenti).
- Il **Database** funge da memoria centrale: tutte le componenti vi attingono per info persistenti (lista telecamere, utenti, eventi storici). Si utilizzano transazioni e indici per mantenere consistenza e performance.
- I moduli **Analytics** e **IoT** spesso lavorano in background: subscribono a code di messaggi. In implementazione si può usare un message broker interno (es. RabbitMQ, Redis pub/sub) dove il Event Manager pubblica gli eventi e diversi consumer (notifiche UI, IoT, registrazione su DB) li processano in parallelo. Questo disaccoppiamento aumenta la resilienza: se un modulo è temporaneamente offline, il messaggio resta in coda.

I diagrammi e descrizioni sopra mostrano come il sistema è pensato per essere **modulare, scalabile e chiaro** nelle interazioni. Ogni flusso evidenzia come i dati passano attraverso i livelli, permettendo agli sviluppatori di localizzare facilmente dove implementare funzionalità o diagnosticare problemi (ad es. se un video non arriva in UI, si verifica Streaming Service, poi connessione RTSP, ecc). Il design a micro-moduli inoltre facilita aggiornamenti: si può migliorare il singolo modulo AI o aggiungere un nuovo tipo di sensore IoT senza dover ridisegnare l'intero sistema.

## Esempi di Codice
Per aiutare lo sviluppo e l'integrazione rapida, forniamo alcuni **snippet di codice** rappresentativi di operazioni comuni nel progetto Smart Camera Network. Questi esempi illustrano come utilizzare librerie e protocolli chiave (ONVIF, RTSP, MQTT, OpenCV, ecc.) all'interno del sistema. I frammenti sono semplificati per chiarezza, ma mostrano le best practice di implementazione.

### 1. Connessione ONVIF e recupero streaming (Python)
Utilizziamo la libreria `onvif-zeep` in Python per connettersi a una telecamera ONVIF, ottenere i profili media e l’URI RTSP del flusso principale:

```python
from onvif import ONVIFCamera

# Connessione alla telecamera ONVIF
cam_ip = '192.168.1.10'
cam_port = 80  # porta servizio ONVIF (80 per HTTP, 443 se HTTPS)
username = 'admin'
password = 'mySecurePass'

camera = ONVIFCamera(cam_ip, cam_port, username, password)  # connessione SOAP
media_service = camera.create_media_service()

# Ottenere i profili media disponibili sulla camera
profiles = media_service.GetProfiles()  
profile = profiles[0]  # selezioniamo il primo profilo (di solito flusso principale)

# Richiedere l'URI RTSP del profilo selezionato
stream_setup = {
    'StreamSetup': {
        'Stream': 'RTP-Unicast',
        'Transport': {'Protocol': 'RTSP'}
    },
    'ProfileToken': profile.token
}
stream_uri = media_service.GetStreamUri(stream_setup)
print("RTSP URL:", stream_uri.Uri)
```

**Spiegazione:** Dopo aver creato l'oggetto `ONVIFCamera`, otteniamo il servizio media e i profili video. Il profilo contiene configurazioni di codec/risoluzione; passiamo il token del profilo a `GetStreamUri` per ottenere l'URL RTSP. In output ad esempio potremmo ottenere qualcosa come:  
`RTSP URL: rtsp://192.168.1.10:554/Streaming/Channels/101`  

A questo punto, il backend utilizzerà questo URL per aprire il flusso video (direttamente con OpenCV/FFmpeg o inoltrandolo a client).

### 2. Apertura di un flusso RTSP con OpenCV (Python)
Spesso è utile verificare un flusso video o acquisire frame per l'analisi. OpenCV semplifica questo tramite `VideoCapture`:

```python
import cv2

rtsp_url = "rtsp://admin:mySecurePass@192.168.1.10:554/Streaming/Channels/101"
cap = cv2.VideoCapture(rtsp_url)

if not cap.isOpened():
    print("Errore: impossibile aprire il flusso RTSP")
    exit()

# Leggere qualche frame di esempio
ret, frame = cap.read()
if ret:
    print(f"Frame acquisito - dimensioni: {frame.shape}")  # ad es. (1080, 1920, 3)
    cv2.imwrite("snapshot.jpg", frame)  # salva un fotogramma su disco
else:
    print("Nessun frame letto dal flusso (stream vuoto o auth fallita)")

cap.release()
```

Questo codice tenta di connettersi al flusso RTSP usando le credenziali incluse nell'URL. Se riesce, legge un frame e lo salva come immagine. Nella pratica del progetto, potremmo integrare qualcosa di simile nel modulo di **health check** per verificare periodicamente che i flussi siano attivi, oppure nel modulo analytics per ottenere frame da elaborare.

### 3. Pubblicazione di un messaggio MQTT (Python)
Per interagire con l’IoT (es. accendere una luce), usiamo il protocollo MQTT. Di seguito un esempio con la libreria `paho-mqtt` che invia un comando:

```python
import paho.mqtt.client as mqtt

broker_address = "iot.smartcity.local"
broker_port = 1883  # porta MQTT non cifrata (per TLS sarebbe 8883)
topic = "city/area1/lights/cmd"
message = "ON"

# Connessione al broker MQTT
client = mqtt.Client("camera_server_1")  # id client MQTT
# Se il broker richiede credenziali:
# client.username_pw_set("mqtt_user", "mqtt_password")
client.connect(broker_address, broker_port, keepalive=60)

# Pubblicazione del messaggio
result = client.publish(topic, message)
status = result[0]
if status == 0:
    print(f"Messaggio inviato a {topic}: {message}")
else:
    print(f"Errore durante l'invio del messaggio a {topic}")

client.disconnect()
```

Questo snippet connette al broker locale e invia il messaggio `"ON"` sul topic `city/area1/lights/cmd`. Nel nostro sistema, i lampioni dell'area1 dovrebbero essere sottoscritti a quel topic (direttamente o tramite un gateway). In pratica, il modulo IoT del backend eseguirà qualcosa di simile quando scatta la regola di automazione.

**Best practice MQTT:** usare *Quality of Service* adeguato. Qui usiamo QoS=0 (fire-and-forget). Per comandi critici (accendere luci di sicurezza) potremmo usare QoS=1 (almeno once) per avere garanzia di consegna. Inoltre, in produzione, la connessione MQTT sarà su TLS con autenticazione per sicurezza.

### 4. Rilevamento volti in un frame (Python OpenCV)
Mostriamo un esempio di come individuare volti in un'immagine usando OpenCV e un modello pre-addestrato (Haar cascade):

```python
import cv2

# Carica il classificatore Haar per volti (in OpenCV)
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")

# Leggi un frame di esempio (dal file o da VideoCapture in real-time)
frame = cv2.imread("snapshot.jpg")
gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

# Rileva volti nell'immagine
faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))
print(f"Trovati {len(faces)} volti nel frame")
for (x, y, w, h) in faces:
    # Disegna un rettangolo attorno ad ogni volto rilevato
    cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)

cv2.imwrite("faces_detected.jpg", frame)
```

Questo codice è illustrativo: in un contesto reale useremmo algoritmi più robusti (reti neurali CNN) per il riconoscimento facciale, ma il procedimento generale resta:
1. Convertire frame in scala di grigi.
2. Applicare modello di detection (Haar Cascade o DNN).
3. Ottenere bounding box dei volti e usarli (per riconoscimento o tracking).

Nel sistema, una volta ottenuto il bounding box, potremmo estrarre quella regione e confrontarla con il database dei volti noti (embedding con modello pre-addestrato tipo FaceNet + coseno di similarità).

### 5. Esempio di regola di automazione (pseudo-code)
Per illustrare come potrebbe apparire una regola evento->azione nel sistema (in pseudo-codice Python):

```python
# Esempio: regola per accendere luci al rilevamento movimento notturno
def on_event_detected(event):
    # event contiene: type, camera_id, timestamp, metadata...
    if event.type == "motion" and event.camera.zone == "Area Parco":
        hour = event.timestamp.hour
        if  hour >= 20 or hour < 6:  # fascia notturna 20:00 - 06:00
            # Pubblica comando MQTT per luci dell'Area Parco
            mqtt_client.publish("city/areaparco/lights/cmd", "ON")
            # Log dell'azione intrapresa
            log.info(f"Luci Area Parco accese per evento motion (camera {event.camera.id})")
```

Questo pseudo-codice sarebbe parte del modulo di Event Handling. In pratica, il sistema potrebbe rappresentare le regole in un formato di configurazione (es. JSON o DSL semplice) che poi viene interpretato da un motore, oppure come nel caso sopra integrarle in funzioni Python se è un sistema più chiuso.

### Best practice nei codici:
- Gestire eccezioni e riconnessioni: ad esempio, se `ONVIFCamera` lancia eccezione (camera non raggiungibile), catturarla e fornire messaggio utile.
- **Resource cleanup**: assicurarsi di rilasciare connessioni (come `cap.release()` e `client.disconnect()` negli esempi) per non esaurire risorse.
- **Threading**: il codice di esempio è sequenziale; nel sistema reale, la lettura di flussi e l’elaborazione AI avvengono in thread o processi separati, per non bloccare l’esecuzione.
- **Uso di config**: indirizzi IP, credenziali, topic MQTT, ecc., dovrebbero provenire da un file di configurazione, non essere hardcoded. Negli snippet li abbiamo messi inline per semplicità.
- **Logging**: come mostrato, è importante loggare le azioni intraprese (ad es. accensione luci). Usare un logging centralizzato e livelli adeguati (info, warning, error) aiuta durante il debug.

Questi esempi offrono un punto di partenza. Gli sviluppatori possono utilizzarli come base e adattarli nel contesto del progetto completo. In particolare, librerie come `onvif`, `paho-mqtt`, e OpenCV sono strumenti potenti per implementare rapidamente funzionalità chiave, mentre il design modulare consente di isolarle e testarle in modo indipendente.

## Strategia Disruptive e Potenziale di Espansione
**Smart Camera Network** adotta una strategia tecnologica _disruptive_ nel campo della videosorveglianza e della gestione urbana, introducendo innovazioni che superano i limiti dei sistemi tradizionali. Analizziamo l'impatto tecnologico e le possibili direzioni di espansione futura della piattaforma:

- **Interoperabilità aperta**: L'uso di standard aperti come ONVIF, MQTT, Zigbee ecc. rende il sistema **indipendente dal fornitore**. Questo rompe il classico lock-in dei sistemi di videosorveglianza chiusi (in cui telecamere e software devono essere della stessa marca). La piattaforma può integrare qualsiasi dispositivo conforme agli standard, offrendo libertà di scelta e favorendo un ecosistema eterogeneo. Ciò è disruptive in quanto spinge verso un **mercato più aperto**, dove l’innovazione è guidata dall’integrazione di componenti migliori da diversi vendor.
- **Integrazione convergente di domini**: Tradizionalmente, la sorveglianza CCTV, l'illuminazione pubblica, i sensori ambientali, etc., sono gestiti da sistemi separati. La nostra piattaforma li **converge** in un unico cervello. Questa sinergia (es. telecamera + luce + AI) crea nuove possibilità: illuminazione on-demand, risposte automatiche a situazioni, ottimizzazione energetica basata su reale utilizzo. In una smart city, avere un hub unico che coordina video e IoT è un cambio di paradigma (disruptive rispetto alla gestione a silos). In futuro, si potrebbero aggiungere altri domini: controllo traffico (semafori adattivi in base a flusso rilevato dalle cam), gestione rifiuti (telecamere che monitorano cassonetti e notificano riempimento), etc.
- **Architettura scalabile e cloud-ready**: Il design modulare consente facilmente di spostare carichi nel cloud o edge computing. Ad esempio, un'espansione potrebbe vedere centinaia di telecamere distribuite in una città: si possono collocare mini-server edge in quartieri (per elaborare AI localmente) e avere un cloud centrale per l’orchestrazione e storage a lungo termine. La piattaforma supporta tali evoluzioni. Inoltre, si presta a un modello SaaS: un fornitore di sicurezza potrebbe offrire Smart Camera Network come servizio gestito multi-tenant per vari clienti, scalando le risorse su Kubernetes. Questa flessibilità di deployment è fondamentale per l’espansione commerciale in diversi scenari (dalla singola azienda fino alla città intera).
- **Miglioramento continuo con AI**: L'adozione dell’AI posiziona la piattaforma all’avanguardia. Col tempo, i modelli di machine learning possono essere affinati (magari addestrando su dati specifici della città per aumentare accuratezza su scenari locali). Inoltre, l'AI consente di **estrarre dati** preziosi: una città può capire pattern di utilizzo degli spazi pubblici, un’azienda può analizzare produttività o sicurezza interna, e così via. La piattaforma dunque non è statica, ma **impara e migliora** con l’uso, offrendo sempre maggior valore. Questo è un cambiamento radicale rispetto ai DVR analogici del passato.
- **Focus sulla comunità degli sviluppatori**: Rendendo la piattaforma modulare, documentata (es. con un README come questo) e con API aperte, si incoraggia una **community di sviluppatori** ad estenderla. Plugin di terze parti potrebbero aggiungere riconoscimento di situazioni specifiche (es. rilevazione incendio da video, moduli di conteggio persone per retail, ecc.), oppure integrazioni con sistemi di terze parti (es. Home Assistant per la domotica). In questo senso, Smart Camera Network si pone come **piattaforma** e non solo prodotto finito, catalizzando innovazione crowdsourced. L'approccio ricorda quello di piattaforme come Home Assistant nel mondo IoT domestico, ma applicato su scala professionale/urbana.
- **Espansione funzionale**: Oltre a luci e sorveglianza, la struttura può inglobare nuovi moduli:
  - **Audio analytics**: microfoni collegati per rilevare suoni (vetro rotto, urla, spari) e correlare con video.
  - **Controllo accessi**: integrazione con serrature smart, lettori badge, in modo che il riconoscimento facciale sblocchi una porta se persona autorizzata.
  - **VR/AR**: in futuro, un operatore con visore AR potrebbe vedere sovraimposte info sulle telecamere (es. identità persone riconosciute in real time).
  - **Big data e dashboard strategiche**: aggregando dati di più città/impianti, si potrebbero trovare metriche globali, tendenze di sicurezza, mappe di calore cittadine multi-sorgente. Un amministratore pubblico potrebbe avere un **cruscotto unico** per monitorare sicurezza, traffico, illuminazione, ambiente.
- **Impatto socio-economico**: Una piattaforma del genere può migliorare la **sicurezza percepita** e reale, ottimizzare costi (meno spreco di luce, meno interventi umani se non necessari) e creare nuovi servizi (es. parcheggi intelligenti se le telecamere rilevano posti liberi, guida ai soccorsi se viene rilevato un incidente su strada e luce automatica illumina la scena). La disruptiveness sta anche nel far convergere obiettivi di **sicurezza** e **efficienza**. Ad esempio, una città potrebbe giustificare l’installazione di più telecamere non solo per sorveglianza, ma anche perché apportano risparmi energetici tangibili grazie all’automazione luci.
- **Standard di sicurezza elevati**: Ponendo gran attenzione a cybersecurity e privacy, la piattaforma si candida a essere **fidata** in contesti critici. Questo è un vantaggio competitivo rispetto a soluzioni DIY o prodotti cinesi a basso costo che spesso presentano falle di sicurezza. In un’epoca di crescenti attacchi IoT, offrire un sistema robusto secondo standard (anche con certificazioni eventuali) è di per sé disruptive poiché sposta l’asticella qualitativa del settore.
- **Adozione e partnership**: Il potenziale di espansione prevede collaborazioni con:
  - Produttori di telecamere e IoT (per garantire compatibilità e magari integrazione nativa con la piattaforma).
  - Fornitori di servizi cloud (per offrire video analytics heavy in cloud, storage illimitato, etc).
  - Pubbliche amministrazioni per progetti pilota di smart city, che fungano da vetrina.
  - Comunità open-source: se il progetto venisse reso open source o con SDK pubblici, sviluppatori indipendenti potrebbero contribuire, migliorando e diffondendo la piattaforma a un ritmo maggiore.
  
In sintesi, Smart Camera Network punta a **rivoluzionare** il modo in cui pensiamo alla videosorveglianza: non più un sistema isolato di telecamere a circuito chiuso, ma un **nervo intelligente** inserito nel sistema nervoso della città o dell’infrastruttura aziendale. Questa visione olistica è ciò che la rende disruptive. Il potenziale di crescita è ampio: partendo dal core attuale (cam + luci), può evolvere in un **framework generale di Smart City**, integrando sempre più funzioni e dati (dall'illuminazione al traffico, dalla sicurezza al comfort dei cittadini).

Grazie alla sua architettura modulare e aperta, il sistema è pronto a **adattarsi ed espandersi** secondo le esigenze future, garantendo così longevità al progetto e un continuo allineamento con i progressi tecnologici. L'auspicio è che questa piattaforma non solo risolva problemi attuali, ma **stimoli nuove idee** su come utilizzare la combinazione di visione artificiale e IoT per rendere le nostre città e i nostri spazi più sicuri, efficienti e vivibili. 
