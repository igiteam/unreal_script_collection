class AdvPerk_Treasure_Flashlight extends AdvPerk_Treasure_Base
    config(Perks)
    notplaceable
    hidecategories(Navigation);

static function ActivateTreasurePerk(AdvPlayerController PC, int PerkPath, int PathLevel)
{
    local AdvPlayerPawn P;
    local AdvInventoryItem_Torch Flashlight;
    local int I;
    local bool bDurationApplied, bPowerApplied;

    P = AdvPlayerPawn(PC.Pawn);
    // End:0x40C
    if(P != none)
    {
        Flashlight = AdvInventoryItem_Torch(P.FindInventoryType(Class'AdvInventoryItem_Torch'));
        // End:0x40C
        if(Flashlight != none)
        {
            // End:0x40C
            if((PerkPath < default.SkillUpgradesPerPath.Length) && PathLevel < default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel.Length)
            {
                bDurationApplied = false;
                bPowerApplied = false;
                I = PathLevel;
                J0x105:

                // End:0x40C [Loop If]
                if(I > 0)
                {
                    // End:0x2E8
                    if(!bDurationApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Duration")
                    {
                        Flashlight.TorchParts.PowerDrainRate = Flashlight.TorchParts.default.PowerDrainRate * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                        Flashlight.TorchParts.PowerRecoveryRate = Flashlight.TorchParts.default.PowerRecoveryRate * (float(1) + default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                        bDurationApplied = true;                        
                    }
                    else
                    {
                        // End:0x3DF
                        if(!bPowerApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Power")
                        {
                            Flashlight.WeaponDamage[0] = Flashlight.default.WeaponDamage[0] * (float(1) + default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            bPowerApplied = true;
                        }
                    }
                    // End:0x3FE
                    if(bDurationApplied && bPowerApplied)
                    {
                        // [Explicit Break]
                        goto J0x40C;
                    }
                    I--;
                    // [Loop Continue]
                    goto J0x105;
                }
            }
        }
    }
    J0x40C:

    //return;    
}

defaultproperties
{
    NotifyMessage="Flashlight Power Increased!"
    SkillUpgradesPerPath[0]=(SkillUpgradesPerLevel=SkillUpgradesPerLevel[0]=(UpgradeName="",UpgradePerc=0.0000000)
    SkillUpgradesPerLevel[1]=(UpgradeName="Duration",UpgradePerc=0.1000000)
    SkillUpgradesPerLevel[2]=(UpgradeName="Power",UpgradePerc=0.2000000)
    SkillUpgradesPerLevel[3]=(UpgradeName="Duration",UpgradePerc=0.2500000)
    SkillUpgradesPerLevel[4]=(UpgradeName="Power",UpgradePerc=0.4000000))
    PerkName="Path of Light"
}