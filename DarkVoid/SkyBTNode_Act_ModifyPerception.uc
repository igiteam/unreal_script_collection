class SkyBTNode_Act_ModifyPerception extends SkyBTNode_Leaf_Action
    native;

enum GodsightModify
{
    GM_GodsightDefault,             // 0
    GM_GodsightEnabled,             // 1
    GM_GodsightDisabled,            // 2
    GM_MAX                          // 3
};

var(Global) bool bUseArchetypePresets;
var(Perception) bool bLOSHearing;
var(Perception) bool bMuffledHearing;
var(Perception) float HearingThreshold;
var(Perception) float Alertness;
var(Perception) float SightRadius;
var(Perception) float PeripheralVision;
var(Godsight) SkyBTNode_Act_ModifyPerception.GodsightModify ChangeGodsight;
var(Godsight) float NewGodsightDuration;
