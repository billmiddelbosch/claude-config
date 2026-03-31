---
name: laptop-price-finder
description: >
  Find the current lowest retail price for a laptop matching specific user-provided specifications, and optionally
  assess purchase profitability when an inkoopprijsEur (purchase price) is provided.
  Use this skill whenever the user asks to compare laptop prices, find the cheapest laptop with certain specs,
  check current prices for a specific laptop model, or wants to know where to buy a laptop at the best price.
  Also triggers when the user provides a laptop spec WITH a purchase price and wants to know if buying/reselling makes sense.
  Triggers include: "find me the cheapest laptop with...", "what's the best price for...", "compare prices for...",
  "lowest price for a laptop with [specs]", "where can I buy [laptop] cheapest", "price check on [laptop]",
  "is it worth buying this laptop at €X", "wat is de marge op deze laptop", "zinvol om in te kopen".
  Always use this skill when the user provides laptop specifications and wants to know the retail price or best deal.
---

# Laptop Price Finder

Your goal is to find the current lowest retail price for a laptop matching the user's specifications, then present a clear, actionable summary in the chat.

## Step 0: Gather input

If the user has not yet provided laptop specifications, ask for them before searching. Use the `AskUserQuestion` tool with these two questions:

**Question 1 — Laptop specs:**
> "Geef de laptop specificaties op: merk, model(nummer), CPU, RAM, opslag, schermgrootte en resolutie. JSON-formaat mag ook."

Options to offer:
- "Ik geef de specs hieronder op" (Other — free text)
- "Ik heb alleen een modelnummer" (e.g. "83B4", "21JN")
- "Ik wil zoeken op specs (geen specifiek model)"

**Question 2 — Inkoopprijs (optional):**
> "Heb je een inkoopprijs in euro's? (optioneel — voor margeberekening)"

Options:
- "Ja, ik geef de inkoopprijs op" (Other — free text)
- "Nee, alleen prijsvergelijking"

If the user already provided specs in their message (as JSON, free text, or inline), skip this step entirely and proceed directly to Step 1.

When invoked from the ITGuru purchasing advice dashboard, the input will be a JSON object with these fields:

```json
{
  "rawName":      "HP PROBOOK 450 G11 I7-1355U 512/16 FHD",
  "brand":        "HP",
  "model":        "ProBook 450 G11",
  "cpu":          "Intel Core i7-1355U",
  "ram":          "16GB",
  "storage":      "512GB SSD",
  "screen":       "15.6\"",
  "resolution":   "1920x1080",
  "gpu":          "Intel Iris Xe",
  "inkoopprijsEur": 523.40
}
```

All fields except `rawName` are optional — use whatever is present. `inkoopprijsEur` triggers the margin analysis in Step 5.

## Step 1: Understand the specifications

Extract the key specs from the user's request. These typically include:
- **Brand / model** (e.g. Dell XPS 15, Apple MacBook Air, Lenovo ThinkPad X1 Carbon) — if given
- **CPU** (e.g. Intel Core Ultra 7, AMD Ryzen 7, Apple M4)
- **RAM** (e.g. 16 GB, 32 GB)
- **Storage** (e.g. 512 GB SSD, 1 TB NVMe)
- **Display** (size, resolution — e.g. 15.6" FHD, 14" 2.8K OLED)
- **GPU** (if relevant — discrete or integrated)
- **OS** (Windows, macOS, Linux)
- **Other constraints** (weight, battery life, budget ceiling)
- **inkoopprijsEur** — optional purchase/cost price in euros. When present, triggers a margin analysis (see Step 5).

If the user gave only partial specs, make reasonable assumptions and state them clearly in your response (e.g. "I'm searching for 16 GB RAM / 512 GB SSD unless you specified otherwise").

## Step 2: Search for prices

Run multiple targeted web searches to find current retail listings. Good search query patterns:
- `[brand] [model] [key specs] kopen site:coolblue.nl OR site:bol.com OR site:alternate.nl`
- `[brand model] [RAM] [storage] beste prijs Nederland`
- `[specs] laptop price compare tweakers`

