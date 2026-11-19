class SPFireManager extends Actor
    native
    notplaceable;

const minSpawnDist = 56.0f;

var private transient array<SPFireObject> sourceFires;
var Vector vLastFirePos;
var bool bDrawDebug;
var ImpactParticlesInfo DefaultImpactParticles;
var ImpactDecalInfo DefaultImpactDecal;

// Export USPFireManager::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPFireManager::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, Actor SpawnOwner, name SpawnTag, Vector SpawnLocation, Rotator SpawnRotation, Actor Template);

// Export USPFireManager::execAdjustNavWeights(FFrame&, void* const)
native static final function AdjustNavWeights(Vector vPos, float fRadius, float fDistMultiplier);

// Export USPFireManager::execDrawNavWeights(FFrame&, void* const)
native static final function DrawNavWeights(Vector vPos, float fRadius);

// Export USPFireManager::execLineIntersectSphere(FFrame&, void* const)
native static final function bool LineIntersectSphere(Vector vP1, Vector vP2, Vector SphereCenter, float Radius);

// Export USPFireManager::execPointInSphere(FFrame&, void* const)
native static final function bool PointInSphere(Vector vPt, Vector SphereCenter, float Radius);

// Export USPFireManager::execLineCrossesFire(FFrame&, void* const)
native static final function int LineCrossesFire(Vector vStart, Vector vEnd, float Radius, optional Actor DisregardActor);

// Export USPFireManager::execDrawFireRadius(FFrame&, void* const)
native static final function DrawFireRadius(float fRadius);

// Export USPFireManager::execFindClosestNonFireBlockedPathNode(FFrame&, void* const)
native static final function bool FindClosestNonFireBlockedPathNode(Vector vPos, float fRadius, out Vector vNewPos);

// Export USPFireManager::execFindClosestAltPathNode(FFrame&, void* const)
native static final function bool FindClosestAltPathNode(Vector vPos, float fRadius, out Vector vNewPos);

// Export USPFireManager::execIsInFire(FFrame&, void* const)
native static final function bool IsInFire(Actor A);

// Export USPFireManager::execGetFireManager(FFrame&, void* const)
native static final function SPFireManager GetFireManager();

