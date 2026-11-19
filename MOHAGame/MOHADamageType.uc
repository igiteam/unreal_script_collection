class MOHADamageType extends DamageType
    abstract;

var bool bKillShouldCauseLimpRagdoll;

static function AdjustDamage(MOHAPawn DamageTarget, out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local MOHAAIPawn aiP;
    local MOHAPlayerPawn PlayerTarget;

    // End:0xAB
    if(!InstigatedBy.bIsPlayer)
    {
        aiP = MOHAAIPawn(DamageTarget);
        // End:0x60
        if(aiP != none)
        {
            AdjustDamageNPCtoNPC(aiP, inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);            
        }
        else
        {
            PlayerTarget = MOHAPlayerPawn(DamageTarget);
            // End:0xA8
            if(PlayerTarget != none)
            {
                AdjustDamageNpcToPlayer(PlayerTarget, inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
            }
        }        
    }
    else
    {
        // End:0x105
        if(InstigatedBy.bIsPlayer)
        {
            aiP = MOHAAIPawn(DamageTarget);
            // End:0x105
            if(aiP != none)
            {
                AdjustDamagePlayertoNPC(aiP, inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
            }
        }
    }
    Momentum = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

static function AdjustDamageNPCtoNPC(MOHAAIPawn DamageTarget, out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local KynapseAIController kaic;

    // End:0x165
    if(DamageTarget != none)
    {
        // End:0x52
        if(MOHAAIPawn(InstigatedBy.Pawn) != none)
        {
            inDamage = int(float(inDamage) * MOHAAIPawn(InstigatedBy.Pawn).NPCtoNPCDamageMult);
        }
        // End:0x6B
        if(DamageTarget.bNPCImmune)
        {
            inDamage = 0;
        }
        // End:0x9B
        if(DamageTarget.Controller != none)
        {
            kaic = KynapseAIController(DamageTarget.Controller);            
        }
        else
        {
            // End:0xFF
            if((Pawn(DamageTarget.Owner) != none) && Pawn(DamageTarget.Owner).Controller != none)
            {
                kaic = KynapseAIController(Pawn(DamageTarget.Owner).Controller);
            }
        }
        // End:0x165
        if(kaic != none)
        {
            // End:0x126
            if(CheckStalemated(kaic))
            {
                inDamage = 0;                
            }
            else
            {
                // End:0x165
                if((KynapseAIController(InstigatedBy) != none) && kaic.TeamIndex == KynapseAIController(InstigatedBy).TeamIndex)
                {
                    inDamage = 0;
                }
            }
        }
    }
    //return;    
}

static function bool CheckStalemated(KynapseAIController kaic)
{
    return kaic.bStalemated;
    //return ReturnValue;    
}

static function AdjustDamagePlayertoNPC(MOHAAIPawn DamageTarget, out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local MOHAPlayerController PlayerController;
    local KynapseAIController kaic;
    local MOHAPawn.EHitLocation HitBone;

    // End:0x31
    if(DamageTarget.Controller != none)
    {
        kaic = KynapseAIController(DamageTarget.Controller);        
    }
    else
    {
        // End:0x95
        if((Pawn(DamageTarget.Owner) != none) && Pawn(DamageTarget.Owner).Controller != none)
        {
            kaic = KynapseAIController(Pawn(DamageTarget.Owner).Controller);
        }
    }
    PlayerController = MOHAPlayerController(InstigatedBy);
    // End:0x108
    if(((PlayerController != none) && PlayerController.IsCheatActive(5)) && ClassIsChildOf(DamageType, Class'MOHABulletDamageType'))
    {
        // End:0x105
        if(!DamageTarget.AdjustDamageHeadShot(inDamage, HitInfo))
        {
            inDamage = 0;
        }        
    }
    else
    {
        DamageTarget.AdjustDamageForHitBone(inDamage, HitInfo, HitBone);
    }
    // End:0x15D
    if(kaic.TeamIndex == 0)
    {
        inDamage = 0;
        PlayerController.BroadcastFriendlyFireGTFOStimulus(DamageTarget);
    }
    //return;    
}

static function AdjustDamageNpcToPlayer(MOHAPlayerPawn DamageTarget, out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local EALAWeapon CurrentWeapon;

    // End:0x64
    if((InstigatedBy != none) && InstigatedBy.Pawn != none)
    {
        CurrentWeapon = EALAWeapon(InstigatedBy.Pawn.Weapon);
        // End:0x64
        if(CurrentWeapon != none)
        {
            inDamage *= CurrentWeapon.NpcToPlayerDamageScale;
        }
    }
    //return;    
}

static function OnKilledPawn(Pawn Target, Controller Killer, Vector HitLocation)
{
    //return;    
}

static function bool TraceHitWall(MOHAPawn Victim, Vector startPos, Vector endDelta)
{
    local Vector HitLocation, HitNormal;

    // End:0x3F
    if(Victim.Trace(HitLocation, HitNormal, startPos + endDelta, startPos, false, vect(12.0000000, 12.0000000, 12.0000000)) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool IsOnPathNetworkEdge(MOHAPawn Victim, Vector Momentum)
{
    local MOHAAIController localController;
    local Vector ThrowTest, ThrowTestStart;
    local float ThrowTestMag2D;

    ThrowTest = Momentum;
    ThrowTest.Z = 0.0000000;
    ThrowTestMag2D = VSize2D(ThrowTest);
    // End:0x13E
    if(ThrowTestMag2D > float(0))
    {
        ThrowTest *= (Victim.RagdollThrowCheckDistance / ThrowTestMag2D);
        ThrowTestStart = Victim.Location + (ThrowTest * (20.0000000 / Victim.RagdollThrowCheckDistance));
        localController = MOHAAIController(((Victim.Controller == none) ? Pawn(Victim.Owner).Controller : Victim.Controller));
        // End:0x13E
        if((none != localController) && !localController.PathableCanGo(ThrowTestStart, ThrowTestStart + ThrowTest))
        {
            ThrowTestStart += vect(0.0000000, 0.0000000, 90.0000000);
            // End:0x13E
            if(!TraceHitWall(Victim, ThrowTestStart, ThrowTest))
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool HasCustomKillingBlowMomentumMultiplier(MOHAPawn Victim, Controller Instigator, Vector Momentum, out float MomentumMultiplier)
{
    // End:0x2D
    if(IsOnPathNetworkEdge(Victim, Momentum))
    {
        MomentumMultiplier = Victim.RagdollThrowWeaponImpulseMultiplier;
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    GibModifier=0.0000000
    // Reference: ForceFeedbackWaveform'Default__MOHADamageType.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0 class=Class'Engine.ForceFeedbackWaveform'
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__MOHADamageType.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1 class=Class'Engine.ForceFeedbackWaveform'
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}