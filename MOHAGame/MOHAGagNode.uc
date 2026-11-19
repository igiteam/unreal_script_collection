class MOHAGagNode extends Actor
    native
    placeable
    hidecategories(Navigation)
    implements(OIROwnerInterface);

enum EGagStatus
{
    GAG_ACTIVITY_READY,             // 0
    GAG_ACTIVITY_SUCCESS,           // 1
    GAG_ACTIVITY_FAILED,            // 2
    GAG_ACTIVITY_MAX                // 3
};

enum EPawnTeamFilter
{
    FILTER_ALLIES,                  // 0
    FILTER_AXIS,                    // 1
    FILTER_ANY,                     // 2
    FILTER_MAX                      // 3
};

struct native PawnModifiedState
{
    var bool bInvincible;
    var bool bMeshAdj_Enabled;

    structdefaultproperties
    {
        bInvincible=false
        bMeshAdj_Enabled=false
    }
};

var export editinline StimulusComponent Stimulus;
var MOHAAIPawn GagPawn;
var private bool bInUse;
var private bool bOn;
var private bool bPlayingActivity;
var bool bLastActivity;
var(GagNode) bool bIgnorePlayerShoot;
var(GagNode) bool bStartEnabled;
var private SeqAct_PlayGagActivity CurrentKismetAction;
var private PawnModifiedState SavedState;
var(GagNode) float StimulusBroadcastTimeInSec;
var(GagNode) float StimulusReactivationDelay;
var(GagNode) float StimulusBroadcastRadius;
var(GagNode) float AnimationTimeOut;
var(GagNode) AnimSet GagAnimSet;
var(GagNode) AnimTree GagAnimTree;
var(GagNode) export editinline StaticMeshComponent GagProxyMesh;
var(GagNode) MOHAAIPawn GagFilterPawn;
var(GagNode) MOHAGagNode.EPawnTeamFilter GagPawnTeam;

simulated function PostBeginPlay()
{
    GagProxyMesh = none;
    super.PostBeginPlay();
    SetInUse(false);
    bOn = bStartEnabled;
    SetTimer(StimulusBroadcastTimeInSec, true, 'SendGagStimulus');
    //return;    
}

function PawnArrived()
{
    TriggerEventClass(Class'SeqEvent_GagNodeReady', self, 0);
    //return;    
}

function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2C
    if(Action.InputLinks[0].bHasImpulse)
    {
        ActivateGagNode(true);        
    }
    else
    {
        // End:0x58
        if(Action.InputLinks[1].bHasImpulse)
        {
            ActivateGagNode(false);            
        }
        else
        {
            // End:0x89
            if(Action.InputLinks[2].bHasImpulse)
            {
                ActivateGagNode(!bOn);
            }
        }
    }
    //return;    
}

function ActivateGagNode(bool bturnOn)
{
    // End:0x41
    if(!bturnOn)
    {
        // End:0x37
        if(GagPawn != none)
        {
            MOHAAIController(GagPawn.Controller).ClearGagNode();
        }
        bOn = false;
        return;
    }
    bOn = true;
    //return;    
}

function OnSetGagPawn(SeqAct_SetGagPawn Action)
{
    local SeqVar_Object ObjVar;

    // End:0x44
    foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "GagPawn")
    {
        GagFilterPawn = MOHAAIPawn(ObjVar.GetObjectValue());        
    }    
    //return;    
}

