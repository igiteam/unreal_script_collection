class SPSkeletalMeshActorMAT extends SkeletalMeshActorMAT
    native;

var transient SPAnimNodeSequence currentSPAnimNode;
var SPWeapon Weapon;
var export editinline SPHeadTrackComponent HeadTrackComponent;
/** Random Ped profile */
var() SPRandomPedProfile PedProfile;
var() transient bool bClickToRegenerate;
var() bool bUseUserCombination;
var() bool bUsedForCutScene;
/** Used to allow the user to specify a specific skeletal mesh candidate */
var() int UserSkelMeshID;
/** Used to allow the user to specify a specific character */
var() array<int> UserMtlCombinationID;

// Export USPSkeletalMeshActorMAT::execMAT_BeginAnimControl(FFrame&, void* const)
native function MAT_BeginAnimControl(array<AnimSet> InAnimSets);

// Export USPSkeletalMeshActorMAT::execMAT_SetAnimPosition(FFrame&, void* const)
native function MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping);

// Export USPSkeletalMeshActorMAT::execMAT_FinishAnimControl(FFrame&, void* const)
native function MAT_FinishAnimControl();

// Export USPSkeletalMeshActorMAT::execSwitchAnimTree(FFrame&, void* const)
native function SwitchAnimTree(AnimTree newAnimTree, float BlendTime);

// Export USPSkeletalMeshActorMAT::execSetupMesh(FFrame&, void* const)
native function SetupMesh(bool bForceReattach);

// Export USPSkeletalMeshActorMAT::execAddAnimationSets(FFrame&, void* const)
native function bool AddAnimationSets(array<AnimSet> animSetsToAdd);

// Export USPSkeletalMeshActorMAT::execRemoveAnimationSets(FFrame&, void* const)
native function bool RemoveAnimationSets(array<AnimSet> animSetsToRemove);

// Export USPSkeletalMeshActorMAT::execToggleSkelControl(FFrame&, void* const)
native function bool ToggleSkelControl(bool On);

// Export USPSkeletalMeshActorMAT::execInitSkelControl(FFrame&, void* const)
native function InitSkelControl();

function PostBeginPlay()
{
    HeadTrackComponent.Init();
    SkeletalMeshComponent.bForceMeshObjectUpdates = bUsedForCutScene;
    super(SkeletalMeshActor).PostBeginPlay();
    //return;    
}

event Attach(Actor attachedToMe)
{
    super(Actor).Attach(attachedToMe);
    // End:0x34
    if(attachedToMe.CanDeleteOnDetach())
    {
        attachedToMe.bDeleteOnDetach = true;
    }
    //return;    
}

simulated function OnSpLookAt(SeqAct_SpLookAt Action)
{
    // End:0x34
    if(Action.LookAtTarget == none)
    {
        ToggleSkelControl(false);
        HeadTrackComponent.HeadLookAt = none;        
    }
    else
    {
        HeadTrackComponent.bInitizlized = false;
        HeadTrackComponent.Init();
        ToggleSkelControl(true);
    }
    //return;    
}

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    super.BeginAnimControl(InAnimSets);
    //return;    
}

simulated event FinishAnimControl()
{
    super.FinishAnimControl();
    //return;    
}

simulated function OnSpAddRemoveAnimSets(SeqAct_SpAddRemoveAnimSets Action)
{
    // End:0x2F
    if(Action.bRemoveAnimSets)
    {
        RemoveAnimationSets(Action.AnimSetsToAddOrRemove);        
    }
    else
    {
        AddAnimationSets(Action.AnimSetsToAddOrRemove);
    }
    //return;    
}

simulated function OnSetAnimTree(SeqAct_SetAnimTree Action)
{
    ClearLatentAction(Class'SeqAct_SetAnimTree', true, Action);
    // End:0x30
    if((HasAnimTrack()) == true)
    {
        ClearLatentAction(Class'SeqAct_SetAnimTree', false, none);
        return;
    }
    // End:0x71
    if(Action.bResetToDefault == true)
    {
        SwitchAnimTree(default.SkeletalMeshComponent.AnimTreeTemplate, Action.BlendTime);        
    }
    else
    {
        SwitchAnimTree(Action.AnimTreeToSet, Action.BlendTime);
    }
    InitSkelControl();
    //return;    
}

simulated function OnSPSetFakeWeapon(SeqAct_SPSetFakeWeapon inAction)
{
    local class<SPWeapon> spWeaponClass, spNpcWeaponClass;

    // End:0x0D
    if(Weapon != none)
    {
        return;
    }
    spWeaponClass = class<SPWeapon>(inAction.WeaponType);
    // End:0x97
    if(spWeaponClass != none)
    {
        spNpcWeaponClass = Class'SPWeapon'.static.ByClassGetNPCWeaponClass(spWeaponClass);
        // End:0x97
        if(spNpcWeaponClass != none)
        {
            Weapon = Spawn(spNpcWeaponClass, self);
            Weapon.AttachWeapon(SkeletalMeshComponent, 'JO_Gun');
        }
    }
    //return;    
}

event Destroyed()
{
    // End:0x2C
    if(Weapon != none)
    {
        Weapon.DetachWeapon();
        Weapon.Destroy();
    }
    super(SkeletalMeshActor).Destroyed();
    //return;    
}

simulated function OnSpPlayFaceFXAnimNotify(SeqAct_SpPlayFaceFXAnimNotify inAction)
{
    local PlayerController PC;

    ClearLatentAction(Class'SeqAct_SpPlayFaceFXAnimNotify', true, inAction);
    // End:0x59
    if(SkeletalMeshComponent != none)
    {
        SkeletalMeshComponent.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName);
    }
    // End:0xD3
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xD2
        if(NetConnection(PC.Player) != none)
        {
            PC.ClientPlayActorFaceFXAnim(self, inAction.FaceFXAnimSetRef, inAction.FaceFXGroupName, inAction.FaceFXAnimName);
        }        
    }    
    //return;    
}
