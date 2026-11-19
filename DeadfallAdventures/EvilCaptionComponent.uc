class EvilCaptionComponent extends EvilActorComponent
    config(UI);

const EVIL_HUD_PICKUP_FADEDISTANCE = 100.0;
const EVIL_HUD_PICKUP_MINSCALE = 0.7;

struct CaptionGFxPerPC
{
    var name PCInstance;
    var GFxObject GFx;
    var GFxObject GFXAlt;
    var GFxObject TF;
    var GFxObject TFAlt;
    var GFxObject BorderGFx;
    var GFxObject BorderLU;
    var GFxObject BorderRD;
    var GFxObject BorderRU;
    var GFxObject BorderLD;
    var bool IsVisible;
    var bool IsVisibleAlt;
    var float LastTimeVisible;
    var float LastTimeTrueVisible;

    structdefaultproperties
    {
        PCInstance="None"
        GFx=none
        GFXAlt=none
        TF=none
        TFAlt=none
        BorderGFx=none
        BorderLU=none
        BorderRD=none
        BorderRU=none
        BorderLD=none
        IsVisible=false
        IsVisibleAlt=false
        LastTimeVisible=0.2500000
        LastTimeTrueVisible=0.2500000
    }
};

var string CaptionText;
var string CaptionAltText;
var() string LocModule;
var() string LocSection;
var() string LocString;
var() string LocAltSection;
var() string LocAltString;
var() bool Use3DCaption;
var bool bVisible;
var() config bool bForceNotVisible;
var() bool UseColorizing;
var() bool DrawBorders;
var() bool DrawAlt;
var transient bool bLastUsingGamepad;
var() bool bAimToFullySee;
var() Vector Offset;
var() Vector OffsetAlt;
var array<CaptionGFxPerPC> Captions;
var array<MaterialInstanceConstant> MaterialInst;
var() float ReferenceDistance;
var() float FarDistance;
var() float FOVMult;
var float AimToFullySeeAlpha;

simulated function SetCaptionLoc(string Key, optional string Section = LocSection, optional string Module = LocModule)
{
    local CaptionGFxPerPC CGFx;
    local EvilPlayerController PC, PCIt;

    CaptionText = Localize(Section, Key, Module);
    LocString = Key;
    // End:0x19B
    foreach Captions(CGFx)
    {
        PC = none;
        // End:0x11E
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PCIt)
        {
            // End:0x11D
            if(PCIt.Name == CGFx.PCInstance)
            {
                PC = PCIt;
                // End:0x11E
                break;
            }            
        }        
        // End:0x19A
        if(CGFx.TF != none)
        {
            CGFx.TF.SetString("htmlText", ParseCaption(CaptionText, PC));
        }        
    }    
    //return;    
}

simulated function SetCaptionCustom(string Text)
{
    local CaptionGFxPerPC CGFx;
    local EvilPlayerController PC, PCIt;

    CaptionText = Text;
    // End:0x152
    foreach Captions(CGFx)
    {
        PC = none;
        // End:0xD5
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PCIt)
        {
            // End:0xD4
            if(PCIt.Name == CGFx.PCInstance)
            {
                PC = PCIt;
                // End:0xD5
                break;
            }            
        }        
        // End:0x151
        if(CGFx.TF != none)
        {
            CGFx.TF.SetString("htmlText", ParseCaption(CaptionText, PC));
        }        
    }    
    //return;    
}

simulated function SetCaptionAltLoc(string Key, optional string Section = LocAltSection, optional string Module = LocModule)
{
    local CaptionGFxPerPC CGFx;
    local EvilPlayerController PC, PCIt;

    CaptionAltText = Localize(Section, Key, Module);
    // End:0x188
    foreach Captions(CGFx)
    {
        PC = none;
        // End:0x10B
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PCIt)
        {
            // End:0x10A
            if(PCIt.Name == CGFx.PCInstance)
            {
                PC = PCIt;
                // End:0x10B
                break;
            }            
        }        
        // End:0x187
        if(CGFx.TFAlt != none)
        {
            CGFx.TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, PC));
        }        
    }    
    //return;    
}

