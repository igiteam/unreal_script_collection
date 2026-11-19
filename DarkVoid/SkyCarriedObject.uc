class SkyCarriedObject extends Actor
    abstract
    native
    notplaceable;

var const NavigationPoint LastAnchor;
var float LastValidAnchorTime;
var bool bHome;
var bool bLastSecondSave;
var repnotify SkyPlayerReplicationInfo HolderPRI;
var Pawn Holder;
var SkyGameObjective HomeBase;
var float TakenTime;
var float MaxDropTime;
var Controller FirstTouch;
var array<Controller> Assists;
var MaterialInstanceConstant HUDMaterialInstance;
var Vector HUDLocation;
var float MapSize;
var float IconXStart;
var float IconYStart;
var float IconXWidth;
var float IconYWidth;
var name GameObjBone3P;
var Vector GameObjOffset3P;
var Rotator GameObjRot3P;
var Vector GameObjOffset1P;
var Rotator GameObjRot1P;
var SoundCue PickupSound;
var SoundCue DroppedSound;
var SoundCue ReturnedSound;
var Pawn OldHolder;
var export editinline PointLightComponent FlagLight;
var float DefaultRadius;
var float DefaultHeight;
var repnotify SkyTeamInfo Team;
var array<SkyObjectiveAnnouncementInfo> NeedToPickUpAnnouncements;
var Actor OldBase;
var Actor OldBaseBase;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        HolderPRI, Team, 
        bHome;
}

function PostBeginPlay()
{
    HomeBase = SkyGameObjective(Owner);
    SetOwner(none);
    super.PostBeginPlay();
    // End:0x5E
    if(CylinderComponent(CollisionComponent) != none)
    {
        DefaultRadius = CylinderComponent(CollisionComponent).CollisionRadius;
        DefaultHeight = CylinderComponent(CollisionComponent).CollisionHeight;
    }
    //return;    
}

simulated function PrecacheAnnouncer(SkyAnnouncer Announcer)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4B [Loop If]
    if(I < NeedToPickUpAnnouncements.Length)
    {
        Announcer.PrecacheStatusSound(NeedToPickUpAnnouncements[I].AnnouncementName);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function SetHUDLocation(Vector NewHUDLocation)
{
    HUDLocation = NewHUDLocation;
    //return;    
}

simulated function byte GetTeamNum()
{
    // End:0x1D
    if(Team != none)
    {
        return byte(Team.TeamIndex);
    }
    return 255;
    //return ReturnValue;    
}

function SetHolder(Controller C)
{
    local int I;
    local SkyPlayerController PC;

    LogTaken(C);
    Holder = C.Pawn;
    // End:0x4D
    if(SkyPawn(Holder) != none)
    {
        SkyPawn(Holder).DeactivateSpawnProtection();
    }
    HolderPRI = SkyPlayerReplicationInfo(Holder.PlayerReplicationInfo);
    HolderPRI.SetFlag(self);
    GotoState('Held');
    C.MoveTimer = -1.0000000;
    Holder.MakeNoise(2.0000000);
    PC = SkyPlayerController(C);
    // End:0xE2
    if(PC != none)
    {
        PC.CheckAutoObjective(true);
    }
    // End:0xF8
    if(FirstTouch == none)
    {
        FirstTouch = C;
    }
    I = 0;
    J0xFF:

    // End:0x130 [Loop If]
    if(I < Assists.Length)
    {
        // End:0x126
        if(Assists[I] == C)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0xFF;
    }
    Assists.Length = Assists.Length + 1;
    Assists[Assists.Length - 1] = C;
    //return;    
}

function Score()
{
    GetKismetEventObjective().TriggerFlagEvent('Captured', ((Holder != none) ? Holder.Controller : none));
    Disable('Touch');
    SetLocation(HomeBase.Location);
    SetRotation(HomeBase.Rotation);
    CalcSetHome();
    GotoState('Home');
    //return;    
}

function drop()
{
    OldHolder = Holder;
    HomeBase.ObjectiveChanged();
    RotationRate.Yaw = Rand(200000) - 100000;
    RotationRate.Pitch = int(float(Rand(int(float(200000) - Abs(float(RotationRate.Yaw))))) - (0.5000000 * (float(200000) - Abs(float(RotationRate.Yaw)))));
    // End:0x123
    if((OldHolder != none) && OldHolder.Health > 0)
    {
        Velocity = 0.5000000 * Holder.Velocity;
        // End:0x123
        if(Holder.Health > 0)
        {
            Velocity += ((float(300) * Vector(Holder.Rotation)) + ((float(100) * (0.5000000 + FRand())) * VRand()));
        }
    }
    Velocity.Z = 250.0000000;
    // End:0x158
    if(PhysicsVolume.bWaterVolume)
    {
        Velocity *= 0.5000000;
    }
    BaseBoneName = 'None';
    BaseSkelComponent = none;
    SetLocation(Holder.Location);
    LogDropped(Holder.Controller);
    GotoState('Dropped');
    //return;    
}

function SendHome(Controller Returner)
{
    CalcSetHome();
    LogReturned(Returner);
    PlaySound(ReturnedSound);
    GotoState('Home');
    //return;    
}

function KismetSendHome()
{
    SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_returned_timeout', int(GetTeamNum()), none);
    BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
    SendHome(none);
    //return;    
}

protected function CalcSetHome()
{
    local Controller C;

    // End:0x48
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x47
        if(C.MoveTarget == self)
        {
            C.MoveTimer = -1.0000000;
        }        
    }    
    OldHolder = none;
    FirstTouch = none;
    J0x57:

    // End:0x6E [Loop If]
    if(Assists.Length != 0)
    {
        Assists.Remove(0, 1);
        // [Loop Continue]
        goto J0x57;
    }
    //return;    
}

