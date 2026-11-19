//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_AddMapInfo extends SequenceAction;

var() bool bClear;

event Activated()
{
 	local HDMapInfo HDMap;
 	local Object O;
 	local Pawn P;
 	local Controller C;

 	HDMap = HDMapInfo(GetWorldInfo().GetMapInfo());
 	if(HDMap != none)
 	{
 	    if(bClear)
 	        HDMap.TeamPawn.length = 0;

        foreach Targets(O)
        {
           C = Controller(O);
           if(C != none)
               P = C.Pawn;
           else
               P = Pawn(O);

           if(P != none)
               HDMap.TeamPawn.AddItem(P);
        }
	}
}