simulated function SetCaptionAltCustom(string Text)
{
    local CaptionGFxPerPC CGFx;
    local EvilPlayerController PC, PCIt;

    CaptionAltText = Text;
    // End:0x152
    foreach Captions(CGFx)
    {
        PC = none;
        // End:0xD5
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'EvilPlayerController', PCIt)
        {
            // End:0xD4
            if(PCIt.Name == CGFx.PCInstance)
            {
                PC = PCIt;
                // End:0xD5
                break;
            }            
        }        
        // End:0x151
        if(CGFx.TFAlt != none)
        {
            CGFx.TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, PC));
        }        
    }    
    //return;    
}

simulated function string GetLocalizedTextForKeyName(name KeyName)
{
    // End:0x3D
    if(KeyName == 'None')
    {
        return Localize("Generic", "NoneMSG", "ADVGame");
    }
    return Localize("GameMappedStrings", "GMS_" $ string(KeyName), "ADVGame");
    //return ReturnValue;    
}

simulated function string ParseCaption(string Caption, PlayerController PC)
{
    local string Result, Prefix, postfix;
    local EvilPlayerInput EvilInput;

    // End:0x22
    if(EvilPlayerController(PC) == none)
    {
        return Result;
    }
    EvilInput = EvilPlayerInput(PC.PlayerInput);
    postfix = "_small";
    // End:0xB1
    if(Owner.WorldInfo.IsConsoleBuild(2))
    {
        Prefix = "ps3_";        
    }
    else
    {
        // End:0x140
        if(Owner.WorldInfo.IsConsoleBuild(1) || LocalPlayer(PC.Player).bPCGamepadMode)
        {
            Prefix = "xbox_";            
        }
        else
        {
            Result = Caption;
            Result = Repl(Result, "{A}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Jump", true)))) $ "]", false);
            Result = Repl(Result, "{B}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Melee", true)))) $ "]", false);
            Result = Repl(Result, "{X}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_ReloadWeapon", true)))) $ "]", false);
            Result = Repl(Result, "{Y}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_WeaponSwitch", true)))) $ "]", false);
            Result = Repl(Result, "{R1}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Grenade", true)))) $ "]", false);
            Result = Repl(Result, "{R2}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Fire", true)))) $ "]", false);
            Result = Repl(Result, "{L1}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_GameplayObject", true)))) $ "]", false);
            Result = Repl(Result, "{L2}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_AltFire", true)))) $ "]", false);
            Result = Repl(Result, "{SELECT}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Stats", true)))) $ "]", false);
            Result = Repl(Result, "{DPAD_UP}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_TEST_None", true)))) $ "]", false);
            Result = Repl(Result, "{DPAD_RIGHT}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_PC_TEST_NotepadNext", true)))) $ "]", false);
            Result = Repl(Result, "{DPAD_LEFT}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_PC_TEST_NotepadPrev", true)))) $ "]", false);
            Result = Repl(Result, "{DPAD_DOWN}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_PC_TEST_Compass", true)))) $ "]", false);
            Result = Repl(Result, "{R3}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Duck", true)))) $ "]", false);
            Result = Repl(Result, "{L3}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Sprint", true)))) $ "]", false);
            Result = Repl(Result, "{RSTICK}", ("[" $ (GetLocalizedTextForKeyName('UILook'))) $ "]", false);
            Result = Repl(Result, "{LSTICK}", ((((((("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_MoveForward", true)))) $ "], [") $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Backward", true)))) $ "], [") $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_StrafeLeft", true)))) $ "], [") $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_StrafeRight", true)))) $ "]", false);
            Result = Repl(Result, "{MMB}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Melee", true)))) $ "]", false);
            Result = Repl(Result, "{USE}", ("[" $ (GetLocalizedTextForKeyName(EvilInput.FindPrimaryBindingForCommand("GBA_Use", true)))) $ "]", false);
            return Result;
        }
    }
    Result = Caption;
    Result = Repl(Result, "{A}", ((("<img src='" $ Prefix) $ "a") $ postfix) $ "'>", false);
    Result = Repl(Result, "{B}", ((("<img src='" $ Prefix) $ "b") $ postfix) $ "'>", false);
    Result = Repl(Result, "{X}", ((("<img src='" $ Prefix) $ "x") $ postfix) $ "'>", false);
    Result = Repl(Result, "{Y}", ((("<img src='" $ Prefix) $ "y") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R1}", ((("<img src='" $ Prefix) $ "r1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R2}", ((("<img src='" $ Prefix) $ "r2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L1}", ((("<img src='" $ Prefix) $ "l1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L2}", ((("<img src='" $ Prefix) $ "l2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{SELECT}", ((("<img src='" $ Prefix) $ "select") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_UP}", ((("<img src='" $ Prefix) $ "lup") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_RIGHT}", ((("<img src='" $ Prefix) $ "lright") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_LEFT}", ((("<img src='" $ Prefix) $ "lleft") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_DOWN}", ((("<img src='" $ Prefix) $ "ldown") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R3}", ((("<img src='" $ Prefix) $ "r3") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L3}", ((("<img src='" $ Prefix) $ "l3") $ postfix) $ "'>", false);
    Result = Repl(Result, "{RSTICK}", ((("<img src='" $ Prefix) $ "rstick") $ postfix) $ "'>", false);
    Result = Repl(Result, "{LSTICK}", ((("<img src='" $ Prefix) $ "lstick") $ postfix) $ "'>", false);
    Result = Repl(Result, "{USE}", ((("<img src='" $ Prefix) $ "a") $ postfix) $ "'>", false);
    return Result;
    //return ReturnValue;    
}

