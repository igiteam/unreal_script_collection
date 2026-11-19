class SkyScoreboard extends ScoreBoard
    config(Game);

var const Texture2D HudTexture;
var int ScrollTop;

function PostBeginPlay()
{
    super(HUD).PostBeginPlay();
    //return;    
}

function DrawHUD()
{
    local int I, Idx, ItemsPerPage;
    local GameReplicationInfo GRI;
    local float LeftPos, TopPos, ColX, Width, Height, XL,
	    YL, W, H, nw;

    local string Str, scrollmsg;
    local int ShowCount;

    GRI = WorldInfo.GRI;
    // End:0x22
    if(GRI == none)
    {
        return;
    }
    WorldInfo.GRI.SortPRIArray();
    I = 0;
    J0x47:

    // End:0x97 [Loop If]
    if(I < GRI.PRIArray.Length)
    {
        // End:0x8D
        if(!GRI.PRIArray[I].bIsSpectator)
        {
            ShowCount++;
        }
        I++;
        // [Loop Continue]
        goto J0x47;
    }
    LeftPos = Canvas.ClipX * 0.0500000;
    TopPos = Canvas.ClipY * 0.1500000;
    Width = Canvas.ClipX * 0.9000000;
    Height = Canvas.ClipY * 0.7000000;
    Canvas.Font = Class'Engine.Engine'.static.GetLargeFont();
    Str = GRI.GameClass.default.GameName;
    Canvas.StrLen(Str, XL, YL);
    Canvas.SetPos((Canvas.ClipX * 0.5000000) - (XL * 0.5000000), 5.0000000);
    Canvas.DrawText(Str);
    Canvas.SetDrawColor(0, 0, 0, 128);
    Canvas.SetPos(LeftPos, TopPos);
    Canvas.DrawTile(Canvas.DefaultTexture, Width, Height, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
    Canvas.SetPos(LeftPos + float(2), TopPos + float(2));
    Canvas.SetDrawColor(255, 255, 0, 255);
    Canvas.DrawBox(Width - float(4), Height - float(4));
    // End:0x3B9
    if(PlayerOwner.IsInState('Dead'))
    {
        Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
        scrollmsg = "Respawn expected in " $ string(int(PlayerOwner.GetTimerRate('ServerRestartPlayer') - PlayerOwner.GetTimerCount('ServerRestartPlayer')));
        Canvas.StrLen(scrollmsg, W, H);
        Canvas.SetPos((Canvas.ClipX * 0.5000000) - (W * 0.5000000), ((TopPos + Height) - H) - float(3));
        Canvas.DrawText(scrollmsg);
    }
    Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    LeftPos += float(16);
    TopPos += float(16);
    Width -= float(32);
    Height -= float(64);
    Canvas.StrLen("00. ", XL, YL);
    nw = XL;
    ItemsPerPage = int(Height / (YL * 1.2000000));
    // End:0x471
    if((ScrollTop < 0) || ShowCount <= ItemsPerPage)
    {
        ScrollTop = 0;        
    }
    else
    {
        // End:0x499
        if((ScrollTop + ItemsPerPage) > ShowCount)
        {
            ScrollTop = ShowCount - ItemsPerPage;
        }
    }
    ColX = LeftPos + (Width * 0.8500000);
    I = 0;
    J0x4B9:

    // End:0x805 [Loop If]
    if(I < ItemsPerPage)
    {
        Idx = ScrollTop + I;
        // End:0x4F7
        if(Idx >= GRI.PRIArray.Length)
        {
            // [Explicit Break]
            goto J0x805;
        }
        Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
        // End:0x55B
        if(GRI.PRIArray[Idx] == PlayerOwner.PlayerReplicationInfo)
        {
            Canvas.SetDrawColor(0, 255, 255, 255);            
        }
        else
        {
            Canvas.SetDrawColor(255, 255, 255, 255);
        }
        Canvas.SetPos(LeftPos, TopPos);
        Canvas.DrawText(("" $ string(Idx + 1)) $ ".");
        Canvas.SetPos((LeftPos + nw) + float(5), TopPos);
        Canvas.DrawText(GRI.PRIArray[Idx].PlayerName);
        Str = "" $ string(int(GRI.PRIArray[Idx].Score));
        Canvas.StrLen(Str, W, H);
        Canvas.SetPos((ColX - (float(25) * (Canvas.ClipX / float(1024)))) - W, TopPos);
        Canvas.DrawText(Str);
        Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
        Str = ("Deaths:" @ string(int(GRI.PRIArray[Idx].Deaths))) $ " ";
        Canvas.StrLen(Str, W, H);
        Canvas.SetPos(ColX, TopPos);
        Canvas.DrawText(Str);
        // End:0x7E8
        if(int(PlayerOwner.Role) < int(ROLE_Authority))
        {
            Str = ("Ping:" @ string(GRI.PRIArray[Idx].Ping)) $ " ";
            Canvas.SetPos(ColX, TopPos + H);
            Canvas.DrawText(Str);
        }
        TopPos += (YL * 1.2000000);
        I++;
        // [Loop Continue]
        goto J0x4B9;
    }
    J0x805:

    //return;    
}

simulated function ChangeState(bool bIsVisible)
{
    local SkyPlayerInput PInput;

    PInput = SkyPlayerInput(PlayerOwner.PlayerInput);
    // End:0x6A
    if(PInput != none)
    {
        // End:0x51
        if(bIsVisible)
        {
            PInput.__OnInputKey__Delegate = SBInputKey;
            ScrollTop = 0;            
        }
        else
        {
            PInput.__OnInputKey__Delegate = None;
        }
    }
    //return;    
}

function bool SBInputKey(int ControllerId, name Key, Object.EInputEvent Event, float AmountDepressed)
{
    // End:0x5E
    if((Key == 'MouseScrollUp') || Key == 'MouseScrollDown')
    {
        // End:0x5C
        if(int(Event) == int(1))
        {
            // End:0x55
            if(Key == 'MouseScrollUp')
            {
                ScrollTop--;                
            }
            else
            {
                ScrollTop++;
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}
