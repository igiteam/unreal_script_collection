class R6GadgetExplosive extends R6GroupGadget
    abstract
    native
    config(GadgetsConfig)
    hidecategories(lighting);

enum EExplosiveSettingType
{
    ExplosiveGadgetType_None,       // 0
    ExplosiveGadgetType_Throw,      // 1
    ExplosiveGadgetType_Set,        // 2
    ExplosiveGadgetType_MAX         // 3
};

var R6Explosive m_Explosive;
var class<R6Explosive> m_ExplosiveClass;
var export editinline SkeletalMeshComponent m_pDetonator;
var export editinline SkeletalMeshComponent m_pDetonatorTP;
var bool m_bSetting;
var bool m_bDetonating;
var bool m_bShowExplosive;
var bool m_bDetonatorAttached;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_Explosive, m_bDetonating, 
        m_bDetonatorAttached, m_bSetting, 
        m_bShowExplosive;
}

// Export UR6GadgetExplosive::execGetExplosivePosRot(FFrame&, void* const)
native function GetExplosivePosRot(out Vector vPos, out Rotator rRot);

// Export UR6GadgetExplosive::execGetSettingType(FFrame&, void* const)
native function R6GadgetExplosive.EExplosiveSettingType GetSettingType();

// Export UR6GadgetExplosive::execCommunicateExplosiveAmmoLeft(FFrame&, void* const)
native function CommunicateExplosiveAmmoLeft();

// Export UR6GadgetExplosive::execCreateExplosive(FFrame&, void* const)
native function CreateExplosive();

simulated function PreBeginPlay()
{
    PreBeginPlay();
    // End:0x37
    if(m_pDetonator != none)
    {
        m_pDetonator.BeginPlayInitAnimTree();
        RemoveComponent(m_pDetonator);
        RemoveComponent(m_pDetonatorTP);
    }
    return;
}

simulated function name GetGadgetAttachSocket(bool bFPMesh)
{
    // End:0x12
    if(m_bSetting)
    {
        return 'R65_BCharge_LHand';        
    }
    else
    {
        return 'R65_Detonator_LHand';
    }
    return;
}

function Explode()
{
    m_Explosive.ExplodeR6Explosive();
    m_Explosive = none;
    CommunicateExplosiveAmmoLeft();
    return;
}

event float GetUseAnimTime()
{
    return GetGadgetsConfig().m_fDetonatorTime;
    return;
}

function SetExplodeTimer()
{
    local float fTime;

    // End:0x2B
    if(Instigator.IsInTakeCover())
    {
        fTime = GetGadgetsConfig().m_fExplosiveExplodeTimeTc;        
    }
    else
    {
        fTime = GetGadgetsConfig().m_fExplosiveExplodeTime;
    }
    SetTimer(fTime, false, 'Explode');
    return;
}

function SetDettachTimer()
{
    return;
}

function ExplosiveExploded()
{
    // End:0x3D
    if((Instigator != none) && !Instigator.m_bIsNPCPawn)
    {
        m_iAmmo--;
        // End:0x3D
        if((GetCount()) <= 0)
        {
            m_bExhausted = true;
        }
    }
    m_Explosive = none;
    GotoState('Ready');
    return;
}

state Set
{
    function BeginState(name PreviousState)
    {
        BeginState(PreviousState);
        m_bSetting = false;
        m_bDetonating = true;
        return;
    }

    function UseGadget()
    {
        ResetAnim();
        GotoState('Detonating');
        SetUseTimer();
        SetExplodeTimer();
        return;
    }
    stop;
}

state Detonating
{
    function EndUseGadget()
    {
        EndUseGadget();
        DettachGadget();
        ExplosiveExploded();
        return;
        return;
    }

    simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
    {
        // End:0x41
        if((m_Explosive != none) && m_pDetonator != none)
        {
            m_pDetonator.super(SkeletalMeshComponent).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, m_bAnimDebugRelevantOnly);
        }
        return;
    }
    stop;
}

auto state Ready
{
    function BeginState(name PreviousState)
    {
        BeginState(PreviousState);
        m_bSetting = true;
        m_bDetonating = false;
        return;
    }

    function UseGadget()
    {
        ResetAnim();
        // End:0x41
        if(int(GetSettingType()) != int(1))
        {
            CreateExplosive();
            m_Explosive.m_Mesh.SetHidden(true);
            m_bShowExplosive = false;
        }
        GotoState('Setting');
        SetDettachTimer();
        SetUseTimer();
        return;
    }
    stop;
}

state Setting
{
    function EndUseGadget()
    {
        EndUseGadget();
        DettachGadget();
        // End:0x3F
        if(m_Explosive != none)
        {
            m_Explosive.m_Mesh.SetHidden(false);
            GotoState('Set');            
        }
        else
        {
            GotoState('Ready');
        }
        return;
    }

    simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
    {
        // End:0x4B
        if((m_Mesh != none) && SkeletalMeshComponent(m_Mesh) != none)
        {
            SkeletalMeshComponent(m_Mesh).super(SkeletalMeshComponent).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, m_bAnimDebugRelevantOnly);
        }
        return;
    }
    stop;
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6GadgetExplosive.DetonatorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DetonatorMesh" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'RS5Weapons.Gadgets.W_Gad_ClayMoreDetonator'
        AnimTreeTemplate=AnimTree'AnimTreeGadgets.DetonatorTree'
        AnimSets[0]=AnimSet'Anims_Props_Gadgets_1st2.Detonator'
        AnimSets[1]=AnimSet'Anims_Props_Gadgets_3rd.Detonator'
        m_eComponentVisibility=1
    end object
    m_pDetonator=DetonatorMesh
    // Reference: SkeletalMeshComponent'Default__R6GadgetExplosive.DetonatorMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DetonatorMeshTP" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'RS5Weapons.Gadgets.W_Gad_ClayMoreDetonator'
        AnimTreeTemplate=AnimTree'AnimTreeGadgets.DetonatorTree'
        AnimSets[0]=AnimSet'Anims_Props_Gadgets_1st2.Detonator'
        AnimSets[1]=AnimSet'Anims_Props_Gadgets_3rd.Detonator'
        m_eComponentVisibility=2
    end object
    m_pDetonatorTP=DetonatorMeshTP
    m_bSetting=true
    m_iAmmo=5
    m_eGadgetType=5
    // Reference: SpriteComponent'Default__R6GadgetExplosive.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6GroupGadget.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=DetonatorMesh
    Components[2]=DetonatorMeshTP
}