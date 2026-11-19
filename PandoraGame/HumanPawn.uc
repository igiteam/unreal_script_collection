class HumanPawn extends SPPawn
    native
    config(Game);

enum EHumanCustomIdleAnims
{
    EHCIA_Normal,                   // 0
    EHCIA_LexCarryVivianIdle,       // 1
    EHCIA_PilotCarryCoPilotIdle,    // 2
    EHCIA_SupportWoundedIdle,       // 3
    EHCIA_CoPilotCarriedIdle,       // 4
    EHCIA_Maximus,                  // 5
    EHCIA_MAX                       // 6
};

enum EHumanCustomRunAnims
{
    EHCRA_Normal,                   // 0
    EHCRA_LexCarryVivianWalk,       // 1
    EHCRA_PilotCarryCoPilotWalk,    // 2
    EHCRA_SupportWoundedWalk,       // 3
    EHCRA_CoPilotCarriedWalk,       // 4
    EHCIA_CivilianRetreatFwd1,      // 5
    EHCIA_CivilianRetreatFwd2,      // 6
    EHCIA_CivilianRetreatFwd3,      // 7
    EHCIA_CivilianRetreatFwd4,      // 8
    EHCIA_CivilianRetreatFwd5,      // 9
    EHCIA_CivilianRetreatFwd6,      // 10
    EHCIA_CivilianRetreatFwd7,      // 11
    EHCIA_CivilianRetreatFwdLookBk1,// 12
    EHCIA_CivilianRetreatFwdLookBk2,// 13
    EHCIA_CivilianRetreatFwdLookBk3,// 14
    EHCIA_CivilianRetreatFwdLookBk4,// 15
    EHCIA_CivilianRetreatFwdLookBk5,// 16
    EHCIA_CivilianRetreatFwdLookBk6,// 17
    EHCIA_CivilianRetreatFwdLookBk7,// 18
    EHCRA_Maximus,                  // 19
    EHumanCustomRunAnims_MAX        // 20
};

struct native FourWayDirAnims
{
    var name fwd;
    var name bk;
    var name Left;
    var name Right;

    structdefaultproperties
    {
        fwd="None"
        bk="None"
        Left="None"
        Right="None"
    }
};

var SPPhysicalMaterial mymaterial;
var array<name> m_customIdleAnimNames;
var array<FourWayDirAnims> m_customRunAnims;
var HumanPawn.EHumanCustomIdleAnims m_customIdleAnim;
var HumanPawn.EHumanCustomRunAnims m_customRunAnim;
var bool m_bResetCustomIdleAnimNode;
var bool m_bResetCustomRunAnimNode;
var bool m_bPlayCustomRunWhenAttached;
var bool bInEquip;
var bool bInUnequip;
var repnotify bool bInReload;

