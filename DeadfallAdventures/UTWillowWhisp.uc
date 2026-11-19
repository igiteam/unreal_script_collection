class UTWillowWhisp extends UTReplicatedEmitter
    hidecategories(Navigation);

const MAX_WAYPOINTS = 15;

var Vector WayPoints[15];
var repnotify int NumPoints;
var int Position;

replication
{
    // Pos:0x000
    if(bNetInitial
        NumPoints, WayPoints;
}

simulated function PostBeginPlay()
{
    local int I, Start;
    local PlayerController P;
    local Actor HitActor;
    local Vector HitLocation, HitNormal;

    super.PostBeginPlay();
    // End:0x351
    if(int(Role) == int(ROLE_Authority))
    {
        P = PlayerController(Owner);
        // End:0x75
        if((P == none) || P.Pawn == none)
        {
            Destroy();            
        }
        else
        {
            SetLocation(P.Pawn.Location);
            WayPoints[0] = (Location + (P.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000))) + (200.0000000 * Vector(P.Rotation));
            HitActor = Trace(HitLocation, HitNormal, WayPoints[0], Location, false);
            // End:0x189
            if(HitActor != none)
            {
                WayPoints[0] = HitLocation;
            }
            NumPoints++;
            // End:0x229
            if(((P.RouteCache[0] != none) && P.RouteCache.Length > 1) && P.ActorReachable(P.RouteCache[1]))
            {
                Start = 1;
            }
            I = Start;
            J0x23C:

            // End:0x351 [Loop If]
            if(((NumPoints < 15) && I < P.RouteCache.Length) && P.RouteCache[I] != none)
            {
                WayPoints[NumPoints++] = P.RouteCache[I].Location + (P.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000));
                I++;
                // [Loop Continue]
                goto J0x23C;
            }
        }
    }
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x8F
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x58
        if(PlayerController(Owner).IsLocalPlayerController())
        {
            StartNextPath();            
        }
        else
        {
            ParticleSystemComponent.DeactivateSystem();
            LifeSpan = ServerLifeSpan;
            SetPhysics(0);
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'NumPoints')
    {
        StartNextPath();        
    }
    else
    {
        super(Emitter).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated event SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish)
{
    super(Emitter).SetTemplate(NewTemplate, bDestroyOnFinish);
    //return;    
}

simulated function StartNextPath()
{
    local Pawn OwnerPawn;
    local UTWillowWhisp OtherWhisp;

    // End:0xC6
    if(((Position == 0) && PlayerController(Owner) != none) && PlayerController(Owner).IsLocalPlayerController())
    {
        // End:0xC5
        foreach DynamicActors(Class'UTWillowWhisp', OtherWhisp)
        {
            // End:0xC4
            if((OtherWhisp != self) && OtherWhisp.Owner == Owner)
            {
                OtherWhisp.Destroy();
            }            
        }        
    }
    // End:0x110
    if((UTPlayerController(Owner) != none) && UTPlayerController(Owner).bHideObjectivePaths)
    {
        Destroy();
        return;
    }
    // End:0x184
    if(++Position >= NumPoints)
    {
        LifeSpan = 5.0000000;
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        ParticleSystemComponent.DeactivateSystem();
        SetPhysics(0);
        GotoState('None');        
    }
    else
    {
        OwnerPawn = ((PlayerController(Owner) != none) ? PlayerController(Owner).Pawn : none);
        // End:0x25B
        if((Position == 0) && OwnerPawn != none)
        {
            SetRotation(OwnerPawn.Rotation);
            SetLocation(OwnerPawn.Location + (Vector(OwnerPawn.Rotation) * 60.0000000));
        }
        SetRotation(Rotator(WayPoints[Position] - Location));
        GotoState('Pathing');
    }
    //return;    
}

state Pathing
{
    simulated function Tick(float DeltaTime)
    {
        local float MaxSpeed;
        local Pawn OwnerPawn;

        // End:0x4A
        if((UTPlayerController(Owner) != none) && UTPlayerController(Owner).bHideObjectivePaths)
        {
            Destroy();
            return;
        }
        SetRotation(Rotator(WayPoints[Position] - Location));
        OwnerPawn = ((PlayerController(Owner) != none) ? PlayerController(Owner).Pawn : none);
        // End:0x1C8
        if(OwnerPawn != none)
        {
            // End:0x181
            if((VSize(Location - OwnerPawn.Location) < OwnerPawn.GroundSpeed) && (Vector(Rotation) Dot Vector(OwnerPawn.Rotation)) > 0.0000000)
            {
                MaxSpeed = OwnerPawn.GroundSpeed + 300.0000000;                
            }
            else
            {
                MaxSpeed = VSize(OwnerPawn.Velocity) + 60.0000000;
                RotationRate = default.RotationRate;
            }            
        }
        else
        {
            MaxSpeed = 60.0000000;
        }
        Velocity = Vector(Rotation) * MaxSpeed;
        // End:0x24A
        if(VSize(WayPoints[Position] - Location) < FMax(80.0000000, (VSize(Velocity) * DeltaTime) * 3.0000000))
        {
            StartNextPath();
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetPhysics(6);
        //return;        
    }
    stop;    
}

defaultproperties
{
    Position=-1
    // Reference: ParticleSystemComponent'Default__UTWillowWhisp.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
    Physics=EPhysics.PHYS_Projectile
    bOnlyRelevantToOwner=true
    bReplicateMovement=false
    LifeSpan=24.0000000
}