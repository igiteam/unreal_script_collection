class EvilCaptionComponent extends EvilActorComponent;

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
var() bool bVisible;
var() bool UseColorizing;
var() bool DrawBorders;
var() bool DrawAlt;
var transient bool bLastUsingGamepad;
var() Vector Offset;
var() Vector OffsetAlt;
var array<CaptionGFxPerPC> Captions;
var array<MaterialInstanceConstant> MaterialInst;
var() float ReferenceDistance;
var() float FarDistance;
var() float FOVMult;

simulated function SetCaptionLoc(string Key, optional string Section = LocSection, optional string Module = LocModule)
{
    local CaptionGFxPerPC CGFx;

    CaptionText = Localize(Section, Key, Module);
    // End:0xDD
    foreach Captions(CGFx)
    {
        // End:0xDC
        if(CGFx.TF != none)
        {
            CGFx.TF.SetString("htmlText", ParseCaption(CaptionText, bLastUsingGamepad));
        }        
    }    
    //return;    
}

simulated function SetCaptionCustom(string Text)
{
    local CaptionGFxPerPC CGFx;

    CaptionText = Text;
    // End:0xA7
    foreach Captions(CGFx)
    {
        // End:0xA6
        if(CGFx.TF != none)
        {
            CGFx.TF.SetString("htmlText", ParseCaption(CaptionText, bLastUsingGamepad));
        }        
    }    
    //return;    
}

simulated function SetCaptionAltLoc(string Key, optional string Section = LocAltSection, optional string Module = LocModule)
{
    local CaptionGFxPerPC CGFx;

    CaptionAltText = Localize(Section, Key, Module);
    // End:0xDD
    foreach Captions(CGFx)
    {
        // End:0xDC
        if(CGFx.TFAlt != none)
        {
            CGFx.TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, bLastUsingGamepad));
        }        
    }    
    //return;    
}

simulated function SetCaptionAltCustom(string Text)
{
    local CaptionGFxPerPC CGFx;

    CaptionAltText = Text;
    // End:0xA7
    foreach Captions(CGFx)
    {
        // End:0xA6
        if(CGFx.TFAlt != none)
        {
            CGFx.TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, bLastUsingGamepad));
        }        
    }    
    //return;    
}

