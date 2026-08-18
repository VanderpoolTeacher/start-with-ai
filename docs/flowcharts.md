# How each skill runs

Five diagrams. The thing to watch in each: where the read-only part ends and the
writing starts.

## Business cards

A photo becomes five things. The interesting decision is in the middle — what
happens when a field can't be read.

```mermaid
flowchart TD
    A[Photos arrive] --> B{Where from?}
    B -->|Path in the message| C[Use it as given]
    B -->|Attached in chat| C
    B -->|A folder you name| C
    B -->|Loose on disk| D[Filter by modified time]
    D --> E{More than one<br/>plausible batch?}
    E -->|Yes| F[ASK which one]
    E -->|No| C
    C --> G[Read every card]
    F --> G
    G --> H{Every field<br/>crisply legible?}
    H -->|No| I[Crop · upscale 3x<br/>contrast · sharpen]
    I --> J{Readable now?}
    J -->|No| K[Leave it BLANK<br/>never guess]
    H -->|Yes| L[Extract fields]
    J -->|Yes| L
    K --> M[Show the plan]
    L --> M
    M --> N{Approved?}
    N -->|No| O[Stop]
    N -->|Yes| P[Contact]
    N -->|Yes| Q[Task card]
    N -->|Yes| R[Draft email<br/>UNSENT]
    N -->|Yes| S[Archive original]
    P & Q & R & S --> T[Report what<br/>could not be read]

    style K fill:#7c2d12,color:#fff
    style R fill:#7c2d12,color:#fff
    style M fill:#1f5c4b,color:#fff
```

**The rule that matters:** a guessed email address is worse than a blank one. A
blank field is a question you know to ask. A wrong one is a message that
silently never arrives.

## Morning plan

Everything is read-only until the last step. The plan is proposed, not written.

```mermaid
flowchart TD
    A[Good morning] --> B[Weather<br/>wttr.in · no API key]
    B --> C{Are today's events<br/>in your home city?}
    C -->|No| D[Pull that location too]
    C -->|Yes| E[Today's calendar]
    D --> E
    E --> F[Attach a real address<br/>to every event]
    F --> G[Flag empty or TBD<br/>locations]
    G --> H[Compute travel gaps<br/>in minutes]
    H --> I[Find the collisions]
    I --> I1[Impossible pairs]
    I --> I2[Work running into<br/>family commitments]
    I --> I3[Someone on the calendar<br/>with an open thread]
    I1 & I2 & I3 --> J[Compute REAL open time<br/>minus meetings, minus travel]
    J --> K[Shortlist 5-7 ranked<br/>with a size each]
    K --> L{Pick up to three}
    L -->|No| M[Nothing written]
    L -->|Yes| N[Write calendar blocks]
    N --> O[RE-READ each one]
    O --> P[Name what was NOT picked<br/>as 'not today']

    style M fill:#1f5c4b,color:#fff
    style N fill:#7c2d12,color:#fff
    style O fill:#7c2d12,color:#fff
```

**The rule that matters:** most morning plans fail because they pretend the day
is empty. Subtract the meetings *and* the driving before proposing anything.

## Daily briefing

Four sources read into one context. The reason they're read together is the
correlation step — no single source can see those connections.

```mermaid
flowchart TD
    A[Catch me up] --> B[Establish the window<br/>since last run]
    B --> C[Email]
    B --> D[Calendar]
    B --> E[Tasks]
    B --> F[Chat]
    C --> C1[New to you]
    C --> C2[Gone quiet]
    C --> C3[What you already SENT]
    C --> C4[Your unsent drafts]
    C3 -.->|the trap| G
    C1 & C2 & C4 --> G[Filter]
    D & E & F --> G
    G --> H{Does it pass?}
    H -->|Someone is blocked on you| I[Keep]
    H -->|Due or happening today| I
    H -->|You left it unfinished| I
    H -->|Otherwise| J[Drop it]
    I --> K[CORRELATE across sources]
    K --> K1[Same person twice = ONE line]
    K --> K2[Card due today + meeting today]
    K --> K3[Unsent draft + they followed up]
    K1 & K2 & K3 --> L[Write the briefing]
    L --> M[Max 3 lines in 'needs you today']
    M --> N[Numbered actions<br/>you choose from]

    style C3 fill:#7c2d12,color:#fff
    style K fill:#1f5c4b,color:#fff
    style J fill:#57534e,color:#fff
```

