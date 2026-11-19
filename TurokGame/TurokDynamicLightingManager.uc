class TurokDynamicLightingManager extends Object
    native;

struct atomic immutable Vector4 extends Vector
{
    var() float W;

    structdefaultproperties
    {
        W=1.0000000
    }
};

var int mMaxNumDynamicLights;
var export editinline array mDynamicLights;
var int mMaxNumWeaponLights;
var bool mGivePriorityToPOVWeapon;
var bool mLightPoolProxyPresent;
var export editinline array mWeaponLights;
var export editinline @NULL mpLightPoolProxy;
var export editinline array mLightPools;

// Export UTurokDynamicLightingManager::execRequestEnableDynamicLight(FFrame&, void* const)
native function RequestEnableDynamicLight(@NULL lightComp);

// Export UTurokDynamicLightingManager::execDisableDynamicLight(FFrame&, void* const)
native function DisableDynamicLight(@NULL lightComp);

// Export UTurokDynamicLightingManager::execRequestEnableWeaponLight(FFrame&, void* const)
native function RequestEnableWeaponLight(@NULL lightComp, bool isPOVWeapon);

// Export UTurokDynamicLightingManager::execDisableWeaponLight(FFrame&, void* const)
native function DisableWeaponLight(@NULL lightComp);

defaultproperties
{
    mMaxNumDynamicLights=5
    mMaxNumWeaponLights=2
    mGivePriorityToPOVWeapon=true
}