replication
{
    // Pos:0x000
    if(bNetDirty && !bNetOwner
        bInEquip, bInUnequip;

    // Pos:0x013
    if(bNetDirty
        bInReload;
}

simulated function PlayMeleeHitFX(float DamageAmount, Pawn DamageInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local ImpactInfo CurrentImpact;

    CurrentImpact.HitActor = self;
    CurrentImpact.HitLocation = HitLocation;
    CurrentImpact.HitNormal = -Momentum;
    CurrentImpact.RayDir = Normal(DamageInstigator.Location - Location);
    CurrentImpact.HitInfo = HitInfo;
    // End:0xAC
    if(HitInfo.PhysMaterial == none)
    {
        HitInfo.PhysMaterial = mymaterial;
    }
    SPPhysicalMaterial(HitInfo.PhysMaterial).PlayImpactSound(DamageType, self, HitLocation);
    // End:0x139
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        SPPhysicalMaterial(HitInfo.PhysMaterial).PlayVocalHitReactionSound(DamageType, self, Mesh.GetBoneLocation('JO_head'));
    }
    SPPhysicalMaterial(HitInfo.PhysMaterial).AddImpactParticles(DamageType, CurrentImpact);
    //return;    
}

simulated event ProcEffects(float DamageAmount, Pawn DamageInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super(Actor).ProcEffects(DamageAmount, DamageInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0xA3
    if(Health > 0)
    {
        // End:0xA3
        if(((DamageInstigator != none) && DamageType == Class'SPDamageTypeMeleeAny') && !IsFirstPerson())
        {
            // End:0xA3
            if(DamageInstigator.IsA('SPBaseWerewolfPawnPersistent'))
            {
                PlayMeleeHitFX(DamageAmount, DamageInstigator, HitLocation, Momentum, DamageType, HitInfo);
            }
        }
    }
    //return;    
}

function int SpecialCost(ReachSpec Path)
{
    // End:0x1E
    if(Path.IsA('SPWallReachSpec'))
    {
        return 1000000000;
    }
    return 0;
    //return ReturnValue;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0xA5
    if(VarName == 'bInReload')
    {
        // End:0x64
        if(bInReload)
        {
            // End:0x3E
            if(CurrentWeaponAttachment != none)
            {
                CurrentWeaponAttachment.PlayReloadAnim();                
            }
            else
            {
                // End:0x61
                if(Weapon != none)
                {
                    Weapon.GotoState('Reloading');
                }
            }            
        }
        else
        {
            // End:0xA3
            if((Weapon != none) && Weapon.IsInState('Reloading'))
            {
                Weapon.GotoState('Active');
            }
        }
        return;
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

simulated event PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
    local SPWeapon NewSPWeapon;

    super(Pawn).PlayWeaponSwitch(OldWeapon, NewWeapon);
    NewSPWeapon = SPWeapon(NewWeapon);
    // End:0x53
    if(NewSPWeapon != none)
    {
        NewSPWeapon.AttachWeapon(Mesh, NewSPWeapon.AttachBoneName);
    }
    //return;    
}

function SetCustomIdleAnim(HumanPawn.EHumanCustomIdleAnims eIdleAnim)
{
    local SPAnimNodeSequence customIdleNode;
    local AnimSequence AnimSeq;

    // End:0x10A
    if(int(eIdleAnim) != int(m_customIdleAnim))
    {
        // End:0xF7
        if(int(eIdleAnim) != int(0))
        {
            // End:0x47
            if((int(eIdleAnim) < int(0)) || int(eIdleAnim) >= int(5))
            {
                return;
            }
            // End:0x54
            if(Mesh == none)
            {
                return;
            }
            customIdleNode = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('CustomIdleTemplateNode'));
            // End:0x8F
            if(customIdleNode == none)
            {
                return;
            }
            AnimSeq = Mesh.FindAnimSequence(m_customIdleAnimNames[int(eIdleAnim)]);
            // End:0xBF
            if(AnimSeq == none)
            {
                return;
            }
            customIdleNode.SetAnim(m_customIdleAnimNames[int(eIdleAnim)], false);
            m_bResetCustomIdleAnimNode = true;
            m_customIdleAnim = eIdleAnim;            
        }
        else
        {
            m_bResetCustomIdleAnimNode = true;
            m_customIdleAnim = eIdleAnim;
        }
    }
    return;
    //return;    
}

function SetCustomRunAnim(HumanPawn.EHumanCustomRunAnims eRunAnim)
{
    local SPAnimNodeSequence runBlendAnimNodeSeqFwd, runBlendAnimNodeSeqBk, runBlendAnimNodeSeqLt, runBlendAnimNodeSeqRt;
    local AnimSequence AnimSeq;
    local bool bHasMissingAnim, bHasMissingNode;

    // End:0x376
    if(int(eRunAnim) != int(m_customRunAnim))
    {
        // End:0x363
        if(int(eRunAnim) != int(0))
        {
            // End:0x47
            if((int(eRunAnim) < int(0)) || int(eRunAnim) >= int(19))
            {
                return;
            }
            // End:0x6B
            if((Mesh == none) || Mesh.Animations == none)
            {
                return;
            }
            bHasMissingNode = false;
            runBlendAnimNodeSeqFwd = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('CustomRunTemplateNodeFwd'));
            // End:0xB4
            if(runBlendAnimNodeSeqFwd == none)
            {
                bHasMissingNode = true;
            }
            runBlendAnimNodeSeqBk = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('CustomRunTemplateNodeBk'));
            // End:0xF5
            if(runBlendAnimNodeSeqBk == none)
            {
                bHasMissingNode = true;
            }
            runBlendAnimNodeSeqLt = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('CustomRunTemplateNodeLt'));
            // End:0x136
            if(runBlendAnimNodeSeqLt == none)
            {
                bHasMissingNode = true;
            }
            runBlendAnimNodeSeqRt = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('CustomRunTemplateNodeRt'));
            // End:0x177
            if(runBlendAnimNodeSeqRt == none)
            {
                bHasMissingNode = true;
            }
            // End:0x182
            if(bHasMissingNode)
            {
                return;
            }
            bHasMissingAnim = false;
            AnimSeq = Mesh.FindAnimSequence(m_customRunAnims[int(eRunAnim)].fwd);
            // End:0x1CB
            if(AnimSeq == none)
            {
                bHasMissingAnim = true;
            }
            AnimSeq = Mesh.FindAnimSequence(m_customRunAnims[int(eRunAnim)].bk);
            // End:0x20C
            if(AnimSeq == none)
            {
                bHasMissingAnim = true;
            }
            AnimSeq = Mesh.FindAnimSequence(m_customRunAnims[int(eRunAnim)].Left);
            // End:0x24D
            if(AnimSeq == none)
            {
                bHasMissingAnim = true;
            }
            AnimSeq = Mesh.FindAnimSequence(m_customRunAnims[int(eRunAnim)].Right);
            // End:0x28E
            if(AnimSeq == none)
            {
                bHasMissingAnim = true;
            }
            // End:0x299
            if(bHasMissingAnim)
            {
                return;
            }
            runBlendAnimNodeSeqFwd.SetAnim(m_customRunAnims[int(eRunAnim)].fwd, false);
            runBlendAnimNodeSeqBk.SetAnim(m_customRunAnims[int(eRunAnim)].bk, false);
            runBlendAnimNodeSeqLt.SetAnim(m_customRunAnims[int(eRunAnim)].Left, false);
            runBlendAnimNodeSeqRt.SetAnim(m_customRunAnims[int(eRunAnim)].Right, false);
            m_bResetCustomRunAnimNode = true;
            m_customRunAnim = eRunAnim;            
        }
        else
        {
            m_customRunAnim = eRunAnim;
            m_bResetCustomRunAnimNode = true;
        }
    }
    return;
    //return;    
}

