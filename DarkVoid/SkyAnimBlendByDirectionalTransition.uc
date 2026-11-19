class SkyAnimBlendByDirectionalTransition extends SkyAnimBlendBase
    native;

struct native AnimDTDef
{
    var() editoronly name Name;
    var() float HeadingCenter;
    var() float HeadingWidth;
    var() float TransitionCenter;
    var() float TransitionWidth;

    structdefaultproperties
    {
        Name="None"
        HeadingCenter=0.0000000
        HeadingWidth=0.0000000
        TransitionCenter=0.0000000
        TransitionWidth=0.0000000
    }
};

var transient Vector LazyVelocity;
var() array<AnimDTDef> Directions;
var() float Laziness;
var() float MinVelocity;
var() bool bDisableBlendBySpeedNodesDuringTransitions;
var() bool bBlendOutEarly;