simulated function PruneVisibility()
{
    local int I;

    bVisible = false;
    I = 0;
    J0x17:

    // End:0x497 [Loop If]
    if(I < Captions.Length)
    {
        // End:0x47D
        if((Captions[I].IsVisible && ((Captions[I].LastTimeVisible > 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - Captions[I].LastTimeVisible) > 1.0000000) || (Captions[I].LastTimeVisible < 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSinceLastTick + Captions[I].LastTimeVisible) > 1.0000000) || Captions[I].IsVisibleAlt && ((Captions[I].LastTimeTrueVisible > 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - Captions[I].LastTimeTrueVisible) > 1.0000000) || (Captions[I].LastTimeTrueVisible < 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSinceLastTick + Captions[I].LastTimeTrueVisible) > 1.0000000)
        {
            // End:0x356
            if(Captions[I].BorderGFx != none)
            {
                Captions[I].BorderGFx.SetVisible(false);
            }
            // End:0x3BF
            if(Captions[I].GFx != none)
            {
                Captions[I].GFx.SetVisible(false);
            }
            // End:0x428
            if(Captions[I].GFXAlt != none)
            {
                Captions[I].GFXAlt.SetVisible(false);
            }
            Captions[I].IsVisible = false;
            Captions[I].IsVisibleAlt = false;            
        }
        else
        {
            bVisible = true;
        }
        ++I;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

simulated function Hide()
{
    local int I;

    bVisible = false;
    bPostRenderDisabled = true;
    I = 0;
    J0x23:

    // End:0x1D6 [Loop If]
    if(I < Captions.Length)
    {
        // End:0xA4
        if(Captions[I].BorderGFx != none)
        {
            Captions[I].BorderGFx.SetVisible(false);
        }
        // End:0x10D
        if(Captions[I].GFx != none)
        {
            Captions[I].GFx.SetVisible(false);
        }
        // End:0x176
        if(Captions[I].GFXAlt != none)
        {
            Captions[I].GFXAlt.SetVisible(false);
        }
        Captions[I].IsVisible = false;
        Captions[I].IsVisibleAlt = false;
        ++I;
        // [Loop Continue]
        goto J0x23;
    }
    //return;    
}

simulated function Show()
{
    bPostRenderDisabled = false;
    //return;    
}

simulated function bool IsOwnerUsable(bool Currently, PlayerController PC)
{
    local EvilUsableInfoInterface EvilInterface;

    EvilInterface = EvilUsableInfoInterface(Owner);
    // End:0x97
    if(NotEqual_InterfaceInterface(EvilInterface, EvilUsableInfoInterface(none)))
    {
        // End:0x76
        if(Currently)
        {
            return EvilInterface.CanBeUsedNow(PC);            
        }
        else
        {
            return EvilInterface.IsUsable();
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool PlayerCanSeeUs(PlayerController PC, bool ignoreTriggers, Vector CameraPosition, Vector CameraDir)
{
    local Vector Dir;
    local float Bias;

    // End:0x20
    if(!bVisible || bForceNotVisible)
    {
        return false;
    }
    // End:0x5D
    if(!ignoreTriggers && IsOwnerUsable(false, PC))
    {
        return IsOwnerUsable(true, PC);
    }
    Dir = Normal(CameraPosition - Owner.Location);
    // End:0xDF
    if(EvilUsePickUp_Base(Owner) != none)
    {
        Bias = EvilUsePickUp_Base(Owner).GetInteractRange();        
    }
    else
    {
        Bias = ((CylinderComponent(Owner.CollisionComponent) != none) ? CylinderComponent(Owner.CollisionComponent).CollisionRadius : Owner.CollisionComponent.Bounds.SphereRadius);
    }
    Dir *= Bias;
    // End:0x260
    if(EvilTouchPickUp_WeaponBase(Owner) != none)
    {
        // End:0x20C
        if(VSizeSq(CameraPosition - Owner.Location) > (FarDistance * FarDistance))
        {
            return false;
        }
        return Owner.FastTrace(CameraPosition, Owner.Location + vect(0.0000000, 0.0000000, 5.0000000));        
    }
    else
    {
        // End:0x2B1
        if(VSizeSq(CameraPosition - (Owner.Location + Dir)) > (FarDistance * FarDistance))
        {
            return false;
        }
        return Owner.FastTrace(CameraPosition, Owner.Location + Dir);
    }
    //return ReturnValue;    
}

simulated function float GetVisibility(PlayerController PC, Vector CameraPosition, Vector CameraDir, optional bool ignoreTriggers = false)
{
    local int Index;
    local float tmpLastVis, vis;
    local CaptionGFxPerPC CGFx;

    // End:0x49
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds < 0.2500000)
    {
        return 0.0000000;
    }
    Index = Captions.Find('PCInstance', PC.Name);    
    // End:0x3E3
    if(Index >= 0)
    {
        tmpLastVis = ((ignoreTriggers) ? Captions[Index].LastTimeTrueVisible : Captions[Index].LastTimeVisible);
        // End:0x2D2
        if(PlayerCanSeeUs(PC, ignoreTriggers, CameraPosition, CameraDir))
        {
            // End:0x1CB
            if((tmpLastVis >= 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - tmpLastVis) > 0.2500000)
            {
                tmpLastVis = -Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
            }
            // End:0x282
            if(tmpLastVis < 0.0000000)
            {
                vis = 4.0000000 * (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds + tmpLastVis);
                // End:0x27F
                if(vis >= 1.0000000)
                {
                    tmpLastVis = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
                }                
            }
            else
            {
                vis = 1.0000000;
                tmpLastVis = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
            }            
        }
        else
        {
            // End:0x2FA
            if(tmpLastVis < 0.0000000)
            {
                tmpLastVis = -tmpLastVis;
            }
            vis = 1.0000000 - (4.0000000 * (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - tmpLastVis));
        }
        // End:0x391
        if(ignoreTriggers)
        {
            Captions[Index].LastTimeTrueVisible = tmpLastVis;            
        }
        else
        {
            Captions[Index].LastTimeVisible = tmpLastVis;
        }
        vis = FClamp(vis, 0.0000000, 1.0000000);        
    }
    else
    {
        CGFx.PCInstance = PC.Name;
        // End:0x509
        if(PlayerCanSeeUs(PC, ignoreTriggers, CameraPosition, CameraDir))
        {
            // End:0x4B3
            if(ignoreTriggers)
            {
                CGFx.LastTimeTrueVisible = -Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;                
            }
            else
            {
                CGFx.LastTimeVisible = -Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
            }            
        }
        else
        {
            // End:0x571
            if(ignoreTriggers)
            {
                CGFx.LastTimeTrueVisible = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - 0.2500000;                
            }
            else
            {
                CGFx.LastTimeVisible = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - 0.2500000;
            }
        }
        Captions.AddItem(CGFx);        
        vis = 0.0000000;
    }
    return vis;
    //return ReturnValue;    
}

simulated function DrawCaption(Controller C, Canvas Canvas, float Scale, float Alpha, Vector screen, optional bool reparse = false)
{
    local ASDisplayInfo D;
    local int Index;
    local CaptionGFxPerPC CGFx;

    // End:0x738
    if(Use3DCaption)
    {
        D.hasAlpha = true;
        D.hasX = true;
        D.hasY = true;
        D.hasXScale = true;
        D.hasYScale = true;
        Index = Captions.Find('PCInstance', C.Name);        
        // End:0x2D3
        if(Index < 0)
        {
            CGFx.PCInstance = C.Name;
            CGFx.GFx = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
            CGFx.TF = CGFx.GFx.GetObject("textField");
            CGFx.TF.SetBool("html", true);
            CGFx.TF.SetString("htmlText", ParseCaption(CaptionText, EvilPlayerController(C)));
            Captions.AddItem(CGFx);            
            Index = Captions.Length - 1;            
        }
        else
        {
            // End:0x49F
            if(Captions[Index].GFx == none)
            {
                Captions[Index].GFx = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
                Captions[Index].TF = Captions[Index].GFx.GetObject("textField");
                Captions[Index].TF.SetBool("html", true);
                Captions[Index].TF.SetString("htmlText", ParseCaption(CaptionText, EvilPlayerController(C)));
            }
        }
        D.Alpha = Alpha * float(255);
        D.X = screen.X;
        D.Y = screen.Y;
        D.XScale = Scale * float(100);
        D.YScale = Scale * float(100);
        Captions[Index].GFx.SetDisplayInfo(D);
        // End:0x656
        if(Alpha > 0.2000000)
        {
            Captions[Index].IsVisible = true;
            Captions[Index].GFx.SetVisible(true);            
        }
        else
        {
            Captions[Index].IsVisible = false;
            Captions[Index].GFx.SetVisible(false);
        }
        // End:0x735
        if(reparse)
        {
            Captions[Index].TF.SetString("htmlText", ParseCaption(CaptionText, EvilPlayerController(C)));
        }        
    }
    else
    {
        // End:0x981
        if((EvilPlayerController(C) != none) && EvilGFxHudWrapper(EvilPlayerController(C).myHUD) != none)
        {
            Index = Captions.Find('PCInstance', C.Name);            
            // End:0x83D
            if(Index < 0)
            {
                CGFx.PCInstance = C.Name;
                Captions.AddItem(CGFx);                
                Index = Captions.Length - 1;
            }
            // End:0x8FD
            if(Alpha > 0.2000000)
            {
                Captions[Index].IsVisible = true;
                EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.SetHintMessageText(ParseCaption(CaptionText, EvilPlayerController(C)), true);                
            }
            else
            {
                Captions[Index].IsVisible = false;
                EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.HideHintMessage();
            }
        }
    }
    //return;    
}

simulated function DrawCaptionAlt(Controller C, Canvas Canvas, float Scale, float Alpha, Vector screen, optional bool reparse = false)
{
    local ASDisplayInfo D;
    local int Index;
    local CaptionGFxPerPC CGFx;

    // End:0x77A
    if(Use3DCaption)
    {
        // End:0x57
        if(CaptionAltText == "")
        {
            // End:0x57
            if(LocAltString != "")
            {
                SetCaptionAltLoc(LocAltString, LocAltSection, LocModule);
            }
        }
        D.hasAlpha = true;
        D.hasX = true;
        D.hasY = true;
        D.hasXScale = true;
        D.hasYScale = true;
        Index = Captions.Find('PCInstance', C.Name);        
        // End:0x318
        if(Index < 0)
        {
            CGFx.PCInstance = C.Name;
            CGFx.GFXAlt = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
            CGFx.TFAlt = CGFx.GFXAlt.GetObject("textField");
            CGFx.TFAlt.SetBool("html", true);
            CGFx.TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, EvilPlayerController(C)));
            Captions.AddItem(CGFx);            
            Index = Captions.Length - 1;            
        }
        else
        {
            // End:0x4E4
            if(Captions[Index].GFXAlt == none)
            {
                Captions[Index].GFXAlt = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
                Captions[Index].TFAlt = Captions[Index].GFXAlt.GetObject("textField");
                Captions[Index].TFAlt.SetBool("html", true);
                Captions[Index].TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, EvilPlayerController(C)));
            }
        }
        D.Alpha = Alpha * float(255);
        D.X = screen.X;
        D.Y = screen.Y;
        D.XScale = Scale * float(100);
        D.YScale = Scale * float(100);
        Captions[Index].GFXAlt.SetDisplayInfo(D);
        // End:0x69B
        if(Alpha > 0.2000000)
        {
            Captions[Index].IsVisibleAlt = true;
            Captions[Index].GFXAlt.SetVisible(true);            
        }
        else
        {
            Captions[Index].IsVisibleAlt = false;
            Captions[Index].GFXAlt.SetVisible(false);
        }
        // End:0x77A
        if(reparse)
        {
            Captions[Index].TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, EvilPlayerController(C)));
        }
    }
    //return;    
}

