class EvilGFxHud extends GFxMoviePlayer
    config(UI);

struct MessageRow
{
    var GFxObject MC;
    var GFxObject TF;
    var float StartFadeTime;
    var int Y;

    structdefaultproperties
    {
        MC=none
        TF=none
        StartFadeTime=0.0000000
        Y=0
    }
};

var WorldInfo ThisWorld;
var GFxObject LogMC;
var array<MessageRow> Messages;
var array<MessageRow> FreeMessages;
var float MessageHeight;
var int NumMessages;
var EvilGameReplicationInfo GRI;
var bool bDrawWeaponCrosshairs;
var bool bVisibilityNeedsUpdate;
var GFxObject RootMC;
var GFxObject HudMC;
var float LastGameplayIndicatorShowTime;
var float LastHUDRenderTime;
var GFxObject HUDOverlay;
var transient int CaptionComponentItemCount;
var transient int CaptionBorderComponentItemCount;

function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Killed, class<EvilDmgType_Base> Dmg)
{
    //return;    
}

function Init(optional LocalPlayer Player)
{
    local int J;

    super.Init(Player);
    ThisWorld = GetPC().WorldInfo;
    GRI = EvilGameReplicationInfo(GetPC().WorldInfo.GRI);
    Start();
    Advance(0.0000000);
    NumMessages = 0;
    LogMC = GetVariableObject("_root.HUD.log");
    J = 0;
    J0xD8:

    // End:0x100 [Loop If]
    if(J < 15)
    {
        InitMessageRow();
        J++;
        // [Loop Continue]
        goto J0xD8;
    }
    //return;    
}

function GFxObject CreateMessageRow()
{
    return LogMC.AttachMovie("LogMessage", "logMessage" $ string(NumMessages++));
    //return ReturnValue;    
}

function GFxObject InitMessageRow()
{
    local MessageRow mrow;

    mrow.Y = 0;
    mrow.MC = CreateMessageRow();
    mrow.TF = mrow.MC.GetObject("message").GetObject("textField");
    mrow.TF.SetBool("html", true);
    mrow.TF.SetString("htmlText", "");
    FreeMessages.AddItem(mrow);
    return mrow.MC;
    //return ReturnValue;    
}

function RemoveMessage()
{
    //return;    
}

function AddMessage(string Type, string msg)
{
    local MessageRow mrow;
    local ASDisplayInfo DI;
    local int J;

    // End:0x13
    if(Len(msg) == 0)
    {
        return;
    }
    // End:0x60
    if(FreeMessages.Length > 0)
    {
        mrow = FreeMessages[FreeMessages.Length - 1];
        FreeMessages.Remove(FreeMessages.Length - 1, 1);        
    }
    else
    {
        mrow = Messages[Messages.Length - 1];
        Messages.Remove(Messages.Length - 1, 1);
    }
    mrow.TF.SetString(Type, msg);
    mrow.Y = 0;
    DI.hasY = true;
    DI.Y = 0.0000000;
    mrow.MC.SetDisplayInfo(DI);
    mrow.MC.GotoAndPlay("show");
    J = 0;
    J0x1BC:

    // End:0x29F [Loop If]
    if(J < Messages.Length)
    {
        Messages[J].Y -= int(MessageHeight);
        DI.Y = float(Messages[J].Y);
        Messages[J].MC.SetDisplayInfo(DI);
        J++;
        // [Loop Continue]
        goto J0x1BC;
    }
    Messages.InsertItem(0, mrow);
    //return;    
}

function ClearMessages()
{
    local MessageRow mrow;
    local int I;

    I = Messages.Length - 1;
    J0x17:

    // End:0x7C [Loop If]
    if(I >= 0)
    {
        mrow = Messages[I];
        Messages.Remove(I, 1);
        FreeMessages.AddItem(mrow);
        --I;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

function TickHud(float DeltaTime)
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    LastHUDRenderTime = GetPC().WorldInfo.TimeSeconds;
    GRI = EvilGameReplicationInfo(PC.WorldInfo.GRI);
    // End:0xD6
    if(bVisibilityNeedsUpdate)
    {
        SetHUDElementsVisible(true);
        bVisibilityNeedsUpdate = false;
    }
    // End:0x1D8
    if((PC.FindNewBestPOIToLookAt() != none) || Abs(PC.WorldInfo.TimeSeconds - LastGameplayIndicatorShowTime) > float(20))
    {
        // End:0x1D8
        if(!PC.bLookingAtPointOfInterest && PC.HasBestPOIToLookAt())
        {
            ShowGameplayIndicator(3);
            LastGameplayIndicatorShowTime = PC.WorldInfo.TimeSeconds;
        }
    }
    //return;    
}

function ToggleCrosshair(bool bToggle)
{
    //return;    
}

function SetHUDElementsVisible(bool Visible)
{
    //return;    
}

function ShowGameplayIndicator(optional int soundType = 0)
{
    //return;    
}

function HideGameplayIndicator()
{
    //return;    
}

function string ParseString(string Text)
{
    local string Result, Prefix, postfix;

    postfix = "_small";
    // End:0x5F
    if(GetPC().WorldInfo.IsConsoleBuild(2))
    {
        Prefix = "ps3_";        
    }
    else
    {
        // End:0xE7
        if(GetPC().WorldInfo.IsConsoleBuild(1) || GetPC().PlayerInput.bUsingGamepad)
        {
            Prefix = "xbox_";            
        }
        else
        {
            Prefix = "pc_";
        }
    }
    Result = Text;
    Result = Repl(Result, "{A}", ((("<img src='" $ Prefix) $ "a") $ postfix) $ "'>", false);
    Result = Repl(Result, "{B}", ((("<img src='" $ Prefix) $ "b") $ postfix) $ "'>", false);
    Result = Repl(Result, "{X}", ((("<img src='" $ Prefix) $ "x") $ postfix) $ "'>", false);
    Result = Repl(Result, "{Y}", ((("<img src='" $ Prefix) $ "y") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R1}", ((("<img src='" $ Prefix) $ "r1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R2}", ((("<img src='" $ Prefix) $ "r2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L1}", ((("<img src='" $ Prefix) $ "l1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L2}", ((("<img src='" $ Prefix) $ "l2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{SKULL}", ("<img src='icon_skull" $ postfix) $ "'>", false);
    Result = Repl(Result, "{MMB}", ("<img src='pc_b" $ postfix) $ "'>", false);
    return Result;
    //return ReturnValue;    
}

function SetLocalizedMessageText(string Text, optional bool long = false, optional bool html = false)
{
    //return;    
}

function SetLocalizedHintMessageText(string Text, optional bool html = false)
{
    //return;    
}

function HideLocalizedHintMessage()
{
    //return;    
}

function GFxObject AddCaptionComponent()
{
    local GFxObject GFxObj;

    GFxObj = HUDOverlay.AttachMovie("caption", "caption" $ string(CaptionComponentItemCount++));
    return GFxObj;
    //return ReturnValue;    
}

function GFxObject AddCaptionComponentBorder()
{
    local GFxObject GFxObj;

    GFxObj = HUDOverlay.AttachMovie("border", "border" $ string(CaptionBorderComponentItemCount++));
    return GFxObj;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    //return;    
}

defaultproperties
{
    MessageHeight=38.0000000
    bDrawWeaponCrosshairs=true
    LastGameplayIndicatorShowTime=-9999.0000000
    bDisplayWithHudOff=false
    bAllowInput=false
    bAllowFocus=false
    bOnlyOwnerFocusable=true
    bDiscardNonOwnerInput=true
}