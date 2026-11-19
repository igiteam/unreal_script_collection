class SPFireObject extends Actor
    native
    placeable;

struct native TouchedActorInfo
{
    var float StartTouchTime;
    var float LastBurnTime;
    var Actor TouchedActor;

    structdefaultproperties
    {
        StartTouchTime=0.0000000
        LastBurnTime=0.0000000
        TouchedActor=none
    }
};

var() ParticleSystem PSLevels[3];
/** In Damage per second; */
var() float DamageAmount;
var() float BurnTime;
var() float FireStrength;
var() float FireSpreadSpeed;
var() float scaleVal;
var() bool bEnabled;
var() bool bDisablePlayerDamage;
var transient bool InitedParented;
var transient bool bCausedSpread;
var transient bool IsTempFire;
var transient bool bLastEnabled;
var bool bWeighted;
var bool bForceToPointUp;
var() float FireNotifyRadius;
var transient SPEmitter FireEmitter;
var transient float StartBurnTime;
var transient float OrigStartBurnTime;
var transient array<TouchedActorInfo> TouchedList;
var export editinline transient AudioComponent AudioComp_FireLoop;
var export editinline transient AudioComponent AudioComp_FireLoopEnd;
var transient SoundCue FireEndCue;
var transient Light LightObject;
var transient float OrigBrightness;
var transient int currCombineLevel;
var transient name attachedSocketName;
var transient float FireDistance;
var int DebugHit;
var() int FireIDTag;
var Actor AttachedActor;
/** Loop sound for fire burning */
var() SoundCue fireBurningSound;
var export editinline AudioComponent LoopSoundComponent;

