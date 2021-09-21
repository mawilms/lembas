-- color.lua
-- Written By Habna


_G.Color = {}; -- Color table in _G
-- Color( Alpha, Red, Green, Blue ) or Color( Red, Green, Blue )
Color["silver"] = Turbine.UI.Color.Silver;
Color["blue"] = Turbine.UI.Color.Blue;
Color["trueblue"] = Turbine.UI.Color( 0.2, 0.5, 0.9 );
--Color["trueblue"] = Turbine.UI.Color.;
Color["stblue"] = Turbine.UI.Color( 1, 0, 0, 0.5 );
Color["niceblue"] = Turbine.UI.Color( 0, 0.66, 0.75)
Color["green"] = Turbine.UI.Color.Lime;
Color["nicegreen"] = Turbine.UI.Color( 0.33, 0.66, 0.33 );
Color["red"] = Turbine.UI.Color.Red;
Color["grey"] = Turbine.UI.Color( 0.5, 0.5, 0.5 );
Color["lightgrey"] = Turbine.UI.Color( 0.5, 0.5, 0.5, 0.5 );
Color["lightgrey1"] = Turbine.UI.Color( 0.4, 0.4, 0.4);
Color["verylightgrey"] = Turbine.UI.Color( 0.05, 0.5, 0.5, 0.5 );
Color["darkgrey"] = Turbine.UI.Color( 0.1, 0.1, 0.1 );
Color["gold"] = Turbine.UI.Color.Gold;
Color["rustedgold"] = Turbine.UI.Color( 0.7, 0.6, 0.2 );
Color["nicegold"] = Turbine.UI.Color(1, 0.9, 0.5);
Color["transparent"] = Turbine.UI.Color( 0.3, 0.3, 0.3, 0.3 ); --Not fully transparent
Color["ftransparent"] = Turbine.UI.Color ( 0, 0, 0, 0 ); -- Fully
Color["black"] = Turbine.UI.Color.Black;
Color["5black"] = Turbine.UI.Color( 0.5, 0, 0, 0 );
Color["3black"] = Turbine.UI.Color( 0.3, 0, 0, 0 );
Color["white"] = Turbine.UI.Color.White;
Color["orange"] = Turbine.UI.Color( 1, 0.7, 0 ); -- first age = orange
Color["cyan"] = Turbine.UI.Color( 0, 1, 1 ); -- second age = cyan
Color["purple"] = Turbine.UI.Color( 1, 0, 1 ); -- third age = purple

Color["brown"] = Turbine.UI.Color( 0.5, 0.4, 0.2);

Color["menuborder"] = Turbine.UI.Color( 0.5, 0, 0.138, 0.863 );

Color["TurbineWhite"] = Turbine.UI.Color(1, 0.9, 0.9, 0.9);
Color["TurbineYellow"] = Turbine.UI.Color( 1, 231/255, 231/255, 69/231);
Color["TurineOrange"] = Turbine.UI.Color( 1, 190/255, 148/255, 0 );
Color["TurbineLightYellow"] = Turbine.UI.Color( 1, 232/255, 229/255, 174/255 );
Color["TurbineGrey"] = Turbine.UI.Color( 1, 0.5, 0.5, 0.5 );

Color["none"] = Turbine.UI.Color();