class MOHADroppedPickup extends DroppedPickup
    hidecategories(Navigation);

var bool bSettled;
var bool bDroppedByPlayer;
var export editinline DynamicLightEnvironmentComponent LightEnvComponent;
var repnotify Vector FinalLocation;
var repnotify Rotator FinalRotation;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        FinalLocation, FinalRotation;
}

simulated event ReplicatedEvent(name VarName)
{
    local bool bSavedCollision;

    bSavedCollision = bCollideWorld;
    // End:0x4B
    if(VarName == 'FinalLocation')
    {
        bCollideWorld = false;
        SetLocation(FinalLocation);
        bCollideWorld = bSavedCollision;
        SetPhysics(0);
        SetCollision(true, false, false);        
    }
    else
    {
        // End:0x89
        if(VarName == 'FinalRotation')
        {
            bCollideWorld = false;
            SetRotation(FinalRotation);
            bCollideWorld = bSavedCollision;
            SetPhysics(0);
            SetCollision(true, false, false);            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0x27
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        UniversalLODMethod = 0;
    }
    //return;    
}

simulated event SetPickupMesh(PrimitiveComponent PickupMesh)
{
    local editinline StaticMeshComponent PickupStaticMeshComponent, CollisionStaticMeshComponent;
    local editinline ActorComponent Comp;

    // End:0x71
    if(!ConvertToRigidBody())
    {
        CollisionComponent = PrimitiveComponent(PickupMesh.Clone(self));
        AttachComponent(CollisionComponent);
        SetPhysics(2);
        SetTimer(0.1000000, true, 'CheckSettled_MPFalling');
        SetCollision(false, false, true);
        CollisionComponent.SetLightEnvironment(self.LightEnvComponent);        
    }
    else
    {
        // End:0x170
        if(SkeletalMeshComponent(PickupMesh) != none)
        {
            Comp = ActorComponent(PickupMesh.Clone(self));
            AttachComponent(Comp);
            CollisionComponent = PrimitiveComponent(Comp);
            SetTimer(1.0000000, true, 'CheckForRigidBodySleepState');
            CollisionComponent.SetBlockRigidBody(true);
            CollisionComponent.SetActorCollision(true, false);
            SkeletalMeshComponent(CollisionComponent).PhysicsWeight = 1.0000000;
            SkeletalMeshComponent(CollisionComponent).SetHasPhysicsAssetInstance(true);
            SetPhysics(10);
            CollisionComponent.SetNotifyRigidBodyCollision(true);
            CollisionComponent.ScriptRigidBodyCollisionThreshold = 100.0000000;
            CollisionComponent.WakeRigidBody();
            CollisionComponent.SetLightEnvironment(self.LightEnvComponent);            
        }
        else
        {
            // End:0x296
            if(PickupMesh != none)
            {
                CollisionComponent = PrimitiveComponent(PickupMesh.Clone(self));
                AttachComponent(CollisionComponent);
                PickupStaticMeshComponent = StaticMeshComponent(PickupMesh);
                // End:0x269
                if(PickupStaticMeshComponent != none)
                {
                    CollisionStaticMeshComponent = StaticMeshComponent(CollisionComponent);
                    CollisionStaticMeshComponent.SetStaticMesh(none);
                    CollisionStaticMeshComponent.SetStaticMesh(PickupStaticMeshComponent.StaticMesh);
                    CollisionStaticMeshComponent.SetBlockRigidBody(true);
                    SetPhysics(10);
                    CollisionStaticMeshComponent.SetRBLinearVelocity(Velocity, false);
                    CollisionStaticMeshComponent.SetMaxRBAngularVelocity(5.0000000);
                    CollisionStaticMeshComponent.SetRBAngularVelocity(Vector(RotRand()) * float(5), true);
                    CollisionStaticMeshComponent.SetRBPosition(Location);
                }
                SetTimer(0.1000000, true, 'CheckSettled');
                CollisionComponent.SetLightEnvironment(self.LightEnvComponent);
            }
        }
    }
    //return;    
}

simulated function bool ConvertToRigidBody()
{
    return int(WorldInfo.NetMode) == int(NM_Standalone);
    //return ReturnValue;    
}

function SetAngularVelocity(Vector vVelocity)
{
    local editinline StaticMeshComponent CollisionStaticMeshComponent;

    CollisionStaticMeshComponent = StaticMeshComponent(CollisionComponent);
    // End:0x30
    if(CollisionStaticMeshComponent != none)
    {
        CollisionStaticMeshComponent.SetRBAngularVelocity(vVelocity, false);
    }
    //return;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    super(Actor).RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
    //return;    
}

function CheckSettled_MPFalling()
{
    // End:0x2A
    if(int(Physics) == int(0))
    {
        Settled_MPFalling();
        ClearTimer('CheckSettled_MPFalling');
    }
    //return;    
}

function CheckSettled()
{
    // End:0x42
    if(VSize(Velocity) < 0.0100000)
    {
        // End:0x37
        if(bSettled)
        {
            Settled();
            ClearTimer('CheckSettled');            
        }
        else
        {
            bSettled = true;
        }        
    }
    else
    {
        bSettled = false;
    }
    //return;    
}

simulated function CheckForRigidBodySleepState()
{
    local editinline SkeletalMeshComponent SkelComp;

    // End:0xBC
    if(CollisionComponent.RigidBodyIsAwake() == false)
    {
        CollisionComponent.SetNotifyRigidBodyCollision(false);
        ClearTimer('CheckForRigidBodySleepState');
        CollisionComponent.SetBlockRigidBody(false);
        CollisionComponent.SetActorCollision(false, false);
        SkelComp = SkeletalMeshComponent(CollisionComponent);
        // End:0xB2
        if((SkelComp != none) && SkelComp.PhysicsAssetInstance != none)
        {
            SkelComp.PhysicsAssetInstance.SetAllBodiesFixed(true);
            SkelComp.bUpdateKinematicBonesFromAnimation = false;
        }
        Settled();
    }
    //return;    
}

function Settled_MPFalling()
{
    Settled();
    FinalLocation = Location;
    FinalRotation = Rotation;
    bNetDirty = true;
    SetCollision(true, false, false);
    //return;    
}

function Settled()
{
    SetPhysics(0);
    //return;    
}

simulated function DeleteLeastRelevantPickup(out array<DroppedPickup> DroppedPickups, DroppedPickup SpawnedPickup)
{
    local MOHAPlayerController PC;
    local int I, iBestIndex;
    local float fDist, fBestDist;

    // End:0x63
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        I = 0;
        J0x20:

        // End:0x60 [Loop If]
        if(I < DroppedPickups.Length)
        {
            // End:0x56
            if(DroppedPickups[I] != none)
            {
                DroppedPickups[I].Destroy();
                // [Explicit Break]
                goto J0x60;
            }
            I++;
            // [Loop Continue]
            goto J0x20;
        }
        J0x60:
        
    }
    else
    {
        fBestDist = -1.0000000;
        iBestIndex = -1;
        PC = Class'MOHAUtilities'.static.GetLocalPlayerController(self);
        I = 0;
        J0x9A:

        // End:0x146 [Loop If]
        if(I < DroppedPickups.Length)
        {
            // End:0xCA
            if(MOHADroppedPickup(DroppedPickups[I]).bDroppedByPlayer)
            {
                // [Explicit Continue]
                goto J0x13C;
            }
            // End:0xE2
            if(DroppedPickups[I] == SpawnedPickup)
            {
                // [Explicit Continue]
                goto J0x13C;
            }
            fDist = VSize(DroppedPickups[I].Location - PC.Pawn.Location);
            // End:0x13C
            if(fDist > fBestDist)
            {
                fBestDist = fDist;
                iBestIndex = I;
            }
            J0x13C:

            I++;
            // [Loop Continue]
            goto J0x9A;
        }
        // End:0x163
        if(iBestIndex >= 0)
        {
            DroppedPickups[iBestIndex].Destroy();
        }
    }
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        // End:0x65
        if((((Other == none) || !Other.bCanPickupInventory) || (Other.DrivenVehicle == none) && Other.Controller == none) || Other.Health <= 0)
        {
            return false;
        }
        // End:0xC7
        if((((int(Physics) == int(2)) && Other == Instigator) && Velocity.Z > float(0)) && (Velocity Dot (Location - Other.Location)) > float(0))
        {
            return false;
        }
        // End:0xFC
        if(WorldInfo.Game.PickupQuery(Other, Inventory.Class, self))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state FadeOut
{
    simulated function BeginState(name PreviousStateName)
    {
        LifeSpan = 1.0000000;
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__MOHADroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHADroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHADroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
    Physics=2
    bGameRelevant=true
    bProjTarget=true
    LifeSpan=0.0000000
    CollisionComponent=none
}