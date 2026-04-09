---
trigger: always_on
---

# Sourdough Project Rules

## Core Directives
1. **Human-in-the-loop**: All generated code requires explicit USER approval before squashing and merging to the `main` branch.
2. **Standardization**: This project relies strictly on the `very_good_analysis` package. Zero warnings or errors are allowed under any circumstance.
3. **Halucination Prevention**: Do not guess at facts. Verify in the documentation using the live search feature

## Workflows & Skills Integration
Always refer to the custom workflows and skills defined natively in the `.agents` directory for step-by-step repeatability:

- **Post-Coding Checks**: After finalizing code in a session, strictly execute the `/post_coding_checks` workflow (`.agents/workflows/post_coding_checks.md`) to run analytics and testing.
- **VCS Commitment**: When staging and committing work, execute the `/git_commit` workflow (`.agents/workflows/git_commit.md`).
- **UI Implementation**: Consult the `.agents/skills/vibecoded_flutter/SKILL.md` skill to ensure every layout component matches the requisite premium aesthetics.

## Global Preferences
- Exclusively use the official Flutter/Dart documentation as your source of truth.
- Consistently keep the aesthetic "vibecoded" (premium UI/UX, transparent glassmorphism, dynamic micro-animations, modern bespoke design).
- Write concise, exact commit messages detailing exactly *what* changed and *why*, avoiding speculative fluff.
