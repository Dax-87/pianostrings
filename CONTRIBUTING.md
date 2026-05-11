# Contributing to PianoStringDB

PianoStringDB relies on community contributions to grow its database of piano models. Anyone can contribute — no programming skills required!

## How it works

1. You provide the **string section data** for a piano model
2. We review and approve it
3. It becomes available in the public database

## What you need to know

Piano strings are grouped into **sections** — consecutive strings that share the same steel gauge, type (plain or wound), and copper winding specifications.

You only need to know:
- The **gauge number** (European standard) for each section
- The **string numbers** where each section starts and ends
- The **type** (plain steel, single wrap, or double wrap)
- The **copper winding gauge** (for wound strings only)

The system automatically calculates:
- Diameter in mm
- Weight in g/m
- Tension in kg

## How to contribute

### Option A: Web form (quick)

Go to the [PianoStringDB web app](https://pianostrings.vercel.app), click the **Contribute** tab, fill out the form and submit. Data will be reviewed by an admin.

You can also **upload a YAML file** using the drag & drop area in the Contribute page — the form will auto-fill.

### Option B: GitHub Pull Request (recommended for frequent contributors)

1. **Copy the template:** Open [`contrib/example.yaml`](contrib/example.yaml) and copy its contents

2. **Create a new file on GitHub:**
   - Go to https://github.com/Dax-87/pianostrings
   - Click "Add file" → "Create new file"
   - Name it `contrib/your-brand-model.yaml` (e.g. `contrib/yamaha-u3.yaml`)

3. **Fill in the data:**

```yaml
brand: Yamaha
model: U3
model_name: U3 — 131 cm upright
total_strings: 88
contributor: Your Name
contributor_email: your@email.com
sections:
  - from: 1   to: 8   type: wound2  gauge: 14  copper1: 12  copper2: 6
  - from: 9   to: 16  type: wound1  gauge: 17  copper1: 8
  - from: 17  to: 46  type: plain   gauge: 17
  - from: 47  to: 51  type: plain   gauge: 16.5
  - from: 52  to: 56  type: plain   gauge: 16
  ...
  - from: 83  to: 88  type: plain   gauge: 13
```

4. **Save and submit a Pull Request**

That's it! We'll review and approve your contribution.

## Section types

| Type | Meaning | Example |
|---|---|---|
| `plain` | Bare steel wire | Treble strings |
| `wound1` | Steel core + single copper wrap | Mid-low bass |
| `wound2` | Steel core + double copper wrap | Lowest bass |

## Tips

- The lowest string is **1** (A0), the highest is **88** (C8)
- Sections must cover all 88 strings without gaps or overlaps
- If you don't know the copper winding data, you can omit `copper1`/`copper2`
- European gauge numbers are decimal (e.g. 13.5, 16.5, etc.)
- Not sure about the data? Submit what you have and note it in the PR — we can help fill gaps

## Need help?

Open an issue on GitHub with your piano model and any data you have.