simulated function name IdleAnimTypeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_bResetCustomIdleAnimNode)
    {
        bResetChildOut = 1;
        m_bResetCustomIdleAnimNode = false;
    }
    switch(m_customIdleAnim)
    {
        // End:0x2F
        case 0:
            return 'Normal';
        // End:0xFFFF
        default:
            return 'Custom';
            break;
    }
    //return ReturnValue;    
}

simulated function name RunAnimTypeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_bResetCustomRunAnimNode)
    {
        bResetChildOut = 1;
        m_bResetCustomRunAnimNode = false;
    }
    switch(m_customRunAnim)
    {
        // End:0x2F
        case 0:
            return 'Normal';
        // End:0xFFFF
        default:
            return 'Custom';
            break;
    }
    //return ReturnValue;    
}

function OnSetCustomHumanAnims(SeqAct_SetCustomHumanAnims Action)
{
    SetCustomIdleAnim(Action.CustomIdleAnim);
    SetCustomRunAnim(Action.CustomRunAnim);
    m_bPlayCustomRunWhenAttached = Action.bPlayCustomRunWhenAttached;
    //return;    
}

simulated event EndCrouch(float HeightAdjust)
{
    super(Pawn).EndCrouch(HeightAdjust);
    // End:0x4F
    if(Mesh != none)
    {
        Mesh.SetTranslation(Mesh.Translation - (vect(0.0000000, 0.0000000, 1.0000000) * HeightAdjust));
    }
    //return;    
}

simulated event StartCrouch(float HeightAdjust)
{
    super(Pawn).StartCrouch(HeightAdjust);
    // End:0x6E
    if(Mesh != none)
    {
        Mesh.SetTranslation(Mesh.Translation + (vect(0.0000000, 0.0000000, 1.0000000) * HeightAdjust));
        SetLocation(Location - (vect(0.0000000, 0.0000000, 1.0000000) * HeightAdjust));
    }
    //return;    
}
