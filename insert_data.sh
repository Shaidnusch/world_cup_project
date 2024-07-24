#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")
#Insert team data
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      if [[ -z $TEAM1_NAME ]]
      then
        INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
          then
            echo Inserted team $WINNER
          fi
      fi
  fi
if [[ $OPPONENT != "opponent" ]]
  then
    TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      if [[ -z $TEAM2_NAME ]]
      then
        INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
          then
            echo Inserted team $OPPONENT
          fi
      fi
  fi
#Insert game data
if [[ $YEAR != "year" ]]
  then
    #Get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #Get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #Add all game data to the table
    INSERT_GAME_DATA=$($PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES ($WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, $YEAR, '$ROUND')")
    if [[ $INSERT_GAME_DATA == "INSERT 0 1" ]]
    then
      echo Game added: $YEAR, $ROUND, $WINNER_ID vs $OPPONENT_ID with a score $WINNER_GOALS:$OPPONENT_GOALS
    fi
  fi
done