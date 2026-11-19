class EvilGameReplicationInfo extends UTGameReplicationInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var EvilObjectPool GOP;
//var delegate<IsWithinMaxEffectDistance> __IsWithinMaxEffectDistance__Delegate;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    GOP = Spawn(Class'EvilObjectPool');
    //return;    
}

final simulated delegate bool IsWithinMaxEffectDistance(const out PlayerController PC, const out Vector EffectLocation, const float CullDistance)
{
    ScriptTrace();
    return false;
    //return ReturnValue;    
}

final simulated function bool CheckEffectDistance_SpawnBehindIfNear(const out PlayerController PC, const out Vector EffectLocation, const float CullDistance)
{
    local Vector Loc;
    local Rotator Rot;
    local float Dist;

    PC.GetPlayerViewPoint(Loc, Rot);
    Dist = VSize(EffectLocation - Loc);
    // End:0x8F
    if((Normal(EffectLocation - Loc) Dot Vector(Rot)) < 0.0000000)
    {
        return Dist < 1600.0000000;
    }
    // End:0xC8
    if((Dist * PC.LODDistanceFactor) > CullDistance)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final simulated function bool CheckEffectDistance_SpawnWithinCullDistanceAndInFront(const out PlayerController PC, const out Vector EffectLocation, const float CullDistance)
{
    local Vector Loc;
    local Rotator Rot;
    local float Dist;

    PC.GetPlayerViewPoint(Loc, Rot);
    // End:0x60
    if((Normal(EffectLocation - Loc) Dot Vector(Rot)) < 0.0000000)
    {
        return false;
    }
    Dist = VSize(EffectLocation - Loc);
    // End:0xB9
    if((Dist * PC.LODDistanceFactor) > CullDistance)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final simulated function bool CheckEffectDistance_SpawnWithinCullDistance(const out PlayerController PC, const out Vector EffectLocation, const float CullDistance)
{
    local Vector Loc;
    local Rotator Rot;
    local float Dist;

    PC.GetPlayerViewPoint(Loc, Rot);
    Dist = VSize(EffectLocation - Loc);
    // End:0x8A
    if((Dist * PC.LODDistanceFactor) > CullDistance)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final simulated function bool IsEffectRelevant(const out Pawn InInstigator, const out Vector EffectLocation, const float CullDistance, const bool bForceRelevant, delegate<IsWithinMaxEffectDistance> DistanceFunc)
{
    local PlayerController PC;

    // End:0x0F
    if(bForceRelevant)
    {
        return true;
    }
    // End:0xEA
    if((((InInstigator != none) && VSize(EffectLocation - InInstigator.Location) <= 128.0000000) && (WorldInfo.TimeSeconds - InInstigator.LastRenderTime) > 2.0000000) && (UTPawn(InInstigator) == none) || !UTPawn(InInstigator).IsFirstPerson())
    {
        return false;
    }
    // End:0x144
    if(((InInstigator != none) && InInstigator.IsHumanControlled()) && InInstigator.IsLocallyControlled())
    {
        return true;
    }
    // End:0x19F
    if((InInstigator != none) && (WorldInfo.TimeSeconds - InInstigator.LastRenderTime) < 1.0000000)
    {
        return true;
    }
    __IsWithinMaxEffectDistance__Delegate = DistanceFunc;
    // End:0x221
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x220
        if(IsWithinMaxEffectDistance(PC, EffectLocation, CullDistance))
        {
            __IsWithinMaxEffectDistance__Delegate = None;            
            return true;
        }        
    }    
    __IsWithinMaxEffectDistance__Delegate = None;
    return false;
    //return ReturnValue;    
}

final simulated function int GetLODLevelToUse(ParticleSystem PS, Vector EffectLocation)
{
    local int Retval, LODIdx;
    local PlayerController PC;
    local Vector POVLoc;
    local Rotator POVRot;
    local float DistanceToEffect, LODDistance;

    // End:0x11
    if(PS == none)
    {
        return 0;
    }
    // End:0xC1
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        PC.GetPlayerViewPoint(POVLoc, POVRot);
        DistanceToEffect = VSize(POVLoc - EffectLocation);
        // End:0xC0
        if((LODDistance == 0.0000000) || DistanceToEffect < LODDistance)
        {
            LODDistance = DistanceToEffect;
        }        
    }    
    Retval = PS.LODDistances.Length - 1;
    LODIdx = 1;
    J0xF9:

    // End:0x183 [Loop If]
    if(LODIdx < PS.LODDistances.Length)
    {
        // End:0x175
        if(DistanceToEffect < PS.LODDistances[LODIdx])
        {
            Retval = LODIdx - 1;
            // [Explicit Break]
            goto J0x183;
        }
        ++LODIdx;
        // [Loop Continue]
        goto J0xF9;
    }
    J0x183:

    return Retval;
    //return ReturnValue;    
}

simulated function bool OnSameTeam(Actor A, Actor B)
{
    local byte AT, bt;

    // End:0x22
    if((A == none) || B == none)
    {
        return false;
    }
    AT = A.GetTeamNum();
    bt = B.GetTeamNum();
    // End:0xA3
    if((int(AT) == int(255)) || int(bt) == int(255))
    {
        return false;        
    }
    else
    {
        return int(AT) == int(bt);
    }
    //return ReturnValue;    
}

simulated function bool IsTeamMultiPlayerGame()
{
    //return ReturnValue;    
}

simulated function bool IsSurvivalGame()
{
    //return ReturnValue;    
}

simulated function MaterialInstanceTimeVarying GetRandomDecalMaterialsFromMapInfo()
{
    return none;
    //return ReturnValue;    
}
