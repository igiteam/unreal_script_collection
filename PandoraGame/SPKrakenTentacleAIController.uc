class SPKrakenTentacleAIController extends SPAIController
    native;

/** Constants MACROS struct DECLARATIONS VARIABLE DECLARATIONSvar SPGameDifficultyTuneTentaclem_TentacleGDTuneData;var SPTuneDataTentacle m_TentacleTuneData; */
var() bool bNoAttack;
var bool m_bTentacleDormant;
var bool m_bIsIdling;
var bool m_bDoneAttacking;
var bool m_bSnapToEnemyOrientation;
var SPKrakenTentaclePawnPersistent m_KrakenTentaclePawn;
var class<DamageType> MyDamageType;
var ScreenShakeStruct m_ShakeParams;
var Actor m_LastActorHit;
var Vector m_vLastEnemyLocation;
var SPGameDifficultyTuneKraken m_KrakenGDTuneData;

simulated event SPGameDifficultyTuneKraken GetKrakenDifficultyData()
{
    // End:0x20
    if(m_KrakenGDTuneData == none)
    {
        m_KrakenGDTuneData = SPGameDifficultyTuneKraken(GetMyGDData());
    }
    return m_KrakenGDTuneData;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.KrakenGD;
    //return ReturnValue;    
}

simulated event PreBeginPlay()
{
    super(AIController).PreBeginPlay();
    GetKrakenDifficultyData();
    //return;    
}

simulated event PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    SetTimer((FRand() * m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.AttackTimer)) + float(1), true, 'EvaluateSituation');
    //return;    
}

function ResetAttackTimer()
{
    m_bTentacleDormant = true;
    m_KrakenTentaclePawn.NotifyHitReactionsEnabled();
    StartAction(0);
    SetTimer((FRand() * m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DormantTimer)) + float(1), false, 'ResetDormantActivity');
    //return;    
}

function ResetDormantActivity()
{
    m_bTentacleDormant = false;
    ClearTimer('EvaluateSituation');
    SetTimer((FRand() * m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.AttackTimer)) + float(1), true, 'EvaluateSituation');
    //return;    
}

function SetHitReaction()
{
    StartAction(3);
    GotoState('HitReaction', 'Begin', true, false);
    //return;    
}

function NotifyDying()
{
    // End:0x22
    if(!IsInState('ControllerDying'))
    {
        PushState('ControllerDying');
    }
    //return;    
}

function int GetTentacleDistance()
{
    local Vector DistanceLoc;
    local float Distance;

    // End:0xF7
    if((GetEnemy()) != none)
    {
        DistanceLoc = GetEnemy().Location;
        DistanceLoc.Z = Pawn.Location.Z;
        Distance = VSize(DistanceLoc - Pawn.Location);
        // End:0x99
        if(Distance >= float(5700))
        {
            m_KrakenTentaclePawn.m_DistanceNode = 3;            
        }
        else
        {
            // End:0xBF
            if(Distance >= float(4500))
            {
                m_KrakenTentaclePawn.m_DistanceNode = 2;                
            }
            else
            {
                // End:0xE5
                if(Distance >= float(3500))
                {
                    m_KrakenTentaclePawn.m_DistanceNode = 1;                    
                }
                else
                {
                    m_KrakenTentaclePawn.m_DistanceNode = 0;
                }
            }
        }
    }
    return int(m_KrakenTentaclePawn.m_DistanceNode);
    //return ReturnValue;    
}

function StartAction(SPKrakenTentaclePawnPersistent.eKrakenTentacleActionState actionState, optional bool Reset)
{
    m_KrakenTentaclePawn.m_actionState = actionState;
    // End:0x31
    if(Reset)
    {
        m_KrakenTentaclePawn.m_bResetAction = true;
    }
    //return;    
}

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    // End:0x21
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super.EnableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftEnableAI()
{
    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super.SoftEnableAI();
    //return;    
}

