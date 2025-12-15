//Global section
var me={};
var game_status={};


$( function() {

	draw_empty_board(null);
	fill_board();

	$('#chess_reset').click(reset_board);
  	$('#chess_login').click(login_to_game);
    $('#do_move').click(do_move);
	$('#refresh_board').click(fill_board);

	$('#move_div').hide(1000);


}
);

// Αρχική έκδοση, χωρίς την αντιστροφή του board ανάλογα με το W ή Β
function draw_empty_board(p) {
	if(p!='B') {p='W';}
	var draw_init = {
		'W': {i1:8,i2:0,istep:-1,j1:1,j2:9,jstep:1},
		'B': {i1:1,i2:9,istep:1, j1:8,j2:0,jstep:-1}
	};
	
	var s=draw_init[p];
	var t='<table id="chess_table">';
	for(var i=s.i1;i!=s.i2;i+=s.istep) {
		t += '<tr>';
		for(var j=s.j1;j!=s.j2;j+=s.jstep) {
			t += '<td class="chess_square" id="square_'+j+'_'+i+'">' + j +','+i+'</td>'; 
		}
		t+='</tr>';
	}
	t+='</table>';

	$('#chess_board').html(t);

	//Lecture 4
	//Onclick add handler on each square
	//$('.chess_square').click(click_on_piece); 
}

function fill_board() {
	$.ajax(
		{	method: "get",
            headers: {"App-Token": me.token},			
			url: "chess.php/board/" , 
		 success: fill_board_by_data 
		}
		);
}

function fill_board_by_data(data) {
	
	for(var i=0;i<data.length;i++) {
		var o = data[i];
		var id = '#square_'+ o.x +'_' + o.y;
		var c = (o.piece!=null)?o.piece_color + o.piece:'';
		
		//var im = ''; //Χωρίς τα πιόνια
		//var im = (o.piece!=null)?c:''; //πιόνια σαν text
	    var im = (o.piece!=null)?'<img src="images/'+c+'.png" class="piece">':''; //πιόνια με εικόνα
		
		$(id).addClass(o.b_color+'_square').html(im);
	}
}

function reset_board() {
	$.ajax(
		{method: 'post',
		 url: "chess.php/board/", 
         headers: {"App-Token": me.token},			
		 success: fill_board_by_data 
		}
		);
}

function login_to_game() {
	if($('#username').val()=='') {
		alert('You have to set a username');
		return;
	}
	var p_color = $('#pcolor').val();
	draw_empty_board(p_color);
	fill_board();
	
	$.ajax({
		url: "chess.php/player/"+p_color, 
		method: 'PUT',
		dataType: "json",
		contentType: 'application/json',
		headers: {"App-Token": me.token},			
		data: JSON.stringify( {username: $('#username').val(), piece_color: p_color}),
		success: login_result,
		error: login_error
	});
}

function login_result(data) {
	me = data[0];
	$('#game_initializer').hide();
	update_info();
	game_status_update();
}

function update_info(){
	$('#game_info').html("I am Player: "+me.piece_color+", my name is "+me.username +'<br>Token='+me.token+'<br>Game state: '+game_status.status+', '+ game_status.p_turn+' must play now.');	
}

function login_error(data,y,z,c) {
	var x = data.responseJSON;
	alert(x.errormesg);
}

function game_status_update() {
	//1st stage
	//$.ajax({url: "chess.php/status/", success: update_status });
	//lecture 4
    //2nd Stage with token in header
	 $.ajax({
	 	url: "chess.php/status/", 
	 	headers: {"App-Token": me.token},
	 	success: update_status
	});
}

function update_status(data) {
	if (game_status.p_turn==null ||  data[0].p_turn != game_status.p_turn ||  data[0].status != game_status.status) {
		fill_board();
	}
	game_status=data[0];
	update_info();
	if(game_status.p_turn==me.piece_color &&  me.piece_color!=null) {
		// do play
		$('#move_div').show(1000);
		setTimeout(function() { game_status_update();}, 15000);
	} else {
		// must wait for something
		$('#move_div').hide(1000);
		setTimeout(function() { game_status_update();}, 4000);
	} 
}

//lecture chess 4
function do_move() {
	var s = $('#the_move').val();
	
	var a = s.trim().split(/[ ]+/); //Για να δουλεύει και με περισσότερα εσωτερικά κενα. π.χ. 2   2 3   2 θα δουλέψει!
	if(a.length!=4) {
		alert('Must give 4 numbers seperated by space');
		return;
	}
	$.ajax({url: "chess.php/board/piece/"+a[0]+'/'+a[1], 
			method: 'PUT',
			dataType: "json",
			contentType: 'application/json',
			//Lecture 4 1st stage token in body
			//data: JSON.stringify( {x: a[2], y: a[3], token: me.token}), // token: me.token --> Προσωρινά, αφού θα το στέλνουμε τελικά στο headers
			//Lecture 4 2nd stage token in header
			headers: {"App-Token": me.token},
			data: JSON.stringify({x: a[2], y: a[3]}),

			success: move_result,
			error: login_error});
}

//lecture 4 empty at first
function move_result(data) {
	fill_board_by_data(data);
	$('#move_div').hide(1000); //Κρύψε όλο το div διαχείρισης κίνησης
	$('#the_move').val(''); //Άδειασε το κείμενο από το input συντεταγμένων
}
