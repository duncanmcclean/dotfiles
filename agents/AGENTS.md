## General Rules

- Always check for existing code patterns before implementing new features.
- Always follow the established coding style and conventions in each directory.
- Never modify files outside of the current working project directory.
- When I follow-up with you requesting changes, please re-read the affected files as I may have changed things since you last looked.
- When reporting information to me, be extremely concise and sacrifice grammar for sake of concision.


## Git

- Never perform destructive Git operations without me **explicitly** asking.
- When I ask you to commit changes for me, please follow these rules:
  - Write commit messages in lowercase.
  - Use backticks (```) when mentioning class names, methods or config options.
- Never, under any circumstances, force push.


## Code Style Rules

- Could should read like well-written prose.
- **Avoid unnecessary code comments.** Variable and method names should be obvious. Logic should make sense.
  - I can use `git blame` to find the related commit/PR when a change was introduced, so no need to explain _why_ a change was made especially if the code makes sense by itself.
- Public interfaces should feel natural and discoverable.
- Avoid nested ternary operators - prefer match expressions, switch statements, or if/else chains for multiple conditions.
- Choose clarity over brevity - explicit code is often better than overly compact code.
- Please respect the existing tab/spaces preferences.
- I prefer `private` functions over `protected` functions.
- When adding `private` or `protected` methods, aim to add them directly under the method that uses it, accounting for other methods that method may call first.
- When writing tests, aim to write tests in the order the code happens in. Happy case first, edge cases after.
- When multiple tests do the same thing but the code is slightly different. Consider using a PHPUnit data provider to swap out values.
- Don't introduce an abstraction, like a helper method, if it's short and can inlined in the call site.
- When multiple variables are next to each other, try to organise them based on line length. Obviously, ensure you don't break any "dependencies".
    Bad:
    ```php
    $skipped = false;
    $values = $this->normalizeValues($request);
    $uploaded = [];
    $rejected = [];
    $honeypot = Arr::get($values, 'honeypot');
    ```

    Good:

    ```php
    $uploaded = [];
    $rejected = [];
    $skipped = false;
    $values = $this->normalizeValues($request);
    $honeypot = Arr::get($values, 'honeypot');
    ```


## Rules for Laravel projects

- Follow Laravel conventions. Don't fight the framework.
- Use proper error handling patterns (exceptions, custom exception classes)
- Maintain consistent naming conventions (PSR-12, Laravel standards).
- Please remember to add any new environment variables to `.env.example`
- When writing queries, always use `Model::query()`, rather than going straight into `Model::where()`
  - The only exception to this is using `Model::find()`
- Always add environment variables to the _bottom_ of the `.env.example`


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


## Rules for Vue projects

- Vue components using the Composition API should be organised as follows:
  - Imports
  - TypeScript types
  - Emits
  - Props
  - Injected variables
  - Refs
  - Computed
  - Methods
  - Exposed variables (unless its a Statamic fieldtype)
  - Watchers
  - `onMounted()` / `onBeforeUnmount()`


## Solo

When you're running inside Solo (https://soloterm.com), please follow these rules:

- When I ask you to "spin up agents", I'm asking you to spin up agents via the Solo MCP. Preferrably with the same model as the current session (unless otherwise specified).
- When creating plans or performing research, please create a Scratchpad via the Solo MCP.
