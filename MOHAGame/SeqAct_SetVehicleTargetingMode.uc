class SeqAct_SetVehicleTargetingMode extends SequenceAction
    hidecategories(Object);

enum EVehicleWeaponIndex
{
    WEAPON_PRIMARY,                 // 0
    WEAPON_SECONDARY,               // 1
    WEAPON_MAX                      // 2
};

var() SeqAct_SetVehicleTargetingMode.EVehicleWeaponIndex VehicleWeaponType;
var() MOHAVehicleController.EVehicleWeaponTargetingMode TargetingMode;
var() bool bStopWhenEngagingVisiblePlayer;
var() bool bDontFire;
var() bool bTurnTowardsPlayerWhenStopped;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Vehicle",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Weapon Target",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set Vehicle Targeting Mode"
    ObjCategory="Vehicle"
}