class TurokDynamicLightingManagerReset extends Actor
    native
    placeable
    hidecategories(Navigation)
    autoexpandcategories(DynamicLightingManagerReset);

var(DynamicLightingManagerReset) int mMaxNumDynamicLights;
var(DynamicLightingManagerReset) int mMaxNumWeaponLights;
var(DynamicLightingManagerReset) bool mGivePriorityToPOVWeapon;
var(DynamicLightingManagerReset) bool mAttemptToEnableAllLights;

// Export UTurokDynamicLightingManagerReset::execResetDynamicLightingManager(FFrame&, void* const)
native function ResetDynamicLightingManager();

simulated function OnResetDynamicLightingManager(@NULL Action)
{
    ResetDynamicLightingManager();
    //return;    
}

defaultproperties
{
    mMaxNumDynamicLights=1
    mMaxNumWeaponLights=2
    mGivePriorityToPOVWeapon=true
    mAttemptToEnableAllLights=true
    bStatic=true
    bNoDelete=true
}