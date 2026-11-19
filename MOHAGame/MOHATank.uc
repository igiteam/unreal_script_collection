class MOHATank extends MOHAVehicle
    config(Game)
    hidecategories(Navigation);

var() float TreadScrollScale;
var() config float fMaxTankTorque;
var() name LeftFrontTreadDustSocket;
var() name LeftRearTreadDustSocket;
var() name RightFrontTreadDustSocket;
var() name RightRearTreadDustSocket;
var() float fMinSpeedForDust;
var export editinline ParticleSystemComponent LeftFrontTreadDustEmitter;
var export editinline ParticleSystemComponent RightFrontTreadDustEmitter;
var export editinline ParticleSystemComponent LeftRearTreadDustEmitter;
var export editinline ParticleSystemComponent RightRearTreadDustEmitter;
var bool bLeftTreadAttachedToFront;
var bool bRightTreadAttachedToFront;
var protected MaterialInstanceConstant LeftTreadMaterialInstance;
var protected MaterialInstanceConstant RightTreadMaterialInstance;
var name TreadSpeedParameterName;
var float LeftTreadScroll;
var float RightTreadScroll;
var export editinline KynapseEntityComponent KynEntityComponent;

function SetupTreadMaterialInstance()
{
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    KynEntityComponent.InitForKynapse();
    SetupTreadMaterialInstance();
    // End:0x43
    if(LeftFrontTreadDustEmitter != none)
    {
        Mesh.AttachComponentToSocket(LeftFrontTreadDustEmitter, LeftFrontTreadDustSocket);
    }
    // End:0x67
    if(RightFrontTreadDustEmitter != none)
    {
        Mesh.AttachComponentToSocket(RightFrontTreadDustEmitter, RightFrontTreadDustSocket);
    }
    // End:0x8B
    if(LeftRearTreadDustEmitter != none)
    {
        Mesh.AttachComponentToSocket(LeftRearTreadDustEmitter, LeftRearTreadDustSocket);
    }
    // End:0xAF
    if(RightRearTreadDustEmitter != none)
    {
        Mesh.AttachComponentToSocket(RightRearTreadDustEmitter, RightRearTreadDustSocket);
    }
    //return;    
}

simulated function ApplyConfigVariables()
{
    super.ApplyConfigVariables();
    MOHASVehicleSimTank(SimObj).MaxEngineTorque = fMaxTankTorque;
    //return;    
}

event bool ContinueOnFoot()
{
    return false;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    KynEntityComponent.DestroyKynapseEntity();
    super.Destroyed();
    //return;    
}

event StreamOutCleanup()
{
    KynEntityComponent.DestroyKynapseEntity();
    super.StreamOutCleanup();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    UpdateTreadScroll(DeltaTime);
    UpdateTreadDust();
    //return;    
}

simulated function UpdateTreadScroll(float DeltaTime)
{
    // End:0x12
    if(MOHASVehicleSimTank(SimObj) == none)
    {
        return;
    }
    LeftTreadScroll += ((MOHASVehicleSimTank(SimObj).LeftTrackVel * TreadScrollScale) * DeltaTime);
    // End:0x54
    if(LeftTreadScroll > 1.0000000)
    {
        LeftTreadScroll = 0.0000000;
    }
    RightTreadScroll += ((MOHASVehicleSimTank(SimObj).RightTrackVel * TreadScrollScale) * DeltaTime);
    // End:0x96
    if(RightTreadScroll > 1.0000000)
    {
        RightTreadScroll = 0.0000000;
    }
    // End:0xBE
    if(LeftTreadMaterialInstance != none)
    {
        LeftTreadMaterialInstance.SetScalarParameterValue('TreadScroll', LeftTreadScroll);
    }
    // End:0xE6
    if(RightTreadMaterialInstance != none)
    {
        RightTreadMaterialInstance.SetScalarParameterValue('TreadScroll', RightTreadScroll);
    }
    //return;    
}

