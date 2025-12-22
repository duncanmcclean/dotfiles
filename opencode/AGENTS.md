## General Rules

- Always check existing code patterns before implementing new features. 
- Follow the established coding style and conventions in each directory.
- Never modify files outside of the current working project directory
- Never perform destructive git operations (ie. commit, push, pull, etc.)
    - Always let me review your changes as unstaged changes and let me manage my own git worktree / staging area
- When I follow-up with you requesting changes, please re-read the affected files as I may have changed things since you last looked.

## Code Style

- Please avoid code comments where possible.
    - Code should be readable - variables names should be obvious, logic should make sense.
    - Only add comments when the code is unreadable out of necessity, or we're dealing with complex situations.

## Laravel projects

- When creating or modifying controllers, please think about the "CRUD" controller pattern popularized by Adam Wathan:
    - `GET` `/users` - maps to the controller's `index` method
    - `POST` `/users` - `store` method
    - `GET` `/users/{id}` - `show` method
    - `GET` `/users/{id}/edit` - `edit` method
    - `PATCH` `/users/{id}/edit` - `update` method
    - `DELETE` `/users/{id}` - `destroy` method
    - When something doesn't fit into one of these cases, please make an invokable controller. eg `ExportUsersController`

## JavaScript projects

- Please don't run Vite commmands (like `npm run dev` or `npm run build`). I likely already have a watcher running.
- When running Vitest tests, please ensure the Chromium instance opens in the background.