simulated function string ParseCaption(string Caption, optional bool bUsingGamepad = false)
{
    local string Result, Prefix, postfix;

    postfix = "_small";
    // End:0x63
    if(Owner.WorldInfo.IsConsoleBuild(2))
    {
        Prefix = "ps3_";        
    }
    else
    {
        // End:0xBF
        if(Owner.WorldInfo.IsConsoleBuild(1) || bUsingGamepad)
        {
            Prefix = "xbox_";            
        }
        else
        {
            Prefix = "pc_";
        }
    }
    Result = Caption;
    Result = Repl(Result, "{A}", ((("<img src='" $ Prefix) $ "a") $ postfix) $ "'>", false);
    Result = Repl(Result, "{B}", ((("<img src='" $ Prefix) $ "b") $ postfix) $ "'>", false);
    Result = Repl(Result, "{X}", ((("<img src='" $ Prefix) $ "x") $ postfix) $ "'>", false);
    Result = Repl(Result, "{Y}", ((("<img src='" $ Prefix) $ "y") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R1}", ((("<img src='" $ Prefix) $ "r1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R2}", ((("<img src='" $ Prefix) $ "r2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{R3}", ((("<img src='" $ Prefix) $ "r3") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L1}", ((("<img src='" $ Prefix) $ "l1") $ postfix) $ "'>", false);
    Result = Repl(Result, "{L2}", ((("<img src='" $ Prefix) $ "l2") $ postfix) $ "'>", false);
    Result = Repl(Result, "{SELECT}", ((("<img src='" $ Prefix) $ "select") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_UP}", ((("<img src='" $ Prefix) $ "lup") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_RIGHT}", ((("<img src='" $ Prefix) $ "lright") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_LEFT}", ((("<img src='" $ Prefix) $ "lleft") $ postfix) $ "'>", false);
    Result = Repl(Result, "{DPAD_DOWN}", ((("<img src='" $ Prefix) $ "ldown") $ postfix) $ "'>", false);
    return Result;
    //return ReturnValue;    
}

simulated function PruneVisibility()
{
    local CaptionGFxPerPC CGFx;

    // End:0x3AF
    foreach Captions(CGFx)
    {
        // End:0x3AE
        if((CGFx.IsVisible && ((CGFx.LastTimeVisible > 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - CGFx.LastTimeVisible) > 1.0000000) || (CGFx.LastTimeVisible < 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSinceLastTick + CGFx.LastTimeVisible) > 1.0000000) || CGFx.IsVisibleAlt && ((CGFx.LastTimeTrueVisible > 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - CGFx.LastTimeTrueVisible) > 1.0000000) || (CGFx.LastTimeTrueVisible < 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSinceLastTick + CGFx.LastTimeTrueVisible) > 1.0000000)
        {
            // End:0x2C6
            if(CGFx.BorderGFx != none)
            {
                CGFx.BorderGFx.SetVisible(false);
            }
            // End:0x31B
            if(CGFx.GFx != none)
            {
                CGFx.GFx.SetVisible(false);
            }
            // End:0x370
            if(CGFx.GFXAlt != none)
            {
                CGFx.GFXAlt.SetVisible(false);
            }
            CGFx.IsVisible = false;
            CGFx.IsVisibleAlt = false;
        }        
    }    
    //return;    
}

simulated function bool IsOwnerUsable(bool Currently, PlayerController PC)
{
    // End:0x6C
    if(Currently)
    {
        // End:0x69
        if(NotEqual_InterfaceInterface(EvilUsableInfoInterface(Owner), EvilUsableInfoInterface(none)))
        {
            return EvilUsableInfoInterface(Owner).CanBeUsedNow(PC);
        }        
    }
    else
    {
        // End:0xBF
        if(NotEqual_InterfaceInterface(EvilUsableInfoInterface(Owner), EvilUsableInfoInterface(none)))
        {
            return EvilUsableInfoInterface(Owner).IsUsable();
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool PlayerCanSeeUs(PlayerController PC, bool ignoreTriggers)
{
    local Vector View, Dir;
    local Rotator Rot;
    local float Bias;

    // End:0x11
    if(!bVisible)
    {
        return false;
    }
    // End:0x4E
    if(!ignoreTriggers && IsOwnerUsable(false, PC))
    {
        return IsOwnerUsable(true, PC);
    }
    PC.GetPlayerViewPoint(View, Rot);
    Dir = Normal(View - Owner.Location) + vect(0.0000000, 0.0000000, 0.6000000);
    Bias = ((CylinderComponent(Owner.CollisionComponent) != none) ? CylinderComponent(Owner.CollisionComponent).CollisionRadius : Owner.CollisionComponent.Bounds.SphereRadius);
    Dir *= Bias;
    // End:0x1E3
    if(VSizeSq(View - (Owner.Location + Dir)) > (FarDistance * FarDistance))
    {
        return false;
    }
    return Owner.FastTrace(View, Owner.Location + Dir);
    //return ReturnValue;    
}

simulated function float GetVisibility(PlayerController PC, optional bool ignoreTriggers = false)
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
    // End:0x3D1
    if(Index >= 0)
    {
        tmpLastVis = ((ignoreTriggers) ? Captions[Index].LastTimeTrueVisible : Captions[Index].LastTimeVisible);
        // End:0x2C0
        if(PlayerCanSeeUs(PC, ignoreTriggers))
        {
            // End:0x1B9
            if((tmpLastVis >= 0.0000000) && (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - tmpLastVis) > 0.2500000)
            {
                tmpLastVis = -Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
            }
            // End:0x270
            if(tmpLastVis < 0.0000000)
            {
                vis = 4.0000000 * (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds + tmpLastVis);
                // End:0x26D
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
            // End:0x2E8
            if(tmpLastVis < 0.0000000)
            {
                tmpLastVis = -tmpLastVis;
            }
            vis = 1.0000000 - (4.0000000 * (Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - tmpLastVis));
        }
        // End:0x37F
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
        // End:0x4E5
        if(PlayerCanSeeUs(PC, ignoreTriggers))
        {
            // End:0x48F
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
            // End:0x54D
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

    // End:0x720
    if(Use3DCaption)
    {
        D.hasAlpha = true;
        D.hasX = true;
        D.hasY = true;
        D.hasXScale = true;
        D.hasYScale = true;
        Index = Captions.Find('PCInstance', C.Name);
        // End:0x2CB
        if(Index < 0)
        {
            CGFx.PCInstance = C.Name;
            CGFx.GFx = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
            CGFx.TF = CGFx.GFx.GetObject("textField");
            CGFx.TF.SetBool("html", true);
            CGFx.TF.SetString("htmlText", ParseCaption(CaptionText, bLastUsingGamepad));
            Captions.AddItem(CGFx);
            Index = Captions.Length - 1;            
        }
        else
        {
            // End:0x48F
            if(Captions[Index].GFx == none)
            {
                Captions[Index].GFx = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
                Captions[Index].TF = Captions[Index].GFx.GetObject("textField");
                Captions[Index].TF.SetBool("html", true);
                Captions[Index].TF.SetString("htmlText", ParseCaption(CaptionText, bLastUsingGamepad));
            }
        }
        D.Alpha = Alpha * float(255);
        D.X = screen.X;
        D.Y = screen.Y;
        D.XScale = Scale * float(100);
        D.YScale = Scale * float(100);
        Captions[Index].GFx.SetDisplayInfo(D);
        // End:0x646
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
        // End:0x71D
        if(reparse)
        {
            Captions[Index].TF.SetString("htmlText", ParseCaption(CaptionText, bLastUsingGamepad));
        }        
    }
    else
    {
        // End:0x961
        if((EvilPlayerController(C) != none) && EvilGFxHudWrapper(EvilPlayerController(C).myHUD) != none)
        {
            Index = Captions.Find('PCInstance', C.Name);
            // End:0x825
            if(Index < 0)
            {
                CGFx.PCInstance = C.Name;
                Captions.AddItem(CGFx);
                Index = Captions.Length - 1;
            }
            // End:0x8DD
            if(Alpha > 0.2000000)
            {
                Captions[Index].IsVisible = true;
                EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.SetLocalizedHintMessageText(ParseCaption(CaptionText, bLastUsingGamepad), true);                
            }
            else
            {
                Captions[Index].IsVisible = false;
                EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.HideLocalizedHintMessage();
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

    // End:0x762
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
        // End:0x310
        if(Index < 0)
        {
            CGFx.PCInstance = C.Name;
            CGFx.GFXAlt = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
            CGFx.TFAlt = CGFx.GFXAlt.GetObject("textField");
            CGFx.TFAlt.SetBool("html", true);
            CGFx.TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, bLastUsingGamepad));
            Captions.AddItem(CGFx);
            Index = Captions.Length - 1;            
        }
        else
        {
            // End:0x4D4
            if(Captions[Index].GFXAlt == none)
            {
                Captions[Index].GFXAlt = EvilGFxHudWrapper(EvilPlayerController(C).myHUD).HudMovie.AddCaptionComponent();
                Captions[Index].TFAlt = Captions[Index].GFXAlt.GetObject("textField");
                Captions[Index].TFAlt.SetBool("html", true);
                Captions[Index].TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, bLastUsingGamepad));
            }
        }
        D.Alpha = Alpha * float(255);
        D.X = screen.X;
        D.Y = screen.Y;
        D.XScale = Scale * float(100);
        D.YScale = Scale * float(100);
        Captions[Index].GFXAlt.SetDisplayInfo(D);
        // End:0x68B
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
        // End:0x762
        if(reparse)
        {
            Captions[Index].TFAlt.SetString("htmlText", ParseCaption(CaptionAltText, bLastUsingGamepad));
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
                EvilGFxHudWrapper(PC.myHUD).HudMovie.HideLocalizedHintMessage();
            }            
        }        
    }
    //return;    
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas)
{
    local Vector X, Diff, screen, screenAlt, Loc;

    local Rotator Rot;
    local float Dist, Scale, Alpha, alphaTrue, maxdistscale, cosine,
	    Visibility, visibilityTrue;

    local editinline MeshComponent OwnerMesh;
    local int I, Length, Index;
    local LinearColor MatColor;
    local Vector2D ScreenInvScale;

    // End:0x1B
    if(Owner == none)
    {
        Destroy();
        return;
    }
    // End:0x60
    if(CaptionText == "")
    {
        // End:0x60
        if(LocString != "")
        {
            SetCaptionLoc(LocString, LocSection, LocModule);
        }
    }
    PruneVisibility();
    Index = Captions.Find('PCInstance', PC.Name);
    // End:0x283
    if(!PC.myHUD.bShowHUD)
    {
        // End:0x281
        if(Index >= 0)
        {
            // End:0x159
            if(Captions[Index].GFx != none)
            {
                Captions[Index].GFx.SetVisible(false);
            }
            // End:0x1C2
            if(Captions[Index].GFXAlt != none)
            {
                Captions[Index].GFXAlt.SetVisible(false);
            }
            // End:0x281
            if(Captions[Index].IsVisible && !Use3DCaption)
            {
                Captions[Index].IsVisible = false;
                EvilGFxHudWrapper(EvilPlayerController(PC).myHUD).HudMovie.HideLocalizedHintMessage();
            }
        }
        return;
    }
    PC.GetPlayerViewPoint(Loc, Rot);
    X = Vector(Rot);
    cosine = Cos((((PC.GetFOVAngle() * FOVMult) * float(((Use3DCaption) ? 1 : 2))) / 180.0000000) * 3.1415930);
    Diff = Owner.Location - Loc;
    // End:0x51E
    if((Normal(X) Dot Normal(Diff)) < cosine)
    {
        // End:0x51C
        if(Index >= 0)
        {
            // End:0x3F4
            if(Captions[Index].GFx != none)
            {
                Captions[Index].GFx.SetVisible(false);
            }
            // End:0x45D
            if(Captions[Index].GFXAlt != none)
            {
                Captions[Index].GFXAlt.SetVisible(false);
            }
            // End:0x51C
            if(Captions[Index].IsVisible && !Use3DCaption)
            {
                Captions[Index].IsVisible = false;
                EvilGFxHudWrapper(EvilPlayerController(PC).myHUD).HudMovie.HideLocalizedHintMessage();
            }
        }
        return;
    }
    ScreenInvScale.X = 1280.0000000 / float(Canvas.SizeX);
    ScreenInvScale.Y = 720.0000000 / float(Canvas.SizeY);
    screen = Canvas.Project(Owner.Location + Offset);
    screen.X *= ScreenInvScale.X;
    screen.Y *= ScreenInvScale.Y;
    screenAlt = Canvas.Project(Owner.Location + OffsetAlt);
    screenAlt.X *= ScreenInvScale.X;
    screenAlt.Y *= ScreenInvScale.Y;
    Dist = VSize(Diff);
    Scale = ReferenceDistance / Dist;
    maxdistscale = 1.0000000 - (Dist / FarDistance);
    visibilityTrue = GetVisibility(PC, true);
    // End:0x7BB
    if(visibilityTrue <= float(0))
    {
        return;
    }
    // End:0x7F3
    if(IsOwnerUsable(false, PC))
    {
        Visibility = GetVisibility(PC);        
    }
    else
    {
        Visibility = visibilityTrue;
    }
    // End:0x998
    if(UseColorizing)
    {
        MatColor = MakeLinearColor(maxdistscale * float(1), maxdistscale * float(5), maxdistscale * float(8), 1.0000000);
        // End:0x92C
        if(MaterialInst.Length == 0)
        {
            // End:0x92B
            foreach Owner.ComponentList(Class'Engine.MeshComponent', OwnerMesh)
            {
                Length = OwnerMesh.GetNumElements();
                I = 0;
                J0x8D0:

                // End:0x92A [Loop If]
                if(I < Length)
                {
                    MaterialInst.AddItem(OwnerMesh.CreateAndSetMaterialInstanceConstant(I));
                    I++;
                    // [Loop Continue]
                    goto J0x8D0;
                }                
            }            
        }
        I = 0;
        J0x937:

        // End:0x998 [Loop If]
        if(I < MaterialInst.Length)
        {
            MaterialInst[I].SetVectorParameterValue('LightColor', MatColor);
            I++;
            // [Loop Continue]
            goto J0x937;
        }
    }
    // End:0x9CC
    if(Scale > 1.0000000)
    {
        Scale = 1.0000000;
        Alpha = 1.0000000;        
    }
    else
    {
        // End:0xA3F
        if(Scale < 0.7000000)
        {
            Alpha = 1.0000000 - ((Dist - (ReferenceDistance / 0.7000000)) / 100.0000000);
            // End:0xA3C
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
    alphaTrue = Alpha;
    Alpha *= Visibility;
    alphaTrue *= visibilityTrue;
    // End:0xA9E
    if(alphaTrue <= 0.0000000)
    {
        return;
    }
    // End:0xAAB
    if(DrawBorders)
    {
    }
    // End:0xBA3
    if(bLastUsingGamepad != EvilPlayerController(PC).PlayerInput.bUsingGamepad)
    {
        bLastUsingGamepad = !bLastUsingGamepad;
        // End:0xB53
        if(DrawAlt)
        {
            DrawCaptionAlt(PC, Canvas, Scale, alphaTrue, screenAlt, true);
        }
        // End:0xB68
        if(Alpha <= 0.0000000)
        {
            return;
        }
        DrawCaption(PC, Canvas, Scale, Alpha, screen, true);        
    }
    else
    {
        // End:0xBE8
        if(DrawAlt)
        {
            DrawCaptionAlt(PC, Canvas, Scale, alphaTrue, screenAlt);
        }
        // End:0xBFD
        if(Alpha <= 0.0000000)
        {
            return;
        }
        DrawCaption(PC, Canvas, Scale, Alpha, screen);
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
}