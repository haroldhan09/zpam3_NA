main()
{
	level._effect["flak_explosion"]				= loadfx("fx/explosions/flak88_explosion.efx");
	level.scr_sound["flak88_explode"]			= "flak88_explode";

	maps\mp\_preload::main();
	maps\mp\_load::main();

	game["allies"] = "british";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["british_soldiertype"] = "africa";
	game["german_soldiertype"] = "africa";

	setcvar("r_glowbloomintensity0",".25");
	setcvar("r_glowbloomintensity1",".25");
	setcvar("r_glowskybleedintensity0",".5");

	if((getcvar("g_gametype") == "hq"))
	{
		level.radio = [];
		level.radio[0] = spawn("script_model", (285.332, 471.947, 12.1747));
		level.radio[0].angles = (0, 335.6, 0);

		level.radio[1] = spawn("script_model", (-7.80745, 1100.36, -11.0072));
		level.radio[1].angles = (355.751, 55.1337, -2.21861);

		level.radio[2] = spawn("script_model", (1282.54, 731.845, -1.99999));
		level.radio[2].angles = (0, 133.073, 0);

		level.radio[3] = spawn("script_model", (2206.32, 411.609, 54.6547));
		level.radio[3].angles = (2.21806, 151.797, -7.6227);

		level.radio[4] = spawn("script_model", (758.63, 1725.03, 148));
		level.radio[4].angles = (0, 354.855, 0);

		level.radio[5] = spawn("script_model", (1558.4, 1569.03, 96.0133));
		level.radio[5].angles = (0.629538, 196.751, -2.07329);

		level.radio[6] = spawn("script_model", (986.298, 3040.61, 58.7701));
		level.radio[6].angles = (0.640552, 196.255, -3.11342);

		level.radio[7] = spawn("script_model", (2295.88, 2483.53, 70.7077));
		level.radio[7].angles = (1.35945, 129.516, 1.18606);

		level.radio[8] = spawn("script_model", (2971.51, 1570.41, 45.4606));
		level.radio[8].angles = (0.282498, 74.994, -0.237561);

		level.radio[9] = spawn("script_model", (1758, 653.443, 176));
		level.radio[9].angles = (0, 39.351, 0);
	}

	// Toujane bug under A roof (player is not visible from allies fox)
	precacheModel("xmodel/toujane_underA_bug");
	// First ledge
	moving_xmodel = spawn("script_model",(1509, 2207, 120)); // 45
	moving_xmodel.angles = (51, 328, 90);
	moving_xmodel setmodel("xmodel/toujane_underA_bug");
	moving_xmodel = spawn("script_model",(1507, 2207, 127)); // top
	moving_xmodel.angles = (90, 270, 30);
	moving_xmodel setmodel("xmodel/toujane_underA_bug");
	// Second ledge
	moving_xmodel = spawn("script_model",(1558, 2265, 103)); // 45
	moving_xmodel.angles = (51, 328, 90);
	moving_xmodel setmodel("xmodel/toujane_underA_bug");
	moving_xmodel = spawn("script_model",(1556, 2265, 110));
	moving_xmodel.angles = (90, 270, 30);
	moving_xmodel setmodel("xmodel/toujane_underA_bug");




	// Fix problem with plants - if bomb explodes, there is no tank explosion effect -> fixed
	// Find bombzones (2 bomzones, A and B)
	array = getentarray("bombzone", "targetname");
	bombzoneA = array[0];
	bombzoneB = array[1];

	ents = getentarray("script_brushmodel", "classname");
	smodels = getentarray("script_model", "classname");
	for(i = 0; i < smodels.size; i++)
		ents[ents.size] = smodels[i];

	// Find the correct entity - its enttity where targetname is empty (and needs to be filled with name, that needs to be saved into bombzone.target)
	for(i = 0; i < ents.size; i++)
	{
		if(isdefined(ents[i].script_exploder))
		{
			if (ents[i].model == "xmodel/fx" && !isDefined(ents[i].targetname))
			{
				if (ents[i].script_exploder == 3791)
				{
					ents[i].targetname = "pf3791_auto1";
					bombzoneA.target = "pf3791_auto1";
				}
				else if (ents[i].script_exploder == 3872)
				{
					ents[i].targetname = "pf3872_auto1";
					bombzoneB.target = "pf3872_auto1";
				}
			}
		}
	}	
}