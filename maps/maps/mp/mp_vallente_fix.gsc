main()
{
	maps\mp\mp_dawnville::main();
	maps\mp\_preload::main();
	maps\mp\_load::main();
    
	game["allies"] = "american";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["american_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";

	setcvar("r_glowbloomintensity0","1");
	setcvar("r_glowbloomintensity1","1");
	setcvar("r_glowskybleedintensity0",".25");
    
    //
    trigger = getent ("playRadio", "targetname") delete();

}