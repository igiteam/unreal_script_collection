class UIAction_IsHost extends UIAction
    hidecategories(Object);

event Activated()
{
    local bool bIsHost;
    local MOHAMultiplayerGameInfo localGI;
    local Plasma P;

    bIsHost = false;
    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0xA1
    if((P != none) && !P.isRanked())
    {
        localGI = MOHAMultiplayerGameInfo(GetWorldInfo().Game);
        // End:0xA1
        if((localGI != none) && localGI.bPlayerCreatedUnrankedMatch)
        {
            // End:0xA1
            if(int(GetWorldInfo().NetMode) != int(NM_Client))
            {
                bIsHost = true;
            }
        }
    }
    // End:0xC1
    if(bIsHost)
    {
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        OutputLinks[1].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    OutputLinks[0]=(Links=none,LinkDesc="Yes",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="No",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Is Host"
}