class MPObjective extends Actor
    native
    nativereplication
    config(Game)
    placeable
    hidecategories(Navigation);

enum EMPObjectiveAnimationType
{
    OBJ_ANIM_BOMB,                  // 0
    OBJ_ANIM_SWITCH,                // 1
    OBJ_ANIM_DOOR,                  // 2
    OBJ_ANIM_MAX                    // 3
};

enum EMPObjectiveType
{
    MPOBJECTIVE_PRIMARY,            // 0
    MPOBJECTIVE_SECONDARY,          // 1
    MPOBJECTIVE_MAX                 // 2
};

enum EObjectiveState
{
    OBJ_STATE_UNARMED,              // 0
    OBJ_STATE_ARMED,                // 1
    OBJ_STATE_DESTROYED,            // 2
    OBJ_STATE_SPAWN_OFF,            // 3
    OBJ_STATE_SPAWN_ON,             // 4
    OBJ_STATE_INACTIVE,             // 5
    OBJ_STATE_MAX                   // 6
};

var config float PointsForObjectiveArm;
var config float PointsForObjectiveDisArm;
var config float PointsForObjectiveDestroyed;
var() int MaxCountdownTimer;
var config float ArmHoldTime;
var const export editinline SpriteComponent PlacementSprite;
var export editinline StaticMeshComponent Mesh;
var() export editinline StaticMeshComponent UnarmedMesh;
var() export editinline StaticMeshComponent ArmedMesh;
var() int Team;
var() bool bDelayRoundEnd;
var() bool bInstantTrigger;
var bool bUpdateStateDisplay;
var float CountdownTimer;
var Controller LastKnownActivater;
var int LastKnownActivaterTeamIndex;
var array<Controller> LastKnownActivaterTeammates;
var() float RadiusToCheck;
var() MPObjective.EMPObjectiveAnimationType AnimationType;
var() MPObjective.EMPObjectiveType m_ObjectiveType;
var repnotify MPObjective.EObjectiveState ObjectiveState;
var transient int m_iGRIIndex;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x3C
    if(WorldInfo.GRI != none)
    {
        MOHAGameReplicationInfo(WorldInfo.GRI).AddObjective(self);
    }
    SetHidden(false);
    //return;    
}

simulated function Destroyed()
{
    // End:0x36
    if(WorldInfo.GRI != none)
    {
        MOHAGameReplicationInfo(WorldInfo.GRI).RemoveObjective(self);
    }
    m_iGRIIndex = -1;
    super.Destroyed();
    //return;    
}

simulated event ChangeState(MPObjective.EObjectiveState NewState, optional bool bForce = false)
{
    // End:0x37
    if(!bForce)
    {
        // End:0x37
        if((int(NewState) == int(ObjectiveState)) || int(ObjectiveState) == int(2))
        {
            return;
        }
    }
    ObjectiveState = NewState;
    // End:0x78
    if(WorldInfo.GRI != none)
    {
        MOHAGameReplicationInfo(WorldInfo.GRI).UpdateObjective(self);
    }
    stateChanged();
    //return;    
}

function EarnObjectivePoints(int Points, bool bGiveTeamPoints)
{
    // End:0x4A
    if(WorldInfo.Game != none)
    {
        ObjectiveGameInfo(WorldInfo.Game).ScoreKillObjectiveCompletePoints(Points, LastKnownActivater, bGiveTeamPoints, LastKnownActivaterTeammates);
    }
    //return;    
}

simulated function stateChanged()
{
    DetachComponent(Mesh);
    // End:0x4F
    if(int(ObjectiveState) == int(1))
    {
        SetHidden(false);
        Mesh = ArmedMesh;
        CountdownTimer = float(MaxCountdownTimer);
        EarnObjectivePoints(int(PointsForObjectiveArm), false);        
    }
    else
    {
        // End:0x86
        if(int(ObjectiveState) == int(0))
        {
            SetHidden(false);
            Mesh = UnarmedMesh;
            EarnObjectivePoints(int(PointsForObjectiveDisArm), false);            
        }
        else
        {
            // End:0xB9
            if(int(ObjectiveState) == int(2))
            {
                SetHidden(true);
                Mesh = none;
                EarnObjectivePoints(int(PointsForObjectiveDestroyed), true);                
            }
            else
            {
                // End:0xD7
                if(int(ObjectiveState) == int(5))
                {
                    SetHidden(true);
                    Mesh = none;
                }
            }
        }
    }
    AttachComponent(Mesh);
    // End:0x10E
    if(MOHAGameReplicationInfo(WorldInfo.GRI).RemainingTime > 0)
    {
        TriggerObjectiveKismet();
    }
    bUpdateStateDisplay = true;
    //return;    
}

simulated function ClearStateUpdate()
{
    bUpdateStateDisplay = false;
    //return;    
}

simulated function bool HasStateChanged()
{
    return bUpdateStateDisplay;
    //return ReturnValue;    
}

