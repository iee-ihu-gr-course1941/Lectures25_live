<?php

require_once "lib/dbconnect.php"; 
require_once "lib/board.php";

$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
// $request = explode('/', trim($_SERVER['SCRIPT_NAME'],'/'));
// Σε περίπτωση που τρέχουμε php –S 
$input = json_decode(file_get_contents('php://input'),true);

switch ($r=array_shift($request)) {
  case 'board' : 
		switch ($b=array_shift($request)) {
			case '':
			case null: 
			  handle_board($method);
			  break;
			case 'piece': 
			  //handle_piece($method, $request[0],$request[1],$input);
				break;
			case 'player': 
			  //handle_player($method, $request[0],$input);
				break;
			default: 
			  header("HTTP/1.1 404 Not Found");
				break;
	}
	break;
   default: 	
	header("HTTP/1.1 404 Not Found");
	exit;
}

function handle_board($method) {
	if($method=='GET') {
    	show_board();
  	} else if ($method=='POST') {
    	reset_board();
  	} else {
    	header('HTTP/1.1 405 Method Not Allowed');
  		print "<h1>Method Not Allowed (405)</h1>";
  	}
}
?>