function EvaluateSituation()
{
    local int PlayerIdx;

    // End:0x15
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;
    }
    // End:0x20
    if(m_bTentacleDormant)
    {
        return;
    }
    // End:0x2D
    if(!m_bDoneAttacking)
    {
        return;
    }
    // End:0x1B1
    if(m_KrakenTentaclePawn != none)
    {
        // End:0x184
        if(!m_KrakenTentaclePawn.CheckAttack())
        {
            // End:0x157
            if(m_KrakenTentaclePawn.LockAttackState())
            {
                PlayerIdx = m_KrakenTentaclePawn.FindEnemyToAttack();
                // End:0xCE
                if(PlayerIdx > -1)
                {
                    SetEnemy(m_KrakenTentaclePawn.GetKrakenParent().m_playerList[PlayerIdx].Target);                    
                }
                else
                {
                    SetEnemy(none);
                }
                // End:0x12A
                if((GetEnemy()) != none)
                {
                    m_KrakenTentaclePawn.SetCanTakeDamage(true);
                    m_KrakenTentaclePawn.m_bTargetingOn = true;
                    GotoState('Attack', 'Begin', true, false);                    
                }
                else
                {
                    m_KrakenTentaclePawn.UnLockAttackState();
                    GotoState('Idle', 'Begin', true, false);
                }                
            }
            else
            {
                m_KrakenTentaclePawn.UnLockAttackState();
                GotoState('Idle', 'Begin', true, false);
            }            
        }
        else
        {
            m_KrakenTentaclePawn.UnLockAttackState();
            GotoState('Idle', 'Begin', true, false);
        }        
    }
    else
    {
        GotoState('Idle', 'Begin', true, false);
    }
    //return;    
}

function CreateDamageImpulse(float DamageAmount, float Radius, class<DamageType> DamageType)
{
    local SPDImpulseActor impulseActor;
    local Vector pos;

    pos = Location;
    impulseActor = Spawn(Class'SPDImpulseActor',,, pos);
    impulseActor.ImpulseComponent.ImpulseFalloff = 1;
    impulseActor.ImpulseComponent.ImpulseStrength = 30000.0000000;
    impulseActor.ImpulseComponent.ImpulseRadius = Radius;
    impulseActor.delay = 0.0000000;
    impulseActor.Damage = int(DamageAmount);
    impulseActor.DamageRadius = Radius;
    impulseActor.DamageType = DamageType;
    //return;    
}

simulated function bool HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = none, optional bool bDoFullDamage, optional float fPlayerOnlyRadius, optional float fPlayerOnlyDamage)
{
    local Actor Victim;
    local bool bCausedDamage;

    bCausedDamage = false;
    // End:0x16D
    foreach CollidingActors(Class'Engine.Actor', Victim, DamageRadius, HurtOrigin)
    {
        // End:0x16C
        if(((!Victim.bWorldGeometry && Victim != self) && Victim != IgnoredActor) && Victim.bProjTarget || NavigationPoint(Victim) == none)
        {
            // End:0xF7
            if(Victim.IsA('PlayerPawn') == true)
            {
                Victim.TakeRadiusDamage(self, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageVSPlayer), DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);                
            }
            else
            {
                Victim.TakeRadiusDamage(self, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageVSAI), DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
            }
            bCausedDamage = bCausedDamage || Victim.bProjTarget;
        }        
    }    
    return bCausedDamage;
    //return ReturnValue;    
}

simulated function KillRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, Vector GroundStart)
{
    local Actor Victim;
    local Vector HitPawnVelocity, KillDirection;
    local TraceHitInfo HitInfo;

    // End:0x181
    foreach CollidingActors(Class'Engine.Actor', Victim, DamageRadius, GroundStart)
    {
        // End:0x180
        if(((!Victim.bWorldGeometry && Victim != self) && Victim.bProjTarget || NavigationPoint(Victim) == none) && Victim.IsA('SPPawn') == true)
        {
            HitPawnVelocity = Normal(Pawn(Victim).Velocity);
            KillDirection = Normal(Pawn(Victim).Location - GroundStart);
            KillDirection += HitPawnVelocity;
            KillDirection *= 100.0000000;
            KillDirection.Z *= 3.0000000;
            SPPawn(Victim).SetThrowDeath(m_KrakenGDTuneData.KillForce, KillDirection);
            Victim.TakeDamageAndProcEffects(float(Pawn(Victim).Health + 100), self, Pawn(Victim).Location, Vector(Pawn(Victim).Rotation), DamageType, HitInfo);
        }        
    }    
    //return;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        // End:0x1B
        if(m_KrakenTentaclePawn == none)
        {
            m_KrakenTentaclePawn = SPKrakenTentaclePawnPersistent(NewPawn);
        }
        super.Possess(NewPawn, bVehicleTransition);
        SetPawnRotationRate(0, 0, 0);
        //return;        
    }
    stop;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetTimer(2.0000000, false, 'ResetDormantActivity');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('ResetDormantActivity');
        //return;        
    }
Begin:

    stop;                
}

state HitReaction
{
    function BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        m_KrakenTentaclePawn.m_bInHitReaction = false;
        m_KrakenTentaclePawn.m_bHitReactionEnabled = false;
        ResetAttackTimer();
        //return;        
    }
    J0x00:
    // End:0x1E [Loop If]
    if(m_KrakenTentaclePawn.m_bHitReactionEnabled)
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x00;
    }
    GotoState('Idle', 'Begin', true, false);
    stop;                
}

