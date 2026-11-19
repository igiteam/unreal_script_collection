class PainItemBase extends Actor
    abstract
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var bool bHidden;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        bHidden=false
    }
};

var(PainItem) export editinline CylinderComponent CylinderComponent;
var(PainItem) SoundCue PickupSound1p;
var(PainItem) SoundCue PickupSound;
var(PainItem) SoundCue SpawnSound;
var(PainItem) int MaxPickCount;
var(PainItem) float CheckSameDropDistance;
var(PainItem) float ItemTakeDistance;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var bool bWaitForEffects;
var(PainItem) bool bIsPowerUpMP;
var bool bRespawnPaused;
var repnotify bool bIsRespawning;
var repnotify bool bIsDisabled;
var repnotify bool bPickupHidden;
var repnotify bool bDestroyItem;
var() bool bCanPickupWhenOwnerDies;
var(PainItem) bool bLightEnabled;
var bool bHidePickupFromLastPicker;
var bool bCanPickup;
var float TimeToLive;
var EvilLightActor BindedLightActor;
var EvilLightActor BindedLightArchetype;
var(PainItem) float RespawnItemTime;
var(PainItem) float RespawnEffectTime;
var repnotify PainPRI LastPRIPicker;
var float LastPickerClearDelay;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        LastPRIPicker, bDestroyItem, 
        bIsRespawning, bPickupHidden;

    // Pos:0x020
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        bIsDisabled;
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    CreateLight();
    ShowLight(!bHidden);
    SetDestroyTimer();
    //return;    
}

