--
-- A database must have been created e.g. `chess`
--

DROP TABLE IF EXISTS `board`;
CREATE TABLE `board` (
  `x` tinyint(1) NOT NULL,
  `y` tinyint(1) NOT NULL,
  `b_color` enum('B','W') NOT NULL,
  `piece_color` enum('W','B') DEFAULT NULL,
  `piece` enum('K','Q','R','B','N','P') DEFAULT NULL,
  PRIMARY KEY (`y`,`x`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `board`
--
LOCK TABLES `board` WRITE; 
-- Δεν είναι απαραίτητο πλέον με InnoDB engine (παλιό MyISAM)
INSERT INTO `board` VALUES (1,1,'B','W','R'),(2,1,'W','W','N'),(3,1,'B','W','B'),(4,1,'W','W','Q'),(5,1,'B','W','K'),(6,1,'W','W','B'),(7,1,'B','W','N'),(8,1,'W','W','R'),(1,2,'W','W','P'),(2,2,'B','W','P'),(3,2,'W','W','P'),(4,2,'B','W','P'),(5,2,'W','W','P'),(6,2,'B','W','P'),(7,2,'W','W','P'),(8,2,'B','W','P'),(1,3,'B',NULL,NULL),(2,3,'W',NULL,NULL),(3,3,'B',NULL,NULL),(4,3,'W',NULL,NULL),(5,3,'B',NULL,NULL),(6,3,'W',NULL,NULL),(7,3,'B',NULL,NULL),(8,3,'W',NULL,NULL),(1,4,'W',NULL,NULL),(2,4,'B',NULL,NULL),(3,4,'W',NULL,NULL),(4,4,'B',NULL,NULL),(5,4,'W',NULL,NULL),(6,4,'B',NULL,NULL),(7,4,'W',NULL,NULL),(8,4,'B',NULL,NULL),(1,5,'B',NULL,NULL),(2,5,'W',NULL,NULL),(3,5,'B',NULL,NULL),(4,5,'W',NULL,NULL),(5,5,'B',NULL,NULL),(6,5,'W',NULL,NULL),(7,5,'B',NULL,NULL),(8,5,'W',NULL,NULL),(1,6,'W',NULL,NULL),(2,6,'B',NULL,NULL),(3,6,'W',NULL,NULL),(4,6,'B',NULL,NULL),(5,6,'W',NULL,NULL),(6,6,'B',NULL,NULL),(7,6,'W',NULL,NULL),(8,6,'B',NULL,NULL),(1,7,'B','B','P'),(2,7,'W','B','P'),(3,7,'B','B','P'),(4,7,'W','B','P'),(5,7,'B','B','P'),(6,7,'W','B','P'),(7,7,'B','B','P'),(8,7,'W','B','P'),(1,8,'W','B','R'),(2,8,'B','B','N'),(3,8,'W','B','B'),(4,8,'B','B','Q'),(5,8,'W','B','K'),(6,8,'B','B','B'),(7,8,'W','B','N'),(8,8,'B','B','R');
UNLOCK TABLES;

--
-- Table structure for table `board_empty`
--

DROP TABLE IF EXISTS `board_empty`;

CREATE TABLE `board_empty` (
  `x` TINYINT NOT NULL,
  `y` TINYINT NOT NULL,
  `b_color` ENUM('B','W') NOT NULL,
  `piece_color` ENUM('W','B') DEFAULT NULL,
  `piece` ENUM('K','Q','R','B','N','P') DEFAULT NULL,
  PRIMARY KEY (`y`, `x`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_general_ci
  ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `board_empty`
--
LOCK TABLES `board_empty` WRITE;
INSERT INTO `board_empty` VALUES (1,1,'B','W','R'),(2,1,'W','W','N'),(3,1,'B','W','B'),(4,1,'W','W','Q'),(5,1,'B','W','K'),(6,1,'W','W','B'),(7,1,'B','W','N'),(8,1,'W','W','R'),(1,2,'W','W','P'),(2,2,'B','W','P'),(3,2,'W','W','P'),(4,2,'B','W','P'),(5,2,'W','W','P'),(6,2,'B','W','P'),(7,2,'W','W','P'),(8,2,'B','W','P'),(1,3,'B',NULL,NULL),(2,3,'W',NULL,NULL),(3,3,'B',NULL,NULL),(4,3,'W',NULL,NULL),(5,3,'B',NULL,NULL),(6,3,'W',NULL,NULL),(7,3,'B',NULL,NULL),(8,3,'W',NULL,NULL),(1,4,'W',NULL,NULL),(2,4,'B',NULL,NULL),(3,4,'W',NULL,NULL),(4,4,'B',NULL,NULL),(5,4,'W',NULL,NULL),(6,4,'B',NULL,NULL),(7,4,'W',NULL,NULL),(8,4,'B',NULL,NULL),(1,5,'B',NULL,NULL),(2,5,'W',NULL,NULL),(3,5,'B',NULL,NULL),(4,5,'W',NULL,NULL),(5,5,'B',NULL,NULL),(6,5,'W',NULL,NULL),(7,5,'B',NULL,NULL),(8,5,'W',NULL,NULL),(1,6,'W',NULL,NULL),(2,6,'B',NULL,NULL),(3,6,'W',NULL,NULL),(4,6,'B',NULL,NULL),(5,6,'W',NULL,NULL),(6,6,'B',NULL,NULL),(7,6,'W',NULL,NULL),(8,6,'B',NULL,NULL),(1,7,'B','B','P'),(2,7,'W','B','P'),(3,7,'B','B','P'),(4,7,'W','B','P'),(5,7,'B','B','P'),(6,7,'W','B','P'),(7,7,'B','B','P'),(8,7,'W','B','P'),(1,8,'W','B','R'),(2,8,'B','B','N'),(3,8,'W','B','B'),(4,8,'B','B','Q'),(5,8,'W','B','K'),(6,8,'B','B','B'),(7,8,'W','B','N'),(8,8,'B','B','R');
UNLOCK TABLES;


--
-- Table structure for table `game_status`
--
DROP TABLE IF EXISTS `game_status`;
CREATE TABLE `game_status` (
  `status` enum('not active','initialized','started','ended','aborded') NOT NULL DEFAULT 'not active',
  `p_turn` enum('W','B') DEFAULT NULL,
  `result` enum('B','W','D') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `game_status`
--
LOCK TABLES `game_status` WRITE;
INSERT INTO `game_status` VALUES ('started','W','D','2022-11-28 18:39:59');
UNLOCK TABLES;


--
-- Table structure for table `players`
--
DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `username` varchar(20) DEFAULT NULL,
  `piece_color` enum('B','W') NOT NULL,
  `token` varchar(100) DEFAULT NULL,
  `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`piece_color`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players`
--
LOCK TABLES `players` WRITE;
INSERT INTO `players` VALUES ('qqqqqq','B','8599a2efe05697622caeddae84507ee3','2022-11-28 18:16:51'),('aaaa','W','05da4297eecc648e840b6d3bfa772adc','2022-11-28 17:16:54');
UNLOCK TABLES;


-- PROCEDURE clean_board
DROP PROCEDURE IF EXISTS `clean_board`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `clean_board`()
BEGIN
	REPLACE INTO board SELECT * FROM board_empty;
	
	UPDATE `players` SET username=NULL, token=NULL;
  
	UPDATE `game_status` SET `status`='not active', `p_turn`=NULL, `result`=NULL;
END ;;
DELIMITER ;



-- PROCEDURE move_piece
DROP PROCEDURE IF EXISTS `move_piece`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `move_piece`(x1 tinyint,y1 tinyint,x2 tinyint,y2 tinyint)
BEGIN
	declare  p, p_color char;

	select  piece, piece_color into p, p_color FROM `board` WHERE X=x1 AND Y=y1;

	update board
	set piece=p, piece_color=p_color
	where x=x2 and y=y2;

	UPDATE board
	SET piece=null,piece_color=null
	WHERE X=x1 AND Y=y1;

	update game_status set p_turn=if(p_color='W','B','W');
	
END ;;
DELIMITER ;




