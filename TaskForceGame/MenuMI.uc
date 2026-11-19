class MenuMI extends MapInfo
	placeable
	native;
	
var SinglePlayerCarryover		PlayerCarryover;

native function InitCarryover();

function LogCarryover()
{
	local int i;
	log("CARRYOVER: Starting log---------------------------");

	for (i=0; i<4; ++i)
	{
		log("  WDA["$i$"] " $ PlayerCarryover.W[i] @ PlayerCarryover.WAA[i]);
	}
	
	for (i=0; i<8; ++i)
	{
		log("  A["$i$"] " $ PlayerCarryover.A[i]);
	}
	
	for (i=0; i<8; ++i)
	{
		log("  AA["$i$"] " $ PlayerCarryover.AA[i]);
	}

	log("  CWS " $ PlayerCarryover.CWS);
	log("  PH " $ PlayerCarryover.PH);
	log("  CI " $ PlayerCarryover.CI);
	log("  DURL " $ PlayerCarryover.DURL);
	log("  CPI " $ PlayerCarryover.CPI);

	log("CARRYOVER: ending log---------------------------");
}

event ClearCheckpoints() 
{
	InitCarryover();

//	log("CARRYOVER: Clearing checkpoints");

	PlayerCarryover.CPI = -1;
	PlayerCarryover.SaveConfig();
}
