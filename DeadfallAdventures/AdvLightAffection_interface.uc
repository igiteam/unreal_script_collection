interface AdvLightAffection_interface extends Interface
    abstract;

simulated function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    //return;    
}

simulated function SetLightAffectionFromVolume(bool bInLightVolume)
{
    //return;    
}

simulated function UpdateLightInfluence_T()
{
    //return;    
}

simulated function StartInLightEffects()
{
    //return;    
}

simulated function StopInLightEffects()
{
    //return;    
}

function bool AddFlashlight(AdvInventoryItem_Torch addTorch)
{
    //return ReturnValue;    
}

function RemoveFlashlight(AdvInventoryItem_Torch removeTorch)
{
    //return;    
}

function bool IsUnderBeamEffect()
{
    //return ReturnValue;    
}