function bool SwitchToCombineLevel(int newLevel)
{
    local int fixedIndex;
    local editinline ParticleSystemComponent psComp;
    local editinline SPActorDestructComponent destruct;

    // End:0x40
    if((Base != none) && newLevel > 1)
    {
        destruct = SPActorDestructComponent(Base.GetActorDestructComponent());
        // End:0x40
        if(destruct != none)
        {
            return false;
        }
    }
    fixedIndex = Clamp(newLevel, 0, 2);
    // End:0xF9
    if((PSLevels[fixedIndex] != none) && (fixedIndex != currCombineLevel) || FireEmitter == none)
    {
        // End:0xC8
        if(FireEmitter != none)
        {
            FireEmitter.bDestroyOnSystemFinish = true;
            psComp = FireEmitter.ParticleSystemComponent;
            psComp.DeactivateSystem();
            FireEmitter = none;
        }
        currCombineLevel = fixedIndex;
        CreateEmitter();
        // End:0xF7
        if(scaleVal != 1.0000000)
        {
            ScaleMe(scaleVal);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OrientToOtherActor(Actor otherActor)
{
    local Vector toVect;
    local Rotator tempRot, origRot;

    toVect = otherActor.Location - Location;
    toVect.Z = 0.0000000;
    tempRot = Rotator(toVect);
    origRot = Rotation;
    origRot.Yaw = tempRot.Yaw + 16384;
    origRot = Normalize(origRot);
    SetRotation(origRot);
    //return;    
}

private final function int FindInTouchedList(Actor TouchedActor)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(I < TouchedList.Length)
    {
        // End:0x3D
        if(TouchedList[I].TouchedActor == TouchedActor)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function AddToTouchedList(Actor TouchedActor)
{
    local int NewIndex;

    // End:0x91
    if(FindInTouchedList(TouchedActor) < 0)
    {
        NewIndex = TouchedList.Length;
        TouchedList.Insert(NewIndex, 1);
        TouchedList[NewIndex].StartTouchTime = WorldInfo.TimeSeconds;
        TouchedList[NewIndex].LastBurnTime = WorldInfo.TimeSeconds;
        TouchedList[NewIndex].TouchedActor = TouchedActor;
    }
    //return;    
}

private final function RemoveIndexFromTouchedList(int delIndex)
{
    local int arrayLen;

    // End:0x55
    if(delIndex >= 0)
    {
        arrayLen = TouchedList.Length - 1;
        TouchedList[delIndex] = TouchedList[arrayLen];
        TouchedList[delIndex].TouchedActor = none;
        TouchedList.Length = arrayLen;
    }
    //return;    
}

private final function RemoveFromTouchedList(Actor TouchedActor)
{
    local int NewIndex;

    NewIndex = FindInTouchedList(TouchedActor);
    // End:0x27
    if(NewIndex >= 0)
    {
        RemoveIndexFromTouchedList(NewIndex);
    }
    //return;    
}

private final function bool ShouldCatchOnFire(TouchedActorInfo taInfo, float currTime, out FireParamsInfo FireParams, out SPActorDestructComponent destruct)
{
    local float percLimit, DeltaTime;

    // End:0xED
    if((taInfo.TouchedActor != none) && !taInfo.TouchedActor.IsPendingKill())
    {
        DeltaTime = currTime - taInfo.LastBurnTime;
        // End:0xED
        if(GetFlammableParams(taInfo.TouchedActor, FireParams, destruct))
        {
            // End:0xED
            if((FireParams.FireFlammability > 0.0100000) && !destruct.IsOnFire())
            {
                percLimit = ((DeltaTime * FireStrength) * FireParams.FireFlammability) / (100.0000000 * 100.0000000);
                return FRand() < percLimit;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

private final function DamageTouchedList()
{
    local int I;
    local float currTime, DamageTotal, DamageDifference;
    local int DamageTrunc;
    local FireParamsInfo FireParams;
    local editinline SPActorDestructComponent destruct;
    local ImpactInfo tempImpactInfo;
    local Actor Other;
    local Vector vOffset;
    local name fireSocketName;

    currTime = WorldInfo.TimeSeconds;
    I = 0;
    J0x1C:

    // End:0x52A [Loop If]
    if(I < TouchedList.Length)
    {
        // End:0x50E
        if((TouchedList[I].TouchedActor != none) && !TouchedList[I].TouchedActor.IsPendingKill())
        {
            // End:0x50B
            if((bDisablePlayerDamage && !TouchedList[I].TouchedActor.IsA('PlayerPawn')) || !bDisablePlayerDamage)
            {
                // End:0x31B
                if(ShouldCatchOnFire(TouchedList[I], currTime, FireParams, destruct))
                {
                    Other = TouchedList[I].TouchedActor;
                    tempImpactInfo.HitActor = Other;
                    tempImpactInfo.HitNormal = Vector(Other.Rotation);
                    SetActorNumFires(Other);
                    // End:0x263
                    if((Other.CollisionComponent != none) && VSize(FireParams.FireCatchOffset) == 0.0000000)
                    {
                        tempImpactInfo.HitLocation = Other.CollisionComponent.Bounds.Origin;
                        // End:0x260
                        if(destruct.OnFireMax > 1)
                        {
                            vOffset = Location - tempImpactInfo.HitLocation;
                            vOffset.Z = 0.0000000;
                            vOffset = Normal(vOffset);
                            vOffset *= 30.0000000;
                            vOffset.Z = Other.CollisionComponent.Bounds.BoxExtent.Z * 0.7500000;
                            tempImpactInfo.HitLocation += vOffset;
                        }                        
                    }
                    else
                    {
                        Class'SPWeapon'.static.GetVectorWorldSpace(Other, FireParams.FireCatchOffset, tempImpactInfo.HitLocation);
                    }
                    // End:0x2D9
                    if(SPPawn(Other) != none)
                    {
                        SPPawn(Other).GetBestFireSocket(Other.Location, fireSocketName);
                    }
                    // End:0x31B
                    if(Class'SPFireManager'.static.HandleImpactFireWParams(none, Class'SPDamageTypeImpactFlame', tempImpactInfo, FireParams, fireSocketName))
                    {
                        destruct.CatchOnFire();
                    }
                }
                // End:0x354
                if(TouchedList[I].TouchedActor == Base)
                {
                    DamageTotal = FireParams.FireDamagedByChildScale;                    
                }
                else
                {
                    DamageTotal = FireParams.FireDamagedByScale;
                }
                // End:0x50B
                if((destruct != none) || TouchedList[I].TouchedActor.IsA('HumanPawn'))
                {
                    // End:0x3E9
                    if(destruct.FireLastDamageTime == WorldInfo.TimeSeconds)
                    {
                        DamageDifference = FMax(DamageAmount - destruct.FireLastDamageAmount, 0.0000000);                        
                    }
                    else
                    {
                        DamageDifference = DamageAmount;
                    }
                    DamageDifference = DamageDifference * DamageTotal;
                    // End:0x50B
                    if(DamageDifference > 0.0000000)
                    {
                        destruct.FireLastDamageAmount = DamageDifference;
                        DamageTotal = (DamageDifference * (currTime - TouchedList[I].LastBurnTime)) + destruct.FireFractionalDamage;
                        DamageTrunc = int(DamageTotal);
                        destruct.FireFractionalDamage = DamageTotal - float(DamageTrunc);
                        TouchedList[I].LastBurnTime = currTime;
                        destruct.FireLastDamageTime = WorldInfo.TimeSeconds;
                        TouchedList[I].TouchedActor.TakeDamageAndProcEffects(float(DamageTrunc), none, Location, Vector(Rotation), Class'SPDamageTypeImpactFlame',, self);
                    }
                }
            }
            // [Explicit Continue]
            goto J0x520;
        }
        RemoveIndexFromTouchedList(I);
        I--;
        J0x520:

        I++;
        // [Loop Continue]
        goto J0x1C;
    }
    //return;    
}

function Destroyed()
{
    local FireParamsInfo FireParams;
    local editinline SPActorDestructComponent destruct;

    // End:0x1B
    if(AudioComp_FireLoop != none)
    {
        AudioComp_FireLoop.Stop();
    }
    // End:0x58
    if((Base != none) && GetFlammableParams(Base, FireParams, destruct))
    {
        destruct.UnCatchOnFire();
    }
    super.Destroyed();
    //return;    
}

static function bool GetFlammableParams(Actor targetActor, out FireParamsInfo FireParams, out SPActorDestructComponent destruct)
{
    destruct = SPActorDestructComponent(targetActor.GetActorDestructComponent());
    // End:0x7E
    if((destruct != none) && destruct.GetProperties() != none)
    {
        FireParams = destruct.GetProperties().FireParams;
        return FireParams.FireFlammability != 0.0000000;
    }
    return false;
    //return ReturnValue;    
}

private final function CreateEmitter()
{
    local editinline SkeletalMeshComponent SkelMesh;
    local name BoneName;
    local Vector NewLoc;
    local Rotator NewRot;

    FireEmitter = Spawn(Class'SPEmitterSpawnable',,, Location, Rotation);
    // End:0x128
    if(FireEmitter != none)
    {
        FireEmitter.SetTemplate(PSLevels[currCombineLevel], true);
        FireEmitter.bDestroyOnSystemFinish = true;
        FireEmitter.SetOwner(self);
        // End:0xFD
        if((attachedSocketName != 'None') && Class'SPPawn'.static.GetSocketInformation(Base, attachedSocketName, SkelMesh, BoneName, NewLoc, NewRot))
        {
            FireEmitter.SetLocation(NewLoc);
            FireEmitter.SetBase(Base, vect(0.0000000, 0.0000000, 1.0000000), SkelMesh, BoneName, true);            
        }
        else
        {
            FireEmitter.SetBase(self);
        }
        FireEmitter.bKillDuringLevelTransition = true;
    }
    //return;    
}

function SetActorNumFires(Actor Parent)
{
    local editinline SPActorDestructComponent destruct;
    local int XNum, YNum;

    // End:0xE5
    if(Parent != none)
    {
        destruct = SPActorDestructComponent(Parent.GetActorDestructComponent());
        // End:0xE5
        if((destruct != none) && Parent.CollisionComponent != none)
        {
            XNum = int(Parent.CollisionComponent.Bounds.BoxExtent.X / 50.0000000);
            YNum = int(Parent.CollisionComponent.Bounds.BoxExtent.Y / 50.0000000);
            destruct.OnFireMax = Clamp(XNum * YNum, 1, 4);
        }
    }
    //return;    
}

function SpreadFire(float DeltaTime)
{
    local editinline SPActorDestructComponent destruct;
    local FireParamsInfo FireParams;
    local ImpactInfo tempImpactInfo;
    local Vector vecOffset;
    local int RandVal;
    local name spreadSocketName;

    // End:0x1C
    if((FRand() * 100.0000000) > (FireSpreadSpeed * DeltaTime))
    {
        return;
    }
    spreadSocketName = 'None';
    // End:0x2A6
    if(((Base != none) && !bCausedSpread) && GetFlammableParams(Base, FireParams, destruct))
    {
        // End:0x2A6
        if((Base.CollisionComponent != none) && destruct.CanCatchOnFire())
        {
            tempImpactInfo.HitActor = Base;
            tempImpactInfo.HitInfo.HitComponent = Base.CollisionComponent;
            tempImpactInfo.HitNormal = Vector(Base.Rotation);
            tempImpactInfo.HitLocation = Base.CollisionComponent.Bounds.Origin;
            vecOffset = Base.CollisionComponent.Bounds.BoxExtent * 0.7500000;
            vecOffset.X = 30.0000000;
            vecOffset.Y = 30.0000000;
            RandVal = Rand(4);
            // End:0x1BF
            if((RandVal & 1) != 0)
            {
                vecOffset.X = -vecOffset.X;
            }
            // End:0x1F1
            if((RandVal & 2) != 0)
            {
                vecOffset.Y = -vecOffset.Y;
            }
            tempImpactInfo.HitLocation += vecOffset;
            // End:0x246
            if(SPPawn(Base) != none)
            {
                SPPawn(Base).GetBestFireSocket(tempImpactInfo.HitLocation, spreadSocketName);
            }
            // End:0x290
            if(Class'SPFireManager'.static.HandleImpactFireWParams(none, Class'SPDamageTypeImpactFlame', tempImpactInfo, FireParams, spreadSocketName))
            {
                bCausedSpread = true;
                destruct.CatchOnFire();
            }
            // End:0x2A6
            if(currCombineLevel < 1)
            {
                SwitchToCombineLevel(1);
            }
        }
    }
    //return;    
}

function CommonTick(float DeltaTime)
{
    //return;    
}

function Tick(float DeltaTime)
{
    CommonTick(DeltaTime);
    //return;    
}

function EnableMe()
{
    // End:0x24
    if((FireEmitter == none) && PSLevels[currCombineLevel] != none)
    {
        CreateEmitter();
    }
    // End:0x4D
    if(Base != none)
    {
        SetActorNumFires(Base);
        AddToTouchedList(Base);
    }
    // End:0x6B
    if(scaleVal != 1.0000000)
    {
        ScaleMe(scaleVal);
    }
    SetCollision(true);
    bEnabled = true;
    bLastEnabled = true;
    StartBurnTime = WorldInfo.TimeSeconds;
    OrigStartBurnTime = WorldInfo.TimeSeconds;
    Class'SPFireManager'.static.GlobalAddFireObject(self);
    //return;    
}

function DisableMe()
{
    local editinline ParticleSystemComponent psComp;

    // End:0xF0
    if(FireEmitter != none)
    {
        FireEmitter.bDestroyOnSystemFinish = true;
        psComp = FireEmitter.ParticleSystemComponent;
        psComp.DeactivateSystem();
        // End:0xE9
        if(AudioComp_FireLoop != none)
        {
            AudioComp_FireLoop.FadeOut(1.4900000, 0.0000000);
            // End:0xDB
            if(FireEndCue != none)
            {
                AudioComp_FireLoopEnd = WorldInfo.CreateAudioComponent(FireEndCue, false, false);
                AudioComp_FireLoopEnd.Location = Location;
                AudioComp_FireLoopEnd.bUseOwnerLocation = false;
                AudioComp_FireLoopEnd.bAutoDestroy = true;
                AudioComp_FireLoopEnd.Play();
            }
            AudioComp_FireLoop = none;
            AudioComp_FireLoopEnd = none;
        }
        FireEmitter = none;
    }
    RemoveFromTouchedList(self);
    SetCollision(false);
    bEnabled = false;
    bLastEnabled = false;
    Class'SPFireManager'.static.GlobalRemoveFireObject(self);
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local FireParamsInfo FireParams;
    local editinline SPActorDestructComponent destruct;

    // End:0x31
    if(Other.IsA('SPBloodTickPawn'))
    {
        SPBloodTickPawnPersistent(Other).TriggerDestructionFromFlameSpread();
    }
    // End:0x5C
    if(GetFlammableParams(Other, FireParams, destruct))
    {
        AddToTouchedList(Other);
    }
    //return;    
}

event UnTouch(Actor Other)
{
    RemoveFromTouchedList(Other);
    //return;    
}

function SetCollisionCylOverride(float overrideRadius, float overrideHeight)
{
    local float NewHeight, NewRadius;
    local Vector NewTranslation;
    local editinline CylinderComponent cylComp;

    cylComp = CylinderComponent(CollisionComponent);
    // End:0x106
    if(((overrideRadius != 0.0000000) || overrideHeight != 0.0000000) && cylComp != none)
    {
        // End:0x5A
        if(overrideRadius != 0.0000000)
        {
            NewRadius = overrideRadius;            
        }
        else
        {
            NewRadius = cylComp.CollisionRadius;
        }
        // End:0x93
        if(overrideHeight != 0.0000000)
        {
            NewHeight = overrideHeight * 0.5000000;            
        }
        else
        {
            NewHeight = cylComp.CollisionHeight;
        }
        cylComp.SetCylinderSize(NewHeight, NewRadius);
        NewTranslation = cylComp.Translation;
        NewTranslation.Z = NewHeight;
        cylComp.SetTranslation(NewTranslation);
    }
    //return;    
}

function ScaleMe(float FireScale)
{
    local editinline CylinderComponent cylComp;
    local float NewHeight, NewRadius, colScale;

    cylComp = CylinderComponent(CollisionComponent);
    // End:0x79
    if(cylComp != none)
    {
        colScale = FireScale / scaleVal;
        NewHeight = cylComp.CollisionHeight * colScale;
        NewRadius = cylComp.CollisionRadius * colScale;
        SetCollisionCylOverride(NewRadius, NewHeight);
    }
    // End:0xBE
    if((FireEmitter != none) && FireEmitter.ParticleSystemComponent != none)
    {
        FireEmitter.ParticleSystemComponent.SetScale(FireScale);
    }
    scaleVal = FireScale;
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0x86
            if(Action.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
            }
        }
    }
    //return;    
}

auto state InitActive
{
    function Tick(float DeltaTime)
    {
        // End:0x2E
        if(bEnabled && !bLastEnabled)
        {
            EnableMe();
            GotoState('Active');
        }
        //return;        
    }
Begin:

    bLastEnabled = bEnabled;
    // End:0xEA
    if(bEnabled)
    {
        // End:0x2E
        if(FireEmitter == none)
        {
            EnableMe();            
        }
        else
        {
            // End:0x83
            if((Base != none) && !Base.IsPendingKill())
            {
                Class'SPFireManager'.static.GlobalAddFireObject(self);
                SetActorNumFires(Base);
                AddToTouchedList(Base);
            }
        }
        SetCollision(true);
        // End:0xDC
        if((Owner != none) && fireBurningSound != none)
        {
            LoopSoundComponent = Owner.CreateAudioComponent(fireBurningSound, false, true);
            // End:0xDC
            if(LoopSoundComponent != none)
            {
                LoopSoundComponent.Play();
            }
        }
        GotoState('Active');
    }
    stop;        
}

state Active
{
    function Tick(float DeltaTime)
    {
        local Rotator rotTemp;
        local Actor saveBase;

        // End:0x25
        if(!bEnabled)
        {
            DisableMe();
            GotoState('InitActive');
            return;
        }
        // End:0x111
        if(((bForceToPointUp && FireEmitter != none) && Abs(float(FireEmitter.Rotation.Roll)) > float(150)) && FireEmitter.Base != none)
        {
            rotTemp = FireEmitter.Rotation;
            rotTemp.Roll = 0;
            rotTemp.Pitch = 0;
            saveBase = FireEmitter.Base;
            FireEmitter.SetRotation(rotTemp);
            FireEmitter.SetBase(none);
            FireEmitter.SetBase(saveBase);
        }
        // End:0x1AB
        if((((WorldInfo.TimeSeconds - StartBurnTime) >= BurnTime) || FireEmitter == none) || (InitedParented == true) && (Base == none) || Base.IsPendingKill())
        {
            DisableMe();
            // End:0x19A
            if(LoopSoundComponent != none)
            {
                LoopSoundComponent.Stop();
                LoopSoundComponent = none;
            }
            GotoState('Inactive');            
        }
        else
        {
            DamageTouchedList();
            SpreadFire(DeltaTime);
        }
        CommonTick(DeltaTime);
        //return;        
    }
    stop;    
}

state Inactive
{
    function Tick(float DeltaTime)
    {
        local float Brightness;

        // End:0x9B
        if(OrigBrightness != 0.0000000)
        {
            Brightness = FMax(0.0000000, LightObject.LightComponent.Brightness - ((OrigBrightness * DeltaTime) / 0.5000000));
            LightObject.LightComponent.SetLightProperties(Brightness, LightObject.LightComponent.LightColor, LightObject.LightComponent.Function);
        }
        //return;        
    }

    function bool SwitchToCombineLevel(int newLevel)
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x41
    if((LightObject != none) && LightObject.LightComponent != none)
    {
        OrigBrightness = LightObject.LightComponent.Brightness;
    }
    Sleep(1.5000000);
    // End:0x61
    if(LightObject != none)
    {
        LightObject.Destroy();
    }
    Destroy();
    stop;                
}
