<?php

//$ficheiro=$_GET["ficheiro"];

//echo "Nome: ".ficheiro."</br>;

$old_path = getcwd();
//Change the path bellow to your current killspikealt dir
chdir('/var/www/html/cacti/killspikealt');
$path=$_POST['path'];
$cmd = shell_exec("./spikeremovealt.sh '".$path."' 2>&1");
//chdir($old_path);
echo "<pre>$cmd</pre>";
?>
