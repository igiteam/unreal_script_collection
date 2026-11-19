class R6Gadget extends Inventory
    abstract
    native
    config(GadgetsConfig)
    hidecategories(lighting);

enum EGadgetType
{
    GADGETTYPE_NONE,                // 0
    GADGETTYPE_THROWING,            // 1
    GADGETTYPE_ROPE,                // 2
    GADGETTYPE_CAM,                 // 3
    GADGETTYPE_UNUSED,              // 4
    GADGETTYPE_EXPLOSIVE,           // 5
    GADGETTYPE_GASMASK,             // 6
    GADGETTYPE_MAX                  // 7
};

enum EGadgetStates
{
    GADGETSTATE_READY,              // 0
    GADGETSTATE_SETTING,            // 1
    GADGETSTATE_UNSETTING,          // 2
    GADGETSTATE_SET,                // 3
    GADGETSTATE_DETONATING,         // 4
    GADGETSTATE_USING,              // 5
    GADGETSTATE_MAX                 // 6
};

var bool m_bExhausted;
var bool m_bGadgetAttached;
var config bool m_bOnlyOneAllowed;
var config bool m_bCanUseInTakeCover;
var config bool m_bSelectable;
var R6Gadget.EGadgetType m_eGadgetType;
var R6Gadget.EGadgetStates m_eState;
var float m_fGadgetAnimTimeLength;
var config string m_strGadgetIcon;
var export editinline MeshComponent m_MeshTP;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bExhausted, m_bGadgetAttached, 
        m_eState, m_fGadgetAnimTimeLength;
}

event UseGadget()
{
    return;
}

simulated event bool CanUseGadget()
{
    return !m_bExhausted;
    return;
}

// Export UR6Gadget::execAttachGadget(FFrame&, void* const)
native function AttachGadget();

// Export UR6Gadget::execDettachGadget(FFrame&, void* const)
native function DettachGadget();

// Export UR6Gadget::execAttachMesh(FFrame&, void* const)
native simulated function AttachMesh(MeshComponent Mesh, MeshComponent MeshTP);

// Export UR6Gadget::execDettachMesh(FFrame&, void* const)
native simulated function DettachMesh(MeshComponent Mesh, MeshComponent MeshTP);

event name GetGadgetAttachSocket(bool bFPMesh)
{
    return;
}

event float GetUseAnimTime()
{
    return 1.0000000;
    return;
}

// Export UR6Gadget::execResetAnim(FFrame&, void* const)
native function ResetAnim();

// Export UR6Gadget::execGetAnimBlendInTime(FFrame&, void* const)
native function float GetAnimBlendInTime(R6WeaponConfigValues WeaponConfig);

// Export UR6Gadget::execGetAnimBlendOutTime(FFrame&, void* const)
native function float GetAnimBlendOutTime(R6WeaponConfigValues WeaponConfig);

// Export UR6Gadget::execMoveToUse(FFrame&, void* const)
native function bool MoveToUse();

// Export UR6Gadget::execSetDestActor(FFrame&, void* const)
native function SetDestActor(Actor pActor);

simulated event bool BlocksActionForPC()
{
    return MoveToUse();
    return;
}

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
{
    return;
}

event string GetKitRestrictionName()
{
    return ItemName;
    return;
}

simulated function EndUseGadget()
{
    // End:0x15
    if((GetCount()) <= 0)
    {
        m_bExhausted = true;
    }
    R6Pawn(Instigator).PawnEndUseGadget();
    return;
}

simulated function CouldNotUseGadget()
{
    R6Pawn(Instigator).PawnEndUseGadget();
    return;
}

simulated function SetUseTimer()
{
    SetTimer(GetUseAnimTime(), false, 'EndUseGadget');
    return;
}

simulated state Setting
{
    function BeginState(name PreviousState)
    {
        m_eState = 1;
        return;
    }
    stop;
}

simulated state Unsetting
{
    function BeginState(name PreviousState)
    {
        m_eState = 2;
        return;
    }
    stop;
}

simulated state Set
{
    function BeginState(name PreviousState)
    {
        m_eState = 3;
        return;
    }
    stop;
}

simulated state Detonating
{
    function BeginState(name PreviousState)
    {
        m_eState = 4;
        return;
    }
    stop;
}

simulated state Using
{
    function BeginState(name PreviousState)
    {
        m_eState = 5;
        return;
    }
    stop;
}

auto state Ready
{
    function BeginState(name PreviousState)
    {
        m_eState = 0;
        return;
    }
    stop;
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6Gadget.GadgetMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="GadgetMeshTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Frag_Grenade'
        bAcceptsDecalsDuringGameplay=false
        m_eComponentVisibility=2
    end object
    m_MeshTP=GadgetMeshTP
    // Reference: StaticMeshComponent'Default__R6Gadget.GadgetMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="GadgetMesh" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Frag_Grenade'
        bAcceptsDecalsDuringGameplay=false
        m_eComponentVisibility=1
    end object
    m_Mesh=GadgetMesh
    RespawnTime=10.0000000
    DroppedPickupClass=Class'R6DroppedPickup'
    bOnlyRelevantToOwner=false
    bReplicateInstigator=true
    UseCharacterLights=true
    UsePawnLights=true
    TickGroup=1
}