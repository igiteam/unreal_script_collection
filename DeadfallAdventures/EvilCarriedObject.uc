class EvilCarriedObject extends UDKCarriedObject
    abstract
    hidecategories(Navigation);

var bool bLastSecondSave;
var bool bLeavingDroppedState;
var bool bUseTeamColorForIcon;
var float TossDistance;
var repnotify EvilPlayerReplicationInfo HolderPRI;
var Pawn Holder;
var float TakenTime;
var float MaxDropTime;
var Controller FirstTouch;
var array<Controller> Assists;
var float MapSize;
var TextureCoordinates IconCoords;
var Texture2D IconTexture;
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
var array<ObjectiveAnnouncementInfo> NeedToPickUpAnnouncements;
var float HighlightScale;
var float MaxHighlightScale;
var float HighlightSpeed;
var float LastHighlightUpdate;
var float LastFlagSeeTime;
var int LastSeeMessageIndex;
var LinearColor RedColor;
var LinearColor BlueColor;
var LinearColor GoldColor;
var ForceFeedbackWaveform PickUpWaveForm;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        HolderPRI;
}

function PostBeginPlay()
{
    HomeBase = EvilGameObjective(Owner);
    SetOwner(none);
    super(Actor).PostBeginPlay();
    // End:0xA4
    if(CylinderComponent(CollisionComponent) != none)
    {
        DefaultRadius = CylinderComponent(CollisionComponent).CollisionRadius;
        DefaultHeight = CylinderComponent(CollisionComponent).CollisionHeight;
    }
    //return;    
}

function bool FlagUse(Controller C)
{
    return false;
    //return ReturnValue;    
}

simulated function bool ShouldMinimapRenderFor(PlayerController PC)
{
    return true;
    //return ReturnValue;    
}

