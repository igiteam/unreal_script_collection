class SeqAct_Unfade extends SeqAct_PostProcessBase
    hidecategories(Object);

var() float UnfadeTime;
var() bool UnfadeAllPlayers;

function UnfadeAll()
{
    local WorldInfo WorldInfo;
    local PlayerController PlayerController;

    WorldInfo = GetWorldInfo();
    // End:0xB8
    if(WorldInfo != none)
    {
        // End:0xB7
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PlayerController)
        {
            // End:0xB6
            if(EvilPlayerController(PlayerController) != none)
            {
                EvilPlayerController(PlayerController).GetPPManager().Unfade(UnfadeTime);
            }            
        }        
    }
    //return;    
}

event Activated()
{
    local EvilPlayerController EPC;

    // End:0x1A
    if(UnfadeAllPlayers)
    {
        UnfadeAll();        
    }
    else
    {
        EPC = GetEPC();
        // End:0x7B
        if(EPC != none)
        {
            EPC.GetPPManager().Unfade(UnfadeTime);
        }
    }
    //return;    
}

defaultproperties
{
    UnfadeTime=1.0000000
    ObjName="SeqAct_Unfade"
}