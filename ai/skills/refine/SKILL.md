---
name: refine
description: My process of "refining" code — making code readable, tested and pointed to the goal.
---

This skill should be used after writing a medium/large PRs. The ultimate goal of this skill is to produce code that _looks_ like it was written by me, rather than a random developer.

Please review the guidelines detailed below and apply them to the relevant files.

## YAGNI

Where possible, I like to follow the YAYNI (You aren't going to need it) princible. In short, we shouldn't add functionality until deemed necessary.

For example:

- We shouldn't try to handle every single possible edge case. Just the ones we know will come up
- When choosing between clean code and a marginal performance benefit, choose clean code
- Before adding a config option, consider whether it's something > 50% of developers will need to change. If it's not, leave it hardcoded for now
- Unless specified, don't create abstractions "just in case"


## Clean up

Look for these patterns in the files we touched and address them:

1. **False starts**: Code that was written as part of an abandoned approach
   - Commented-out alternative implementations
   - Functions/methods that were superseded by a better approach
   - Imports that are no longer needed

2. **Experimental remnants**:
   - Debug logging/console statements added during development
   - Temporary variables or flags used for testing approaches
   - Hardcoded test values that should be parameterized

3. **Duplicated logic**:
   - Multiple ways of doing the same thing where we settled on one
   - Copy-pasted code that can now be consolidated

4. **Naming inconsistencies**:
   - Variables/functions named for the first approach that no longer fit
   - Misleading names from when the implementation was different

Dead code should be deleted. The working approach should be consolidatd into clean, readable code. Files should be renamed to reflect their purpose. The final implementation should follow project conventions.


## Types

- Add parameter & return types to new methods. Don't do this for existing methods unless they already utilize typehints
- On projects with TypeScript, hard coded "string booleans" (eg. `inspectorType: "field"/"section"`) should become enums


## Tests

Writing tests is an important part of the software development process. Please write tests for any bug fixes or new features.

- Don't change existing tests unless necessary
- Don't test edge cases that'll never happen (YAGNI)
- Every PR to fix a bug should include a test
    - That is, unless it's a Vue/JS bug and we don't have JS tests for that project.
    - When fixing an edge case bug, add a docblock with a `@see` comment to mention the issue.


## Code Style

All changes should follow my code style practices detailed in my global `AGENTS.md` file (or `CLAUDE.md` if you're a Claude agent).

Remember to run Laravel Pint when its installed: `./vendor/bin/pint`


## Summary

Report back with:
- Files changed
- What was cleaned up/consolidated/removed
- Any concerns or items that need user input


## Important

- **Don't expand scope** — only touch files related to the recent work
- **Preserve the working solution** — this is about cleaning, not reimplementing
- **Ask if uncertain** — if unsure whether something is a false start or intentional, ask
- **Keep it simple** — the goal is clarity and maintainability, not perfection
