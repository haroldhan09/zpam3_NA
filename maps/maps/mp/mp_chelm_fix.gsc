/*
* 		CHELM FIX
* 		ORIGINALLY BY JULIAN LUO, 2005
*
* 		VERSION APPLICABLE WITH ZPAM3, FPSCHALLENGE.EU
*
* 		REPRODUCED BY FJOZEK, 2023
* 		THANKS TO CRAVEN
*
* 		FLAKS AND MORTAR TOOLS REMOVED FROM THIS VERSION
*/

main()
{	
	level.scr_sound["flak88_explode"]	= "flak88_explode";
	level._effect["dudek"] 				= loadfx("fx/props/wine_bottle.efx");
	level._effect["flak_explosion"]		= loadfx("fx/explosions/flak88_explosion.efx");
	
	maps\mp\_preload::main();
	maps\mp\_load::main();

	game["allies"] = "american";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["american_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";

	setCvar("r_glowbloomintensity0", ".25");
	setCvar("r_glowbloomintensity1", ".25");
	setcvar("r_glowskybleedintensity0", ".3");
	
	level thread bottles_info();
	level thread bottles_arrangement();

	doHQ();

}

//using script_origins in map "radio" as targetnames for the locations of HQ
doHQ()
{
	if(getcvar("g_gametype") == "hq")
	{
		level.radio = [];
		
		radioloc = getentarray("radio", "targetname");
		logPrint("Number of radios: " + radioloc.size + "\n");
		println("Number of radios:: " + radioloc.size + "\n");
		
		for(i = 0; i < radioloc.size; i++)
		{
			level.radio[i] = spawn("script_model", (radioloc[i].origin));
			level.radio[i].angles = (radioloc[i].angles);
			logPrint("Radio " + i + " set at (" + radioloc[i].origin + "), angles of (" + radioloc[i].angles + ") \n");
			println("Radio " + i + " set at (" + radioloc[i].origin + "), angles of (" + radioloc[i].angles + ") \n");
		}
	}
}

bottles_info()
{
	info = getent("bottleinfo", "targetname");
	
	info setHintString("WINE BOTTLES CHALLENGE");

	while(1) 
	{
		info waittill("trigger", player);	

		player iprintLn("Find and destroy the wine bottles until the Pan Dudek gets drunk");
	}
}

bottles_arrangement()
{
	level.pool_1 = [];
	level.pool_2 = [];
	
	level.__tt = 0;
	level.index = 0;
	
	
	for (i = 0; i < 26; i++) 
	{
		level.pool_1[i] = int(i);
	}
	
	//iprintlnbold(level.pool_1.size);


	for(i = 0; i < 15; i++) 
	{
		level.index = level.pool_1[randomInt(level.pool_1.size)];	
		
		while(level.index == 0)
		{
			level.index = level.pool_1[randomInt(level.pool_1.size)];	
			//iprintlnbold("^6reroll "+level.index);
			wait .05;
		}
		
		//iprintlnbold("^5rerolled new "+level.index);
		//iprintlnbold("^2rolled "+level.index+" ^7value "+level.pool_1[level.index]);
		level.pool_1[level.index] = 0;
		level.pool_2[i] = level.index;
	}
	
	
	//iprintlnbold("^1----------------ARRAY-----------------");
	/*
	for(i = 0; i < level.pool_2.size; i++) {
		iprintlnbold(level.pool_2[i]); 
	}
	*/

	for(i = 1; i < 26; i++)
	{
		level.__tt++;
		bottle_trig = getent("wodka"+i+"_trig", "targetname") thread bottlethink(i); 
	}

	b0 = getent("wodka0_trig", "targetname") thread INTRO();
}

bottlethink(id)
{
	b = getent("wodka"+id, "targetname");
	
	for(i = 0; i < level.pool_2.size; i++) 
	{
		if(id == level.pool_2[i])	
		{
			b delete();
			self delete();
			
			level.__tt--;
			//iprintlnbold("removed "+id);
			return;
		}
	}	
	
	while(1) 
	{
		self waittill("trigger", player);
		
		level.__tt--;

		playfx(level._effect["dudek"], b.origin);
		playfx(level._effect["dudek"], b.origin);
	
		b delete();
		self delete();
	
		if(level.__tt < 1)
		{
			level thread HAMMERED(player);
		}
	}
}

INTRO()
{
	b = getent("wodka0", "targetname");

	while(1) 
	{
		self waittill("trigger", player);	
        
		playfx(level._effect["dudek"], b.origin);
	}
}

HAMMERED(player)
{	
	players = getentarray("player", "classname");
	
	iprintlnbold("NO MORE ALCOHOL ON THIS MAP\n"+ player.name +" HAS DRUNK IT ALL");
	
	for(i = 0; i < players.size; i++)
	{
		players[i] playsound("dudek");
	}
}