simulated function UpdateTreadDust()
{
    // End:0x12
    if(MOHASVehicleSimTank(SimObj) == none)
    {
        return;
    }
    // End:0xA6
    if(LeftFrontTreadDustEmitter != none)
    {
        // End:0x64
        if((MOHASVehicleSimTank(SimObj).LeftTrackVel <= -fMinSpeedForDust) && !LeftFrontTreadDustEmitter.bIsActive)
        {
            LeftFrontTreadDustEmitter.ActivateSystem();            
        }
        else
        {
            // End:0xA6
            if((MOHASVehicleSimTank(SimObj).LeftTrackVel > -fMinSpeedForDust) && LeftFrontTreadDustEmitter.bIsActive)
            {
                LeftFrontTreadDustEmitter.DeactivateSystem();
            }
        }
    }
    // End:0x136
    if(LeftRearTreadDustEmitter != none)
    {
        // End:0xF6
        if((MOHASVehicleSimTank(SimObj).LeftTrackVel >= fMinSpeedForDust) && !LeftRearTreadDustEmitter.bIsActive)
        {
            LeftRearTreadDustEmitter.ActivateSystem();            
        }
        else
        {
            // End:0x136
            if((MOHASVehicleSimTank(SimObj).LeftTrackVel < fMinSpeedForDust) && LeftRearTreadDustEmitter.bIsActive)
            {
                LeftRearTreadDustEmitter.DeactivateSystem();
            }
        }
    }
    // End:0x1CA
    if(RightFrontTreadDustEmitter != none)
    {
        // End:0x188
        if((MOHASVehicleSimTank(SimObj).RightTrackVel <= -fMinSpeedForDust) && !RightFrontTreadDustEmitter.bIsActive)
        {
            RightFrontTreadDustEmitter.ActivateSystem();            
        }
        else
        {
            // End:0x1CA
            if((MOHASVehicleSimTank(SimObj).RightTrackVel > -fMinSpeedForDust) && RightFrontTreadDustEmitter.bIsActive)
            {
                RightFrontTreadDustEmitter.DeactivateSystem();
            }
        }
    }
    // End:0x25A
    if(RightRearTreadDustEmitter != none)
    {
        // End:0x21A
        if((MOHASVehicleSimTank(SimObj).RightTrackVel >= fMinSpeedForDust) && !RightRearTreadDustEmitter.bIsActive)
        {
            RightRearTreadDustEmitter.ActivateSystem();            
        }
        else
        {
            // End:0x25A
            if((MOHASVehicleSimTank(SimObj).RightTrackVel < fMinSpeedForDust) && RightRearTreadDustEmitter.bIsActive)
            {
                RightRearTreadDustEmitter.DeactivateSystem();
            }
        }
    }
    //return;    
}

simulated function GetSVehicleDebug(out array<string> DebugInfo)
{
    local int I;
    local MOHAVehicleController VehicleController;

    VehicleController = MOHAVehicleController(Controller);
    DebugInfo[DebugInfo.Length] = "----Vehicle----: ";
    DebugInfo[DebugInfo.Length] = ((("Speed: " $ string(VSize(Velocity))) $ " UUPS -- ") $ string(VSize(Velocity) * 0.0426125)) $ " MPH";
    DebugInfo[DebugInfo.Length] = "LeftTrackTorque: " $ string(SVehicleSimTank(SimObj).LeftTrackTorque);
    DebugInfo[DebugInfo.Length] = "RightTrackTorque: " $ string(SVehicleSimTank(SimObj).RightTrackTorque);
    DebugInfo[DebugInfo.Length] = "LeftTrackVel: " $ string(SVehicleSimTank(SimObj).LeftTrackVel);
    DebugInfo[DebugInfo.Length] = "RightTrackVel: " $ string(SVehicleSimTank(SimObj).RightTrackVel);
    DebugInfo[DebugInfo.Length] = "Throttle: " $ string(OutputGas);
    DebugInfo[DebugInfo.Length] = "Steering: " $ string(OutputSteering);
    DebugInfo[DebugInfo.Length] = "Brake: " $ string(OutputBrake);
    DebugInfo[DebugInfo.Length] = "Stuck Count: " $ string(StuckCount);
    // End:0x39C
    if(VehicleController != none)
    {
        DebugInfo[DebugInfo.Length] = "----Vehicle Targeting----: ";
        I = 0;
        J0x214:

        // End:0x39C [Loop If]
        if(I < VehicleController.TargetInfo.Length)
        {
            DebugInfo[DebugInfo.Length] = (("Weapon " $ string(I)) $ " Target: ") $ string(VehicleController.TargetInfo[I].WeapTarget);
            DebugInfo[DebugInfo.Length] = (("Weapon " $ string(I)) $ " Targeting Mode: ") $ string(VehicleController.TargetInfo[I].TargetingMode);
            DebugInfo[DebugInfo.Length] = (("Weapon " $ string(I)) $ " Stop When Engaging Visible Player: ") $ string(VehicleController.TargetInfo[I].StopWhenEngagingVisiblePlayer);
            DebugInfo[DebugInfo.Length] = (("Weapon " $ string(I)) $ " Engaging Enemy: ") $ string(VehicleController.TargetInfo[I].bEngagingEnemy);
            I++;
            // [Loop Continue]
            goto J0x214;
        }
    }
    //return;    
}

