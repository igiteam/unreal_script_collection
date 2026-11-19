class SeqAct_FadeToColor extends SeqAct_PostProcessBase
    hidecategories(Object);

var() Color FadeColor;
var() float FadeTime;
var() bool FadeAllPlayers;

function FadeAll()
{
    local WorldInfo WorldInfo;
    local PlayerController PlayerController;

    WorldInfo = GetWorldInfo();
    // End:0xCE
    if(WorldInfo != none)
    {
        // End:0xCD
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PlayerController)
        {
            // End:0xCC
            if(EvilPlayerController(PlayerController) != none)
            {
                EvilPlayerController(PlayerController).GetPPManager().EnableFade(ColorToLinearColor(FadeColor), FadeTime);
            }            
        }        
    }
    //return;    
}

event Activated()
{
    local EvilPlayerController EPC;

    // End:0x1A
    if(FadeAllPlayers)
    {
        FadeAll();        
    }
    else
    {
        EPC = GetEPC();
        // End:0x91
        if(EPC != none)
        {
            EPC.GetPPManager().EnableFade(ColorToLinearColor(FadeColor), FadeTime);
        }
    }
    //return;    
}

defaultproperties
{
    FadeTime=1.0000000
    ObjName="SeqAct_FadeToColor"
}