simulated function HighlightOnMinimap(int Switch)
{
    // End:0x4E
    if(HighlightScale < 1.2500000)
    {
        HighlightScale = MaxHighlightScale;
        LastHighlightUpdate = WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated function Texture2D GetIconTexture()
{
    //return ReturnValue;    
}

simulated function DrawIcon(Canvas Canvas, Vector IconLocation, float IconWidth, float IconAlpha)
{
    local float YoverX;
    local LinearColor DrawColor;

    // End:0x52
    if(bUseTeamColorForIcon)
    {
        DrawColor = ((Team.TeamIndex == 0) ? RedColor : BlueColor);        
    }
    else
    {
        DrawColor = GoldColor;
    }
    DrawColor.A = IconAlpha;
    YoverX = IconCoords.VL / IconCoords.UL;
    Canvas.SetPos(IconLocation.X - (0.5000000 * IconWidth), IconLocation.Y - ((0.5000000 * IconWidth) * YoverX));
    Canvas.DrawTile(IconTexture, IconWidth, IconWidth * YoverX, IconCoords.U, IconCoords.V, IconCoords.UL, IconCoords.VL, DrawColor);
    //return;    
}

simulated function RenderMapIcon(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner)
{
    local float CurrentScale;

    // End:0x97
    if(HighlightScale > 1.0000000)
    {
        CurrentScale = (WorldInfo.TimeSeconds - LastHighlightUpdate) / HighlightSpeed;
        HighlightScale = FMax(1.0000000, HighlightScale - (CurrentScale * MaxHighlightScale));
        CurrentScale = HighlightScale;        
    }
    else
    {
        CurrentScale = 1.0000000;
    }
    DrawIcon(Canvas, HUDLocation, ((IconCoords.UL * (Canvas.ClipY / float(720))) * MapSize) * CurrentScale, 1.0000000);
    //return;    
}

simulated function RenderEnemyMapIcon(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner, EvilGameObjective NearbyObjective)
{
    local float YoverX, IconWidth, FlashScale, CurrentScale;
    local LinearColor DrawColor;

    FlashScale = 0.5000000 * Abs(Cos(2.0000000 * WorldInfo.TimeSeconds));
    DrawColor = ((Team.TeamIndex == 0) ? RedColor : BlueColor);
    DrawColor.G = FlashScale;
    // End:0x139
    if(HighlightScale > 1.0000000)
    {
        CurrentScale = (WorldInfo.TimeSeconds - LastHighlightUpdate) / HighlightSpeed;
        HighlightScale = FMax(1.0000000, HighlightScale - (CurrentScale * MaxHighlightScale));
        CurrentScale = HighlightScale;        
    }
    else
    {
        CurrentScale = 1.0000000;
    }
    IconWidth = ((IconCoords.UL * (Canvas.ClipY / float(720))) * MapSize) * CurrentScale;
    YoverX = IconCoords.VL / IconCoords.UL;
    Canvas.SetPos(HUDLocation.X - (0.5000000 * IconWidth), HUDLocation.Y - ((0.5000000 * IconWidth) * YoverX));
    Canvas.DrawTile(IconTexture, IconWidth, IconWidth * YoverX, IconCoords.U, IconCoords.V, IconCoords.UL, IconCoords.VL, DrawColor);
    //return;    
}

function SetHolder(Controller C)
{
    local int I;
    local EvilPlayerController PC;
    local Controller OtherC;

    LogTaken(C);
    Holder = C.Pawn;
    // End:0x7B
    if(EvilPawn(Holder) != none)
    {
        EvilPawn(Holder).DeactivateSpawnProtection();
    }
    HolderPRI = EvilPlayerReplicationInfo(Holder.PlayerReplicationInfo);
    HolderPRI.SetFlag(self);
    HolderPRI.bForceNetUpdate = true;
    LastFlagSeeTime = WorldInfo.TimeSeconds - float(11);
    GotoState('Held');
    C.MoveTimer = -1.0000000;
    Holder.MakeNoise(2.0000000);
    PC = EvilPlayerController(C);
    // End:0x1DF
    if(PC != none)
    {
        PC.CheckAutoObjective(true);
        PC.ClientPlayForceFeedbackWaveform(PickUpWaveForm);
    }
    // End:0x283
    foreach WorldInfo.AllControllers(Class'Engine.Controller', OtherC)
    {
        PC = EvilPlayerController(OtherC);
        // End:0x282
        if(PC != none)
        {
            // End:0x282
            if(PC.LastAutoObjective == self)
            {
                PC.CheckAutoObjective(true);
            }
        }        
    }    
    // End:0x2A6
    if(FirstTouch == none)
    {
        FirstTouch = C;
    }
    I = 0;
    J0x2B1:

    // End:0x2FA [Loop If]
    if(I < Assists.Length)
    {
        // End:0x2EC
        if(Assists[I] == C)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x2B1;
    }
    Assists.Length = Assists.Length + 1;
    Assists[Assists.Length - 1] = C;
    SendFlagMessage(C);
    //return;    
}

function SendFlagMessage(Controller C)
{
    C.SendMessage(none, 'HOLDINGFLAG', 10.0000000);
    //return;    
}

function Score()
{
    GetKismetEventObjective().TriggerFlagEvent('Captured', ((Holder != none) ? Holder.Controller : none));
    // End:0x123
    if(!WorldInfo.Game.bGameEnded)
    {
        Disable('Touch');
        SetLocation(HomeBase.Location + (HomeBaseOffset >> HomeBase.Rotation));
        SetRotation(HomeBase.Rotation);
        CalcSetHome();
        GotoState('Home');
    }
    //return;    
}

function Drop(optional Controller Killer)
{
    local EvilPlayerController PC;

    OldHolder = Holder;
    HomeBase.ObjectiveChanged();
    RotationRate.Yaw = Rand(200000) - 100000;
    RotationRate.Pitch = int(float(Rand(int(float(200000) - Abs(float(RotationRate.Yaw))))) - (0.5000000 * (float(200000) - Abs(float(RotationRate.Yaw)))));
    // End:0x1AF
    if((OldHolder != none) && OldHolder.Health > 0)
    {
        Velocity = 0.5000000 * Holder.Velocity;
        // End:0x1AF
        if(Holder.Health > 0)
        {
            Velocity += ((float(300) * Vector(Holder.Rotation)) + ((float(100) * (0.5000000 + FRand())) * VRand()));
        }
    }
    Velocity.Z = 250.0000000;
    // End:0x203
    if(PhysicsVolume.bWaterVolume)
    {
        Velocity *= 0.5000000;
    }
    BaseBoneName = 'None';
    BaseSkelComponent = none;
    SetLocation(Holder.Location);
    // End:0x267
    if(Killer != none)
    {
        LogDropped(Killer);        
    }
    else
    {
        LogDropped(Holder.Controller);
    }
    GotoState('Dropped');
    // End:0x2F2
    foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        PC.CheckAutoObjective(true);        
    }    
    //return;    
}

function SendHome(Controller Returner)
{
    local EvilPlayerController PC;

    CalcSetHome();
    LogReturned(Returner);
    PlaySound(ReturnedSound);
    GotoState('Home');
    // End:0xBC
    foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        // End:0xBB
        if(PC.LastAutoObjective == self)
        {
            PC.CheckAutoObjective(true);
        }        
    }    
    //return;    
}