simulated function OnHUDReset()
{
    local CaptionGFxPerPC CGFx;

    DeregisterWithHUD();
    RegisterWithHUD();
    // End:0x12B
    foreach Captions(CGFx)
    {
        // End:0x80
        if(CGFx.GFx != none)
        {
            CGFx.GFx.SetVisible(false);
        }
        // End:0xD5
        if(CGFx.GFXAlt != none)
        {
            CGFx.GFXAlt.SetVisible(false);
        }
        // End:0x12A
        if(CGFx.BorderGFx != none)
        {
            CGFx.BorderGFx.SetVisible(false);
        }        
    }    
    Captions.Remove(0, Captions.Length);    
    //return;    
}

simulated function Destroy()
{
    local CaptionGFxPerPC CGFx;
    local EvilPlayerController PC;
    local int Index;

    DeregisterWithHUD();
    // End:0x121
    foreach Captions(CGFx)
    {
        // End:0x76
        if(CGFx.GFx != none)
        {
            CGFx.GFx.SetVisible(false);
        }
        // End:0xCB
        if(CGFx.GFXAlt != none)
        {
            CGFx.GFXAlt.SetVisible(false);
        }
        // End:0x120
        if(CGFx.BorderGFx != none)
        {
            CGFx.BorderGFx.SetVisible(false);
        }        
    }    
    // End:0x24C
    if(!Use3DCaption)
    {
        // End:0x24B
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'EvilPlayerController', PC)
        {
            Index = Captions.Find('PCInstance', PC.Name);            
            // End:0x24A
            if((Index > -1) && Captions[Index].IsVisible)
            {
                EvilGFxHudWrapper(PC.myHUD).HudMovie.HideHintMessage();
            }            
        }        
    }
    //return;    
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas)
{
    local Vector ViewPoint, ViewDir;
    local Rotator ViewRotation;

    PC.GetPlayerViewPoint(ViewPoint, ViewRotation);
    ViewDir = Vector(ViewRotation);
    OptimizedPostRenderFor(PC, Canvas, ViewPoint, ViewDir, PC.GetFOVAngle());
    //return;    
}

