<?php

/**
 * Opens a local Git repository or worktree in Tower.app
 *
 * Usage: http://duncan.test/tower.php?path=/Users/duncan/Code/Statamic/cms/worktrees/forms-2
 */

const HOME = '/Users/duncan';
const GITTOWER = '/opt/homebrew/bin/gittower';

$path = trim((string) ($_GET['path'] ?? ''));

if (! str_starts_with($path, HOME) || ! is_dir($path)) {
    http_response_code(400);
    exit("Not a directory under ".HOME.": {$path}");
}

exec(sprintf('%s %s > /dev/null 2>&1 &', GITTOWER, escapeshellarg($path)));

echo "Opening {$path} in Tower…<script>setTimeout(() => window.close(), 400)</script>";
