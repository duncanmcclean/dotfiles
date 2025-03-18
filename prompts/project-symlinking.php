<?php

use function Laravel\Prompts\search;

require __DIR__.'/../../.composer/vendor/autoload.php';

$package = $argv[1] ?? null;

$recommended = [
    '/Users/duncan/Code/Statamic/cms' => 'statamic/cms',
    '/Users/duncan/Code/Statamic/runway' => 'statamic-rad-pack/runway',
    '/Users/duncan/Code/SideProjects/cargo' => 'duncanmcclean/cargo',
    '/Users/duncan/Code/SideProjects/simple-commerce' => 'duncanmcclean/simple-commerce',
];

$projects = collect(scandir('/Users/duncan/Code'))
    ->flatMap(fn (string $directory) => glob("/Users/duncan/Code/{$directory}" . '/*', GLOB_ONLYDIR))

    // Filter out non-PHP projects and "site" projects.
    ->reject(fn (string $directory) => ! file_exists("{$directory}/composer.json"))
    ->filter(function (string $directory) {
        $composerJson = json_decode(file_get_contents("{$directory}/composer.json"), true);

        return isset($composerJson['name']) && ! in_array($composerJson['name'], ['laravel/laravel', 'statamic/statamic']);
    })

    // Map stuff for the select prompt.
    ->mapWithKeys(function (string $directory) {
        $composerJson = json_decode(file_get_contents("{$directory}/composer.json"), true);

        return [$directory => $composerJson['name']];
    });

// When a package is provided as an argument, we can skip the search.
if ($package) {
    $project = $projects->flip()->get($package);
} else {
    $project = search(
        label: 'Which project would you like to symlink?',
        options: fn (string $value) => strlen($value) > 0
            ? $projects->filter(fn ($project) => str_contains($project, $value))->all()
            : $recommended,
    );
}

// Write to a temporary file so we can read it from the Bash script.
$composerJson = json_decode(file_get_contents("{$project}/composer.json"), true);

$vendorName = explode('/', $composerJson['name'])[0];
$packageName = explode('/', $composerJson['name'])[1];

// eg. /Users/duncan/Code/Statamic/cms|statamic|cms
file_put_contents('/tmp/project-symlinking.txt', "{$project}|{$vendorName}|{$packageName}");
