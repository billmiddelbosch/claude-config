---
name: apify-lead-generation
description: "Genereert B2B/B2C leads door het scrapen van Google Maps, websites, Instagram, TikTok, Facebook, LinkedIn, YouTube en Google Search. Gebruik wanneer de gebruiker vraagt om leads, prospects of bedrijven te vinden..."
---

# Lead Generatie

Schraapt leads van meerdere platforms met Apify Actors.

## Vereisten
(Hoeft niet vooraf gecontroleerd)

- `.env` bestand met `APIFY_TOKEN`
- Node.js 20.6+ (voor native `--env-file` ondersteuning)
- `mcpc` CLI tool: `npm install -g @apify/mcpc`

## Werkstroom

Kopieer deze checklist en volg de voortgang:

```
Taak Voortgang:
- [ ] Stap 1: Bepaal lead bron (selecteer Actor)
- [ ] Stap 2: Haal Actor schema op via mcpc
- [ ] Stap 3: Vraag gebruikersvoorkeuren (formaat, bestandsnaam)
- [ ] Stap 4: Voer het lead finder script uit
- [ ] Stap 5: Vat resultaten samen
```

### Stap 1: Bepaal Lead Bron

Selecteer de juiste Actor op basis van gebruikersbehoefte:

| Gebruikersbehoefte | Actor ID | Best Voor |
|-------------------|----------|----------|
| Lokale bedrijven | `compass/crawler-google-places` | Restaurants, sportscholen, winkels |
| Contact verrijking | `vdrmota/contact-info-scraper` | E-mails, telefoons van URLs |
| Instagram profielen | `apify/instagram-profile-scraper` | Influencer discovery |
| Instagram posts/reacties | `apify/instagram-scraper` | Posts, reacties, hashtags, locaties |
| Instagram zoeken | `apify/instagram-search-scraper` | Locaties, gebruikers, hashtags ontdekking |
| TikTok videos/hashtags | `clockworks/tiktok-scraper` | Uitgebreide TikTok data extractie |
| TikTok hashtags/profielen | `clockworks/free-tiktok-scraper` | Gratis TikTok data extractor |
| TikTok gebruiker zoeken | `clockworks/tiktok-user-search-scraper` | Vind gebruikers op trefwoorden |
| TikTok profielen | `clockworks/tiktok-profile-scraper` | Creator outreach |
| TikTok volgers/volgend | `clockworks/tiktok-followers-scraper` | Doelgroepanalyse, segmentatie |
| Facebook paginas | `apify/facebook-pages-scraper` | Zakelijke contacten |
| Facebook pagina contacten | `apify/facebook-page-contact-information` | Extraheer e-mails, telefoons, adressen |
| Facebook groepen | `apify/facebook-groups-scraper` | Koopintentie signalen |
| Facebook evenementen | `apify/facebook-events-scraper` | Event networking, partnerships |
| Google Search | `apify/google-search-scraper` | Brede lead discovery |
| YouTube kanalen | `streamers/youtube-scraper` | Creator partnerships |
| Google Maps e-mails | `poidata/google-maps-email-extractor` | Directe e-mail extractie |

### Stap 2: Haal Actor Schema Op

Haal het input schema en details van de Actor dynamisch op met mcpc:

```bash
export $(grep APIFY_TOKEN .env | xargs) && mcpc --json mcp.apify.com --header "Authorization: Bearer $APIFY_TOKEN" tools-call fetch-actor-details actor:="ACTOR_ID" | jq -r ".content"
```

Vervang `ACTOR_ID` met de geselecteerde Actor (bijv. `compass/crawler-google-places`).

Dit geeft terug:
- Actor beschrijving en README
- Vereiste en optionele input parameters
- Output velden (indien beschikbaar)

### Stap 3: Vraag Gebruikersvoorkeuren

Vraag vooraf:
1. **Output formaat**:
   - **Snel antwoord** - Toon top resultaten in chat (geen bestand opgeslagen)
   - **CSV** - Volledige export met alle velden
   - **JSON** - Volledige export in JSON formaat
2. **Aantal resultaten**: Gebaseerd op karakter van use case

### Stap 4: Voer Script Uit

**Snel antwoord (toon in chat, geen bestand):**
```bash
node --env-file=.env ${CLAUDE_PLUGIN_ROOT}/reference/scripts/run_actor.js \
  --actor "ACTOR_ID" \
  --input 'JSON_INPUT'
```

**CSV:**
```bash
node --env-file=.env ${CLAUDE_PLUGIN_ROOT}/reference/scripts/run_actor.js \
  --actor "ACTOR_ID" \
  --input 'JSON_INPUT' \
  --output YYYY-MM-DD_OUTPUT_FILE.csv \
  --format csv
```

**JSON:**
```bash
node --env-file=.env ${CLAUDE_PLUGIN_ROOT}/reference/scripts/run_actor.js \
  --actor "ACTOR_ID" \
  --input 'JSON_INPUT' \
  --output YYYY-MM-DD_OUTPUT_FILE.json \
  --format json
```

### Stap 5: Vat Resultaten Samen

Rapporteer na voltooiing:
- Aantal gevonden leads
- Bestandslocatie en naam
- Beschikbare kernvelden
- Voorgestelde vervolgstappen (filteren, verrijking)

## Error Handling

`APIFY_TOKEN not found` - Vraag gebruiker om `.env` aan te maken met `APIFY_TOKEN=your_token`
`mcpc not found` - Vraag gebruiker om `npm install -g @apify/mcpc` te installeren
`Actor not found` - Controleer Actor ID spelling
`Run FAILED` - Vraag gebruiker om Apify console link in error output te controleren
`Timeout` - Verklein input grootte of verhoog `--timeout`