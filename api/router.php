<?php
// Get the requested URL
$request_uri = parse_url($_SERVER["REQUEST_URI"], PHP_URL_PATH);

// If the file exists, serve it directly (e.g., for assets like CSS/JS/images)
if (file_exists(__DIR__ . $request_uri)) {
    return false;
}

// Otherwise, route everything to index.php
require __DIR__ . '/index.php';
?>