function ClearHolder()
{
    local int I;
    local SkyGameReplicationInfo GRI;
    local SkyPlayerReplicationInfo PRI;

    // End:0x0D
    if(Holder == none)
    {
        return;
    }
    // End:0xB9
    if(Holder.PlayerReplicationInfo == none)
    {
        GRI = SkyGameReplicationInfo(WorldInfo.GRI);
        I = 0;
        J0x43:

        // End:0xB6 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            PRI = SkyPlayerReplicationInfo(GRI.PRIArray[I]);
            // End:0xAC
            if(PRI.GetFlag() == self)
            {
                PRI.SetFlag(none);
            }
            I++;
            // [Loop Continue]
            goto J0x43;
        }        
    }
    else
    {
        SkyPlayerReplicationInfo(Holder.PlayerReplicationInfo).SetFlag(none);
    }
    Holder = none;
    HolderPRI = none;
    //return;    
}

function Actor Position()
{
    // End:0x14
    if(Holder != none)
    {
        return Holder;        
    }
    else
    {
        // End:0x26
        if(bHome)
        {
            return HomeBase;            
        }
        else
        {
            return self;
        }
    }
    //return ReturnValue;    
}

function bool ValidHolder(Actor Other)
{
    local Pawn P;
    local SkyPawn SP;

    P = Pawn(Other);
    // End:0xC1
    if(((((((P == none) || P.Health <= 0) || !P.bCanPickupInventory) || !P.IsPlayerPawn()) || Vehicle(P.Base) != none) || P == OldHolder) || (SkyVehicle(P) != none) && !SkyVehicle(P).bCanCarryFlag)
    {
        return false;
    }
    SP = SkyPawn(Other);
    // End:0xFA
    if((SP != none) && SP.IsInState('FeigningDeath'))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

singular event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x16
    if(!ValidHolder(Other))
    {
        return;
    }
    SetHolder(Pawn(Other).Controller);
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    // End:0x45
    if(int(Role) == int(ROLE_Authority))
    {
        BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
        SendHome(none);
    }
    //return;    
}

event NotReachableBy(Pawn P)
{
    // End:0x62
    if(((int(Physics) != int(2)) && WorldInfo.Game.NumBots > 0) && !SkyGame_Struggle(WorldInfo.Game).bAllowTranslocator)
    {
        SendHome(none);
    }
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    //return;    
}

function SkyGameObjective GetKismetEventObjective()
{
    return HomeBase;
    //return ReturnValue;    
}

simulated event OnBaseChainChanged()
{
    //return;    
}

function LogTaken(Controller EventInstigator)
{
    GetKismetEventObjective().TriggerFlagEvent('Taken', EventInstigator);
    //return;    
}

function LogReturned(Controller EventInstigator)
{
    GetKismetEventObjective().TriggerFlagEvent('Returned', EventInstigator);
    //return;    
}

event CheckPain()
{
    //return;    
}

function LogDropped(Controller EventInstigator)
{
    GetKismetEventObjective().TriggerFlagEvent('Dropped', EventInstigator);
    // End:0x33
    if(bLastSecondSave)
    {        
    }
    else
    {
        BroadcastLocalizedMessage(MessageClass, 2 + (7 * int(GetTeamNum())), HolderPRI, none, Team);
    }
    bLastSecondSave = false;
    SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_dropped', int(GetTeamNum()), HolderPRI);
    //return;    
}

