<?php

/**
 * Opens a local Git repository or worktree in PhpStorm Light
 *
 * Usage: http://duncan.test/phpstorm.php?path=/Users/duncan/Code/Statamic/cms/worktrees/forms-2
 */

const HOME = '/Users/duncan';
const PHPSTORM = '/Applications/PhpStorm Light.app';

$path = trim((string) ($_GET['path'] ?? ''));

if (! str_starts_with($path, HOME) || ! is_dir($path)) {
    http_response_code(400);
    exit("Not a directory under ".HOME.": {$path}");
}

exec(sprintf('open -a %s %s > /dev/null 2>&1 &', escapeshellarg(PHPSTORM), escapeshellarg($path)));

echo "Opening {$path} in PhpStorm Light…<script>setTimeout(() => window.close(), 400)</script>";