static function bool HandleImpactFireWParams(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, FireParamsInfo FireParams, name fireSocketName, optional ImpactDecalInfo DefaultDecal, optional ImpactParticlesInfo DefaultParticles)
{
    local SPFireManager spfManager;

    // End:0x83
    if(Impact.HitActor != none)
    {
        spfManager = GetFireManager();
        // End:0x83
        if(spfManager != none)
        {
            // End:0x4F
            if(PhysMat == none)
            {
                PhysMat = Class'SPWeapon'.default.DefaultMaterial;
            }
            return spfManager.SPFHandleImpactFire(PhysMat, theDamageType, Impact, FireParams, fireSocketName, DefaultDecal, DefaultParticles);
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool HandleImpactFire(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, optional ImpactDecalInfo DefaultDecal, optional ImpactParticlesInfo DefaultParticles)
{
    local FireParamsInfo newFireParams;

    newFireParams.FireFlammability = 50.0000000;
    newFireParams.FireStrength = 100.0000000;
    newFireParams.FireSpreadSpeed = 50.0000000;
    newFireParams.FireBurnTime = 2.0000000;
    newFireParams.FireDamage = 2.0000000;
    newFireParams.FireIsTempFire = true;
    return HandleImpactFireWParams(PhysMat, theDamageType, Impact, newFireParams, 'None', DefaultDecal, DefaultParticles);
    //return ReturnValue;    
}

static function bool HandleImpactFireWithScaleAndBurnTime(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, float FireScale, float BurnTime, float Damage, optional ImpactDecalInfo DefaultDecal, optional ImpactParticlesInfo DefaultParticles)
{
    local FireParamsInfo newFireParams;

    newFireParams.FireFlammability = 10000.0000000;
    newFireParams.FireStrength = 10000.0000000;
    newFireParams.FireSpreadSpeed = 500.0000000;
    newFireParams.FireScale = FireScale;
    newFireParams.FireBurnTime = BurnTime;
    newFireParams.FireDamage = Damage;
    newFireParams.FireIsTempFire = true;
    return HandleImpactFireWParams(PhysMat, theDamageType, Impact, newFireParams, 'None', DefaultDecal, DefaultParticles);
    //return ReturnValue;    
}

static function AdjustWeightsFireActive(SPFireObject newFO)
{
    AdjustNavWeights(newFO.Location, 200.0000000, 100.0000000);
    newFO.bWeighted = true;
    //return;    
}

static function AdjustWeightsFireInactive(SPFireObject newFO)
{
    AdjustNavWeights(newFO.Location, 200.0000000, -100.0000000);
    newFO.bWeighted = false;
    //return;    
}

static function GlobalAddFireObject(SPFireObject newFO)
{
    local SPFireManager FireManager;

    FireManager = GetFireManager();
    // End:0x2C
    if(FireManager != none)
    {
        FireManager.AddFireObject(newFO);
    }
    // End:0x69
    if((newFO.bEnabled == true) && newFO.bWeighted == false)
    {
        AdjustWeightsFireActive(newFO);
    }
    //return;    
}

static function GlobalRemoveFireObject(SPFireObject newFO)
{
    local SPFireManager FireManager;

    // End:0x3D
    if((newFO.bEnabled == false) && newFO.bWeighted == true)
    {
        AdjustWeightsFireInactive(newFO);
    }
    FireManager = GetFireManager();
    // End:0x69
    if(FireManager != none)
    {
        FireManager.RemoveFireObject(newFO);
    }
    //return;    
}

private final function AddFireObject(SPFireObject newFO)
{
    sourceFires[sourceFires.Length] = newFO;
    vLastFirePos = newFO.Location;
    //return;    
}

private final function RemoveFireObject(SPFireObject newFO)
{
    local int I, arrayLen;

    arrayLen = sourceFires.Length;
    I = 0;
    J0x13:

    // End:0x77 [Loop If]
    if(I < arrayLen)
    {
        // End:0x6D
        if(sourceFires[I] == newFO)
        {
            arrayLen--;
            sourceFires[I] = sourceFires[arrayLen];
            sourceFires[arrayLen] = none;
            I = arrayLen;
        }
        I++;
        // [Loop Continue]
        goto J0x13;
    }
    sourceFires.Length = arrayLen;
    //return;    
}

private final function float SPFFindClosestFireObject(ImpactInfo Impact, out SPFireObject closest, out SPFireObject nextClosest, out float nextClosestDistSq)
{
    local float fClosestDistSq, fCurrentDistSq;
    local int I;
    local Vector currPos;

    currPos = Impact.HitLocation;
    closest = none;
    fClosestDistSq = 10000000000.0000000;
    I = 0;
    J0x2F:

    // End:0xF1 [Loop If]
    if(I < sourceFires.Length)
    {
        // End:0x5D
        if(!sourceFires[I].bEnabled)
        {
            // [Explicit Continue]
            goto J0xE7;
        }
        // End:0xE7
        if(sourceFires[I].GetStateName() != 'Inactive')
        {
            fCurrentDistSq = VSizeSq(sourceFires[I].Location - currPos);
            // End:0xE7
            if(fCurrentDistSq < fClosestDistSq)
            {
                nextClosest = closest;
                nextClosestDistSq = fClosestDistSq;
                closest = sourceFires[I];
                fClosestDistSq = fCurrentDistSq;
            }
        }
        J0xE7:

        I++;
        // [Loop Continue]
        goto J0x2F;
    }
    return fClosestDistSq;
    //return ReturnValue;    
}

function ClearFireHits()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < sourceFires.Length)
    {
        sourceFires[I].DebugHit = 0;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SetFireHit(int I, int Val)
{
    sourceFires[I].DebugHit = Val;
    //return;    
}

private final function bool SPFHandleImpactFire(SPPhysicalMaterial PhysMat, class<DamageType> theDamageType, ImpactInfo Impact, FireParamsInfo FireParams, name fireSocketName, optional ImpactDecalInfo DefaultDecal, optional ImpactParticlesInfo DefaultParticles)
{
    local SPFireObject newSPFireObject, closestFireObject, nextClosestFireObject;
    local float nextClosestDistSq, closestDistSQ;
    local Rotator rotTemp;
    local bool bShouldForceOnFire;
    local editinline SPActorDestructComponent destruct;
    local editinline SkeletalMeshComponent SkelMesh;
    local name BoneName;
    local Vector NewLoc;
    local Rotator NewRot;

    // End:0x6C
    if(Impact.HitActor != none)
    {
        destruct = SPActorDestructComponent(Impact.HitActor.GetActorDestructComponent());
        // End:0x6C
        if((destruct != none) && !destruct.IsOnFire())
        {
            bShouldForceOnFire = true;
        }
    }
    closestDistSQ = SPFFindClosestFireObject(Impact, closestFireObject, nextClosestFireObject, nextClosestDistSq);
    // End:0x1FC
    if((closestDistSQ < Square(56.0000000)) && FireParams.FireIsTempFire || !bShouldForceOnFire)
    {
        closestFireObject.DamageAmount = FMax(FireParams.FireDamage, closestFireObject.DamageAmount);
        closestFireObject.BurnTime = FMax(FireParams.FireBurnTime, closestFireObject.BurnTime);
        closestFireObject.FireStrength = FMax(FireParams.FireStrength, closestFireObject.DamageAmount);
        closestFireObject.FireSpreadSpeed = FMax(FireParams.FireSpreadSpeed, closestFireObject.BurnTime);
        closestFireObject.StartBurnTime = WorldInfo.TimeSeconds;
        // End:0x1F9
        if((closestFireObject.currCombineLevel == 0) && (WorldInfo.TimeSeconds - closestFireObject.OrigStartBurnTime) > 1.0000000)
        {
            closestFireObject.SwitchToCombineLevel(1);
        }        
    }
    else
    {
        newSPFireObject = SPFireObject(SPSpawn(Class'SPFireObject', self, 'None', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), none));
        newSPFireObject.AttachedActor = Impact.HitActor;
        AdjustWeightsFireInactive(newSPFireObject);
        newSPFireObject.bKillDuringLevelTransition = true;
        // End:0x7A9
        if(newSPFireObject != none)
        {
            newSPFireObject.AudioComp_FireLoop = PhysMat.PlayEffectLoopSound(theDamageType, newSPFireObject, Impact.HitLocation, newSPFireObject.FireEndCue);
            // End:0x309
            if(Impact.HitActor != none)
            {
                PhysMat.AddImpactDecal(theDamageType, Impact, DefaultDecal);
            }
            newSPFireObject.LightObject = PhysMat.AddImpactLight(theDamageType, Impact);
            newSPFireObject.LightObject.bKillDuringLevelTransition = true;
            newSPFireObject.FireEmitter = PhysMat.AddImpactParticlesOldVersion(theDamageType, Impact, fireSocketName, newSPFireObject.PSLevels, DefaultParticles);
            // End:0x7A9
            if(newSPFireObject.FireEmitter != none)
            {
                newSPFireObject.SetLocation(Impact.HitLocation);
                newSPFireObject.SetRotation(rotTemp);
                newSPFireObject.FireEmitter.SetRotation(rotTemp);
                newSPFireObject.DamageAmount = FireParams.FireDamage;
                newSPFireObject.BurnTime = FireParams.FireBurnTime;
                newSPFireObject.FireStrength = FireParams.FireStrength;
                newSPFireObject.FireSpreadSpeed = FireParams.FireSpreadSpeed;
                newSPFireObject.StartBurnTime = WorldInfo.TimeSeconds;
                newSPFireObject.OrigStartBurnTime = WorldInfo.TimeSeconds;
                newSPFireObject.InitedParented = true;
                newSPFireObject.IsTempFire = FireParams.FireIsTempFire;
                newSPFireObject.attachedSocketName = fireSocketName;
                // End:0x5A9
                if((fireSocketName != 'None') && Class'SPPawn'.static.GetSocketInformation(Impact.HitActor, fireSocketName, SkelMesh, BoneName, NewLoc, NewRot))
                {
                    newSPFireObject.SetLocation(NewLoc);
                    newSPFireObject.SetBase(Impact.HitActor, vect(0.0000000, 0.0000000, 1.0000000), SkelMesh, BoneName, true);                    
                }
                else
                {
                    newSPFireObject.SetBase(Impact.HitActor);
                }
                newSPFireObject.SetCollisionCylOverride(FireParams.FireCylRadiusOverride, FireParams.FireCylHeightOverride);
                // End:0x643
                if(FireParams.FireScale != 1.0000000)
                {
                    newSPFireObject.ScaleMe(FireParams.FireScale);
                }
                // End:0x7A9
                if(((((closestFireObject != none) && !newSPFireObject.IsTempFire ^^ closestFireObject.IsTempFire) && !closestFireObject.bCausedSpread) && (closestFireObject.Base == newSPFireObject.Base) || Rand(100) < 50) && closestDistSQ < Square(56.0000000 * 3.0000000))
                {
                    // End:0x77B
                    if((((nextClosestFireObject != none) && !nextClosestFireObject.bCausedSpread) && (nextClosestFireObject.Base == newSPFireObject.Base) || Rand(100) < 35) && nextClosestDistSq < Square(56.0000000 * 6.0000000))
                    {
                        // End:0x778
                        if(!newSPFireObject.SwitchToCombineLevel(2))
                        {
                            newSPFireObject.SwitchToCombineLevel(1);
                        }                        
                    }
                    else
                    {
                        newSPFireObject.SwitchToCombineLevel(1);
                    }
                    newSPFireObject.OrientToOtherActor(closestFireObject);
                }
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    local int I, arrayLen;

    arrayLen = sourceFires.Length;
    I = 0;
    J0x13:

    // End:0x8A [Loop If]
    if(I < arrayLen)
    {
        // End:0x80
        if((sourceFires[I] == none) || sourceFires[I].IsPendingKill())
        {
            arrayLen--;
            sourceFires[I] = sourceFires[arrayLen];
            sourceFires[arrayLen] = none;
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x13;
    }
    sourceFires.Length = arrayLen;
    // End:0xBA
    if(bDrawDebug)
    {
        DrawNavWeights(vLastFirePos, 250.0000000);
        DrawFireRadius(200.0000000);
    }
    //return;    
}

function Vector GetSphereIntersectPos(int Id, Vector Loc, float Radius)
{
    local Vector vDir, vOut;

    vDir = Normal(Loc - sourceFires[Id].Location);
    vOut = sourceFires[Id].Location + (vDir * Radius);
    return vOut;
    //return ReturnValue;    
}
