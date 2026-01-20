#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

cat games.csv | while IFS="," read match_year match_round team_a team_b goals_a goals_b
do
  if [[ $match_year != "year" ]]
  then
    team_a_id=$($PSQL "SELECT team_id FROM teams WHERE name='$team_a'")
    if [[ -z $team_a_id ]]
    then
      add_team_a=$($PSQL "INSERT INTO teams(name) VALUES('$team_a')")
      echo Inserted team: $team_a
    fi

    team_b_id=$($PSQL "SELECT team_id FROM teams WHERE name='$team_b'")
    if [[ -z $team_b_id ]]
    then
      add_team_b=$($PSQL "INSERT INTO teams(name) VALUES('$team_b')")
      echo Inserted team: $team_b
    fi

    team_a_id=$($PSQL "SELECT team_id FROM teams WHERE name='$team_a'")
    team_b_id=$($PSQL "SELECT team_id FROM teams WHERE name='$team_b'")

    add_game=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      VALUES($match_year, '$match_round', $team_a_id, $team_b_id, $goals_a, $goals_b)")
    echo Inserted game: $match_year $match_round $team_a vs $team_b
  fi
done