function KismetSendHome()
{
    BroadcastReturnedMessage();
    SendHome(none);
    //return;    
}

function BroadcastReturnedMessage()
{
    // End:0x6B
    if(!WorldInfo.GRI.bMatchIsOver)
    {
        BroadcastLocalizedMessage(MessageClass, 3 + (7 * int(GetTeamNum())), none, none, Team);
    }
    //return;    
}

function BroadcastDroppedMessage(Controller EventInstigator)
{
    // End:0xDC
    if(!WorldInfo.GRI.bMatchIsOver)
    {
        // End:0x85
        if(EventInstigator == none)
        {
            BroadcastLocalizedMessage(MessageClass, 2 + (7 * int(GetTeamNum())), HolderPRI, none, Team);            
        }
        else
        {
            BroadcastLocalizedMessage(MessageClass, 2 + (7 * int(GetTeamNum())), HolderPRI, EventInstigator.PlayerReplicationInfo, Team);
        }
    }
    //return;    
}

function BroadcastTakenFromBaseMessage(Controller EventInstigator)
{
    BroadcastLocalizedMessage(MessageClass, 6 + (7 * int(GetTeamNum())), EventInstigator.PlayerReplicationInfo, none, Team);
    //return;    
}

function BroadcastTakenDroppedMessage(Controller EventInstigator)
{
    // End:0x88
    if(!WorldInfo.GRI.bMatchIsOver)
    {
        BroadcastLocalizedMessage(MessageClass, 4 + (7 * int(GetTeamNum())), EventInstigator.PlayerReplicationInfo, none, Team);
    }
    //return;    
}

protected function CalcSetHome()
{
    local Controller C;

    // End:0x7D
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x7C
        if(C.MoveTarget == self)
        {
            C.MoveTimer = -1.0000000;
        }        
    }    
    OldHolder = none;
    FirstTouch = none;
    J0x94:

    // End:0xB4 [Loop If]
    if(Assists.Length != 0)
    {
        Assists.Remove(0, 1);        
        // [Loop Continue]
        goto J0x94;
    }
    //return;    
}

function ClearHolder()
{
    local int I;
    local EvilGameReplicationInfo GRI;
    local EvilPlayerReplicationInfo PRI;

    // End:0x11
    if(Holder == none)
    {
        return;
    }
    // End:0x165
    if(Holder.PlayerReplicationInfo == none)
    {
        GRI = EvilGameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
        I = 0;
        J0x86:

        // End:0x162 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            PRI = EvilPlayerReplicationInfo(GRI.PRIArray[I]);
            // End:0x154
            if(PRI.GetFlag() == self)
            {
                PRI.SetFlag(none);
                PRI.bForceNetUpdate = true;
            }
            I++;
            // [Loop Continue]
            goto J0x86;
        }        
    }
    else
    {
        EvilPlayerReplicationInfo(Holder.PlayerReplicationInfo).SetFlag(none);
        Holder.PlayerReplicationInfo.bForceNetUpdate = true;
    }
    Holder = none;
    HolderPRI = none;
    //return;    
}

