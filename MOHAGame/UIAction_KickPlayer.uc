class UIAction_KickPlayer extends UIAction
    hidecategories(Object);

event Activated()
{
    local UIScene_MPBase localScene;
    local bool bSuccess;

    // End:0x4E
    if(Targets.Length > 0)
    {
        localScene = UIScene_MPBase(GetOwnerScene());
        // End:0x4E
        if(localScene != none)
        {
            bSuccess = localScene.OnKickPlayer(UIScreenObject(Targets[0]));
        }
    }
    // End:0x91
    if(ObjClassVersion >= 2)
    {
        // End:0x7A
        if(bSuccess)
        {
            OutputLinks[0].bHasImpulse = true;            
        }
        else
        {
            OutputLinks[1].bHasImpulse = true;
        }        
    }
    else
    {
        OutputLinks[0].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=2
    ObjName="Kick Player"
}