simulated function OptimizedPostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir, float FOV)
{
    local Vector Diff, screen, screenAlt;
    local float Dist, Scale, Alpha, alphaTrue, maxdistscale, cosine,
	    Visibility, visibilityTrue;

    local editinline MeshComponent OwnerMesh;
    local int I, Length, Index;
    local LinearColor MatColor;
    local Vector2D ScreenInvScale;
    local bool bReparse;
    local Vector PLoc, HitLocation, HitNormal;
    local Rotator PRot;
    local Actor HitActor;

    // End:0x1B
    if(Owner == none)
    {
        Destroy();
        return;
    }
    // End:0x62
    if(Len(CaptionText) == 0)
    {
        // End:0x62
        if(Len(LocString) != 0)
        {
            SetCaptionLoc(LocString, LocSection, LocModule);
        }
    }
    PruneVisibility();
    // End:0x2C9
    if(!PC.myHUD.bShowHUD)
    {
        Index = Captions.Find('PCInstance', PC.Name);        
        // End:0x2C7
        if(Index >= 0)
        {
            // End:0x15B
            if(Captions[Index].GFx != none)
            {
                Captions[Index].GFx.SetVisible(false);
            }
            // End:0x1C4
            if(Captions[Index].GFXAlt != none)
            {
                Captions[Index].GFXAlt.SetVisible(false);
            }
            // End:0x2C7
            if(Captions[Index].IsVisible || Captions[Index].IsVisibleAlt)
            {
                Captions[Index].IsVisible = false;
                Captions[Index].IsVisibleAlt = false;
                EvilGFxHudWrapper(EvilPlayerController(PC).myHUD).HudMovie.HideHintMessage();
            }
        }
        return;
    }
    cosine = Cos((((FOV * FOVMult) * float(((Use3DCaption) ? 1 : 2))) / 180.0000000) * 3.1415930);
    Diff = Owner.Location - CameraPosition;
    // End:0x58A
    if((Normal(CameraDir) Dot Normal(Diff)) < cosine)
    {
        Index = Captions.Find('PCInstance', PC.Name);        
        // End:0x588
        if(Index >= 0)
        {
            // End:0x41C
            if(Captions[Index].GFx != none)
            {
                Captions[Index].GFx.SetVisible(false);
            }
            // End:0x485
            if(Captions[Index].GFXAlt != none)
            {
                Captions[Index].GFXAlt.SetVisible(false);
            }
            // End:0x588
            if(Captions[Index].IsVisible || Captions[Index].IsVisibleAlt)
            {
                Captions[Index].IsVisible = false;
                Captions[Index].IsVisibleAlt = false;
                EvilGFxHudWrapper(EvilPlayerController(PC).myHUD).HudMovie.HideHintMessage();
            }
        }
        return;
    }
    Dist = VSize(Diff);
    // End:0x5D1
    if(Dist != float(0))
    {
        Scale = ReferenceDistance / Dist;        
    }
    else
    {
        Scale = 1.0000000;
    }
    // End:0x614
    if(Scale > 1.0000000)
    {
        Scale = 1.0000000;
        Alpha = 1.0000000;        
    }
    else
    {
        // End:0x687
        if(Scale < 0.7000000)
        {
            Alpha = 1.0000000 - ((Dist - (ReferenceDistance / 0.7000000)) / 100.0000000);
            // End:0x684
            if((Alpha <= 0.0000000) || Scale <= 0.0000000)
            {
                return;
            }            
        }
        else
        {
            Alpha = 1.0000000;
        }
    }
    // End:0x7BB
    if(bAimToFullySee)
    {
        // End:0x7BB
        if(ReferenceDistance < Dist)
        {
            PC.GetPlayerViewPoint(PLoc, PRot);
            HitActor = EvilPlayerController(PC).Pawn.Trace(HitLocation, HitNormal, PLoc + (Vector(PRot) * Dist), PLoc, true);
            // End:0x7A8
            if(HitActor != Owner)
            {
                AimToFullySeeAlpha -= 0.0400000;
                Alpha = AimToFullySeeAlpha;                
            }
            else
            {
                AimToFullySeeAlpha = Alpha;
            }
        }
    }
    alphaTrue = Alpha;
    visibilityTrue = GetVisibility(PC, CameraPosition, CameraDir, true);
    // End:0x811
    if(visibilityTrue <= float(0))
    {
        return;
    }
    // End:0x85B
    if(IsOwnerUsable(false, PC))
    {
        Visibility = GetVisibility(PC, CameraPosition, CameraDir);        
    }
    else
    {
        Visibility = visibilityTrue;
    }
    // End:0x894
    if(!DrawAlt && Visibility <= 0.0000000)
    {
        return;
    }
    // End:0xA5E
    if(UseColorizing && FarDistance != float(0))
    {
        maxdistscale = 1.0000000 - (Dist / FarDistance);
        MatColor = MakeLinearColor(maxdistscale * float(1), maxdistscale * float(5), maxdistscale * float(8), 1.0000000);
        // End:0x9F2
        if(MaterialInst.Length == 0)
        {
            // End:0x9F1
            foreach Owner.ComponentList(Class'Engine.MeshComponent', OwnerMesh)
            {
                Length = OwnerMesh.GetNumElements();
                I = 0;
                J0x996:

                // End:0x9F0 [Loop If]
                if(I < Length)
                {
                    MaterialInst.AddItem(OwnerMesh.CreateAndSetMaterialInstanceConstant(I));                    
                    I++;
                    // [Loop Continue]
                    goto J0x996;
                }                
            }            
        }
        I = 0;
        J0x9FD:

        // End:0xA5E [Loop If]
        if(I < MaterialInst.Length)
        {
            MaterialInst[I].SetVectorParameterValue('LightColor', MatColor);
            I++;
            // [Loop Continue]
            goto J0x9FD;
        }
    }
    Alpha *= Visibility;
    alphaTrue *= visibilityTrue;
    ScreenInvScale.X = 1920.0000000 / float(Canvas.SizeX);
    ScreenInvScale.Y = 1080.0000000 / float(Canvas.SizeY);
    // End:0xB80
    if(bLastUsingGamepad != EvilPlayerController(PC).PlayerInput.bUsingGamepad)
    {
        bLastUsingGamepad = !bLastUsingGamepad;
        bReparse = true;        
    }
    else
    {
        bReparse = false;
    }
    // End:0xCA0
    if(DrawAlt)
    {
        screenAlt = Canvas.Project(Owner.Location + OffsetAlt);
        screenAlt.X *= ScreenInvScale.X;
        screenAlt.Y *= ScreenInvScale.Y;
        DrawCaptionAlt(PC, Canvas, Scale, alphaTrue, screenAlt, bReparse);
    }
    // End:0xDBA
    if(Alpha > 0.0000000)
    {
        screen = Canvas.Project(Owner.Location + Offset);
        screen.X *= ScreenInvScale.X;
        screen.Y *= ScreenInvScale.Y;
        DrawCaption(PC, Canvas, Scale, Alpha, screen, bReparse);
    }
    //return;    
}

defaultproperties
{
    LocModule="EvilGame"
    LocSection="Captions"
    LocAltSection="CaptionsAlt"
    Use3DCaption=true
    bVisible=true
    Offset=(X=0.0000000,Y=0.0000000,Z=45.0000000)
    OffsetAlt=(X=0.0000000,Y=0.0000000,Z=60.0000000)
    ReferenceDistance=200.0000000
    FarDistance=300.0000000
    FOVMult=0.8000000
    AimToFullySeeAlpha=0.2500000
}