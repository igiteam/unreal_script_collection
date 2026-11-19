class AdvPerk_Treasure_Health extends AdvPerk_Treasure_Base
    config(Perks)
    notplaceable
    hidecategories(Navigation);

static function ActivateTreasurePerk(AdvPlayerController PC, int PerkPath, int PathLevel)
{
    local AdvPlayerPawn P;
    local int I;
    local bool bHealthApplied, bHRecoveryApplied, bStaminaApplied, bSRecoveryApplied;

    P = AdvPlayerPawn(PC.Pawn);
    // End:0x698
    if(P != none)
    {
        // End:0x698
        if((PerkPath < default.SkillUpgradesPerPath.Length) && PathLevel < default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel.Length)
        {
            bHealthApplied = false;
            bHRecoveryApplied = false;
            bStaminaApplied = false;
            bSRecoveryApplied = false;
            I = PathLevel;
            J0xD2:

            // End:0x698 [Loop If]
            if(I > 0)
            {
                // End:0x256
                if(!bHealthApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Health")
                {
                    P.DefaultHealth = P.default.DefaultHealth * (float(1) + default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                    P.HealthMax = int(P.DefaultHealth);
                    P.Health = int(P.DefaultHealth);
                    bHealthApplied = true;                    
                }
                else
                {
                    // End:0x350
                    if(!bHRecoveryApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "HRecovery")
                    {
                        P.AutoRecoveryDelay = P.default.AutoRecoveryDelay * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                        bHRecoveryApplied = true;                        
                    }
                    else
                    {
                        // End:0x4CF
                        if(!bStaminaApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Stamina")
                        {
                            P.StaminaDecreaseAmount = P.default.StaminaDecreaseAmount * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            P.JumpStaminaCost = P.default.JumpStaminaCost * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            bStaminaApplied = true;                            
                        }
                        else
                        {
                            // End:0x64D
                            if(!bSRecoveryApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "SRecovery")
                            {
                                P.StaminaRegenAmount = P.default.StaminaRegenAmount * (float(1) + default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                P.JumpStaminaRegenAmount = P.default.JumpStaminaRegenAmount * (float(1) + default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                bSRecoveryApplied = true;
                            }
                        }
                    }
                }
                // End:0x68A
                if((bHealthApplied && bHRecoveryApplied) || bStaminaApplied && bSRecoveryApplied)
                {
                    // [Explicit Break]
                    goto J0x698;
                }
                I--;
                // [Loop Continue]
                goto J0xD2;
            }
        }
    }
    J0x698:

    //return;    
}

defaultproperties
{
    NotifyMessage="Health Increased!"
    SkillUpgradesPerPath[0]=(SkillUpgradesPerLevel=SkillUpgradesPerLevel[0]=(UpgradeName="",UpgradePerc=0.0000000)
    SkillUpgradesPerLevel[1]=(UpgradeName="Health",UpgradePerc=0.2500000)
    SkillUpgradesPerLevel[2]=(UpgradeName="HRecovery",UpgradePerc=0.1000000)
    SkillUpgradesPerLevel[3]=(UpgradeName="Health",UpgradePerc=0.5000000)
    SkillUpgradesPerLevel[4]=(UpgradeName="HRecovery",UpgradePerc=0.2500000))
    SkillUpgradesPerPath[1]=(SkillUpgradesPerLevel=SkillUpgradesPerLevel[0]=(UpgradeName="",UpgradePerc=0.0000000)
    SkillUpgradesPerLevel[1]=(UpgradeName="Stamina",UpgradePerc=0.2500000)
    SkillUpgradesPerLevel[2]=(UpgradeName="SRecovery",UpgradePerc=0.2500000)
    SkillUpgradesPerLevel[3]=(UpgradeName="Stamina",UpgradePerc=0.5000000)
    SkillUpgradesPerLevel[4]=(UpgradeName="SRecovery",UpgradePerc=0.5000000))
    PerkName="Path of Live"
}