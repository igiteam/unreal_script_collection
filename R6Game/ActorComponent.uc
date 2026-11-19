class ActorComponent extends Component
    abstract
    native
    noexport;

enum EComponentVisibility
{
    ECV_Default,                    // 0
    ECV_UseFirstPerson,             // 1
    ECV_UseThirdPerson,             // 2
    ECV_MAX                         // 3
};

var native const transient bool bAttached;
var native const transient Pointer Scene;
var const transient Actor Owner;
var ActorComponent.EComponentVisibility m_eComponentVisibility;
var native const transient Pointer m_pCachedScene[2];
var const transient Actor m_pCachedOwner[2];
var const bool bTickInEditor;
var const bool bDirty;
var const bool bCachelighting;
var bool m_bIsVisibleInScope;
var bool m_bIsWeaponOnBody;
var bool m_bIsWeaponOnChest;
var() bool m_bDontSupportNearPlane;
var bool m_bDontSupportFirstPersonPOVInThird;
var const Object.ETickingGroup TickGroup;

// Export UActorComponent::execSetTickGroup(FFrame&, void* const)
native final function SetTickGroup(Object.ETickingGroup NewTickGroup);
