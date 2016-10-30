<?php
$mem = new Memcached();
$mem->addServer("127.0.0.1", 11211);

$result = $mem->get("blah");

if ($result) {
    echo $result;
} else {
    echo "No matching key found.  I'll add that now!";
    $mem->set("blah", "I am data!  I am held in memcached!") or die("Couldn't save anything to memcached...");
}


echo '<br/><br/>';
//echo "You are using " . $mem->getstats()["bytes"] . " of storage ";
//echo "out of " . $mem->getstats()["limit_maxbytes"];

echo '<br/><br/>';
echo 'run this:
echo "stats" | nc 127.0.0.1 11211 | grep bytes
';