function Trigger(MOHAPlayerController PC)
{
    LastKnownActivater = PC;
    LastKnownActivaterTeamIndex = LastKnownActivater.PlayerReplicationInfo.Team.TeamIndex;
    GetLastKnownTeammates();
    // End:0x75
    if(PC.PlayerReplicationInfo.Team.TeamIndex == Team)
    {
        ChangeState(0);        
    }
    else
    {
        ChangeState(1);
    }
    //return;    
}

simulated function bool IsInArmedMode()
{
    // End:0x24
    if((int(ObjectiveState) == int(1)) || int(ObjectiveState) == int(4))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CanTrigger(int PlayerTeamIndex)
{
    // End:0x38
    if((PlayerTeamIndex == Team) && (int(ObjectiveState) == int(1)) || int(ObjectiveState) == int(3))
    {
        return true;        
    }
    else
    {
        // End:0x6D
        if((PlayerTeamIndex != Team) && (int(ObjectiveState) == int(0)) || int(ObjectiveState) == int(4))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event TriggerObjectiveKismet()
{
    // End:0x24
    if(FindEventsOfClass(Class'SeqEvent_ObjectiveTriggered'))
    {
        TriggerEventClass(Class'SeqEvent_ObjectiveTriggered', self);        
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x22
    if(VarName == 'ObjectiveState')
    {
        stateChanged();
        return;        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function ResetToDefualtState()
{
    ChangeState(0, true);
    LastKnownActivater = none;
    ClearLastKnownTeammates();
    //return;    
}

simulated function ClearLastKnownTeammates()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x34 [Loop If]
    if(I < LastKnownActivaterTeammates.Length)
    {
        LastKnownActivaterTeammates.Remove(I, 1);
        I--;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function GetLastKnownTeammates()
{
    local Controller P;

    ClearLastKnownTeammates();
    // End:0xE1
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        // End:0xE0
        if(((P != LastKnownActivater) && P.Pawn != none) && P.PlayerReplicationInfo.Team.TeamIndex == LastKnownActivaterTeamIndex)
        {
            // End:0xE0
            if(VSize2D(P.Pawn.Location - LastKnownActivater.Pawn.Location) < ObjectiveGameInfo(WorldInfo.Game).ObjectiveCompleteDist)
            {
                LastKnownActivaterTeammates[LastKnownActivaterTeammates.Length] = P;
            }
        }        
    }    
    // End:0x100
    if(LastKnownActivaterTeammates.Length > 0)
    {
        LastKnownActivaterTeammates[LastKnownActivaterTeammates.Length] = LastKnownActivater;
    }
    //return;    
}

simulated function UseObjectiveSpecial(MOHAMultiplayerController PC)
{
    // End:0x83
    if(int(AnimationType) == int(0))
    {
        // End:0x83
        if(PC.Pawn.InvManager != none)
        {
            MOHAInventoryManager(PC.Pawn.InvManager).StopWeaponChange();
            MOHAInventoryManager(PC.Pawn.InvManager).FilteredNextWeapon(3);
        }
    }
    //return;    
}

simulated function StopUseObjectiveSpecial(MOHAMultiplayerController PC)
{
    // End:0x107
    if(int(AnimationType) == int(0))
    {
        PC.Pawn.Weapon.ClearTimer('WeaponIsDown');
        // End:0x107
        if(PC.Pawn.InvManager != none)
        {
            // End:0xD1
            if(MOHAInventoryManager(PC.Pawn.InvManager).PendingWeapon == MOHAInventoryManager(PC.Pawn.InvManager).DemoChargeWeapon)
            {
                MOHAInventoryManager(PC.Pawn.InvManager).StopWeaponChange();
            }
            PC.SwitchWeapon();
            PC.Pawn.Weapon.bWeaponPutDown = false;
        }
    }
    //return;    
}

simulated function float GetArmHoldTime()
{
    // End:0x0F
    if(bInstantTrigger)
    {
        return 0.0000000;
    }
    return ArmHoldTime;
    //return ReturnValue;    
}

defaultproperties
{
    PointsForObjectiveArm=1.0000000
    PointsForObjectiveDisArm=1.0000000
    PointsForObjectiveDestroyed=3.0000000
    MaxCountdownTimer=30
    ArmHoldTime=3.0000000
    // Reference: SpriteComponent'Default__MPObjective.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'MOHAEngineMaterials.Objective'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale=0.1000000
    end object
    PlacementSprite=Sprite
    // Reference: StaticMeshComponent'Default__MPObjective.SMComp1'
    begin object name=SMComp1 class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'EditorMeshes.TexPropCube'
    end object
    Mesh=SMComp1
    UnarmedMesh=SMComp1
    // Reference: StaticMeshComponent'Default__MPObjective.SMComp2'
    begin object name=SMComp2 class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'EditorMeshes.TexPropCube'
    end object
    ArmedMesh=SMComp2
    bDelayRoundEnd=true
    bUpdateStateDisplay=true
    LastKnownActivaterTeamIndex=255
    RadiusToCheck=250.0000000
    m_iGRIIndex=-1
    Components[0]=SMComp1
    Components[1]=Sprite
    bNoDelete=true
    CollisionType=0
    SupportedEvents=/* Array type was not detected. */
}