defaultproperties
{
    TreadScrollScale=0.0020000
    fMaxTankTorque=1600.0000000
    // Reference: KynapseEntityComponent'Default__MOHATank.KynapseEnt0'
    begin object name=KynapseEnt0 class=Class'EAKynapse.KynapseEntityComponent'
        sKynClassName="MovingBlockPathObject"
        sKynDebugName="TigerTank"
    end object
    KynEntityComponent=KynapseEnt0
    MyDamageTypes[0]=Class'MOHAPanzerschreckDamageType'
    MyDamageTypes[1]=Class'MOHAM18RecoillessRifleDamageType'
    MyDamageTypes[2]=Class'MOHAGammonGrenadeDamageType'
    MyDamageTypes[3]=Class'MOHACompBDamageType'
    DestructionSound=SoundCue'Aud_GCm_FakeWAV.explosions.Tank_Destroy_Final_LP'
    // Reference: MOHAGraph'Default__MOHATank.ThrottleGraph0'
    begin object name=ThrottleGraph0
    end object
    throttleGraph=ThrottleGraph0
    // Reference: AudioComponent'Default__MOHATank.VehicleTurnSound'
    begin object name=VehicleTurnSound
    end object
    TurnSound=VehicleTurnSound
    // Reference: MOHASVehicleSimTank'Default__MOHATank.SimObject'
    begin object name=SimObject class=Class'MOHASVehicleSimTank'
        MaxEngineTorque=3350.0000000
        EngineDamping=2.0000000
        InsideTrackTorqueCurve=(Points=/* Array type was not detected. */)
        TurnInPlaceThrottle=0.5000000
        ChassisTorqueScale=0.2000000
        ReverseThrottle=-0.8500000
        StopThreshold=50.0000000
        WheelSuspensionStiffness=1000.0000000
        WheelSuspensionDamping=5.0000000
    end object
    SimObj=SimObject
    // Reference: RB_StayUprightSetup'Default__MOHATank.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__MOHATank.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    UprightLiftStrength=0.0000000
    UprightTorqueStrength=0.0000000
    UprightTime=1.0000000
    // Reference: AudioComponent'Default__MOHATank.VehicleEngineSound'
    begin object name=VehicleEngineSound
    end object
    EngineSound=VehicleEngineSound
    bSeparateTurretFocus=true
    bHasHandbrake=true
    // Reference: SkeletalMeshComponent'Default__MOHATank.SVehicleMesh'
    begin object name=SVehicleMesh
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__MOHATank.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=VehicleEngineSound
    Components[3]=VehicleTurnSound
    Components[4]=SimObject
    Components[5]=KynapseEnt0
    CollisionComponent=SVehicleMesh
}