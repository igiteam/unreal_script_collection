interface EvilPawnClothAssetInterface extends Interface
    abstract;

function int GetHealth()
{
    //return ReturnValue;    
}

function int GetMaxHealth()
{
    //return ReturnValue;    
}

function ISetMaterial(int ElementIndex, MaterialInterface Mat)
{
    //return;    
}

function ISetMaterialFromRandomMaterials(int ElementIndex)
{
    //return;    
}

function int GetRandomMaterialsAmount()
{
    //return ReturnValue;    
}

function ReduceDamage(out int Damage, class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
    //return;    
}

function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
    //return;    
}

function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath)
{
    //return;    
}

simulated function SetScalarParameterForMaterials(name InParamName, float InValue)
{
    //return;    
}

simulated function PostAttachComponent()
{
    //return;    
}

simulated function AttachCloth(EvilPawn P)
{
    //return;    
}

simulated function bool PreValidateMaterials(EvilPawn P)
{
    //return ReturnValue;    
}

simulated function bool ValidateComponent(EvilPawn P, const out array<EvilPawnClothAssetInterface> validateAssets)
{
    //return ReturnValue;    
}

simulated function Object ObjectGetObjectArchetype()
{
    //return ReturnValue;    
}
