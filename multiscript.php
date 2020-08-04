<?php


//$old_path = getcwd();
//chdir('/var/www/html/cacti/killspikealt');
$myfile = fopen("php.txt", "a+");
$ola = $_POST['files'];
echo "<pre>$ola</pre>";
fwrite($myfile, $ola);
fclose($myfile);
shell_exec("dos2unix php.txt 2>&1");
$cmd = shell_exec("./multispikeremoval.sh  2>&1");
chdir($old_path);
echo "<pre>$cmd</pre>";

?>
