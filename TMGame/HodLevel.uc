class HodLevel extends HodObject
	native(TG)
	dependson(general_human);

var HodPlayer player;
var int gameskill;
var HodAI painAI;

var array<bool> flag;

function Construct()
{
	gameskill = 3;
	flag.Add(hod_flag_element_count);
}
