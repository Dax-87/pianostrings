# PianoStringDB — Contributing via YAML

This directory contains YAML contribution files for PianoStringDB.

Each `.yaml` file describes the string sections of a piano model.
To contribute a new model:

1. Copy `example.yaml` to a new file (e.g. `yamaha-u3.yaml`)
2. Edit the brand, model, and sections
3. Submit a Pull Request on GitHub

The admin will review and approve your contribution.

## Format

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
  ...
```

See `example.yaml` for full documentation of all fields.
