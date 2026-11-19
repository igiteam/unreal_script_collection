class UTGFxTweenableMoviePlayer extends GFxMoviePlayer
    native(UI)
    config(UI);

enum TweenType
{
    TWEEN_EaseOut,                  // 0
    TWEEN_EaseIn,                   // 1
    TWEEN_Linear,                   // 2
    TWEEN_MAX                       // 3
};

struct native GFxTween
{
    var GFxObject TargetMC;
    var float TweenTime;
    var float Duration;
    var float StartValue;
    var float Delta;
    var float DesiredValue;
    var string MemberName;
    var string Callback;
    var ASDisplayInfo displayInfo;
    var bool bFinished;
    var UTGFxTweenableMoviePlayer.TweenType ThisTweenType;

    structdefaultproperties
    {
        TargetMC=none
        TweenTime=0.0000000
        Duration=0.0000000
        StartValue=0.0000000
        Delta=0.0000000
        DesiredValue=0.0000000
        MemberName=""
        Callback=""
        displayInfo=(X=0.0000000,Y=0.0000000,Z=0.0000000,Rotation=0.0000000,XRotation=0.0000000,YRotation=0.0000000,XScale=0.0000000,YScale=0.0000000,ZScale=0.0000000,Alpha=0.0000000,Visible=false,hasX=false,hasY=false,hasZ=false,hasRotation=false,hasXRotation=false,hasYRotation=false,hasXScale=false,hasYScale=false,hasZScale=false,hasAlpha=false,hasVisible=false)
        bFinished=false
        ThisTweenType=TweenType.TWEEN_EaseOut
    }
};

struct native BlurFilter
{
    var GFxObject BlurClip;
    var float BlurX;
    var float BlurY;
    var float BlurQuality;
    var float Prev_BlurX;
    var float Prev_BlurY;
    var float Prev_BlurQuality;
    var float BlendTime;
    var float BlurStartTime;
    var bool bIsBlending;

    structdefaultproperties
    {
        BlurClip=none
        BlurX=0.0000000
        BlurY=0.0000000
        BlurQuality=0.0000000
        Prev_BlurX=0.0000000
        Prev_BlurY=0.0000000
        Prev_BlurQuality=0.0000000
        BlendTime=0.0000000
        BlurStartTime=0.0000000
        bIsBlending=false
    }
};

var array<GFxTween> TweenList;
var transient array<BlurFilter> CurrentBlurs;
var transient int PriorityEffect_BlurCounter;
var transient int PriorityEffect_VisibilityCounter;
var transient bool bLesserHideIsFading;
var transient float LesserHideInitialAlpha;
var transient float LesserHideDestinationAlpha;
var transient float LesserHideFadeStartTime;
var float LesserHideFadeDuration;
var transient GFxObject MovieRootObject;

function TweenTo(GFxObject MC, float Duration, string Member, float Target, UTGFxTweenableMoviePlayer.TweenType NewTweenType, optional string Callback = "")
{
    local GFxTween Tween;

    Tween.TargetMC = MC;
    Tween.Duration = Duration;
    Tween.MemberName = Member;
    Tween.DesiredValue = Target;
    Tween.StartValue = MC.GetFloat(Member);
    Tween.Callback = Callback;
    Tween.ThisTweenType = NewTweenType;
    TweenList[TweenList.Length] = Tween;
    //return;    
}

function ProcessTweenCallback(string Callback, GFxObject TargetMC)
{
    //return;    
}

function Tick(float DeltaTime)
{
    local int I;
    local float pos, CurrentValue;

    I = 0;
    J0x0B:

    // End:0x2F1 [Loop If]
    if(I < TweenList.Length)
    {
        // End:0x2E3
        if(!TweenList[I].bFinished)
        {
            TweenList[I].TweenTime += DeltaTime;
            pos = TweenList[I].TweenTime / TweenList[I].Duration;
            switch(TweenList[I].ThisTweenType)
            {
                // End:0x136
                case 1:
                    pos = (pos * pos) * pos;
                // End:0x181
                case 0:
                    pos = pos - float(1);
                    pos = ((pos * pos) * pos) + float(1);
                // End:0x189
                case 2:
                    // End:0x19E
                    break;
                // End:0xFFFF
                default:
                    pos = 1.0000000;
                    // End:0x19E
                    break;
                    break;
            }
            CurrentValue = ((TweenList[I].DesiredValue - TweenList[I].StartValue) * pos) + TweenList[I].StartValue;
            TweenList[I].TargetMC.SetFloat(TweenList[I].MemberName, CurrentValue);
            // End:0x2E3
            if(pos > 1.0000000)
            {
                TweenList[I].bFinished = true;
                TweenComplete(I);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function ClearsTweensOnMovieClip(GFxObject MC, optional bool bReset = true)
{
    local int I;
    local GFxTween Item;

    I = 0;
    J0x10:

    // End:0x128 [Loop If]
    if(I < TweenList.Length)
    {
        Item = TweenList[I];
        // End:0x11A
        if(Item.TargetMC == MC)
        {
            Item.bFinished = true;
            // End:0x105
            if(bReset)
            {
                Item.TargetMC.SetFloat(Item.MemberName, Item.StartValue);
            }
            TweenList.Remove(I, 1);
        }
        I++;
        // [Loop Continue]
        goto J0x10;
    }
    //return;    
}

function PrintTweensToLog()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x31 [Loop If]
    if(I < TweenList.Length)
    {
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function TweenComplete(int Index)
{
    ProcessTweenCallback(TweenList[Index].Callback, TweenList[Index].TargetMC);
    TweenList.Remove(Index, 1);
    //return;    
}

function Init(optional LocalPlayer LocPlay)
{
    super.Init(LocPlay);
    MovieRootObject = GetVariableObject("_root");
    // End:0x3F
    if(MovieRootObject == none)
    {
    }
    //return;    
}

function ApplyPriorityVisibilityEffect(bool bRemoveEffect)
{
    local float RealTimeSeconds;

    RealTimeSeconds = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    // End:0xAA
    if(bLesserHideIsFading)
    {
        LesserHideInitialAlpha = Lerp(LesserHideInitialAlpha, LesserHideDestinationAlpha, (RealTimeSeconds - LesserHideFadeStartTime) / LesserHideFadeDuration);
        LesserHideFadeDuration -= (RealTimeSeconds - LesserHideFadeStartTime);        
    }
    else
    {
        LesserHideInitialAlpha = float(((bRemoveEffect) ? 0 : 100));
        LesserHideFadeDuration = default.LesserHideFadeDuration;
    }
    LesserHideDestinationAlpha = float(((bRemoveEffect) ? 100 : 0));
    bLesserHideIsFading = true;
    LesserHideFadeStartTime = RealTimeSeconds;
    //return;    
}

defaultproperties
{
    LesserHideFadeDuration=0.2500000
}