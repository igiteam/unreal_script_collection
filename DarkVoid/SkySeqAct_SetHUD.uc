class SkySeqAct_SetHUD extends SequenceAction
    native;

var() HUD HUDArchetype_PC;
var() HUD HUDArchetype_PS3;
var() HUD HUDArchetype_XBOX;

// Export USkySeqAct_SetHUD::execGetHUDArchetype(FFrame&, void* const)
native function HUD GetHUDArchetype();

event Activated()
{
    local PlayerController PC;
    local WorldInfo WI;

    PC = PlayerController(Pawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Controller);
    // End:0x9B
    if(PC != none)
    {
        WI = GetWorldInfo();
        // End:0x9B
        if(WI != none)
        {
            PC.ClientSetHUD(GetHUDArchetype(), WI.Game.ScoreBoardType);
        }
    }
    //return;    
}