function SetDestroyTimer()
{
    // End:0x28
    if(TimeToLive > float(0))
    {
        SetTimer(TimeToLive, false, 'TimedDestroy');
    }
    //return;    
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    CylinderComponent.SetCylinderSize(GetTakeDistance(), CylinderComponent.CollisionHeight);
    // End:0xFB
    if(!PainGRI(WorldInfo.GRI).IsMultiplayerGame() && !PainGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
    {
        // End:0xEA
        if(bIsPowerUpMP)
        {
            Destroy();            
        }
        else
        {
            GotoState('None');
        }        
    }
    else
    {
        // End:0x181
        if((bIsPowerUpMP && PKGameMP_Base(WorldInfo.Game) != none) && !PKGameMP_Base(WorldInfo.Game).bPowerUps)
        {
            Destroy();            
        }
        else
        {
            SetInitialState();
        }
    }
    //return;    
}

simulated function SetPickupVisible(bool bVisible)
{
    bPickupHidden = !bVisible;
    ShowLight(bVisible);
    // End:0x65
    if(BindedLightActor != none)
    {
        BindedLightActor.SetHidden(!bVisible);
    }
    //return;    
}

function CheckTouching()
{
    //return;    
}

simulated function ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bIsDisabled')
    {
        global.SetInitialState();        
    }
    else
    {
        // End:0x51
        if(VarName == 'bPickupHidden')
        {
            SetPickupVisible(!bPickupHidden);
        }
        // End:0x80
        if(VarName == 'bIsRespawning')
        {
            // End:0x80
            if(bIsRespawning)
            {
                SetPickupVisible(true);
            }
        }
        // End:0xC2
        if(VarName == 'bDestroyItem')
        {
            // End:0xC2
            if(bDestroyItem)
            {
                ClearTimer('TimedDestroy');
                DestroyItem();
            }
        }
        // End:0xE3
        if(VarName == 'LastPRIPicker')
        {
            HideFromLastPicker();
        }
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

function float GetTakeDistance()
{
    return ItemTakeDistance;
    //return ReturnValue;    
}

simulated function bool CanCreateLight()
{
    return bLightEnabled;
    //return ReturnValue;    
}

simulated function CreateLight()
{
    // End:0x8C
    if((BindedLightArchetype != none) && CanCreateLight())
    {
        BindedLightActor = Spawn(Class'EvilGame.EvilLightActor', self,, Location,, BindedLightArchetype);
        BindedLightActor.SetBase(self);
        BindedLightActor.Activate();
    }
    //return;    
}

simulated function DestoryLight()
{
    // End:0x39
    if(BindedLightActor != none)
    {
        BindedLightActor.Deactivate();
        BindedLightActor = none;
    }
    //return;    
}

simulated function ShowLight(bool bShow)
{
    // End:0x3A
    if(BindedLightActor != none)
    {
        BindedLightActor.DisableLight(!bShow);
    }
    //return;    
}

simulated event Destroyed()
{
    StopEffects();
    super.Destroyed();
    //return;    
}

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x20
    if(bHidden || !bCanPickup)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    local PKPlayerController PC;
    local bool bSeparate1pSound;

    PC = PKPlayerController(P.Controller);
    bSeparate1pSound = (PickupSound1p != none) && PickupSound1p != PickupSound;
    // End:0xA6
    if(PickupSound != none)
    {
        P.PlaySound(PickupSound,, bSeparate1pSound);
    }
    // End:0xEC
    if(bSeparate1pSound && PC != none)
    {
        PC.ClientPlaySound(PickupSound1p);
    }
    // End:0x11A
    if(PC != none)
    {
        PC.NotifyPickup();
    }
    TriggerEventClass(Class'EvilGame.SeqEvent_Picked', P);
    // End:0x174
    if((MaxPickCount > 0) && --MaxPickCount <= 0)
    {
        bCanPickup = false;
        DestroyItem();        
    }
    else
    {
        SetRespawn();
    }
    //return;    
}

function PlayerTouch(PKPlayerPawn P, PainPRI PRI)
{
    //return;    
}

function bool ValidTouch(Pawn Other)
{
    // End:0x3A
    if((Other == none) || !Other.bCanPickupInventory)
    {
        return false;        
    }
    else
    {
        // End:0x6D
        if(!FastTrace(Other.Location, Location))
        {
            return false;
        }
    }
    // End:0x87
    if(PKPlayerPawn(Other) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanTakeWhenGhost()
{
    return false;
    //return ReturnValue;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super.OnToggleHidden(Action);
    ShowLight(!bHidden);
    // End:0x42
    if(!bHidden)
    {
        CheckTouching();
    }
    //return;    
}

simulated function StopEffects()
{
    DestoryLight();
    //return;    
}

simulated function DestroyItem()
{
    // End:0x29
    if(bWaitForEffects)
    {
        StopEffects();
        LifeSpan = 1.0000000;        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function TimedDestroy()
{
    // End:0x20
    if(int(Role) == int(ROLE_Authority))
    {
        bDestroyItem = true;
    }
    DestroyItem();
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Rotation = Rotation;
    Record.Location = Location;
    Record.bHidden = bHidden;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    SetRotation(Record.Rotation);
    SetLocation(Record.Location);
    SetHidden(Record.bHidden);
    ShowLight(!Record.bHidden);
    //return;    
}

function SetRespawn()
{
    // End:0x48
    if(WorldInfo.GRI.IsCoopMultiplayerGame())
    {
        GotoState('PickupReady');        
    }
    else
    {
        GotoState('Sleeping');
    }
    //return;    
}

function float GetRespawnTime()
{
    // End:0x46
    if(PainGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
    {
        return 10.0000000;
    }
    return ((PKGameMP_Base(WorldInfo.Game) != none) ? PKGameMP_Base(WorldInfo.Game).GetItemRespawnTime(self) : RespawnItemTime);
    //return ReturnValue;    
}

function RespawnEffect()
{
    // End:0x27
    if(SpawnSound != none)
    {
        PlaySound(SpawnSound);
    }
    //return;    
}

function bool DelayRespawn()
{
    return false;
    //return ReturnValue;    
}

simulated function HideFromLastPicker()
{
    //return;    
}

auto state PickupReady
{
    function CheckTouching()
    {
        local Pawn P;

        // End:0x61
        foreach TouchingActors(Class'Engine.Pawn', P)
        {
            Touch(P, none, Location, Normal(Location - P.Location));            
        }        
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        TriggerEventClass(Class'Engine.SeqEvent_PickupStatusChange', none, 0);
        //return;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local PKPlayerPawn P;
        local PKPlayerController PC;

        // End:0x35
        if(bHidden || !CylinderComponent.CollideActors)
        {
            return;
        }
        P = PKPlayerPawn(Other);
        // End:0x62
        if(P == none)
        {
            return;
        }
        PC = PKPlayerController(P.Controller);
        // End:0xD9
        if(((PC != none) && PC.IsGhost()) && !CanTakeWhenGhost())
        {
            return;
        }
        super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
        // End:0x25A
        if(PC != none)
        {
            // End:0x25A
            if(ValidTouch(P))
            {
                // End:0x1C8
                if(CanPickUp(P, PainPRI(P.PlayerReplicationInfo)))
                {
                    Pickup(P, PainPRI(P.PlayerReplicationInfo));
                    CylinderComponent.SetActorCollision(false, false);                    
                }
                else
                {
                    // End:0x25A
                    if(!bCanPickupWhenOwnerDies || (EvilPawn(Owner) == none) || !EvilPawn(Owner).IsAliveAndWell())
                    {
                        PlayerTouch(P, PainPRI(P.PlayerReplicationInfo));
                    }
                }
            }
        }
        //return;        
    }
Begin:

    CheckTouching();
    CylinderComponent.SetCylinderSize(GetTakeDistance(), CylinderComponent.CollisionHeight);
    CylinderComponent.SetActorCollision(true, false);
    stop;                    
}

state Sleeping
{
    ignores Touch, StartSleeping;

    function bool ReadyToPickup(float MaxWait)
    {
        return true;
        //return ReturnValue;        
    }

    event BeginState(name PreviousStateName)
    {
        SetPickupVisible(false);
        //return;        
    }

    event EndState(name NextStateName)
    {
        SetPickupVisible(true);
        //return;        
    }
Begin:

    bRespawnPaused = true;
    J0x0C:

    // End:0x24 [Loop If]
    if(DelayRespawn())
    {
        Sleep(1.0000000);
        // [Loop Continue]
        goto J0x0C;
    }
    bRespawnPaused = false;
    Sleep((GetRespawnTime()) - RespawnEffectTime);
Respawn:


    RespawnEffect();
    Sleep(RespawnEffectTime);
    GotoState('PickupReady');
    stop;                
}

defaultproperties
{
    // Reference: CylinderComponent'Default__PainItemBase.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=60.0000000
        CollisionRadius=60.0000000
        ReplacementPrimitive=none
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    SpawnSound=SoundCue'a_Specials.Cue.respawn_objects'
    MaxPickCount=1
    CheckSameDropDistance=200.0000000
    ItemTakeDistance=60.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__PainItemBase.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    begin object name="MyLightEnvironment" class=Class'Engine.DynamicLightEnvironmentComponent'
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
    end object
    LightEnvironment=MyLightEnvironment
    bLightEnabled=true
    bCanPickup=true
    TimeToLive=-1.0000000
    RespawnItemTime=15.0000000
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bCollideActors=true
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}