class SkyUI_HudWidget extends SkyUI_Widget
    abstract
    native
    config(UI);

enum ESkyAnimPropType
{
    ESkyAPT_None,                   // 0
    ESkyAPT_PositionLeft,           // 1
    ESkyAPT_PositionTop,            // 2
    ESkyAPT_MAX                     // 3
};

struct native SkyWidgetAnimSequence
{
    var() name Tag;
    var() float Rate;
    var() float StartValue;
    var() float EndValue;

    structdefaultproperties
    {
        Tag="None"
        Rate=0.0000000
        StartValue=0.0000000
        EndValue=0.0000000
    }
};

struct native SkyWidgetAnimation
{
    var() name Tag;
    var() SkyUI_HudWidget.ESkyAnimPropType Property;
    var() editinline array<editinline SkyWidgetAnimSequence> Sequences;
    var transient bool bIsPlaying;
    var transient int SeqIndex;
    var transient float Time;
    var transient float Value;

    structdefaultproperties
    {
        Tag="None"
        Property=ESkyAPT_None
        Sequences=none
        bIsPlaying=false
        SeqIndex=0
        Time=0.0000000
        Value=0.0000000
    }
};

var SkyUIScene_Hud SkyHudSceneOwner;
var float OpacityTarget;
var float OpacityTimer;
var bool bManualVisibility;
var(Visibility) bool bVisibleBeforeMatch;
var(Visibility) bool bVisibleDuringMatch;
var(Visibility) bool bVisibleAfterMatch;
var(Visibility) bool bVisibleWhileSpectating;
var(Animation) editinline array<editinline SkyWidgetAnimation> Animations;

// Export USkyUI_HudWidget::execPlayAnimation(FFrame&, void* const)
native function PlayAnimation(name AnimTag, name SeqTag, optional bool bForceBeginning);

// Export USkyUI_HudWidget::execStopAnimation(FFrame&, void* const)
native function StopAnimation(name AnimTag, optional bool bForceEnd);

function bool bIsAnimating()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3D [Loop If]
    if(I < Animations.Length)
    {
        // End:0x33
        if(Animations[I].bIsPlaying)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function SkyHUD GetHudOwner()
{
    local SkyPlayerController PC;

    // End:0x45
    if(SkyHudSceneOwner != none)
    {
        PC = SkyHudSceneOwner.GetSkyPlayerOwner();
        // End:0x45
        if(PC != none)
        {
            return SkyHUD(PC.myHUD);
        }
    }
    return none;
    //return ReturnValue;    
}

event WidgetVisibilityChanged()
{
    //return;    
}

event FadeTo(float NewOpacity, float NewFadeTime, optional bool bTimeFromExtent)
{
    local float Perc;

    OpacityTarget = NewOpacity;
    OpacityTimer = NewFadeTime;
    // End:0x62
    if(bTimeFromExtent)
    {
        Perc = 1.0000000 - ((NewOpacity > Opacity) ? Opacity / NewOpacity : NewOpacity / Opacity);
        OpacityTimer *= Perc;
    }
    //return;    
}

event WidgetTick(float DeltaTime)
{
    // End:0x61
    if(Opacity != OpacityTarget)
    {
        Opacity += ((Opacity - OpacityTarget) * (OpacityTimer * DeltaTime));
        OpacityTimer -= DeltaTime;
        // End:0x61
        if(OpacityTimer <= 0.0000000)
        {
            Opacity = OpacityTarget;
            OpacityTimer = 0.0000000;
        }
    }
    //return;    
}

event bool PlayerOwnerIsSpectating()
{
    local SkyPlayerController PC;

    // End:0x96
    if(SkyHudSceneOwner != none)
    {
        PC = SkyHudSceneOwner.GetSkyPlayerOwner();
        // End:0x96
        if(PC != none)
        {
            // End:0x81
            if(((PC.Pawn == none) || PC.IsDead()) || PC.Pawn.Health <= 0)
            {
                return true;
            }
            return PC.IsSpectating();
        }
    }
    return false;
    //return ReturnValue;    
}
