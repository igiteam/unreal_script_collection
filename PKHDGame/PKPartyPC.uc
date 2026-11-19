class PKPartyPC extends PKPlayerController
    config(Game)
    hidecategories(Navigation);

var bool bSignedIn;

function OnLoginChange(byte LocalUserNum)
{
    local PainGFxMenuHudWrapper PKMH;
    local PKLocalPlayer LP;

    // End:0x16C
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        super.OnLoginChange(LocalUserNum);
        // End:0x169
        if(IsPrimaryPlayer())
        {
            PKMH = PainGFxMenuHudWrapper(myHUD);
            // End:0x169
            if((PKMH != none) && PKMH.FrontEnd != none)
            {
                // End:0x10C
                if(!IsOnTitleScreen())
                {
                    LP = PKLocalPlayer(Player);
                    // End:0xF5
                    if(LP != none)
                    {
                        LP.bIsFirstFrontEndLoad = true;
                    }
                    ShowLoginChangeError();
                    RestartFrontEnd();                    
                }
                else
                {
                    // End:0x169
                    if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
                    {
                        ShowLoginChangeError();
                        RestartFrontEnd();
                    }
                }
            }
        }        
    }
    else
    {
        ShowLoginChangeError();
        ReturnToMainMenu(true);
        super.OnLoginChange(LocalUserNum);
    }
    //return;    
}

function OnNewLogin()
{
    // End:0x33
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        super.OnNewLogin();
    }
    //return;    
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    local PKFrontEnd FrontEnd;
    local PainGRI GRI;

    super.OnLoginStatusChange(NewStatus, NewId);
    bSignedIn = int(NewStatus) != int(0);
    // End:0x236
    if(int(NewStatus) < int(2))
    {
        FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
        GRI = FrontEnd.GetMenuGRI();
        // End:0x236
        if(FrontEnd != none)
        {
            // End:0x196
            if((GRI != none) && int(GRI.CurrentPartyType) < int(2))
            {
                FrontEnd.LocalPartyCreated();
                // End:0x196
                if(FrontEnd.Party != none)
                {
                    FrontEnd.Party.bForceUpdateTitle = true;
                    FrontEnd.Party.bForceUpdatePlayerPanel = true;
                }
            }
            // End:0x236
            if(FrontEnd.bOnMPScreens || (FrontEnd.LeaderboardMenu != none) && FrontEnd.CurrentScene == FrontEnd.LeaderboardMenu)
            {
                ShowOSSConnectionLostMessage();
                ReturnToMainMenu(true);
            }
        }
    }
    //return;    
}

function RestartFrontEnd()
{
    local PainGFxMenuHudWrapper PKMH;
    local PKLocalPlayer LP;

    PKMH = PainGFxMenuHudWrapper(myHUD);
    LP = PKLocalPlayer(Player);
    // End:0xB3
    if(IsPrimaryPlayer())
    {
        // End:0x84
        if(bIsReturningToMainMenu)
        {
            // End:0x84
            if(LP != none)
            {
                LP.bIsFirstFrontEndLoad = true;
                return;
            }
        }
        // End:0xB3
        if(PKMH != none)
        {
            PKMH.RestartFrontEnd();
        }
    }
    //return;    
}

function AcceptDeferredInvite()
{
    //return;    
}

function bool ShouldShowStartupNotifiesBeforeInvite()
{
    return false;
    //return ReturnValue;    
}

function OnLinkStatusChange(bool bIsConnected)
{
    //return;    
}

reliable client simulated function ClientSetOnlineStatus()
{
    SetRichPresenceString(4);
    super(PlayerController).ClientSetOnlineStatus();
    //return;    
}

defaultproperties
{
    // Reference: EvilSceneCaptureHighlightComponent'Default__PKPartyPC.HighlightComponent'
    // Archetype: EvilSceneCaptureHighlightComponent'Default__PKPlayerController.HighlightComponent'
    begin object name="HighlightComponent"
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__PKPartyPC.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__PKPartyPC.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__PKPartyPC.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}