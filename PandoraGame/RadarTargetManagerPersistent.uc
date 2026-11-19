class RadarTargetManagerPersistent extends Object
    native;

enum ERadarTargetFadeMode
{
    RTFM_NotFading,                 // 0
    RTFM_FadeIn,                    // 1
    RTFM_FadeOut,                   // 2
    RTFM_MAX                        // 3
};

enum ERadarTargetFontSize
{
    RTFS_Small,                     // 0
    RTFS_Medium,                    // 1
    RTFS_Large,                     // 2
    RTFS_MAX                        // 3
};

struct native RadarTarget
{
    var Actor targetActor;
    var Vector Offset;
    var LinearColor HUDColor;
    var Texture2D PinImage;
    var bool bConstrainedX;
    var bool bConstrainedY;
    var RadarTargetManagerPersistent.ERadarTargetFadeMode FadeMode;
    var RadarTargetManagerPersistent.ERadarTargetFontSize TextFontSize;
    var LinearColor TextColor;

    structdefaultproperties
    {
        targetActor=none
        Offset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HUDColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
        PinImage=none
        bConstrainedX=false
        bConstrainedY=false
        FadeMode=RTFM_NotFading
        TextFontSize=RTFS_Small
        TextColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    }
};

var const float SafeRegionOffset;
var Actor OriginActor;
var array<RadarTarget> Targets;
var Texture2D DefaultPinImage;
var Texture2D ArrowImage;
var Texture2D ChaosImage;
var Texture2D OrderImage;

// Export URadarTargetManagerPersistent::execRender(FFrame&, void* const)
native function Render(Canvas C);

function ClearTargets()
{
    Targets.Length = 0;
    //return;    
}

function bool IsTarget(Actor inTargetActor)
{
    local int I;

    // End:0x0D
    if(inTargetActor == none)
    {
        return false;
    }
    I = 0;
    J0x14:

    // End:0x50 [Loop If]
    if(I < Targets.Length)
    {
        // End:0x46
        if(Targets[I].targetActor == inTargetActor)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return false;
    //return ReturnValue;    
}

function AddTarget(Actor inTargetActor, optional float VerticalOffset, optional Texture2D inPinImage, optional LinearColor clr, optional RadarTargetManagerPersistent.ERadarTargetFontSize FontSize = 0, optional LinearColor theFontColor)
{
    local RadarTarget Target;

    Target.targetActor = inTargetActor;
    Target.PinImage = inPinImage;
    // End:0xFC
    if((((clr.R == 0.0000000) && clr.G == 0.0000000) && clr.B == 0.0000000) && clr.A == 0.0000000)
    {
        clr.R = 1.0000000;
        clr.G = 1.0000000;
        clr.B = 1.0000000;
        clr.A = 1.0000000;
    }
    // End:0x1B2
    if((((theFontColor.R == 0.0000000) && theFontColor.G == 0.0000000) && theFontColor.B == 0.0000000) && (theFontColor.A == 0.0000000) || theFontColor.A == 1.0000000)
    {
        theFontColor.G = 1.0000000;
        theFontColor.A = 1.0000000;
    }
    Target.HUDColor = MakeLinearColor(clr.R, clr.G, clr.B, clr.A);
    Target.TextFontSize = FontSize;
    Target.TextColor = MakeLinearColor(theFontColor.R, theFontColor.G, theFontColor.B, theFontColor.A);
    Target.Offset.Z = VerticalOffset;
    Targets.Insert(Targets.Length, 1);
    Targets[Targets.Length - 1] = Target;
    //return;    
}

function RemoveTarget(Actor inTargetActor)
{
    local int I;

    // End:0x0D
    if(inTargetActor == none)
    {
        return;
    }
    I = 0;
    J0x14:

    // End:0x61 [Loop If]
    if(I < Targets.Length)
    {
        // End:0x57
        if(Targets[I].targetActor == inTargetActor)
        {
            Targets.Remove(I, 1);
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    //return;    
}

function AddTargetOrder(Actor inTargetActor)
{
    local LinearColor clr;

    clr.R = 1.0000000;
    clr.G = 1.0000000;
    clr.B = 1.0000000;
    clr.A = 0.6000000;
    AddTarget(inTargetActor, inTargetActor.CollisionComponent.Bounds.BoxExtent.Z + 160.0000000, OrderImage, clr);
    //return;    
}

function AddTargetChaos(Actor inTargetActor)
{
    local LinearColor clr;

    clr.R = 1.0000000;
    clr.G = 1.0000000;
    clr.B = 1.0000000;
    clr.A = 0.6000000;
    AddTarget(inTargetActor, inTargetActor.CollisionComponent.Bounds.BoxExtent.Z + 160.0000000, ChaosImage, clr);
    //return;    
}

function float GetMinFadeoutAlpha()
{
    return 0.2000000;
    //return ReturnValue;    
}

function UpdateFadeColor(float DeltaTime, int I)
{
    local float minFadeAlpha;

    switch(Targets[I].FadeMode)
    {
        // End:0xBD
        case 1:
            Targets[I].HUDColor.A += (0.4000000 * DeltaTime);
            // End:0xBA
            if(Targets[I].HUDColor.A >= 1.0000000)
            {
                Targets[I].HUDColor.A = 1.0000000;
                Targets[I].FadeMode = 0;
                return;
            }
            // End:0x172
            break;
        // End:0x16F
        case 2:
            Targets[I].HUDColor.A -= (0.4000000 * DeltaTime);
            minFadeAlpha = GetMinFadeoutAlpha();
            // End:0x16C
            if(Targets[I].HUDColor.A <= minFadeAlpha)
            {
                Targets[I].HUDColor.A = minFadeAlpha;
                Targets[I].FadeMode = 0;
            }
            // End:0x172
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function Update(float DeltaTime)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xA4 [Loop If]
    if(I < Targets.Length)
    {
        // End:0x6D
        if(!Targets[I].bConstrainedX && !Targets[I].bConstrainedY)
        {
            Targets[I].FadeMode = 2;            
        }
        else
        {
            Targets[I].FadeMode = 1;
        }
        UpdateFadeColor(DeltaTime, I);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

defaultproperties
{
    SafeRegionOffset=10.0000000
}