function OnSpawnGagPawn(SeqAct_SpawnGagPawn Action)
{
    local OIRData oir;

    oir = GetOIRData();
    GagFilterPawn = __NFUN_278__(Action.GagPawnClass, self,, oir.OIRPosition, oir.OIRRotation);
    SavedState.bInvincible = false;
    // End:0x8C
    if(Action.HeadMesh != none)
    {
        GagFilterPawn.HeadSkeletalMesh = Action.HeadMesh;
    }
    // End:0xB0
    if(!Action.bAllowWeaponSpecificGear)
    {
        GagFilterPawn.GearSkeletalMesh = none;
    }
    GagFilterPawn.SetCompositeMesh();
    GagFilterPawn.Mesh.bUpdateSkelWhenNotRendered = Action.bUpdateSkelWhenNotRendered;
    GagFilterPawn.Mesh.ForcedLodModel = Action.iForcedLODModel;
    Mount(GagFilterPawn);
    MOHAAIController(GagFilterPawn.Controller).UseGagNode(self);
    Action.SpawnedPawn = GagFilterPawn;
    //return;    
}

function OnPlayGagActivity(SeqAct_PlayGagActivity Action)
{
    // End:0x145
    if(GagPawn != none)
    {
        // End:0x5A
        if(Action.InputLinks[1].bHasImpulse)
        {
            KynapseAIController(GagPawn.Controller).ABSS.TripNamedScriptEvent('scriptabortplaygag');
            return;
        }
        // End:0x92
        if(bPlayingActivity)
        {
            KynapseAIController(GagPawn.Controller).ABSS.TripNamedScriptEvent('scriptabortplaygag');
        }
        bLastActivity = Action.bLastActivity;
        KynapseAIController(GagPawn.Controller).ABSS.PushNamedScriptEventParamName('scriptplaygag', 'GagActivityName', Action.GagActivityName);
        KynapseAIController(GagPawn.Controller).ABSS.TripNamedScriptEvent('scriptplaygag');
        bPlayingActivity = true;
        CurrentKismetAction = Action;
        CurrentKismetAction.SetActivityStatus(0);
    }
    //return;    
}

function SendGagStimulus()
{
    // End:0x7C
    if(!GetInUse() && bOn)
    {
        Stimulus.AttachSender('GagAlert', 'GagAlert', Location, rot(0, 0, 0),, 0, true, true);
        Stimulus.PushStimuliSenderParamName('GagAlert', 'GagNode', Name);
    }
    //return;    
}

function GagActivityDone(bool bSuccess)
{
    bPlayingActivity = false;
    // End:0x29
    if(bSuccess)
    {
        CurrentKismetAction.SetActivityStatus(1);        
    }
    else
    {
        CurrentKismetAction.SetActivityStatus(2);
    }
    // End:0x5B
    if(bLastActivity)
    {
        SetTimer(StimulusReactivationDelay, false, 'UnMount');
    }
    //return;    
}

function SetInUse(bool InUse)
{
    bInUse = InUse;
    //return;    
}

function bool GetInUse()
{
    return bInUse;
    //return ReturnValue;    
}

function bool IsUsedBy(KynapseAIController C)
{
    // End:0x0D
    if(GagPawn == none)
    {
        return false;
    }
    return KynapseAIController(GagPawn.Controller) == C;
    //return ReturnValue;    
}

function float GetArrivedAtRadius()
{
    return 50.0000000;
    //return ReturnValue;    
}

function OIRData GetOIRData()
{
    local OIRData oir;

    oir.OIRAnimSet = GagAnimSet;
    oir.OIRAnimTree = GagAnimTree;
    oir.OIRPosition = Location;
    oir.OIRRotation = Rotation;
    oir.OIRCollideWorldRadius = 10.0000000;
    return oir;
    //return ReturnValue;    
}

function name GetActivityPose(name InName)
{
    // End:0x1D
    if(CurrentKismetAction != none)
    {
        return CurrentKismetAction.GagActivityPose;        
    }
    else
    {
        return name("");
    }
    //return ReturnValue;    
}

function bool IsDifferentOIR(Object ActiveOIR, bool bAnimsChanged)
{
    // End:0x0B
    if(bAnimsChanged)
    {
        return true;
    }
    return NotEqual_InterfaceInterface(OirInstance(ActiveOIR).OIRParent, OIROwnerInterface(self));
    //return ReturnValue;    
}

function UpdateNewOIRReference(Object newOIR)
{
    //return;    
}

