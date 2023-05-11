CREATE OR REPLACE TYPE nba_player as OBJECT(
	id INT,
	name VARCHAR2(20),
	surname VARCHAR2(20),
	shirtnumber INT,
	university VARCHAR2(20),
	height FLOAT,
	debutyear INT,
	CONSTRUCTOR FUNCTION nba_player(pid INT, pname VARCHAR2, psurname VARCHAR2) RETURN SELF AS RESULT,
	FINAL MAP MEMBER FUNCTION sortplayers RETURN NUMBER
) NOT FINAL;

/

-- Create the type body of nba_player
CREATE OR REPLACE TYPE BODY nba_player AS
	CONSTRUCTOR FUNCTION nba_player (pid INT, pname VARCHAR2, psurname VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		SELF.id := pid;
		SELF.name := pname;
		SELF.surname := psurname;
		RETURN ;
	END;
	FINAL MAP MEMBER FUNCTION sortplayers RETURN NUMBER IS
	BEGIN
		RETURN SELF.shirtnumber;
	END;
END;    

DROP TYPE static_array;

-- Create an static array of nba_players
CREATE OR REPLACE TYPE static_array AS VARRAY(15) OF nba_player;

DECLARE
	players static_array;
BEGIN
	players := NEW static_array(NEW nba_player(1,'Stephen','Curry'));
END;

-- Create an dynamic list of nba_player elements
CREATE OR REPLACE TYPE list_of_nba_players
AS TABLE OF nba_player;

-- Create a new type to represent each NBA team including a field with an undetermined number of players (list_of_nba_players)
CREATE OR REPLACE TYPE nba_franchise AS OBJECT(
	id INT,
	franchisename VARCHAR2(20),
	completename VARCHAR2(100),
	initials VARCHAR2(3),
	rings INT,
	players list_of_nba_players
);

DROP TABLE nba_playoffs;

-- Create a table in order to store nba franchise data which needs an extra table to store the info from the players
CREATE TABLE nba_playoffs (
	season INT,
	is_winner CHAR(1),
	team nba_franchise
) NESTED TABLE team.players STORE AS players_list;