state Attack
{
    function BeginState(name PreviousStateName)
    {
        m_LastActorHit = none;
        //return;        
    }

    function OrientToEnemy()
    {
        local Vector toEnemy, pawnVectorRotation, pawnToEnemyVectorRotation, pawnNewVectorRotation;
        local float distanceToEnemy;
        local Rotator ViewRotation;
        local Pawn pEnemyPawn;

        pEnemyPawn = GetEnemy();
        // End:0x42
        if((pEnemyPawn != none) && IsActorInDefendArea(pEnemyPawn))
        {
            m_vLastEnemyLocation = pEnemyPawn.Location;
        }
        // End:0x19A
        if(!m_bSnapToEnemyOrientation)
        {
            pawnVectorRotation = Vector(Pawn.Rotation);
            pawnVectorRotation.Z = 0.0000000;
            pawnVectorRotation = Normal(pawnVectorRotation);
            pawnToEnemyVectorRotation = m_vLastEnemyLocation - Pawn.Location;
            pawnToEnemyVectorRotation.Z = 0.0000000;
            pawnToEnemyVectorRotation = Normal(pawnToEnemyVectorRotation);
            // End:0x103
            if((pawnVectorRotation Dot pawnToEnemyVectorRotation) > 0.9900000)
            {
                m_bSnapToEnemyOrientation = true;
                toEnemy = m_vLastEnemyLocation - Pawn.Location;                
            }
            else
            {
                distanceToEnemy = VSize(m_vLastEnemyLocation - Pawn.Location);
                pawnVectorRotation *= distanceToEnemy;
                pawnVectorRotation = Pawn.Location + pawnVectorRotation;
                pawnNewVectorRotation = Normal(m_vLastEnemyLocation - pawnVectorRotation);
                pawnNewVectorRotation *= 60.0000000;
                pawnNewVectorRotation = pawnVectorRotation + pawnNewVectorRotation;
                toEnemy = pawnNewVectorRotation - Pawn.Location;
            }            
        }
        else
        {
            toEnemy = m_vLastEnemyLocation - Pawn.Location;
        }
        toEnemy.Z = 0.0000000;
        toEnemy = Normal(toEnemy);
        ViewRotation = Rotator(toEnemy);
        Pawn.SetRotation(ViewRotation);
        //return;        
    }

    function CheckHit()
    {
        local Actor HitActor;
        local SPPawn SPPawn;
        local Vector vGroundStart;
        local Rotator rGroundStart;
        local Vector vGroundEnd;
        local Rotator rGroundEnd;
        local Vector HitLocation, HitNormal, HitPawnVelocity, KillDirection, DamageRadius1, DamageRadius2,
	        DamageRadius3, DamageRadius4, DamageRadius5, DamageRadius6, DamageRadius7,
	        DamageRadius8;

        local float ShakeDampening;
        local TraceHitInfo HitInfo;
        local PlayerController PC;
        local PandoraPlayerController PPC;
        local PlayerPawn pPawn;

        // End:0x35
        if(Pawn.Mesh.GetSocketWorldLocationAndRotation('GroundCheckStart', vGroundStart, rGroundStart) == false)
        {
            return;
        }
        // End:0x6A
        if(Pawn.Mesh.GetSocketWorldLocationAndRotation('GroundCheckEnd', vGroundEnd, rGroundEnd) == false)
        {
            return;
        }
        HitActor = Trace(HitLocation, HitNormal, vGroundStart, vGroundEnd, true, vect(30.0000000, 30.0000000, 30.0000000), HitInfo, 10, true);
        // End:0x844
        if((HitActor != none) && m_KrakenTentaclePawn.m_bCanCauseMajorDamage)
        {
            // End:0x55A
            if((HitActor.bStatic || HitActor.bWorldGeometry) || HitActor.IsA('DynamicSMActor'))
            {
                KillRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.KillDamageRadius), MyDamageType, HitLocation);
                HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius), MyDamageType, 100.0000000, HitLocation);
                // End:0x557
                if((((((((Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius1', DamageRadius1, rGroundEnd) == true) && Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius2', DamageRadius2, rGroundEnd) == true) && Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius3', DamageRadius3, rGroundEnd) == true) && Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius4', DamageRadius4, rGroundEnd) == true) && Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius5', DamageRadius5, rGroundEnd) == true) && Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius6', DamageRadius6, rGroundEnd) == true) && Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius7', DamageRadius7, rGroundEnd) == true) && Pawn.Mesh.GetSocketWorldLocationAndRotation('DamageRadius8', DamageRadius8, rGroundEnd) == true)
                {
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius1), MyDamageType, 100.0000000, DamageRadius1);
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius2), MyDamageType, 100.0000000, DamageRadius2);
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius3), MyDamageType, 100.0000000, DamageRadius3);
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius4), MyDamageType, 100.0000000, DamageRadius4);
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius5), MyDamageType, 100.0000000, DamageRadius5);
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius6), MyDamageType, 100.0000000, DamageRadius6);
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius7), MyDamageType, 100.0000000, DamageRadius7);
                    HurtRadius(0.0000000, m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.DamageRadius8), MyDamageType, 100.0000000, DamageRadius8);
                }                
            }
            else
            {
                SPPawn = SPPawn(HitActor);
                // End:0x61F
                if(SPPawn != none)
                {
                    HitPawnVelocity = Normal(SPPawn.Velocity);
                    KillDirection = Normal(vGroundEnd - vGroundStart);
                    KillDirection += HitPawnVelocity;
                    KillDirection *= 100.0000000;
                    SPPawn.SetThrowDeath(m_KrakenGDTuneData.KillForce, KillDirection);
                    HitActor.TakeDamageAndProcEffects(float(SPPawn.Health + 100), self, HitLocation, KillDirection, MyDamageType, HitInfo);
                }
            }
            // End:0x839
            if(m_KrakenTentaclePawn.m_bCanDoShake)
            {
                // End:0x838
                foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
                {
                    pPawn = PlayerPawn(PC.Pawn);
                    PPC = PandoraPlayerController(PC);
                    // End:0x837
                    if(pPawn != none)
                    {
                        ShakeDampening = VSize(pPawn.Location - HitLocation);
                        // End:0x6E4
                        if((ShakeDampening > m_KrakenGDTuneData.ShakeDampeningValueFar) && ShakeDampening < m_KrakenGDTuneData.ShakeDampeningValueMax)
                        {
                            ShakeDampening = m_KrakenGDTuneData.ShakeDampeningFar;                            
                        }
                        else
                        {
                            // End:0x737
                            if((ShakeDampening < (m_KrakenGDTuneData.ShakeDampeningValueFar - 1.0000000)) && ShakeDampening > m_KrakenGDTuneData.ShakeDampeningValueNear)
                            {
                                ShakeDampening = m_KrakenGDTuneData.ShakeDampeningMid;                                
                            }
                            else
                            {
                                // End:0x76F
                                if(ShakeDampening < (m_KrakenGDTuneData.ShakeDampeningValueNear - 1.0000000))
                                {
                                    ShakeDampening = m_KrakenGDTuneData.ShakeDampeningNear;                                    
                                }
                                else
                                {
                                    ShakeDampening = 0.1000000;
                                }
                            }
                        }
                        m_ShakeParams.RotAmplitude *= ShakeDampening;
                        // End:0x7D3
                        if(PPC != none)
                        {
                            PPC.PlayLocalizedShake(m_ShakeParams, pPawn.Location, m_KrakenGDTuneData.ShakeRadius);
                        }
                        m_KrakenTentaclePawn.m_bCanDoShake = false;
                        pPawn.ApplyDamageImpulseFromKraken(m_KrakenTentaclePawn.Location);
                        // End:0x837
                        if(ShakeDampening > 0.1000000)
                        {
                            pPawn.StartHitMaterialEffect(1.0000000 + ShakeDampening);
                        }
                    }                    
                }                
            }
            m_LastActorHit = HitActor;
        }
        //return;        
    }