**Only include retailers that deliver in the Netherlands.** Skip:
- Official brand/manufacturer stores (dell.com, lenovo.com, apple.com, hp.com, etc.) — they typically charge MSRP and are not competitive
- Retailers that ship to the US/UK only (bestbuy.com, walmart.com, newegg.com, etc.)

Prioritise these sources:
- **Dutch**: bol.com, coolblue.nl, mediamarkt.nl, alternate.nl, centralpoint.nl, azerty.nl, bechtle.nl
- **Belgian/EU with NL delivery**: amazon.nl, amazon.de (ships to NL), megekko.nl
- **Price aggregators**: tweakers.net/pricewatch (best for NL), geizhals.eu, pricespy.nl

Use `WebSearch` and `WebFetch` to check 3–5 sources. Prioritize sources where you can actually see a current, specific price — not just a category page.

## Step 3: Validate matches

Before reporting a price, verify the listing actually matches the requested specs. Watch out for:
- Different RAM or storage tiers (the €799 version may have 8 GB RAM, not 16 GB)
- Refurbished or open-box listings vs. new
- Bundle prices that inflate the listed total
- Out-of-stock items or pre-orders with uncertain pricing

Only report prices for in-stock, new units (unless the user asked for refurbished).

## Step 4: Present the results

Reply in the chat with a clear, scannable summary. Use this structure:

---

**🏆 Lowest price found**
- **[Product name with exact specs]** — **€[price]** at [Store]
- 🔗 [Direct link to listing]

**Alternatives worth considering**
| Store | Price | Notes |
|-------|-------|-------|
| [Store 2] | €[price] | [e.g. free shipping, in stock today] |
| [Store 3] | €[price] | [e.g. includes warranty, slightly diff config] |

