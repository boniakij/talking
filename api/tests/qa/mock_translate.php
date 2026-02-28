<?php
// tests/qa/mock_translate.php

$uri = $_SERVER['REQUEST_URI'];
$response = [];

// Support both GET (for initial implementation) and potential POST
if (strpos($uri, '/detect') !== false) {
    $response = [
        'data' => [
            'detections' => [
                [
                    ['language' => 'en', 'isReliable' => true, 'confidence' => 1.0]
                ]
            ]
        ]
    ];
} else {
    // Basic translation mock
    $q = $_GET['q'] ?? $_POST['q'] ?? 'Unknown text';
    $target = $_GET['target'] ?? $_POST['target'] ?? 'en';
    
    $response = [
        'data' => [
            'translations' => [
                ['translatedText' => "[MOCK_TRANSLATION][$target]: " . $q]
            ]
        ]
    ];
}

header('Content-Type: application/json');
echo json_encode($response);