Begin:

    m_KrakenTentaclePawn.NotifyHitReactionsDisabled();
    m_bIsIdling = false;
    m_bDoneAttacking = false;
    J0x24:

    // End:0x3A [Loop If]
    if(!m_bIsIdling)
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x24;
    }
    // End:0x10A
    if(((GetEnemy()) != none) && IsActorInDefendArea(GetEnemy()))
    {
        StartAction(1);
        m_KrakenTentaclePawn.m_bCanCauseMajorDamage = true;
        m_KrakenTentaclePawn.m_bCanDoShake = false;
        m_KrakenTentaclePawn.EnableNovadexCallbackOnPhysicsAsset(true);
        m_vLastEnemyLocation = GetEnemy().Location;
        m_bSnapToEnemyOrientation = false;
        J0xC5:

        // End:0x10A [Loop If]
        if(m_KrakenTentaclePawn.m_bCanTakeDamage)
        {
            // End:0xF5
            if(m_KrakenTentaclePawn.m_bTargetingOn)
            {
                OrientToEnemy();
            }
            CheckHit();
            Sleep(0.0000000);
            // [Loop Continue]
            goto J0xC5;
        }
    }
    m_bDoneAttacking = true;
    m_KrakenTentaclePawn.UnLockAttackState();
    EvaluateSituation();
    stop;                
}

state ControllerDying
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }
Begin:

    stop;                
}

state WaitingForTheInevitable
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}
