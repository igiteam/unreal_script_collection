class MOHAParatrooperPawnNative extends MOHAAlliedAIPawn
    abstract
    native
    config(Game)
    hidecategories(Navigation)
    implements(SpawneeInterface);

var() MOHAParadropTarget ParaDropTarget;
var() bool bInitialSpawnIsParachuting;
var bool bSetInitialRotation;
var bool bInAirdrop;
var bool bUsingFallbackAnimTree;
var() AnimTree Ground_AnimTree;
var() name landingAnimationName;
var() name descendAnimationName;
var(AirHandling) float MaxDescendSpeed;
var(AirHandling) float MaxLateralSpeed;
var string ITP_AnimSetName;
var AffordanceNodeVolume AffordanceVolumeToJoin;
var AnimNodeSequence FallBackAnimSeq;

// Export UMOHAParatrooperPawnNative::execGetTerminalVelocity(FFrame&, void* const)
native function float GetTerminalVelocity();

// Export UMOHAParatrooperPawnNative::execLoadITPAnimSet(FFrame&, void* const)
native function LoadITPAnimSet();

// Export UMOHAParatrooperPawnNative::execUnloadITPAnimSet(FFrame&, void* const)
native function UnloadITPAnimSet();

function EquipWeapons()
{
    AddDefaultInventory();
    //return;    
}

function AddDefaultInventory()
{
    // End:0x13
    if(GetStateName() != 'Landing')
    {
        return;
    }
    super(MOHAAIPawn).AddDefaultInventory();
    //return;    
}

event JumpedOut()
{
    GotoState('Airdrop');
    //return;    
}

function OnSetParadropTarget(SeqAct_SetParadropTarget Action)
{
    local MOHAParadropTarget Target;
    local array<Object> objVars;
    local int idx;

    Action.GetObjectVars(objVars, "ParadropTarget");
    idx = 0;
    J0x2B:

    // End:0x7E [Loop If]
    if((idx < objVars.Length) && Target == none)
    {
        Target = MOHAParadropTarget(objVars[idx]);
        // End:0x74
        if(Target != none)
        {
            ParaDropTarget = Target;
        }
        idx++;
        // [Loop Continue]
        goto J0x2B;
    }
    // End:0x89
    if(Target == none)
    {
    }
    //return;    
}

