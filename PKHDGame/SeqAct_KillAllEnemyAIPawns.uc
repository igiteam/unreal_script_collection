class SeqAct_KillAllEnemyAIPawns extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x4E
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'EvilPlayerController', PC)
    {
        // End:0x4E
        break;        
    }    
    // End:0x60
    if(PC == none)
    {
        return;
    }
    // End:0x176
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().DynamicActors(Class'EvilPawn', P)
    {
        // End:0x175
        if(!P.IsPlayerPawn() && !PC.Pawn.IsSameTeam(P))
        {
            // End:0x15D
            if(P.Controller != none)
            {
                P.Controller.Destroy();
            }
            P.Destroy();
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Kill All Enemy AI Pawns"
}