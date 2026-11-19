class R6Shield extends R6Weapon
    native
    config(WeaponsConfig)
    hidecategories(lighting);

var R6Weapon m_FireableWeapon;
var bool m_bDoingChangeTcTransition;
var float m_fTcTransitionTimer;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_FireableWeapon;
}

// Export UR6Shield::execProcessHit(FFrame&, void* const)
native final function ProcessHit(Vector vHitLocation, Vector vMomentum);

// Export UR6Shield::execGetShieldNameWithWeapon(FFrame&, void* const)
native function GetShieldNameWithWeapon(out string strName);

simulated function ChangeTcStance()
{
    // End:0x28
    if(m_bDoingChangeTcTransition)
    {
        m_fTcTransitionTimer = GetWeaponsConfig().m_fTimeToTc - m_fTcTransitionTimer;        
    }
    else
    {
        m_fTcTransitionTimer = GetWeaponsConfig().m_fTimeToTc;
        m_bDoingChangeTcTransition = true;
    }
    return;
}

simulated event SetFireableWeapon(R6Weapon fireableWeapon)
{
    local R6AttachmentsShield pAttachments;

    m_FireableWeapon = fireableWeapon;
    pAttachments = R6AttachmentsShield(GetWeaponAttachments());
    // End:0x3C
    if(pAttachments != none)
    {
        pAttachments.m_FireableWeapon = fireableWeapon;
    }
    // End:0x6D
    if(m_FireableWeapon != none)
    {
        m_FireableWeapon.m_bComplementary = true;
        SetCurrentFireMode(m_FireableWeapon.CurrentFireMode);
    }
    return;
}

simulated event string GetWeaponName()
{
    local string strName;

    GetShieldNameWithWeapon(strName);
    return strName;
    return;
}

simulated event Vector GetPhysicalFireStartLoc()
{
    return m_FireableWeapon.GetPhysicalFireStartLoc();
    return;
}

simulated event SetFireMode(byte u8NewFireMode)
{
    SetFireMode(u8NewFireMode);
    m_FireableWeapon.SetFireMode(u8NewFireMode);
    return;
}

simulated function bool CanReload()
{
    return m_FireableWeapon.CanReload();
    return;
}

simulated function float GetFireInterval(byte u8FireModeIndex)
{
    return m_FireableWeapon.GetFireInterval(u8FireModeIndex);
    return;
}

simulated function ActivateSoundSuppressor()
{
    m_FireableWeapon.ActivateSoundSuppressor();
    return;
}

simulated function bool ForceReload()
{
    return m_FireableWeapon.ForceReload();
    return;
}

simulated function FinishPutDown(optional bool bInstantSwitch)
{
    m_FireableWeapon.GotoState('Inactive');
    FinishPutDown(bInstantSwitch);
    return;
}

simulated event bool IsInShootSequence()
{
    return m_FireableWeapon.IsInShootSequence();
    return;
}

simulated function InstantEquip()
{
    InstantEquip();
    // End:0x33
    if(m_FireableWeapon != none)
    {
        m_FireableWeapon.m_bSwitchWeaponHandled = false;
        m_FireableWeapon.InstantEquip();
    }
    return;
}

simulated function bool CanChangeScope()
{
    local R6Pawn pPawn;

    pPawn = R6Pawn(Instigator);
    // End:0x34
    if((pPawn != none) && pPawn.m_bTcShield)
    {
        return false;        
    }
    else
    {
        return CanChangeScope();
    }
    return;
}

simulated function FinishEquip()
{
    FinishEquip();
    // End:0x33
    if(m_FireableWeapon != none)
    {
        // End:0x33
        if(m_FireableWeapon.m_bPawnActivatedUnderbarrel)
        {
            m_FireableWeapon.ActivateUnderbarrelAttachment();
        }
    }
    return;
}

simulated function InstantPutDown()
{
    // End:0x1C
    if(m_FireableWeapon != none)
    {
        m_FireableWeapon.DetachWeapon(true);
    }
    InstantPutDown();
    return;
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local R6Pawn pPawn;

        BeginState(PreviousStateName);
        pPawn = R6Pawn(Instigator);
        // End:0x71
        if((m_FireableWeapon != none) && (pPawn.m_R6InvManager == none) || pPawn.m_R6InvManager.PendingWeapon != m_FireableWeapon)
        {
            m_FireableWeapon.m_bSwitchWeaponHandled = false;
        }
        return;
    }

    simulated function WeaponIsDown()
    {
        local R6Pawn pPawn;

        WeaponIsDown();
        pPawn = R6Pawn(Instigator);
        // End:0x9A
        if((((m_FireableWeapon != none) && pPawn.IsFirstPerson()) && pPawn.m_R6Weapon != m_FireableWeapon) && (pPawn.m_R6InvManager == none) || pPawn.m_R6InvManager.PendingWeapon != m_FireableWeapon)
        {
            m_FireableWeapon.PutDown();
        }
        return;
    }
    stop;
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        R6Pawn(Instigator).m_bPreviousWasPistol = false;
        WeaponEquipped();
        return;
    }

    simulated function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        // End:0x72
        if(((m_FireableWeapon != none) && Instigator.IsFirstPerson()) && !R6Pawn(Instigator).m_bPreviousWasPistol)
        {
            m_FireableWeapon.m_bSwitchWeaponHandled = false;
            m_FireableWeapon.SetTimer(0.2000000, false, 'Equip');            
        }
        else
        {
            // End:0x94
            if(R6Pawn(Instigator).m_bPreviousWasPistol)
            {
                Equip(true);                
            }
            else
            {
                // End:0xB0
                if(m_FireableWeapon != none)
                {
                    m_FireableWeapon.m_bSwitchWeaponHandled = false;
                }
            }
        }
        return;
    }
    stop;
}

state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        m_FireableWeapon.GotoState('Inactive');
        BeginState(PreviousStateName);
        return;
    }
    stop;
}

defaultproperties
{
    m_eWeaponAnimType=3
    m_weaponSetup=R6WeaponSetup'WeaponSetups.Misc.MiscShieldSetup'
    m_WeaponAttachmentsClass=Class'R6AttachmentsShield'
    m_ConfigClass=Class'ConfigR6Shield'
    m_AnimConfigClass=Class'R6WeaponAnimConfigShield'
    ItemName="SHIELD"
}