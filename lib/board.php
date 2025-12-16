<?php

function show_board() {
  global $mysqli;
	
	$sql = 'select * from board';
	$st = $mysqli->prepare($sql); //Αυτό βελτιώνει την ασφάλεια και την απόδοση.
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json'); //Στέλνει μια κεφαλίδα HTTP στον browser (ή στον πελάτη) ενημερώνοντάς τον ότι τα δεδομένα που ακολουθούν είναι σε μορφή JSON και όχι σε απλή HTML.
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function reset_board() {
	global $mysqli;
	
	$sql = 'call clean_board()';
	$mysqli->query($sql);
	show_board();
}

//Lecture 4
function show_piece($x,$y) {
	global $mysqli;
	
	$sql = 'select * from board where x=? and y=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('ii',$x,$y);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

//Lecture 4 1st stage only do_move($x,$y,$x2,$y2);
//Lecture 4 2nd stage 
//Lecture 4 3rd stage 
function move_piece($x,$y,$x2,$y2,$token) {
	//Lecture 4 1st stage only do_move($x,$y,$x2,$y2);
	//do_move($x,$y,$x2,$y2);

	//Εάν δεν δόθηκε token, raise error
	if($token==null || $token=='') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"token is not set."]);
		exit;
	}

	//Εάν δεν βρέθηκε παίκτης με αυτό το token, raise error
	$color = current_color($token); //Επιστρέφει το χρώμα που έχει ο παίκτης με το συγκεκριμένο token
	if($color==null ) {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"You are not a player of this game."]);
		exit;
	}

	//Εάν το παιχνίδι δεν βρίσκεται σε κατάσταση started, raise error
	$status = read_status();
	if($status['status']!='started') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Game is not in action."]);
		exit;
	}

	//Εάν παιζεί ο αντίπαλος παίκτης δεν επιτρέπουμε την κίνηση, raise error
	if($status['p_turn']!=$color) {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"It is not your turn."]);
		exit;
	}

	do_move($x,$y,$x2,$y2); //Προσωρινά 2 stage...
	
	// //Lecture 4 3rd stage
	// //Επεξήγηση στο επόμενο στάδιο
	// $orig_board=read_board();
	// $board=convert_board($orig_board);
	// $n = add_valid_moves_to_piece($board,$color,$x,$y);
	
	// //Εάν το πιόνι που προκειται να κινηθεί, μπορεί όντως να κινηθεί
	// if($n==0) {
	// 	header("HTTP/1.1 400 Bad Request");
	//     print json_encode(['errormesg'=>"This piece cannot move."]);
	//     exit;
	// }

	// foreach($board[$x][$y]['moves'] as $i=>$move) {
	//   	if($x2==$move['x'] && $y2==$move['y']) {
	//  		do_move($x,$y,$x2,$y2); 
	//  		exit;
	// 	}
	// }

	// header("HTTP/1.1 400 Bad Request");
	// print json_encode(['errormesg'=>"This move is illegal."]);
	// exit;

}

//Lecture chess 4
function do_move($x,$y,$x2,$y2) {
	global $mysqli;
	$sql = 'call `move_piece`(?,?,?,?);';
	$st = $mysqli->prepare($sql);
	$st->bind_param('iiii',$x,$y,$x2,$y2 );
	$st->execute();

	//Lecture 4 1st stage
	show_board();
	//Lecture 4 2nd stage
	//header('Content-type: application/json');
	//print json_encode(read_board(), JSON_PRETTY_PRINT);
}


?>