main()
{
    maps\mp\_load::main();

    level._effect = [];
    level._effect["flak_explosion"] =  loadfx("fx/explosions/flak88_explosion.efx");
    level.scr_sound["flak88_explode"] = "flak88_explode";

    game["allies"] = "american";
    game["axis"] = "german";
    game["attackers"] = "allies";
    game["defenders"] = "axis";
    game["american_soldiertype"] = "normandy";
    game["german_soldiertype"] = "normandy";

    setCvar("r_glowbloomintensity0", "25");
    setCvar("r_glowbloomintensity1", "25");
    setcvar("r_glowskybleedintensity0",".5");

}