class AdvSpikeFloor extends AdvFloorSwitch
    hidecategories(Navigation);

var() AdvDamageVolume DamageVolume;

auto state Idle
{
    simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Vector MoveVect;

        // End:0xA6
        if((Activators.Find(Other.Class) != ) || )
        {
            Pawn(Other) != none;            
            MoveVect.Z = ZPressOffset;
            Move(MoveVect);
            SetTimer(ActivationTime, false, 'ActivateSpikes');
            GotoState('Attack');
        }
        //return;        
    }
    stop;    
}

state Attack
{
    ignores Touch, Tick, UnTouch;

    function ActivateSpikes()
    {
        Activate(true);
        // End:0x39
        if(DamageVolume != none)
        {
            DamageVolume.EnableDamage();
        }
        SetTimer(1.2000000, false, 'Deactivate');
        //return;        
    }

    function Deactivate()
    {
        local Vector MoveVect;

        Activate(false);
        // End:0x39
        if(DamageVolume != none)
        {
            DamageVolume.DisableDamage();
        }
        MoveVect.Z = -ZPressOffset;
        Move(MoveVect);
        SetTimer(0.0000000, false, 'Deactivate');
        GotoState('Idle');
        //return;        
    }
    stop;    
}

defaultproperties
{
    bIsPressable=false
    ZPressOffset=-5.0000000
    ActivationTime=0.2000000
    Activators=none
    // Reference: StaticMeshComponent'Default__AdvSpikeFloor.Mesh'
    begin object name=Mesh
        ReplacementPrimitive=none
        Scale3D=(X=1.6000000,Y=1.6000000,Z=0.0800000)
    end object
    TriggerMesh=Mesh
    // Reference: DynamicLightEnvironmentComponent'Default__AdvSpikeFloor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__AdvSpikeFloor.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=30.0000000
        CollisionRadius=74.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
    Components[3]=Mesh
    Components[4]=Mesh
    CollisionComponent=Mesh
}