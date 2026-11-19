class SkySeqAct_ChangeTeam extends SequenceAction;

var() byte NewTeamNum;

event Activated()
{
    local SeqVar_Object ObjVar;
    local Pawn P;
    local Controller C;
    local SkyGame Game;
    local Actor A;

    Game = SkyGame(GetWorldInfo().Game);
    // End:0x262
    if(Game != none)
    {
        // End:0x261
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Target")
        {
            C = Controller(ObjVar.GetObjectValue());
            // End:0x139
            if(C == none)
            {
                P = Pawn(ObjVar.GetObjectValue());
                // End:0xF6
                if(P != none)
                {
                    // End:0xC2
                    if(P.Controller != none)
                    {
                        C = P.Controller;                        
                    }
                    else
                    {
                        // End:0xF3
                        if(SkyGameVehicle(P) != none)
                        {
                            SkyGameVehicle(P).SetTeamNum(NewTeamNum);                            
                            return;
                        }
                    }                    
                }
                else
                {
                    A = Actor(ObjVar.GetObjectValue());
                    // End:0x139
                    if(A != none)
                    {
                        A.SetTeamNum(NewTeamNum);
                    }
                }
            }
            // End:0x169
            if(SkyAIController(C) != none)
            {
                SkyAIController(C).SetTeam(int(NewTeamNum));
            }
            // End:0x260
            if((C != none) && C.PlayerReplicationInfo != none)
            {
                // End:0x1F2
                if(C.PlayerReplicationInfo.Team != none)
                {
                    C.PlayerReplicationInfo.Team.RemoveFromTeam(C);
                    C.PlayerReplicationInfo.Team = none;
                }
                // End:0x22D
                if(int(NewTeamNum) != int(255))
                {
                    Game.Teams[int(NewTeamNum)].AddToTeam(C);
                }
                // End:0x260
                if(C.Pawn != none)
                {
                    C.Pawn.NotifyTeamChanged();
                }
            }            
        }        
    }
    //return;    
}
