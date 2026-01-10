## General Rules

- Always check for existing code patterns before implementing new features.
- Always follow the established coding style and conventions in each directory.
- Never modify files outside of the current working project directory.
- Never perform destructive git operations (ie. commit, push, pull, etc.)
    - Always let me review your changes as unstaged changes and let me manage my own git worktree / staging area
- When I follow-up with you requesting changes, please re-read the affected files as I may have changed things since you last looked.

## Code Style Rules

- Could should read like well-written prose.
- Avoid unnecessary code comments. Variable and method names should be obvious. Logic should make sense.
- Public interfaces should feel natural and discoverable.
- Avoid nested ternary operators - prefer match expressions, switch statements, or if/else chains for multiple conditions.
- Choose clarity over brevity - explicit code is often better than overly compact code.

## Rules for Laravel projects

- Follow Laravel conventions. Don't fight the framework.
- Use proper error handling patterns (exceptions, custom exception classes)
- Maintain consistent naming conventions (PSR-12, Laravel standards).

### Controllers

When creating or modifying controllers, please think about the "Cruddy by Design" pattern popularized by Adam Wathan.

- `GET` `/users` - maps to the controller's `index` method
- `POST` `/users` - `store` method
- `GET` `/users/{id}` - `show` method
- `GET` `/users/{id}/edit` - `edit` method
- `PATCH` `/users/{id}/edit` - `update` method
- `DELETE` `/users/{id}` - `destroy` method

When something doesn't fit into one of these cases, please create an invokable controller. For example: `ExportUsersController`

## Rules for JavaScript projects

- Please don't run Vite commands, like `npm run dev` or `npm run build`. I usually already have the Vite server running.
- When running tests with Vitest, please ensure the Chromium instance opens in the background.
