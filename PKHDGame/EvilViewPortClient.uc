class EvilViewPortClient extends UDKGameViewportClient within Engine
    transient
    config(Game);

event bool Init(out string OutError)
{
    local bool ret;
    local EvilViewPortInput EvilCustomViewport;

    ret = super(GameViewportClient).Init(OutError);
    EvilCustomViewport = new (self) Class'EvilViewPortInput';
    // End:0x99
    if((InsertInteraction(EvilCustomViewport)) == -1)
    {
        OutError = "Failed to add  interaction to GlobalInteractions array!";
        return false;
    }
    return ret;
    //return ReturnValue;    
}

function UpdateActiveSplitscreenType()
{
    // End:0x23
    if(int(DesiredSplitscreenType) == int(0))
    {
        ActiveSplitscreenType = 0;        
    }
    else
    {
        super(GameViewportClient).UpdateActiveSplitscreenType();
    }
    //return;    
}

event LocalPlayer CreatePlayer(int ControllerId, out string OutError, bool bSpawnActor)
{
    local LocalPlayer LP;
    local PlayerController PC;

    LP = super(GameViewportClient).CreatePlayer(ControllerId, OutError, bSpawnActor);
    // End:0xC7
    if(LP != none)
    {
        switch(Outer.GamePlayers.Length)
        {
            // End:0x6C
            case 0:
            // End:0x7F
            case 1:
                DesiredSplitscreenType = 0;
                // End:0xC7
                break;
            // End:0x9A
            case 2:
                DesiredSplitscreenType = Default2PSplitType;
                // End:0xC7
                break;
            // End:0xB5
            case 3:
                DesiredSplitscreenType = Default3PSplitType;
                // End:0xC7
                break;
            // End:0xFFFF
            default:
                DesiredSplitscreenType = 5;
                // End:0xC7
                break;
                break;
        }
    }
    // End:0x142
    foreach LP.Actor.LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x141
        if(PC.bCinematicMode)
        {
            DesiredSplitscreenType = 0;
            // End:0x142
            break;
        }        
    }    
    return LP;
    //return ReturnValue;    
}

event GameSessionEnded()
{
    switch(Outer.GamePlayers.Length)
    {
        // End:0x2D
        case 0:
        // End:0x40
        case 1:
            DesiredSplitscreenType = 0;
            // End:0x88
            break;
        // End:0x5B
        case 2:
            DesiredSplitscreenType = Default2PSplitType;
            // End:0x88
            break;
        // End:0x76
        case 3:
            DesiredSplitscreenType = Default3PSplitType;
            // End:0x88
            break;
        // End:0xFFFF
        default:
            DesiredSplitscreenType = 5;
            // End:0x88
            break;
            break;
    }
    super(GameViewportClient).GameSessionEnded();
    //return;    
}

function DrawTransition(Canvas Canvas)
{
    switch(Outer.TransitionType)
    {
        // End:0x30
        case 2:
            // End:0xA7
            break;
        // End:0x54
        case 3:
            DrawTransitionMessage(Canvas, SavingMessage);
            // End:0xA7
            break;
        // End:0x78
        case 4:
            DrawTransitionMessage(Canvas, ConnectingMessage);
            // End:0xA7
            break;
        // End:0x9C
        case 5:
            DrawTransitionMessage(Canvas, PrecachingMessage);
            // End:0xA7
            break;
        // End:0xA4
        case 1:
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

defaultproperties
{
    Default2PSplitType=ESplitScreenType.eSST_2P_VERTICAL
}