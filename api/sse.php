<?php
// header('Content-Type: text/event-stream');
// header('Cache-Control: no-cache');
// header('Connection: keep-alive');

// $gateway = new EventGateway();
// $lastEventId = $gateway->getLast();
// if ($lastEventId === false) {
//   $lastEventId = 0;
// } else {
//   $lastEventId = $lastEventId["id"];
// }

// while (true) {
//   $nextEvent = $gateway->getNext($lastEventId);
//   if ($nextEvent !== false) {
//     echo "event: {$nextEvent['type']}\n";
//     echo "data: {$nextEvent['data']}\n\n";
//     $lastEventId = $nextEvent["id"];
//   }

//   ob_flush();
//   flush();
//   sleep(1);
// }

ob_start();

header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');
header('Pragma: no-cache');
header('Connection: keep-alive');

ob_implicit_flush(true);

$gateway = new EventGateway();
$lastEventId = $gateway->getLast();
if ($lastEventId === false) {
  $lastEventId = 0;
} else {
  $lastEventId = $lastEventId["id"];
}

$timeout = 60;
$startTime = time();

while (time() - $startTime < $timeout) {
  if (connection_aborted()) {
    break;
  }

  $nextEvent = $gateway->getNext($lastEventId);
  if ($nextEvent !== false) {
    echo "event: {$nextEvent['type']}\n";
    echo "data: {$nextEvent['data']}\n\n";
    $lastEventId = $nextEvent["id"];
  } else {
    sleep(2);
  }

  ob_flush();
  flush();
}
?>

