class EvilRailCar_Base extends InterpActor
    abstract
    native
    hidecategories(Navigation)
    classgroup(RailCars);

var array<NavigationPoint> AttachedNavList;
var array<Keypoint> AttachedKeyList;
var array<EvilPawn> AttachedPawnList;
var() bool bClampedBaseEnabled;
var() bool bAlwaysConfineToClampedBase;
var() bool bDoComplexCameraCollision;
var() bool bDisallowPawnMovement;
var() bool bForceStickToClosestNavPoint;
var() bool bForceAlignView;
var repnotify bool bInterpolating;
var() int DamageToNonClampedPawnOnCollision;
var() class<EvilDmgType_Base> DamageTypeOnCollision;
var() Vector AlignViewDir;
var() float AlignViewEpsilon;
var Rotator LastRot;
var Rotator RotDelta;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        bForceAlignView, bInterpolating;

    // Pos:0x020
    if((bNetDirty && int(Role) == int(ROLE_Authority)) && bForceAlignView
        AlignViewDir, AlignViewEpsilon;

    // Pos:0x04F
    if(bNetInitial && int(Role) == int(ROLE_Authority)
        bAlwaysConfineToClampedBase, bClampedBaseEnabled, 
        bDisallowPawnMovement;
}

simulated function PostBeginPlay()
{
    local NavigationPoint Nav;
    local Keypoint Key;
    local int Idx;

    super.PostBeginPlay();
    // End:0x70
    foreach BasedActors(Class'Engine.NavigationPoint', Nav)
    {
        Idx = AttachedNavList.Find(Nav);        
        // End:0x6F
        if(Idx < 0)
        {
            AttachedNavList[AttachedNavList.Length] = Nav;
        }        
    }    
    // End:0xD7
    foreach BasedActors(Class'Engine.Keypoint', Key)
    {
        Idx = AttachedKeyList.Find(Key);        
        // End:0xD6
        if(Idx < 0)
        {
            AttachedKeyList[AttachedKeyList.Length] = Key;
        }        
    }    
    //return;    
}

simulated function FixBasedPawn(EvilPawn GP)
{
    local NavigationPoint Nav;
    local Keypoint Key;
    local Actor Best;
    local float bestDist, DistSq;
    local Vector TryLoc;
    local int Idx;

    // End:0x11
    if(GP == none)
    {
        return;
    }
    Best = none;
    bestDist = 10000000000.0000000;
    Idx = 0;
    J0x36:

    // End:0x1BD [Loop If]
    if(Idx < AttachedNavList.Length)
    {
        Nav = AttachedNavList[Idx];
        // End:0x94
        if(Nav == none)
        {
            AttachedNavList.Remove(Idx--, 1);                        
        }
        else
        {
            DistSq = VSizeSq(GP.Location - Nav.Location);
            TryLoc = Nav.Location;
            // End:0x1AF
            if((Best == none) || (DistSq < bestDist) && bForceStickToClosestNavPoint || GP.FindSpot(GP.GetCollisionExtent(), TryLoc))
            {
                Best = Nav;
                bestDist = DistSq;
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x36;
    }
    Idx = 0;
    J0x1C8:

    // End:0x3E9 [Loop If]
    if(Idx < AttachedKeyList.Length)
    {
        Key = AttachedKeyList[Idx];
        // End:0x226
        if(Key == none)
        {
            AttachedKeyList.Remove(Idx--, 1);                        
        }
        else
        {
            DistSq = VSizeSq(GP.Location - Key.Location);
            TryLoc = Key.Location;
            // End:0x3DB
            if(((Best == none) || (EvilRailCarSeat(Key) != none) && EvilRailCarSeat(Key).Occupant == GP) || ((DistSq < bestDist) && (EvilRailCarSeat(Key) == none) || EvilRailCarSeat(Key).Occupant == none) && bForceStickToClosestNavPoint || GP.FindSpot(GP.GetCollisionExtent(), TryLoc))
            {
                Best = Key;
                bestDist = DistSq;
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x1C8;
    }
    // End:0x57F
    if(Best != none)
    {
        TryLoc = Best.Location;
        // End:0x476
        if(!bForceStickToClosestNavPoint)
        {
            GP.FindSpot(GP.GetCollisionExtent(), TryLoc);
        }
        GP.SetLocation(TryLoc);
        GP.SetRotation(Rotation);
        GP.SetBase(self);
        // End:0x57F
        if(EvilRailCarSeat(Best) != none)
        {
            EvilRailCarSeat(Best).Occupant = GP;
            // End:0x57F
            if(!GP.IsPlayerPawn())
            {
                GP.BlendByRailCar.SetBlendTarget(1.0000000, 0.0000000);
            }
        }
    }
    //return;    
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    super.InterpolationStarted(InterpAction, GroupInst);
    // End:0x56
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(1.0000000, true, 'ForceUpdateReplication');
        SetTimer(1.0000000, true, 'CheckBasedPawns');
    }
    bInterpolating = true;
    LastRot = Rotation;
    //return;    
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    super.InterpolationFinished(InterpAction);
    // End:0x4F
    if(int(Role) == int(ROLE_Authority))
    {
        ClearTimer('ForceUpdateReplication');
        ClearTimer('CheckBasedPawns');
    }
    bInterpolating = true;
    LastRot = Rotation;
    RotDelta = MakeRotator(0, 0, 0);
    //return;    
}

function ForceUpdateReplication()
{
    local int I;
    local SeqAct_Interp InterpAction;

    I = 0;
    J0x0B:

    // End:0xC0 [Loop If]
    if(I < LatentActions.Length)
    {
        InterpAction = SeqAct_Interp(LatentActions[I]);
        // End:0xB2
        if((InterpAction != none) && InterpAction.ReplicatedActor != none)
        {
            InterpAction.ReplicatedActor.Update();
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated event Attach(Actor Other)
{
    local EvilPawn P;
    local int Idx;

    P = EvilPawn(Other);
    // End:0x452
    if(P != none)
    {
        // End:0x44F
        if(bClampedBaseEnabled)
        {
            P.ClampedBase = self;
            // End:0x44D
            if(((bDisallowPawnMovement || !P.ConfineToClampedBase()) || P.bJustTeleported) || int(P.Physics) == int(10))
            {
                Idx = AttachedPawnList.Find(EvilPawn(Other));                
                // End:0x208
                if(Idx < 0)
                {
                    AttachedPawnList[AttachedPawnList.Length] = EvilPawn(Other);
                    Other.PushState('RidingRailCar');
                    EvilPawn(Other).SetSprint(false);
                    // End:0x208
                    if(EvilPlayerController(EvilPawn(Other).Controller) != none)
                    {
                        EvilPlayerController(EvilPawn(Other).Controller).StopCameraAnim(true);
                    }
                }
                // End:0x246
                if((AttachedPawnList.Length > 0) && !IsTimerActive('CheckBasedPawns'))
                {
                    SetTimer(1.0000000, true, 'CheckBasedPawns');
                }
                // End:0x3B9
                if((P.MyEvilAI != none) && EvilAICmd_RideRailCar(P.MyEvilAI.CommandList) == none)
                {
                    // End:0x34F
                    if(P.MyEvilAI.CommandList != none)
                    {
                        P.MyEvilAI.AbortCommand(P.MyEvilAI.CommandList);
                    }
                    P.MyEvilAI.RideCommand.static.RideRailCar(P.MyEvilAI);                    
                }
                else
                {
                    // End:0x44A
                    if((EvilPlayerController(P.Controller) != none) && P.ClampedBase != self)
                    {
                        EvilPlayerController(P.Controller).NotifyEnteredRailCar(self);
                    }
                }                
            }
            else
            {
                return;
            }
        }        
    }
    else
    {
        // End:0x4C3
        if(NavigationPoint(Other) != none)
        {
            Idx = AttachedNavList.Find(Other);            
            // End:0x4C0
            if(Idx < 0)
            {
                AttachedNavList[AttachedNavList.Length] = NavigationPoint(Other);
            }            
        }
        else
        {
            // End:0x531
            if(Keypoint(Other) != none)
            {
                Idx = AttachedKeyList.Find(Other);                
                // End:0x531
                if(Idx < 0)
                {
                    AttachedKeyList[AttachedKeyList.Length] = Keypoint(Other);
                }
            }
        }
    }
    super.Attach(Other);
    //return;    
}

simulated function bool IsStillOnClampedBase(EvilPawn GP, Vector PawnExtent)
{
    local Vector Start, End, TraceExtent, HitLocation, HitNormal;

    local Actor TraceActor, HitActor;
    local int I;

    // End:0x11
    if(GP == none)
    {
        return false;
    }
    Start = GP.Location;
    End = GP.Location - (vect(0.0000000, 0.0000000, 1.0000000) * PawnExtent.Z);
    TraceExtent = PawnExtent * vect(0.9000000, 0.9000000, 0.5000000);
    I = 0;
    TraceActor = GP;
    J0xCF:

    HitActor = TraceActor.Trace(HitLocation, HitNormal, End, Start, true, TraceExtent);
    // End:0x17C
    if((HitActor != none) && !HitActor.bWorldGeometry)
    {
        TraceActor = HitActor;
        Start = HitLocation;
    }
    // End:0x191
    if(++I > 100)
    {        
    }
    else
    {
        // End:0xCF
        if(!(((HitActor == self) || HitActor == none) || HitActor.bWorldGeometry))
            goto J0xCF;
    }
    return HitActor == self;
    //return ReturnValue;    
}

simulated function bool ShouldTryToFixPlayer(EvilPawn P)
{
    return true;
    //return ReturnValue;    
}

singular function CheckBasedPawns()
{
    local int PawnIdx;
    local EvilPawn GP;

    // End:0x22A
    if(bClampedBaseEnabled)
    {
        PawnIdx = 0;
        J0x18:

        // End:0x22A [Loop If]
        if(PawnIdx < AttachedPawnList.Length)
        {
            GP = AttachedPawnList[PawnIdx];
            // End:0xC2
            if((GP == none) || (GP.ClampedBase != none) && GP.ClampedBase != self)
            {
                AttachedPawnList.Remove(PawnIdx--, 1);                                
            }
            else
            {
                // End:0x21C
                if(!GP.IsDoingAPawnAction() && GP.Health > 0)
                {
                    // End:0x21C
                    if((ShouldTryToFixPlayer(GP)) && !IsStillOnClampedBase(GP, GP.GetCollisionExtent()))
                    {
                        FixBasedPawn(GP);
                        // End:0x21C
                        if(bDisallowPawnMovement || bForceStickToClosestNavPoint)
                        {
                            GP.SetPhysics(0);
                            GP.bCollideWorld = false;
                            GP.SetCollision(GP.bCollideActors, GP.bBlockActors, true);
                        }
                    }
                }
            }
            PawnIdx++;
            // [Loop Continue]
            goto J0x18;
        }
    }
    // End:0x24E
    if(AttachedPawnList.Length == 0)
    {
        ClearTimer('CheckBasedPawns');
    }
    //return;    
}

function UpdateSeats()
{
    local Keypoint KP;

    // End:0x142
    if(bForceStickToClosestNavPoint)
    {
        // End:0x141
        foreach AttachedKeyList(KP)
        {
            // End:0x140
            if((EvilRailCarSeat(KP) != none) && EvilRailCarSeat(KP).Occupant != none)
            {
                EvilRailCarSeat(KP).Occupant.SetLocation(KP.Location);
                // End:0x140
                if(!EvilRailCarSeat(KP).Occupant.IsPlayerPawn())
                {
                    EvilRailCarSeat(KP).Occupant.SetRotation(Rotation);
                }
            }            
        }        
    }
    //return;    
}

function OnAttachToActor(SeqAct_AttachToActor Action)
{
    local Object O;
    local array<Object> objVars;

    Action.GetObjectVars(objVars, "Attachment");
    // End:0x1A7
    foreach objVars(O)
    {
        // End:0x67
        if(Actor(O) == none)
        {
            continue;            
        }
        else
        {
            // End:0xCE
            if(O.IsA('Controller'))
            {
                O = Controller(O).Pawn;
                // End:0xCE
                if(O == none)
                {
                    continue;
                    // [Explicit Continue]
                    goto J0x1A7;
                }
            }
            // End:0x181
            if(Action.bDetach)
            {
                // End:0x130
                if(O.IsA('EvilPawn'))
                {
                    DetachPawn(EvilPawn(O));
                }
                Actor(O).SetBase(none);
                Actor(O).SetHardAttach(false);                
            }
            else
            {
                DoKismetAttachment(Actor(O), Action);
            }            
        }
    }
    J0x1A7:
    
    //return;    
}

simulated function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    // End:0xF1
    if((bDisallowPawnMovement || bForceStickToClosestNavPoint) && EvilPawn(Attachment) != none)
    {
        Attachment.SetPhysics(0);
        Attachment.bCollideWorld = false;
        Attachment.SetCollision(Attachment.bCollideActors, Attachment.bBlockActors, true);
        // End:0xF1
        if(bForceStickToClosestNavPoint)
        {
            FixBasedPawn(EvilPawn(Attachment));
        }
    }
    super(Actor).DoKismetAttachment(Attachment, Action);
    //return;    
}

function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x45
    if(inAction.InputLinks[0].bHasImpulse)
    {
        SetEnabled(true);        
    }
    else
    {
        // End:0x8A
        if(inAction.InputLinks[1].bHasImpulse)
        {
            SetEnabled(false);            
        }
        else
        {
            SetEnabled(!bClampedBaseEnabled);
        }
    }
    //return;    
}

simulated function DetachPawn(EvilPawn P, optional bool ByDeath = false)
{
    local Vector Exit, HitLoc, HitNorm;
    local Keypoint Key;

    // End:0x4D1
    if((P.ClampedBase == self) || (P.DrivenVehicle != none) && P.DrivenVehicle.Base == self)
    {
        P.ClampedBase = none;
        P.PopState();
        // End:0x308
        if((int(P.Physics) == int(0)) && !ByDeath)
        {
            // End:0x271
            if(!ByDeath)
            {
                // End:0x1DE
                if(TraceComponent(HitLoc, HitNorm, CollisionComponent, P.Location, P.Location + (vect(0.0000000, 0.0000000, 2.0000000) * P.GetCollisionHeight()), P.GetCollisionExtent()))
                {
                    Exit = HitLoc;                    
                }
                else
                {
                    Exit = P.Location;
                }
                // End:0x271
                if(P.FindSpot(P.GetCollisionExtent(), Exit))
                {
                    P.SetLocation(Exit);
                }
            }
            P.SetMovementPhysics();
            P.bCollideWorld = true;
            P.SetCollision(P.bCollideActors, P.bBlockActors, false);
        }
        AttachedPawnList.RemoveItem(P);        
        // End:0x389
        if(EvilPlayerController(P.Controller) != none)
        {
            EvilPlayerController(P.Controller).NotifyLeftRailCar(self);
        }
        // End:0x4D0
        foreach AttachedKeyList(Key)
        {
            // End:0x3BC
            if(EvilRailCarSeat(Key) == none)
            {
                continue;                
            }
            else
            {
                // End:0x4CF
                if(EvilRailCarSeat(Key).Occupant == P)
                {
                    EvilRailCarSeat(Key).Occupant = none;
                    // End:0x4CC
                    if(((P.BlendByRailCar != none) && P.BlendByRailCar.Child2Weight ~= 1.0000000) && !ByDeath)
                    {
                        P.BlendByRailCar.SetBlendTarget(0.0000000, 0.0000000);
                    }                    
                }
                else
                {                    
                }
            }
        }        
    }
    //return;    
}

function SetEnabled(bool inbEnabled)
{
    local EvilPawn GP;

    bClampedBaseEnabled = inbEnabled;
    // End:0xA7
    foreach WorldInfo.AllPawns(Class'EvilPawn', GP)
    {
        // End:0x92
        if(bClampedBaseEnabled)
        {
            // End:0x8F
            if(GP.Base == self)
            {
                Attach(GP);
            }
            // End:0xA6
            continue;
        }
        DetachPawn(GP);        
    }    
    //return;    
}

event RanInto(Actor Other)
{
    local EvilPawn GP;

    // End:0xE1
    if(DamageToNonClampedPawnOnCollision > 0)
    {
        GP = EvilPawn(Other);
        // End:0xE1
        if(((GP != none) && GP.Base != none) && GP.ClampedBase != self)
        {
            GP.TakeDamage(DamageToNonClampedPawnOnCollision, none, GP.Location, Velocity, DamageTypeOnCollision,, self);
        }
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x5C
    if(bInterpolating)
    {
        RotDelta = Rotation - LastRot;
        LastRot = Rotation;
        UpdateSeats();
    }
    //return;    
}

defaultproperties
{
    bDoComplexCameraCollision=true
    DamageToNonClampedPawnOnCollision=20
    DamageTypeOnCollision=Class'EvilDmgType_VehicleCollision'
    AlignViewDir=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    AlignViewEpsilon=0.9600000
    bStopOnEncroach=false
    // Reference: StaticMeshComponent'Default__EvilRailCar_Base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilRailCar_Base.MyLightEnvironment'
        BlockRigidBody=true
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilRailCar_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bUpdateSimulatedPosition=true
    NetPriority=2.0000000
    CollisionComponent=StaticMeshComponent0
}