#!/usr/bin/php
<?php
copy ( '/DATA/htdocs/wp-config-sample.php' , '/DATA/htdocs/wp-config.php');
$filepath = '/DATA/htdocs/wp-config.php';

$define = "/** The Database Collate type. Don't change this if in doubt. */";

$ssl_content = <<<'EOF'
/** DEVOPly Settings */
if(isset(($_SERVER['HTTP_X_FORWARDED_PROTO'] )) ){
if ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https'){
if(!defined('WP_HOME')){
	define('WP_HOME','https://'.$_SERVER["HTTP_HOST"]);
	define('WP_SITEURL','https://'.$_SERVER["HTTP_HOST"]);
	define('FORCE_SSL_ADMIN', true);

	$_SERVER['HTTPS']='on';
	define('WP_REDIS_HOST', DB_HOST);
	define('WP_CACHE_KEY_SALT', DB_NAME);
}
}
}
/** The Database Collate type. Don't change this if in doubt. */
EOF;

$config = file_get_contents($filepath);

if(strpos($config, $ssl_content) !== false){
  die();
}

$new_config = str_replace($define, $ssl_content, $config);

file_put_contents($filepath, $new_config);
