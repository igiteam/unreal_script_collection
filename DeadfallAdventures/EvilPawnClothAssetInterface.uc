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

simulated function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, optional bool bForce)
{
    //return;    
}

simulated function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath, optional bool bForce)
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

simulated function SetReplicator(EvilPawnClothingAssetReplicator InEvilPawnClothingAssetReplicator)
{
    //return;    
}

simulated function EvilPawnClothingAssetReplicator GetReplicator()
{
    //return ReturnValue;    
}

simulated function Object GetObject()
{
    //return ReturnValue;    
}

simulated function bool IsShield()
{
    //return ReturnValue;    
}

simulated function bool IsHeart()
{
    //return ReturnValue;    
}