function Actor Position()
{
    // End:0x1C
    if(Holder != none)
    {
        return Holder;        
    }
    else
    {
        // End:0x36
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
    local EvilPawn UTP;

    P = Pawn(Other);
    // End:0xE7
    if((((((P == none) || P.Health <= 0) || !P.bCanPickupInventory) || !P.IsPlayerPawn()) || Vehicle(P.Base) != none) || P == OldHolder)
    {
        return false;
    }
    UTP = EvilPawn(Other);
    // End:0x13B
    if((UTP != none) && UTP.IsInState('FeigningDeath'))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

singular event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x1A
    if(!ValidHolder(Other))
    {
        return;
    }
    SetHolder(Pawn(Other).Controller);
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    // End:0x1E
    if(int(Role) == int(ROLE_Authority))
    {
        AutoSendHome();
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x31
    if(VarName == 'bHome')
    {
        // End:0x2E
        if(bHome)
        {
            ClientReturnedHome();
        }        
    }
    else
    {
        super(Actor).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function ClientReturnedHome()
{
    // End:0x82
    if(HomeBase != none)
    {
        SetLocation(HomeBase.Location + (HomeBaseOffset >> HomeBase.Rotation));
        SetRotation(HomeBase.Rotation);
        SetPhysics(0);
    }
    //return;    
}

event NotReachableBy(Pawn P)
{
    // End:0x5A
    if((int(Physics) != int(2)) && WorldInfo.Game.NumBots > 0)
    {
        SendHome(none);
    }
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    local Rotator NewRot;

    NewRot = rot(16384, 0, 0);
    NewRot.Yaw = Rotation.Yaw;
    SetRotation(NewRot);
    OldHolder = none;
    //return;    
}

function UDKGameObjective GetKismetEventObjective()
{
    return HomeBase;
    //return ReturnValue;    
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

function LogDropped(Controller EventInstigator)
{
    GetKismetEventObjective().TriggerFlagEvent('Dropped', EventInstigator);
    // End:0xE3
    if(bLastSecondSave && EventInstigator != Holder.Controller)
    {
        // End:0xE0
        if(EvilPlayerReplicationInfo(EventInstigator.PlayerReplicationInfo) != none)
        {
            EvilPlayerReplicationInfo(EventInstigator.PlayerReplicationInfo).IncrementEventStat('EVENT_LASTSECONDSAVE');
        }        
    }
    else
    {
        BroadcastDroppedMessage(EventInstigator);
    }
    bLastSecondSave = false;
    //return;    
}

function CheckTouching()
{
    local int I;
    local Controller BestToucher;
    local Pawn PastHolder;

    PastHolder = OldHolder;
    OldHolder = none;
    I = 0;
    J0x29:

    // End:0x15A [Loop If]
    if(I < Touching.Length)
    {
        // End:0x14C
        if(ValidHolder(Touching[I]))
        {
            // End:0x102
            if(PlayerController(Pawn(Touching[I]).Controller) != none)
            {
                // End:0xFD
                if(PastHolder != Touching[I])
                {
                    SetHolder(Pawn(Touching[I]).Controller);
                }
                return;                
            }
            else
            {
                // End:0x14C
                if(BestToucher == none)
                {
                    BestToucher = Pawn(Touching[I]).Controller;
                }
            }
        }
        I++;
        // [Loop Continue]
        goto J0x29;
    }
    // End:0x17C
    if(BestToucher != none)
    {
        SetHolder(BestToucher);
    }
    //return;    
}

function AutoSendHome()
{
    BroadcastReturnedMessage();
    SendHome(none);
    //return;    
}

function CheckFit()
{
    //return;    
}

function CheckPain()
{
    //return;    
}

auto state Home
{
    ignores SendHome, KismetSendHome, Score, Drop;

    function LogTaken(Controller EventInstigator)
    {
        global.LogTaken(EventInstigator);
        BroadcastTakenFromBaseMessage(EventInstigator);
        //return;        
    }

    function Timer()
    {
        local Vector FinalLoc;

        FinalLoc = HomeBase.Location + (HomeBaseOffset >> HomeBase.Rotation);
        // End:0x103
        if((VSize2D(Location - FinalLoc) > 10.0000000) || Abs(Location.Z - FinalLoc.Z) > CylinderComponent(CollisionComponent).CollisionHeight)
        {
            BroadcastReturnedMessage();
            BeginState('None');
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetTimer(1.0000000, true);
        Disable('Touch');
        bHome = true;
        // End:0xA7
        if(SetLocation(HomeBase.Location + (HomeBaseOffset >> HomeBase.Rotation)))
        {
            SetRotation(HomeBase.Rotation);
            SetCollision(true, false);
            Enable('Touch');            
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetTimer(0.0000000, false);
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
    ignores SetHolder;

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
        BroadcastReturnedMessage();
        SendHome(none);
        //return;        
    }

    function Timer()
    {
        // End:0x24
        if(Holder == none)
        {
            BroadcastReturnedMessage();
            SendHome(none);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        EvilGameReplicationInfo(WorldInfo.GRI).SetFlagHeldEnemy(int(GetTeamNum()));
        WorldInfo.GRI.bForceNetUpdate = true;
        bCollideWorld = false;
        SetCollision(false, false);
        SetLocation(Holder.Location);
        // End:0xF3
        if(EvilPawn(Holder) != none)
        {
            EvilPawn(Holder).HoldGameObject(self);
        }
        bForceNetUpdate = true;
        SetTimer(10.0000000, true);
        HomeBase.ObjectiveChanged();
        // End:0x150
        if(PickupSound != none)
        {
            PlaySound(PickupSound);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearHolder();
        SetBase(none);
        SetHardAttach(false);
        bForceNetUpdate = true;
        //return;        
    }
    stop;    
}

state Dropped
{
    ignores Drop;

    function LogTaken(Controller EventInstigator)
    {
        global.LogTaken(EventInstigator);
        BroadcastTakenDroppedMessage(EventInstigator);
        //return;        
    }

    function CheckFit()
    {
        local Vector X, Y, Z;

        GetAxes(OldHolder.Rotation, X, Y, Z);
        SetRotation(Rotator(float(-1) * X));
        // End:0x1C2
        if((!SetLocation((OldHolder.Location - ((float(2) * OldHolder.GetCollisionRadius()) * X)) + (OldHolder.GetCollisionHeight() * vect(0.0000000, 0.0000000, 0.5000000))) && !SetLocation(OldHolder.Location)) && OldHolder.GetCollisionRadius() > float(0))
        {
            SetCollisionSize(FMin(DefaultRadius, 0.8000000 * OldHolder.GetCollisionRadius()), FMin(DefaultHeight, 0.8000000 * OldHolder.GetCollisionHeight()));
            // End:0x1C2
            if(!SetLocation(OldHolder.Location))
            {
                AutoSendHome();
                return;
            }
        }
        //return;        
    }

    function CheckPain()
    {
        // End:0x17
        if(IsInPain())
        {
            AutoSendHome();
        }
        //return;        
    }

    event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        CheckPain();
        //return;        
    }

    singular function PhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        // End:0x19
        if(!bLeavingDroppedState)
        {
            CheckPain();
        }
        //return;        
    }

    function Timer()
    {
        AutoSendHome();
        //return;        
    }

    singular event BaseChange()
    {
        // End:0x75
        if(Pawn(Base) != none)
        {
            // End:0x3A
            if(bLeavingDroppedState)
            {
                SetBase(none);
                SetHardAttach(false);                
            }
            else
            {
                Velocity = 100.0000000 * VRand();
                Velocity.Z += 200.0000000;
                SetPhysics(2);
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x27
        if(DroppedSound != none)
        {
            PlaySound(DroppedSound);
        }
        EvilGameReplicationInfo(WorldInfo.GRI).SetFlagDown(int(GetTeamNum()));
        WorldInfo.GRI.bForceNetUpdate = true;
        SetTimer(MaxDropTime, false);
        SetPhysics(2);
        bCollideWorld = true;
        SetCollisionSize(0.7500000 * DefaultRadius, DefaultHeight);
        SetCollision(true, false);
        CheckFit();
        CheckPain();
        //return;        
    }

    function EndState(name NextStateName)
    {
        bLeavingDroppedState = true;
        SetPhysics(0);
        bForceNetUpdate = true;
        bCollideWorld = false;
        SetCollisionSize(DefaultRadius, DefaultHeight);
        ClearTimer();
        bLeavingDroppedState = false;
        //return;        
    }
Begin:

    Sleep(0.0500000);
    CheckTouching();
    stop;        
}

defaultproperties
{
    TossDistance=1500.0000000
    MaxDropTime=25.0000000
    MapSize=1.0000000
    IconCoords=(U=599.0000000,V=236.0000000,UL=25.0000000,VL=25.0000000)
    MaxHighlightScale=8.0000000
    HighlightSpeed=10.0000000
    LastSeeMessageIndex=-1
    RedColor=(R=1.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    BlueColor=(R=0.0000000,G=0.0000000,B=1.0000000,A=1.0000000)
    GoldColor=(R=1.0000000,G=1.0000000,B=0.0000000,A=1.0000000)
    // Reference: ForceFeedbackWaveform'Default__EvilCarriedObject.ForceFeedbackWaveformPickUp'
    begin object name=ForceFeedbackWaveformPickUp class=Class'Engine.ForceFeedbackWaveform'
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    // Reference: CylinderComponent'Default__EvilCarriedObject.CollisionCylinder'
    begin object name=CollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=30.0000000
        CollisionRadius=48.0000000
        ReplacementPrimitive=none
        CollideActors=true
    end object
    Components[0]=CollisionCylinder
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bIgnoreRigidBodyPawns=true
    bOrientOnSlope=true
    bAlwaysRelevant=true
    bUpdateSimulatedPosition=true
    CollisionComponent=CollisionCylinder
}