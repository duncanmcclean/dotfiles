<?php

use Alfred\Workflows\Workflow;

use AlgoliaSearch\Client as Algolia;
use AlgoliaSearch\Version as AlgoliaUserAgent;

require __DIR__ . '/vendor/autoload.php';

$query = $argv[1];
//$branch = empty($_ENV['branch']) ? 'master' : $_ENV['branch'];
//$subtext = empty($_ENV['alfred_theme_subtext']) ? '0' : $_ENV['alfred_theme_subtext'];

$workflow = new Workflow;
$parsedown = new Parsedown;
$algolia = new Algolia('BH4D9OD16A', 'b5e8f73c7462a6d5c8b525ef183aabec');

AlgoliaUserAgent::addSuffixUserAgentSegment('Statamic Doc Search', '1.1.0');

$index = $algolia->initIndex('statamic_3');
$search = $index->search($query);
$results = $search['hits'];

$subtextSupported = $subtext === '0' || $subtext === '2';

if (empty($results)) {
    if (empty($results)) {
        $workflow->result()
            ->title('No matches')
            ->icon('google.png')
            ->subtitle("No match found in the docs. Search Google for: \"Statamic+{$query}\"")
            ->arg("https://www.google.com/search?q=statamic+{$query}")
            ->quicklookurl("https://www.google.com/search?q=statamic+{$query}")
            ->valid(true);

        echo $workflow->output();
        exit;
    }
    exit;
}

$urls = [];


foreach ($results as $hit) {
    $highestLvl = $hit['hierarchy']['lvl6'] ? 6 : (
        $hit['hierarchy']['lvl5'] ? 5 : (
            $hit['hierarchy']['lvl4'] ? 4 : (
                $hit['hierarchy']['lvl3'] ? 3 : (
                    $hit['hierarchy']['lvl2'] ? 2 : (
                        $hit['hierarchy']['lvl1'] ? 1 : 0
                    )
                )
            )
        )
    );

    $title = $hit['hierarchy']['lvl' . $highestLvl];
    $currentLvl = 0;
    $subtitle = $hit['hierarchy']['lvl0'];
    while ($currentLvl < $highestLvl) {
        $currentLvl = $currentLvl + 1;
        $subtitle = $subtitle . ' » ' . $hit['hierarchy']['lvl' . $currentLvl];
    }

    $workflow->result()
        ->uid($hit['objectID'])
        ->title($title)
        ->autocomplete($title)
        ->subtitle($subtitle)
        ->arg($hit['url'])
        ->quicklookurl($hit['url'])
        ->valid(true);
}

echo $workflow->output();
