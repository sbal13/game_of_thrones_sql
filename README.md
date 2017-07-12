# Tables

## Battles
	Houses
	Battles
	Battle_types
	Locations
	Regions
	Characters
	Battle_attacker_kings
	Battle_defender_kings
	Battle_attacker_commanders
	Battle_defender_commanders
	Battle_attacker_houses
	Battle_defender_houses
	
# Instructions

From the config directory, run the environment.rb file in the config folder to run the files. To populate or repopulate the database, run "repopulate" . 


* Who attacks most often? (Not attacker king, general attacker) . 

	Character.most_attacks_sql_query . 
	or . 
	Character.most_attacks . 


* Which attacker most often loses a battle? (Not attacker king, general attacker) . 
	Character.most_losses_sql_query
	or
	Character.most_losses

* What is the most common type of battle?
	Battle.most_common_by_id("battle_type")
	or
	Battle.most_common_battle_type

* What location has seen the most amount of battles?
	Battle.most_common_by_id("location")
	or 
	Location.most_battles


* List the battles attackers lost where attackers outnumbered defenders
	Battle.lost_battles_attackers_outnumber_defenders_sql_query
	or
	Battle.loss_attack_outnumber_defense