function CheckTouching()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5F [Loop If]
    if(I < Touching.Length)
    {
        // End:0x55
        if(ValidHolder(Touching[I]))
        {
            SetHolder(Pawn(Touching[I]).Controller);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export USkyCarriedObject::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int DamageAmount, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

auto state Home
{
    function LogTaken(Controller EventInstigator)
    {
        global.LogTaken(EventInstigator);
        BroadcastLocalizedMessage(MessageClass, 6 + (7 * int(GetTeamNum())), EventInstigator.PlayerReplicationInfo, none, Team);
        SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_taken', int(GetTeamNum()), EventInstigator.PlayerReplicationInfo);
        //return;        
    }

    function Timer()
    {
        // End:0xE5
        if((VSize2D(Location - HomeBase.Location) > 10.0000000) || Abs(Location.Z - HomeBase.Location.Z) > CylinderComponent(CollisionComponent).CollisionHeight)
        {
            SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_returned_timeout', int(GetTeamNum()), none);
            BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
            BeginState('None');
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        Disable('Touch');
        bHome = true;
        SetLocation(HomeBase.Location);
        SetRotation(HomeBase.Rotation);
        Enable('Touch');
        //return;        
    }

    function EndState(name NextStateName)
    {
        bHome = false;
        TakenTime = WorldInfo.TimeSeconds;
        //return;        
    }
Begin:

    Sleep(0.0500000);
    CheckTouching();
    stop;        
}

state Held
{
    function SendHome(Controller Returner)
    {
        OldHolder = Holder;
        HomeBase.ObjectiveChanged();
        BaseBoneName = 'None';
        BaseSkelComponent = none;
        SetLocation(Holder.Location);
        GotoState('Dropped');
        global.SendHome(Returner);
        //return;        
    }

    function KismetSendHome()
    {
        SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_returned_timeout', int(GetTeamNum()), none);
        BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
        SendHome(none);
        //return;        
    }

    function Timer()
    {
        // End:0x79
        if(Holder == none)
        {
            SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_returned_timeout', int(GetTeamNum()), none);
            BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
            SendHome(none);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SkyGameReplicationInfo(WorldInfo.GRI).SetFlagHeldEnemy(int(GetTeamNum()));
        bCollideWorld = false;
        SetCollision(false, false);
        SetLocation(Holder.Location);
        // End:0x7A
        if(SkyPawn_MP(Holder) != none)
        {
            SkyPawn_MP(Holder).SHoldGameObject(self);
        }
        SetTimer(10.0000000, true);
        HomeBase.ObjectiveChanged();
        // End:0xB4
        if(PickupSound != none)
        {
            PlaySound(PickupSound);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearHolder();
        bCollideWorld = true;
        Disable('Touch');
        SetCollision(true, false);
        Enable('Touch');
        SetBase(none);
        //return;        
    }
    stop;    
}

state Dropped
{
    function LogTaken(Controller EventInstigator)
    {
        global.LogTaken(EventInstigator);
        SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_pickup', int(GetTeamNum()), EventInstigator.PlayerReplicationInfo);
        BroadcastLocalizedMessage(MessageClass, 4 + (7 * int(GetTeamNum())), EventInstigator.PlayerReplicationInfo, none, Team);
        //return;        
    }

    function CheckFit()
    {
        local Vector X, Y, Z;

        GetAxes(OldHolder.Rotation, X, Y, Z);
        SetRotation(Rotator(float(-1) * X));
        // End:0x197
        if((!SetLocation((OldHolder.Location - ((float(2) * OldHolder.GetCollisionRadius()) * X)) + (OldHolder.GetCollisionHeight() * vect(0.0000000, 0.0000000, 0.5000000))) && !SetLocation(OldHolder.Location)) && OldHolder.GetCollisionRadius() > float(0))
        {
            SetCollisionSize(FMin(DefaultRadius, 0.8000000 * OldHolder.GetCollisionRadius()), FMin(DefaultHeight, 0.8000000 * OldHolder.GetCollisionHeight()));
            // End:0x197
            if(!SetLocation(OldHolder.Location))
            {
                SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_returned_timeout', int(GetTeamNum()), none);
                BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
                SendHome(none);
                return;
            }
        }
        //return;        
    }

    event CheckPain()
    {
        // End:0x17
        if(IsInPain())
        {
            Timer();
        }
        //return;        
    }

    singular function PhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        super(Actor).PhysicsVolumeChange(NewVolume);
        CheckPain();
        //return;        
    }

    function Timer()
    {
        BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
        SkyGame_Struggle(WorldInfo.Game).GameEvent('flag_returned_timeout', int(GetTeamNum()), none);
        SendHome(none);
        //return;        
    }

    singular event BaseChange()
    {
        // End:0x3B
        if(Pawn(Base) != none)
        {
            Velocity = 100.0000000 * VRand();
            Velocity.Z += 200.0000000;
            SetPhysics(2);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x1B
        if(DroppedSound != none)
        {
            PlaySound(DroppedSound);
        }
        SkyGameReplicationInfo(WorldInfo.GRI).SetFlagDown(int(GetTeamNum()));
        SetPhysics(2);
        bCollideWorld = true;
        SetCollisionSize(0.5000000 * DefaultRadius, DefaultHeight);
        SetCollision(true, false);
        CheckFit();
        CheckPain();
        SetTimer(MaxDropTime, false);
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetPhysics(0);
        bCollideWorld = false;
        SetCollisionSize(DefaultRadius, DefaultHeight);
        //return;        
    }
Begin:

    Sleep(0.0500000);
    CheckTouching();
    stop;        
}
