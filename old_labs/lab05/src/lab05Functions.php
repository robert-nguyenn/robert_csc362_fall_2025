<?php

// summarize_text_file: count words (case-insensitive), ignore punctuation
function summarize_text_file(string $text_file_name): array {
    if (!is_readable($text_file_name)) {
        return [];
    }
    $txt = file_get_contents($text_file_name);
    $txt = strtolower($txt);

    // split on anything that's not a letter or number
    $words = preg_split('/[^a-z0-9]+/i', $txt);

    $counts = [];
    foreach ($words as $w) {
        if ($w === '' || $w === null) continue;
        if (!isset($counts[$w])) {
            $counts[$w] = 0;
        }
        $counts[$w]++;
    }
    return $counts;
}

// make_multiplication_table: 0-based i*j
function make_multiplication_table(int $size): array {
    $table = [];
    for ($i = 0; $i < $size; $i++) {
        $row = [];
        for ($j = 0; $j < $size; $j++) {
            $row[$j] = $i * $j;
        }
        $table[$i] = $row;
    }
    return $table;
}

// pad_to_longest: pad in place to longest length
function pad_to_longest(array &$string_array, bool $do_pad_left=true): void {
    $max = 0;
    foreach ($string_array as $s) {
        $len = strlen((string)$s);
        if ($len > $max) $max = $len;
    }
    $type = $do_pad_left ? STR_PAD_LEFT : STR_PAD_RIGHT;
    foreach ($string_array as $i => $s) {
        $string_array[$i] = str_pad((string)$s, $max, ' ', $type);
    }
}
