class MOHAOIRPawn extends MOHAAxisAIPawn
    config(Game)
    hidecategories(Navigation);

var class<KynapseAIController> ResumeAffordanceControllerClass;

function ResumeAffordance()
{
    local Controller LastController;

    LastController = Controller;
    Controller.UnPossess();
    LastController.Destroy();
    bIgnoreAffordance = false;
    KynapseControllerClass = ResumeAffordanceControllerClass;
    SpawnKynapseAIController();
    AddSelfToBeadList();
    SetTimer(5.0000000,, 'ValidateInPathableSpace');
    //return;    
}

function ValidateInPathableSpace()
{
    // End:0x3E
    if(KynapseAIController(Controller) != none)
    {
        KynapseAIController(Controller).bDeleteIfSpawnedOutsidePathableSpace = true;
        KynapseAIController(Controller).KillIfOutsidePathableSpace();
    }
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    // End:0x26
    if(KynapseAIController(C) != none)
    {
        KynapseAIController(C).bDeleteIfSpawnedOutsidePathableSpace = false;
    }
    super(Pawn).PossessedBy(C, bVehicleTransition);
    //return;    
}

defaultproperties
{
    ResumeAffordanceControllerClass=Class'MOHAAxisEasySMGController'
    KynapseControllerClass=Class'MOHAOIRPawnController'
    bIgnoreAffordance=true
    // Reference: OirInstance'Default__MOHAOIRPawn.ActiveOirInstance'
    begin object name=ActiveOirInstance
    end object
    ActiveOIR=ActiveOirInstance
    // Reference: FixedFireOIRImpl'Default__MOHAOIRPawn.FFoirImpl'
    begin object name=FFoirImpl
    end object
    FFImpl=FFoirImpl
    // Reference: MeleeOIRImpl'Default__MOHAOIRPawn.MeleeOIRImpl'
    begin object name=MeleeOIRImpl
    end object
    MImpl=MeleeOIRImpl
    // Reference: DeathOIRImpl'Default__MOHAOIRPawn.DeathOIRImpl'
    begin object name=DeathOIRImpl
    end object
    DeathImpl=DeathOIRImpl
    // Reference: NavigationOIRImpl'Default__MOHAOIRPawn.NavOIRImpl'
    begin object name=NavOIRImpl
    end object
    NImpl=NavOIRImpl
    // Reference: CCPerformerForAI'Default__MOHAOIRPawn.MyCCP'
    begin object name=MyCCP
    end object
    CCP=MyCCP
    // Reference: AudioComponent'Default__MOHAOIRPawn.MyFaceFXAudioComponent'
    begin object name=MyFaceFXAudioComponent
    end object
    FaceFXAudioComponent=MyFaceFXAudioComponent
    // Reference: AxonScriptEventObserverComponent'Default__MOHAOIRPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAOIRPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: MOHARagdollSkelComponent'Default__MOHAOIRPawn.AvatorPawnSkeletalMeshComponent'
    begin object name=AvatorPawnSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAOIRPawn.MyLightEnvironment'
    end object
    Mesh=AvatorPawnSkeletalMeshComponent
    // Reference: MOHACylinderComponent'Default__MOHAOIRPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder
    end object
    CylinderComponent=MOHACollisionCylinder
    // Reference: SpriteComponent'Default__MOHAOIRPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__MOHAOIRPawn.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=AxonObserver0
    Components[4]=MyFaceFXAudioComponent
    Components[5]=MyCCP
    Components[6]=MOHACollisionCylinder
    // Reference: MOHAAIPawnRenderingComponent'Default__MOHAOIRPawn.RenderComp0'
    begin object name=RenderComp0
    end object
    Components[7]=RenderComp0
    CollisionComponent=MOHACollisionCylinder
}