function SetNextOIRInPlace()
{
    //return;    
}

function bool Mount(Pawn Pawn)
{
    local Vector NewLocation;

    // End:0x21F
    if(!GetInUse() && Pawn != none)
    {
        SetInUse(true);
        GagPawn = MOHAAIPawn(Pawn);
        GagPawn.bIsGagPawn = true;
        SavedState.bInvincible = GagPawn.bInvincible;
        GagPawn.bInvincible = true;
        GagFilterPawn.bDetachableGear = false;
        GagPawn.bApplyOIRPhysics = false;
        GagPawn.Mesh.FaceFXBlendMode = 1;
        SavedState.bMeshAdj_Enabled = GagPawn.bMeshAdj_Enabled;
        GagPawn.bMeshAdj_Enabled = false;
        NewLocation = Location;
        NewLocation.X += GagPawn.Mesh.SkeletalMesh.Origin.X;
        NewLocation.Y += GagPawn.Mesh.SkeletalMesh.Origin.Z;
        NewLocation.Z += GagPawn.Mesh.SkeletalMesh.Origin.Y;
        SetLocation(NewLocation);
        GagPawn.SetLocation(NewLocation);
        SkelControlFootPlacement(GagPawn.Mesh.FindSkelControl('RightFootControl')).SetSkelControlActive(false);
        SkelControlFootPlacement(GagPawn.Mesh.FindSkelControl('LeftFootControl')).SetSkelControlActive(false);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UnMount()
{
    SetInUse(false);
    // End:0x10C
    if(GagPawn != none)
    {
        GagPawn.bIsGagPawn = false;
        GagPawn.bInvincible = SavedState.bInvincible;
        GagPawn.bApplyOIRPhysics = true;
        GagPawn.Mesh.FaceFXBlendMode = 0;
        GagFilterPawn.bDetachableGear = true;
        GagPawn.bMeshAdj_Enabled = SavedState.bMeshAdj_Enabled;
        SkelControlFootPlacement(GagPawn.Mesh.FindSkelControl('RightFootControl')).SetSkelControlActive(true);
        SkelControlFootPlacement(GagPawn.Mesh.FindSkelControl('LeftFootControl')).SetSkelControlActive(true);
        GagPawn = none;
    }
    //return;    
}

function bool GetIsMounted()
{
    return bInUse;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    // End:0x12
    if(GagPawn != none)
    {
        GagPawn = none;
    }
    super.Destroyed();
    //return;    
}

function RegisteredAsNext()
{
    //return;    
}

function bool GetAlternateExitFinalPosition(out Vector pos)
{
    return false;
    //return ReturnValue;    
}

function bool IsDifferentReference(OIROwnerInterface prevOIR)
{
    return NotEqual_InterfaceInterface(OIROwnerInterface(self), prevOIR);
    //return ReturnValue;    
}

function int GetHeightPostureOverride(name ActivityPoseName)
{
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAGagNode.Stimulus0'
    begin object name=Stimulus0 class=Class'EAKynapse.StimulusComponent'
    end object
    Stimulus=Stimulus0
    StimulusBroadcastTimeInSec=1.0000000
    StimulusReactivationDelay=1.0000000
    // Reference: StaticMeshComponent'Default__MOHAGagNode.ProxyMesh0'
    begin object name=ProxyMesh0 class=Class'Engine.StaticMeshComponent'
        HiddenGame=true
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
        Rotation=(Pitch=0,Yaw=16384,Roll=0)
    end object
    GagProxyMesh=ProxyMesh0
    GagPawnTeam=2
    Components[0]=Stimulus0
    // Reference: SpriteComponent'Default__MOHAGagNode.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EngineResources.S_NavP'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[1]=Sprite
    // Reference: ArrowComponent'Default__MOHAGagNode.Arrow'
    begin object name=Arrow class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
        ArrowSize=0.5000000
    end object
    Components[2]=Arrow
    SupportedEvents=/* Array type was not detected. */
}