#include maps\mp\gametypes\global\_global;

main()
{
	maps\mp\mp_leningrad::main();
	maps\mp\_preload::main();
	maps\mp\_load::main();
    
    level thread ReadyUp();    

	if(level.scr_replace_russian)
	{
		game["allies"] = "british";
		game["axis"] = "german";
		game["attackers"] = "allies";
		game["defenders"] = "axis";
		game["british_soldiertype"] = "normandy";
		game["german_soldiertype"] = "winterdark";
	}
	else
	{
		game["allies"] = "russian";
		game["axis"] = "german";
		game["attackers"] = "allies";
		game["defenders"] = "axis";
		game["russian_soldiertype"] = "padded";
		game["german_soldiertype"] = "winterlight";
	}

	setcvar("r_glowbloomintensity0","1");
	setcvar("r_glowbloomintensity1","1");
	setcvar("r_glowskybleedintensity0",".25");

	if(getcvar("g_gametype") == "hq")
	{
		level.radio = [];
		level.radio[0] = spawn("script_model", (482.259, 1086.52, 8));
		level.radio[0].angles = (0, 157.687, 0);

		level.radio[1] = spawn("script_model", (-215.47, 1021.66, -56));
		level.radio[1].angles = (0, 19.587, 0);

		level.radio[2] = spawn("script_model", (-1012.53, 852.77, 16.329));
		level.radio[2].angles = (358.036, 233.487, -5.43541);

		level.radio[3] = spawn("script_model", (676.957, 135.464, 60));
		level.radio[3].angles = (0, 75, 0);

		level.radio[4] = spawn("script_model", (-984.004, 112.323, 93));
		level.radio[4].angles = (0, 233.3, 0);

		level.radio[5] = spawn("script_model", (577.105, -505.297, 8.72071));
		level.radio[5].angles = (359.008, 73.0989, -0.690039);

		level.radio[6] = spawn("script_model", (-283.817, -681.342, 80));
		level.radio[6].angles = (0, 317.899, 0);

		level.radio[7] = spawn("script_model", (-1096, -1021, 55));
		level.radio[7].angles = (0, 356.5, 0);

		level.radio[8] = spawn("script_model", (-212.005, 82.1896, 58.0002));
		level.radio[8].angles = (6.86437, 89.8501, 0.930204);
	}
}

ReadyUp()
{
    level endon("intermission");

    level.piano_use = spawnstruct();
	level.piano_use.trigger = getent ("playPiano", "targetname");
    level.piano_use.plugged = false;
    
    level.radio_use = spawnstruct();
	level.radio_use.trigger = getent ("playRadio", "targetname");
    level.radio_use.plugged = false;
    
    level._poppingHelmet = loadfx("fx/props/germanhelmet_bounce.efx");
 
    if( (isdefined(level.in_readyup) && level.in_readyup && getcvar("g_gametype") == "sd") || getcvar("g_gametype") == "strat")
    {
        thread checkUseTouchRadio( level.radio_use );
        thread checkUseTouchPiano( level.piano_use );
        thread poppingHelmets();
        return;
    } 
    
    level.piano_use.trigger delete();
    level.radio_use.trigger delete();

}


poppingHelmets()
{
    level endon("intermission");

    for (i = 1; i < 10; i++)
    {
        level thread helmetInit(i);
    }
}

helmetInit(i)
{
    helmet = spawnstruct();
    
	helmet.prop = getent ("helmet" + i, "targetname");
	helmet.trigger = getent ("helmet" + i + "_trigger", "targetname");
    
    helmet.prop notSolid();
    helmet.inflicted = false;
    
    while (1)
    {
		helmet.trigger waittill("damage", damage, attacker);
        
        if ( !helmet.inflicted ) 
        {   
            helmet thread propInflicted(attacker);
        }
    }
}

propInflicted(player)
{
    self.prop hide();
    self.prop playSound("bullet_small_metal");
    self.inflicted = true;
    
    playFX(level._poppingHelmet, self.prop.origin);  
    
    player iprintlnRand();
    player playSound("american_cheers");
    
    wait level.fps_multiplier * 11;
    
    self.inflicted = false;
    self.prop show();
}

iprintlnRand()
{
    i = RandomIntRange(1, 10);
    
    switch (i)
    {
        case 1: self iprintlnBold("^2Good!"); return;
        case 2: self iprintlnBold("^2Yikes!"); return;
        case 3: self iprintlnBold("^2Excellent!"); return;
        case 4: self iprintlnBold("^2Great!"); return;
        case 5: self iprintlnBold("^2Sick!"); return;
        case 6: self iprintlnBold("^4Awesome!"); return;
        case 7: self iprintlnBold("^6Bot"); return;
        case 8: self iprintlnBold("^2Wild!"); return;
        case 9: self iprintlnBold("^2Nice!"); return;
        case 10: self iprintlnBold("^1Rage!"); return;
    }
}


checkUseTouchPiano(trig)
{
    level endon("intermission");
    trig.trigger setHintString("Play piano (Use).");
    
    while (1)
    {
        trig.trigger waittill("trigger", player);
        
        if(trig.plugged == true)
            return;

        trig.plugged = true;
        trig.trigger setHintString("Wait till end.");
        
        player iprintln("Playing music.");
        playSoundAtLocation(trig, "leningrad_piano", player.origin, 320);
    } 
}

checkUseTouchRadio(trig)
{
    level endon("intermission");   
    trig.trigger setHintString("Plug on radio (Use).");
    
    trig.trigger.track = [];
    trig.trigger.track[0] = "leningrad_radio0";
    trig.trigger.track[1] = "leningrad_radio1";
    trig.trigger.track[2] = "leningrad_radio2";
    trig.trigger.track[3] = "leningrad_radio3";
    
    trig.trigger.delay = [];
    trig.trigger.delay[0] = 3 * 60 + 20;
    trig.trigger.delay[1] = 2 * 60 + 50;
    trig.trigger.delay[2] = 2 * 60 + 55;
    trig.trigger.delay[3] = 2 * 60 + 50;
    
    while (1)
    {
        trig.trigger waittill("trigger", player);
        
        if(trig.plugged == true)
            return;
        
        nInt = RandomIntRange( 0, 4 );
        trig.plugged = true;
        trig.trigger setHintString("Wait till end.");
        
        player iprintln("Playing the music.");
        playSoundAtLocation(trig, trig.trigger.track[nInt], player.origin, trig.trigger.delay[nInt]);
    }
}

playSoundAtLocation(trig, sound, location, delay)
{
    level endon("intermission");

	origin = spawn("script_origin", location + (0, 0, 24));
	origin playSound(sound); 
    origin delete();
    
    wait delay * level.fps_multiplier;

    trig.plugged = false;
    trig.trigger setHintString("Continue (Use).");
}