**The rule that matters:** read your own sent mail first. Your reply often lands
in a brand-new thread, so the original still looks like it's waiting on you. A
briefing that says "Adam is blocked on you" two hours after you answered him
destroys trust in the whole report.

## Email triage

The one place where the boundary is absolute.

```mermaid
flowchart TD
    A[What's in my inbox?] --> B[Pull the window]
    B --> C[Drop the noise]
    C --> C1[Newsletters · receipts]
    C --> C2[no-reply senders]
    C --> C3[CC-only threads]
    C --> C4[Calendar accepts]
    C1 & C2 & C3 & C4 --> D[Remaining threads]
    D --> E{Is the LAST message<br/>from someone else?}
    E -->|No| F[You already handled it]
    E -->|Yes| G{Do they need<br/>something from you?}
    G -->|No, it's an FYI| F
    G -->|Yes| H[Genuinely waiting on you]
    H --> I[Say what they WANT<br/>not that mail arrived]
    I --> J{Draft a reply?}
    J -->|Yes| K[Ask clarifying<br/>questions first]
    K --> L[Write it short<br/>one ask, signed]
    L --> M[SAVE AS DRAFT]
    M --> N[You read it]
    N --> O[YOU press send]

    style M fill:#7c2d12,color:#fff
    style O fill:#1f5c4b,color:#fff
    style F fill:#57534e,color:#fff
```

**The rule that matters:** the assistant drafts, the human sends. Not because
the drafts are bad — because a sent email cannot be unsent, and the one time it
gets the tone wrong is the time it goes to the person who matters most.

## Screenshot routing

Extraction and routing are deliberately separate. The gate in the middle is the
whole point: nothing reaches the calendar until a date is anchored to a real
source.

```mermaid
flowchart TD
    A[Screenshots arrive] --> B{One thread or<br/>several?}
    B -->|Several shots<br/>of one thread| C[Stitch in order<br/>ONE extraction]
    B -->|One| C
    C --> D[Extract six fields<br/>source · counterparty · direction<br/>ask · timing · unreadable]
    D --> E{Any field<br/>illegible?}
    E -->|Yes| F[Crop · upscale 4x<br/>contrast · sharpen]
    F --> G{Readable now?}
    G -->|No| H[Mark UNREADABLE<br/>never guess]
    E -->|No| I{Direction<br/>unambiguous?}
    G -->|Yes| I
    H --> I
    I -->|No| J[DIRECTION UNCERTAIN<br/>describe both readings]
    I -->|Yes| K{Timing is<br/>relative?}
    J --> K
    K -->|"Tuesday" / "next week"| L[Mark UNANCHORED]
    L --> M[Try calendar + email<br/>for a second source]
    M --> N{Anchored?}
    N -->|No| O[ASK which date]
    K -->|Absolute date shown| P[Route]
    N -->|Yes| P
    O -.blocks ONLY<br/>the calendar item.-> P
    P --> Q[Calendar<br/>only if anchored]
    P --> R[Task card]
    P --> S[Contact]
    P --> T[Draft reply<br/>USER SENDS]
    Q & R & S & T --> U[Re-read every write]
    U --> V[Report blanks<br/>and dates asked about]

    style H fill:#7c2d12,color:#fff
    style L fill:#7c2d12,color:#fff
    style O fill:#7c2d12,color:#fff
    style T fill:#7c2d12,color:#fff
    style U fill:#1f5c4b,color:#fff
```

**The rule that matters:** never resolve a relative date. A screenshot carries no
year and usually no date, and the file's timestamp is not an anchor — people
screenshot week-old threads. A wrong date does not look wrong. It looks like a
meeting, until nobody is there.

**The second rule:** a blocked date does not freeze the rest. File the task card,
leave the calendar entry pending.
