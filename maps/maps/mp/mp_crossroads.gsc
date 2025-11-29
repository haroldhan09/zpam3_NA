/********************************************************
*
*		CREATED BY FJOZEK
*		08/05/2024
*
*		THANKS TO CRAVEN
*		ADDED: RETRIEVAL
*		ADDED: HEADQUARTERS // SCRIPT BY JULIAN LUO
*
********************************************************/

main()
{
	maps\mp\mp_crossroads_fx::main();
	maps\mp\_preload::main();
	maps\mp\_load::main(); 
    
	level thread doHQ(); 
	level thread Retrieval();
	level thread ReadyUp();

	if (!isdefined(level.scr_allow_ambient_weather) || level.scr_allow_ambient_weather)
        setExpFog(0.0001, 0.55, 0.6, 0.55, 0);
        
	if (!isdefined(level.scr_allow_ambient_sounds) || level.scr_allow_ambient_sounds)
		ambientPlay("ambient_france");
        
	game["allies"] = "british";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["british_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";
    
	setCvar( "r_glowbloomintensity0", ".25" );
	setCvar( "r_glowbloomintensity1", ".25" );
	setCvar( "r_glowskybleedintensity0", ".3" );
    
    // for fun with stuka. If you remove, your mom be gay
    level._effect["Invisible"] = "xmodel/default_static_model";
	precacheModel(level._effect["Invisible"]);
	precacheModel("xmodel/vehicle_stuka_flying");
}

doHQ()
{
	if(getcvar("g_gametype") == "hq")
	{
		level.radio = [];
		
		radioloc = getentarray("hqradio", "targetname");
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

Retrieval()
{
	if(getcvar("g_gametype") == "re")
	{
		level.OBJECTIVES_DECIDED_GSC = true;
	
		obj = [];
		goal = (0,0,0);	
		
		game["attackers"] = "allies";
		game["defenders"] = "axis";
		goal = (811, 261, -200);
		obj[0] = add_array((2170, 3179, -61), (0, 332, 0), &"RE_EXPLOSIVES", 50, "xmodel/mp_tntbomb", "xmodel/mp_tntbomb_obj");
		obj[1] = add_array((-82, 2860, -110), (0, 105, 0), &"RE_EXPLOSIVES", 50, "xmodel/mp_tntbomb", "xmodel/mp_tntbomb_obj");
		
		level.OBJECTIVESARRAY = obj;
		level.ATTACKERSBASE = goal;

		for(i = 0; i < level.OBJECTIVESARRAY.size; i++)
		{
			precacheModel(level.OBJECTIVESARRAY[i][4]);
			precacheModel(level.OBJECTIVESARRAY[i][5]);
		}		
	}
}


ReadyUp()
{	
	trigger_tls_house	= getent ("bed", "targetname") thread _print("^4Damn, you fucking can't hog this lovely eyza's bed!", 2);
	trigger_doghouse = getent ("credits", "targetname") thread _print(undefined, undefined, " ^3is rediscovering his pretty neaty backyard doghouse ", 8);	
	trigger_dawnville = getent ("dawnville", "targetname") thread _print(undefined, undefined, " ^5let it go and came into the orig Call of Duty 1 Dawnville garage ", 15);	
    
	level thread ReadyUpDoor();
    
    if(isdefined(level.in_readyup) && level.in_readyup || getCvar("g_gametype") == "strat")
    {
        readyUpClip = getentarray ("ReadyUpClip", "targetname");
        
        for( i = 0; i < readyUpClip.size; i++ )
            readyUpClip[i] notSolid();
    }
    
    level thread stukaFlying();
	
	entTransporter 	= getentarray("enter", "targetname");
	if(isdefined(entTransporter))
	{
		for(i = 0; i < entTransporter.size; i++)
		entTransporter[i] thread Transporter();
	}
}

Transporter()
{
	while(1)
	{
		self waittill("trigger", other);
        
		wait(0.05);
		entTarget = getent(self.target, "targetname");
        
		other setOrigin(entTarget.origin);
		other setPlayerAngles(entTarget.angles);
        
		other iprintLnBold("^3Whoosh!");
		iprintLnBold(other.name+ " ^4is magically appearing inside the barnhouse");
	}
}

ReadyUpDoor()
{
	door = getent ("door", "targetname");
	trig = getent ("doortrig", "targetname"); 
	trig setHintString("Unlock (F)");
	
	while(1)
	{
		trig setHintString("Unlock the door");
		trig waittill ("trigger", player);
		iprintLnBold(player.name+ " found his way to the TLS House");
		
		door rotateyaw (90, 1.5);
		door waittill ("rotatedone");
		
		wait 3;
		
		trig setHintString("Shut the door");
		trig waittill ("trigger", player);
		iprintLnBold(player.name+ " shut down the TLS House");
		
		door rotateyaw (-90, 1.5);
		door waittill ("rotatedone");

		wait 6;
	}
}

stukaFlying()
{
    trig = getent("stuka", "targetname");
    trig setHintString("^2Pilot license:\n^3(1) TOGGLE use ^1(F)\n^3(2) HOLD to pilot ^1(Left mouse) \n^3(3) Quit anywhere ^1(Melee)");
    
    while (1)
    {
        trig waittill("trigger", player);
        
        
        if(!isdefined(player.airplane)) 
        {
            player.airplane = true;
            player thread stuka_tsf();
        } 
        else 
        {
            player iprintLnBold("^4Use only when quitting plane ^1(MELEE)");
        }
    }
}

stuka_tsf()
{
    level endon("intermission");
    self endon("killed_player");
    
    // Hide player model
    self setModel("xmodel/vehicle_stuka_flying");
    self disableWeapon();
    self detachAll();
    
    self.stuka = spawn("script_model", self.origin);
    self linkTo(self.stuka);
    
    self.stuka_origin = spawn("script_origin", self.stuka.origin);
    self.stuka_origin linkTo(self.stuka);
    self.stuka_origin playSound("germanradio_chatter");
    
    self thread LookWho();
    
    self iprintLnBold("^1Hold ^4([{+attack}])^1 to pilot the plane");
    self iprintLnBold("^1Press ^4(MELEE)^1 to quit flying");
    
    self thread stuka_fly();
    self thread stuka_maintain_health(self.stuka);
}

LookWho()
{
    level endon("intermission");
    self endon("killed_player");

    wait 11;
    
    if(isdefined(self.stuka))
    {
        iprintLnBold("^6Look, it's a bird? It's a plane? No, it's ^4" + self.name);
    }
}

stuka_fly()
{
    level endon("intermission");
    self endon("killed_player");
   
    self setClientCvar("cg_thirdperson", 1);
    self setClientCvar("cg_thirdpersonRange", 300);
    
    while(isdefined(self.airplane) && self.airplane)
    {
        wait 0.1;

        if(self attackButtonPressed() && isdefined(self.stuka))
        {
            angles = self getPlayerAngles();
            vector = anglesToForward(angles);
            vector = maps\mp\_utility::vectorScale(vector, 120);
            self.stuka moveTo(self.origin + vector, 0.08); 
        }
        else if(self meleeButtonPressed())
        {
            thread revertStandard();
        }
    }
}

stuka_maintain_health(stuka)
{
    level endon("intermission");
    
    while(self.sessionstate == "playing" && isAlive(self))
        wait .05;
    
    thread revertStandard();
}

revertStandard()
{
    if(isdefined(self.stuka))
    {
        self unlink();
        self.airplane = undefined;
        self.stuka delete();
        self.stuka_origin stopLoopSound();
        self.stuka_origin delete();    
    } 
    
    self detachAll();
    
    if(self.pers["team"] == "allies")
    {
        [[game["allies_model"] ]]();
    }
    else if(self.pers["team"] == "axis")
    {
        [[game["axis_model"] ]]();
    }
    
    self enableWeapon();
    self iprintLnBold("^4You quitted flying.");
    self setClientCvar("cg_thirdperson", 0);
    self setClientCvar("cg_thirdpersonRange", 120);
}

add_array(A, B, C, D, E, F)
{
	array = [];

	if(isdefined(A))
		array[array.size] = A;
	if(isdefined(B))
		array[array.size] = B;
	if(isdefined(C))
		array[array.size] = C;
	if(isdefined(D))
		array[array.size] = D;
	if(isdefined(E))
		array[array.size] = E;
	if(isdefined(F))
		array[array.size] = F;

	return array;
}

_print(text1, wait1, text2, wait2)
{
	level endon("intermission");

	while (1)
	{
		self waittill ("trigger", player);
		
		if(isdefined(text1))
			player iprintLnBold(text1);
		
		if(isdefined(wait1))
            wait wait1;
		
		if(isdefined(text2))
			iprintLnBold(player.name, "", text2);

		if(isdefined(wait2))
            wait wait2;
	}
}