**Notes**
- Prices checked: [today's date]
- Specs matched: [brief confirmation of what you searched for]
- [Any relevant caveats — e.g. "The €799 version at Bol.com has 8 GB RAM; I found 16 GB for €899"]

---

Keep it concise. The user wants to know: what's the cheapest, where to buy it, and whether there are close alternatives. Don't pad with lengthy explanations — let the prices speak.

## Step 5: Margin analysis (only when inkoopprijsEur is provided)

When the input includes an `inkoopprijsEur` field, add a **Inkoopadvies** section after the price results. Use the lowest confirmed retail price you found as the reference selling price.

**Calculations:**
- Marge (€) = laagste verkoopprijs − inkoopprijs
- Marge (%) = (marge / laagste verkoopprijs) × 100

**Price confidence rule — important:** Only use a price for the margin calculation if you found it directly from an actual retailer listing (a specific product page with a visible price). Do not estimate, extrapolate, or derive a price from US market data, general markup assumptions, or regional conversions — these are too unreliable. If you cannot find a confirmed price with reasonable certainty (roughly 80%+ confidence it reflects the actual current NL retail price), show "Niet vastgesteld" in the Laagste verkoopprijs NL and Marge rows, and leave the Advies row blank or note that no margin calculation is possible. Explain briefly in the Basis verkoopprijs row why the price could not be determined.

If the exact spec wasn't found but you found the closest alternative with a confirmed price, use that price but flag the spec difference clearly in the Toelichting row.

**Advice format:**

---
**📊 Inkoopadvies**

| | |
|--|--|
| Inkoopprijs | €[inkoopprijsEur] |
| Laagste verkoopprijs NL | €[prijs] ([winkel]) |
| Marge | €[X] ([Y]%) |
| Basis verkoopprijs | [direct URL to the listing, or if unavailable: one short sentence explaining what the price is based on] |
| Aanbieders in NL | [number of retailers found that deliver in NL, e.g. "3 aanbieders gevonden", or if none: one short sentence] |
| Toelichting | [max 1 sentence of relevant context, e.g. spec mismatch used, model phased out, price estimated — omit row if nothing meaningful to add] |
| Advies | **Zinvol / Twijfelachtig / Niet zinvol** — [1–2 sentence reasoning] |

---

**How to assess the advice:**

The goal is to help the user decide whether buying this laptop to resell in the Netherlands makes commercial sense. Consider three angles:

1. **Marge**: A gross margin below ~15% is generally thin for a reseller (leaves little room for shipping, returns, platform fees, or price competition). Above 25% is healthy. Flag if margin is negative.

2. **Verkoopbaarheid in NL**: Based on what you found during your search — is this model widely available at NL retailers, or hard to find? If it's scarce (few listings, out of stock at major retailers), that's a *positive* signal for a reseller: less direct competition. If it's abundantly available at Bol.com and Coolblue, competition is fierce and the margin will likely erode quickly.

3. **Spec-marktfit**: Is the spec competitive for the price? A laptop with a dated CPU or very limited storage at a high price will be hard to sell even if margin looks OK on paper.

Combine these into a direct verdict in the Advies row: **Zinvol / Twijfelachtig / Niet zinvol**, followed by 1–2 sentences of reasoning. Don't hedge excessively — the user needs a clear steer.

## US→NL prijsafleiding (als NL prijs niet direct gevonden wordt)

Als geen bevestigde NL prijs gevonden wordt maar wel een US retailprijs, kan een schatting afgeleid worden op basis van onderstaande kalibratielijst. Gebruik dit **alleen als informatieve aanvulling** — niet als basis voor de margeberekening. Toon de schatting apart als `Geschatte NL prijs (afgeleid)` in de Basis verkoopprijs rij, en laat Marge en Advies op "Niet vastgesteld" staan.

### Kalibratielijst: bevestigde US/NL prijsparen

Bijgehouden gevallen waarbij zowel een US- als NL-prijs bevestigd is. Gebruik de gemiddelde factor als conversiegrondslag. Voeg nieuwe paren toe zodra je ze bevestigt (US én NL prijs beide direct van een retailpagina).

| Model | Categorie | US prijs (USD) | NL prijs (EUR) | Factor (NL/US) | Bron NL |
|-------|-----------|---------------|----------------|----------------|---------|
| Apple MacBook Air 13" M3 16GB/256GB | Consumer | $1.299 (Apple US) | €999 (YourMacStore) | 0,77 | yourmacstore.nl |
| Apple MacBook Air 13" M3 8GB/256GB | Consumer | $1.099 (Apple US) | €1.279 (bol.com) | 1,16 | bol.com |

*Gemiddelde factor (huidige data): ~0,97 — te vroeg om te vertrouwen op 2 paren, en Apple-prijzen zijn atypisch t.o.v. zakelijke laptops. Voeg meer zakelijke laptop-paren toe voor betrouwbare kalibratie.*

### Hoe de factor toepassen

Bereken: `Geschatte NL prijs = US_prijs_USD ÷ EUR/USD_koers × factor_uit_tabel`

Gebruik bij voorkeur de factor van een model in dezelfde **categorie** (consumer vs. zakelijk, zelfde prijsklasse). Als er onvoldoende vergelijkbare paren zijn (<3 in dezelfde categorie), vermeld dan alleen de US prijs en leg uit dat afleiding nog niet betrouwbaar is.

Toon altijd: *"Geschatte NL prijs: €X (afgeleid van US retailprijs $Y, factor Z — onbevestigd)"*

### Kalibratielijst bijwerken

Wanneer je tijdens een zoekopdracht **zowel** een bevestigde US- als NL-prijs vindt voor hetzelfde model en dezelfde specs: voeg het paar toe aan de tabel hierboven, inclusief categorie, beide prijzen, de berekende factor en de NL-bron.

---

## Tips for better results

- Tweakers.net/pricewatch is one of the best Dutch price comparison tools. Try fetching the search results page directly when looking for NL prices.
- If the exact model isn't found at any NL-delivering retailer, don't just say "not found" — instead offer the **closest available configuration** (e.g. same model with Core Ultra 5 instead of Ultra 7, or 256GB SSD instead of 512GB). Clearly label what spec differs and give a price for that alternative.
- If prices vary between amazon.de and NL retailers, note this only if amazon.de ships to NL at a meaningfully lower price.
- If you can't find a reliable current price after 3–4 searches, be honest: tell the user what you searched for, what you found, and suggest they check tweakers.net/pricewatch directly.