function SpawnParaDropController()
{
    ControllerClass = Class'MOHAITPController';
    Controller = __NFUN_278__(ControllerClass);
    // End:0x44
    if(MOHAITPController(Controller) != none)
    {
        Controller.Possess(self, false);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super(MOHAAIPawn).PostBeginPlay();
    SpawnParaDropController();
    DesiredRotation = Rotation;
    Controller.DesiredRotation = Rotation;
    //return;    
}

function NotifySpawned(Actor SpawnPoint, Actor PopulationParent)
{
    local MOHAParatrooperSpawnPoint ParatrooperSpawnPoint;

    AffordanceVolumeToJoin = AffordanceNodeVolume(PopulationParent);
    // End:0x2F
    if(AffordanceVolumeToJoin != none)
    {
        AffordanceVolumeToJoin.IncrementPendingJoins(self);
    }
    ParatrooperSpawnPoint = MOHAParatrooperSpawnPoint(SpawnPoint);
    // End:0x86
    if(ParatrooperSpawnPoint != none)
    {
        ParaDropTarget = ParatrooperSpawnPoint.DropTarget;
        MaxDescendSpeed = ParatrooperSpawnPoint.DescendSpeed;
        MaxLateralSpeed = ParatrooperSpawnPoint.LateralSpeed;
    }
    //return;    
}

auto state Startup
{
    function BeginState(name PreviousStateName)
    {
        // End:0x1A
        if(bInitialSpawnIsParachuting == false)
        {
            DetachComponent(Mesh);            
        }
        else
        {
            GotoState('Airdrop');
        }
        Mesh.RootMotionMode = 2;
        //return;        
    }

    function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
    {
        inDamage = 0;
        Momentum = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }
    stop;    
}

state Airdrop
{
    function BeginState(name PreviousStateName)
    {
        // End:0x1F
        if(bInitialSpawnIsParachuting == false)
        {
            Mesh.StopAnim();
        }
        MOHAITPController(Controller).GotoState('Airdrop');
        SetCollision(true, true, false);
        bCollideWorld = true;
        OnSpawnParachuteAndAttach(none);
        AirdropParachuteMesh.SetCollision(false, false, true);
        // End:0x95
        if(bUsingFallbackAnimTree)
        {
            MOHASkeletalMeshComponent(Mesh).PlayAnimAtRate(descendAnimationName, 0.1500000, 0.0000000, true, true);
        }
        Mesh.LightingChannels.Characters_Weapons_Vehicles = true;
        Mesh.LightingChannels.In_The_Plane_Characters = false;
        EnableLightEnvironment(true);
        bInAirdrop = true;
        //return;        
    }

    event Landed(Vector HitNormal, Actor FloorActor)
    {
        AirdropParachuteMesh.SetBase(none);
        super(MOHAPawn).Landed(HitNormal, FloorActor);
        // End:0x60
        if((ParaDropTarget != none) && ParaDropTarget.bDestroyTrooperOnLanded == true)
        {
            AirdropParachuteMesh.Destroy();
            Controller.Destroy();
            Destroy();            
        }
        else
        {
            ParaDropTarget = none;
            AirdropParachuteMesh.HitGround();
            GotoState('Landing');
        }
        //return;        
    }

    function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
    {
        inDamage = 0;
        Momentum = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }
Begin:

    stop;                
}

state Landing
{
    function BeginState(name PreviousStateName)
    {
        // End:0x32
        if(bUsingFallbackAnimTree)
        {
            MOHASkeletalMeshComponent(Mesh).PlayAnimAtRate(landingAnimationName, 1.0000000, 0.0000000, false, false);
        }
        // End:0x50
        if(AirdropParachuteMesh != none)
        {
            AirdropParachuteMesh.PlayChuteLandingAnimation();
        }
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        GotoState('CombatTransition');
        //return;        
    }
    stop;    
}

state CombatTransition
{
    function AddDefaultInventory()
    {
        super(MOHAParatrooperPawnNative).AddDefaultInventory();
        //return;        
    }

    function SwitchToKynapseControllerAndInit()
    {
        Controller.Destroy();
        Controller.UnPossess();
        SpawnKynapseAIController();
        ControllerSpecificInit();
        AddSelfToBeadList();
        AffordanceVolumeToJoin.DecrementPendingJoins(self);
        // End:0x7A
        if(KynapseAIController(Controller) != none)
        {
            KynapseAIController(Controller).ForceAssignedAffordance = AffordanceVolumeToJoin;
        }
        //return;        
    }

    function SetOnTheGroundProperties()
    {
        Mesh.SetAnimTreeTemplate(Ground_AnimTree);
        Mesh.SetTranslation(vect(0.0000000, 0.0000000, 0.0000000));
        Mesh.bForceDiscardRootMotion = true;
        Mesh.bRootMotionModeChangeNotify = true;
        Mesh.SetActorCollision(true, true);
        Mesh.SetBlockRigidBody(true);
        Mesh.RootMotionMode = 1;
        Mesh.LightingChannels.Characters_Weapons_Vehicles = true;
        Mesh.LightingChannels.In_The_Plane_Characters = false;
        bInAirdrop = false;
        //return;        
    }
Begin:

    SetOnTheGroundProperties();
    SwitchToKynapseControllerAndInit();
    stop;                
}

defaultproperties
{
    // Reference: OirInstance'Default__MOHAParatrooperPawnNative.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    // Reference: FixedFireOIRImpl'Default__MOHAParatrooperPawnNative.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAParatrooperPawnNative.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAParatrooperPawnNative.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAParatrooperPawnNative.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__MOHAParatrooperPawnNative.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAParatrooperPawnNative.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    // Reference: AxonScriptEventObserverComponent'Default__MOHAParatrooperPawnNative.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAParatrooperPawnNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: MOHARagdollSkelComponent'Default__MOHAParatrooperPawnNative.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAParatrooperPawnNative.MyLightEnvironment'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAParatrooperPawnNative.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__MOHAParatrooperPawnNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAParatrooperPawnNative.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAParatrooperPawnNative.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    CollisionComponent=MOHACollisionCylinder
}