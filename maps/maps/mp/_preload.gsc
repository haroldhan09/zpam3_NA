main()
{
	level thread setTraining();
	level thread setExploitAccess();
	level thread setPosters();
}

setTraining()
{
	mapname = getcvar("mapname");

	// Load targets and activators
	targets = 		getentarray("trainer_target", "targetname");
	targets_damage = 	getentarray("trainer_trigger", "targetname");
	activators = 		getentarray("trainer_activator", "targetname");
	activators_damage = 	getentarray("trainer_activator_damage", "targetname");
	activators_hint = 	getentarray("trainer_activator_hint", "targetname");

	// For some reason script_brushmodel have specific random origin offset in each axis after map is compiled
	// This code will bring it back to correct possition
	// It must be set before triggers are linked to brush
	offset = (0, 0, 0);
	if (mapname == "mp_toujane_fix") 	offset = (-0.5, 0, 0.5);
	if (mapname == "mp_burgundy_fix") 	offset = (-0.5, 0, 0.5);
	if (mapname == "mp_dawnville_fix") 	offset = (0.5, 0, 0.5);
	if (mapname == "mp_matmata_fix") 	offset = (-0.5, 0, 0.5);
	if (mapname == "mp_carentan_fix") 	offset = (-0.5, 0, 0.5); 
	if (mapname == "mp_carentan_bal") 	offset = (-0.5, 0, 0.5); 
	if (mapname == "mp_chelm_fix") 		offset = (0.5, 0, 0.5);

	for(i = 0; i < targets.size; i++)
		targets[i].origin += offset;

	for(i = 0; i < activators.size; i++)
		activators[i].origin += offset + (0, 0, 0.1);
	


	waittillframeend; // Wait till variables from zPAM are defined

	// Targets were not handled by mod logic, delete them
	if (!isDefined(level.aimTargets)) // level.aimTargets must be set from mod
	{
		for(i = 0; i < targets.size; i++)
		{
			targets[i] delete();
			targets_damage[i] delete();
		}

		for(i = 0; i < activators.size; i++)
		{
			activators[i] delete();
			activators_damage[i] delete();
			activators_hint[i] delete();
		}
	}
}

setExploitAccess()
{
	waittillframeend; // Wait till variables from zPAM are defined
	
	clip = getent("clip", "targetname");
	trigger = getent("exploit", "targetname");
	
	if (isdefined(level.in_readyup) && level.in_readyup && isDefined(clip) && isDefined(trigger))
	{
		clip delete();

		for (;;)
		{
			trigger waittill("trigger", player);

			if (isPlayer(player) && !isDefined(player.exploitWarningPrinted))
			{
				player iprintlnBold("^1This place is accessible only in Ready-Up!");
				player.exploitWarningPrinted = true;
			}	
		}
	}
}

setPosters() 
{
	waittillframeend; // Wait till variables from zPAM are defined

	posters_small = getentarray("poster_small", "targetname");
	posters_big = getentarray("poster_big", "targetname");

	// By default delete posters
	// If its enabled by zPAM, keep them
	if (!isDefined(level.scr_posters) || !level.scr_posters) {
		for(i = 0; i < posters_small.size; i++)
		{
			posters_small[i] delete();
		}
		for(i = 0; i < posters_big.size; i++)
		{
			posters_big[i] delete();
		}
	}
}