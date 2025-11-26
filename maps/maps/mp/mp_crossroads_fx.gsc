main()
{
	precacheFX();
	ambientFX();
	level.scr_sound["flak88_explode"]	= "flak88_explode";
}

precacheFX()
{
	level._effect["flak_explosion"]				= loadfx("fx/explosions/flak88_explosion.efx");
	level._effect["lantern_light"] 				= loadfx("fx/props/glow_latern.efx");
	level._effect["dust_wind"]					= loadfx("fx/dust/dust_wind_eldaba.efx");
	level._effect["thin_light_smoke_M"]			= loadfx ("fx/smoke/thin_light_smoke_M.efx");
	level._effect["building_fire_small"] 		= loadfx ("fx/fire/building_fire_small.efx");
}

ambientFX()
{
	if (!isdefined(level.scr_allow_ambient_weather) || level.scr_allow_ambient_weather)
	{
        maps\mp\_fx::loopfx("thin_light_smoke_M", (1050, 1173, -89), 1, (1050, 1173, 11));
        maps\mp\_fx::loopfx("thin_light_smoke_M", (1499, 2302, -108), 1, (1499, 2302, -8));
        maps\mp\_fx::loopfx("thin_light_smoke_M", (923, 1917, -133), 1, (923, 1917, -33));
        maps\mp\_fx::loopfx("thin_light_smoke_M", (1042, 1175, -100), 1, (1042, 1175, 0));
        maps\mp\_fx::loopfx("thin_light_smoke_M", (2082, 4726, -57), 1, (2082, 4726, 57));
        maps\mp\_fx::loopfx("thin_light_smoke_M", (912, 2400, -187), 1, (912, 2400, -87));
        maps\mp\_fx::loopfx("thin_light_smoke_M", (1303, 2231, -181), 1, (1303, 2231, -81));

        maps\mp\_fx::loopfx("building_fire_small", (1189, 3527, -79), 2, (1189, 3527, 21));
        maps\mp\_fx::loopfx("building_fire_small", (2863, 1983, -134), 2, (2863, 1983, -43));

        maps\mp\_fx::loopfx("dust_wind", (1045, 1634, -161), 1, (1045, 1634, -58));
        maps\mp\_fx::loopfx("dust_wind", (-195, 3440, -165), 1, (-195, 3440, -59));
        maps\mp\_fx::loopfx("dust_wind", (2047, 827, -108), 1, (2047, 827, -8));
        maps\mp\_fx::loopfx("dust_wind", (-109, -439, -138), 1, (-109, -439, -38));
        maps\mp\_fx::loopfx("dust_wind", (2024, 3020, -140), 1, (2024, 3020, -40));
        maps\mp\_fx::loopfx("dust_wind", (1579, 2564, -131), 1, (1579, 2564, -39));
        maps\mp\_fx::loopfx("dust_wind", (-1273, 665, -129), 1, (-1273, 665, -29));
        maps\mp\_fx::loopfx("dust_wind", (768, 394, -124), 1, (768, 394, -24));
        maps\mp\_fx::loopfx("dust_wind", (1911, 5286, -61), 1, (1911, 5286, 49));
        maps\mp\_fx::loopfx("dust_wind", (2759, 4077, -67), 1, (2759, 4077, 47));
        maps\mp\_fx::loopfx("dust_wind", (-1129, 2229, -165), 1, (-1129, 2229, -65));
        maps\mp\_fx::loopfx("dust_wind", (-119, 5306, -88), 1, (-119, 5306, 62));
        maps\mp\_fx::loopfx("dust_wind", (473, 2442, -152), 1, (473, 2442, -52));
        maps\mp\_fx::loopfx("dust_wind", (325, 1431, -140), 1, (325, 1431, -40));
        maps\mp\_fx::loopfx("dust_wind", (-284, -469, -125), 1, (-284, -469, -25));
        maps\mp\_fx::loopfx("dust_wind", (2581, 1145, -127), 1, (258, 1145, -27));
    }
}