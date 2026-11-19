class SeqAct_EndOfGame extends SeqAct_EndOfLevel
    hidecategories(Object);

var() class<AdvGFxUI_Credits> CreditsMovie;

event Activated()
{
    local AdvGRI_SP GRI;
    local AdvPlayerController PC;

    GRI = AdvGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super.Activated();
    GRI.EndOfGame();
    // End:0x184
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0x110
        if(InputLinks[0].bHasImpulse || CreditsMovie == none)
        {
            PC.ReturnToMainMenu(false);
            // End:0x183
            continue;
        }
        // End:0x183
        if(AdvGFxHudWrapper(PC.myHUD) != none)
        {
            AdvGFxHudWrapper(PC.myHUD).ShowCredits(CreditsMovie);
        }        
    }    
    //return;    
}

defaultproperties
{
    CreditsMovie=Class'AdvGFxUI_Credits'
    InputLinks[0]=(LinkDesc="Return To Menu",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Show Credits",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="End of game"
}