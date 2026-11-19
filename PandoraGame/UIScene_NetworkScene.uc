class UIScene_NetworkScene extends UIScene_BaseFrontEnd;

function OnPlayerTalking(UniqueNetId TalkingPlayer)
{
    //return;    
}

function SPPlayerReplicationInfo ResolveUniqueNetID(UniqueNetId TestId)
{
    local PandoraGRI GRI;
    local int I;

    GRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0xB9
    if(GRI != none)
    {
        I = 0;
        J0x31:

        // End:0xB9 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0xAF
            if((GRI.PRIArray[I] != none) && GRI.PRIArray[I].UniqueId == TestId)
            {
                return SPPlayerReplicationInfo(GRI.PRIArray[I]);
            }
            I++;
            // [Loop Continue]
            goto J0x31;
        }
    }
    return none;
    //return ReturnValue;    
}

function bool CanCommunicate(UniqueNetId TalkingPlayer)
{
    local OnlineSubsystem OnlineSub;
    local int I;
    local OnlineSubsystem.EFeaturePrivilegeLevel PrivLevel;
    local GameUISceneClient GameSceneClient;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    GameSceneClient = GameUISceneClient(SceneClient);
    I = 0;
    J0x2D:

    // End:0x1C4 [Loop If]
    if(I < GameSceneClient.Outer.Outer.Outer.GamePlayers.Length)
    {
        PrivLevel = OnlineSub.PlayerInterface.CanCommunicate(byte(GameSceneClient.Outer.Outer.Outer.GamePlayers[I].ControllerId));
        // End:0xDE
        if(int(PrivLevel) == int(0))
        {
            return false;
            // [Explicit Continue]
            goto J0x1BA;
        }
        // End:0x1BA
        if((GameSceneClient.Outer.Outer.Outer.GamePlayers[I].Actor.PlayerReplicationInfo.UniqueId != TalkingPlayer && int(PrivLevel) == int(1)) && !OnlineSub.PlayerInterface.IsFriend(byte(GameSceneClient.Outer.Outer.Outer.GamePlayers[I].ControllerId), TalkingPlayer))
        {
            return false;
        }
        J0x1BA:

        I++;
        // [Loop Continue]
        goto J0x2D;
    }
    return true;
    //return ReturnValue;    
}

function TrackChat()
{
    local OnlineSubsystem OnlineSub;

    // End:0x9D
    if(IsXboxBuild())
    {
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x9D
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
        {
            // End:0x9D
            if(CanCommunicate(GetPC().PlayerReplicationInfo.UniqueId))
            {
                OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);
            }
        }
    }
    //return;    
}

function IgnoreChat()
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x69
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
    }
    //return;    
}

function bool IsHeadsetPresent(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x6A
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        // End:0x6A
        if(OnlineSub.VoiceInterface.IsHeadsetPresent(LocalUserNum))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function UpdateHeadsetState()
{
    local PandoraPlayerController PPC;
    local SPPlayerReplicationInfo SPPRI;

    // End:0xA6
    if(IsXboxBuild())
    {
        PPC = GetPC();
        SPPRI = SPPlayerReplicationInfo(PPC.PlayerReplicationInfo);
        // End:0x7E
        if(IsHeadsetPresent(byte(LocPlayer.ControllerId)))
        {
            // End:0x7B
            if(!SPPRI.bHeadsetPresent)
            {
                SPPRI.SetHeadsetIsPresent(true);
            }            
        }
        else
        {
            // End:0xA6
            if(SPPRI.bHeadsetPresent)
            {
                SPPRI.SetHeadsetIsPresent(false);
            }
        }
    }
    //return;    
}

function LoadChildScenes()
{
    //return;    
}

function EnableMPLoadingScreen()
{
    //return;    
}

function DisableMPLoadingScreen()
{
    //return;    
}

function NotifyGameSessionEnded()
{
    IgnoreChat();
    super.NotifyGameSessionEnded();
    //return;    
}
