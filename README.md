TrollsAndElves
==============

A custom dota 2 addon for Dota 2 based apon the warcraft 3 map with the same name.

###How do I use this?###
 - Keep in mind it is still in development, and may be buggy
 - **IMPORTANT** Dota will only load the first plugin in your addons folder, to prevent this, move all other addons out of your addons folder. (I moved mine into an addons_disabled folder) - ONLY the host has to do this. This is not required if you use d2fixups
 - There is another guide here: http://www.reddit.com/r/Dota2Modding/comments/1v3ywq/custom_gamemodes_how_to_play_frota_and_set_up/
 - Download the zip (or clone if you are good enough)
 - Stick the files into "Steam\steamapps\common\dota 2 beta\dota\addons\TrollsAndElves"
 - If done correctly, the following folder should exist "Steam\steamapps\common\dota 2 beta\dota\addons\TrollsAndElves\HudSRC"
 - Reopen dota after each install / update (hud might not update)
 - Run the following command
  - dota_local_custom_enable 1;dota_local_custom_game TrollsAndElves;dota_local_custom_map TrollsAndElves;dota_force_gamemode 15;update_addon_paths;dota_wait_for_players_to_load 0;dota_wait_for_players_to_load_timeout 10;map arenaotdr;
