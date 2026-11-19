class AdvPerk_Treasure_Weapon extends AdvPerk_Treasure_Base
    config(Perks)
    notplaceable
    hidecategories(Navigation);

static function ActivateTreasurePerk(AdvPlayerController PC, int PerkPath, int PathLevel)
{
    local AdvPlayerPawn P;
    local AdvWeap_Base Weap, WeapLeft;
    local int I, J;
    local bool bReloadApplied, bSpreadApplied, bRateApplied, bRecoilApplied;

    P = AdvPlayerPawn(PC.Pawn);
    // End:0xFB6
    if(P != none)
    {
        Weap = AdvWeap_Base(P.Weapon);
        // End:0xFB6
        if((Weap != none) && !ClassIsChildOf(Weap.Class, Class'AdvInventoryItem_Base'))
        {
            // End:0x126
            if(!Weap.BothHandWeapon)
            {
                WeapLeft = AdvWeap_Base(P.FindInventoryType(Weap.OffHandWeaponClass));
            }
            // End:0xFB6
            if((PerkPath < default.SkillUpgradesPerPath.Length) && PathLevel < default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel.Length)
            {
                bReloadApplied = false;
                bSpreadApplied = false;
                bRateApplied = false;
                bRecoilApplied = false;
                I = PathLevel;
                J0x1B8:

                // End:0xFB6 [Loop If]
                if(I > 0)
                {
                    // End:0x354
                    if(!bReloadApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Reload")
                    {
                        Weap.ReloadTime = Weap.default.ReloadTime * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                        // End:0x345
                        if(WeapLeft != none)
                        {
                            WeapLeft.ReloadTime = WeapLeft.default.ReloadTime * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                        }
                        bReloadApplied = true;                        
                    }
                    else
                    {
                        // End:0xB46
                        if(!bSpreadApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Spread")
                        {
                            J = 0;
                            J0x3C0:

                            // End:0x5E2 [Loop If]
                            if(J < Weap.Spread.Length)
                            {
                                Weap.WeaponSpread[J] = Weap.default.WeaponSpread[J] * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                Weap.Spread[J] = Weap.WeaponSpread[J];
                                // End:0x5D4
                                if(WeapLeft != none)
                                {
                                    WeapLeft.WeaponSpread[J] = WeapLeft.default.WeaponSpread[J] * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                    WeapLeft.Spread[J] = WeapLeft.WeaponSpread[J];
                                }
                                J++;
                                // [Loop Continue]
                                goto J0x3C0;
                            }
                            Weap.MoveSpreadMultiplier = Weap.default.MoveSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            Weap.JumpSpreadMultiplier = Weap.default.JumpSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            Weap.SprintSpreadMultiplier = Weap.default.SprintSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            Weap.CrouchSpreadMultiplier = Weap.default.CrouchSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            Weap.ShotSpreadModifier = Weap.default.ShotSpreadModifier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            // End:0xB37
                            if(WeapLeft != none)
                            {
                                WeapLeft.MoveSpreadMultiplier = WeapLeft.default.MoveSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                WeapLeft.JumpSpreadMultiplier = WeapLeft.default.JumpSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                WeapLeft.SprintSpreadMultiplier = WeapLeft.default.SprintSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                WeapLeft.CrouchSpreadMultiplier = WeapLeft.default.CrouchSpreadMultiplier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                WeapLeft.ShotSpreadModifier = WeapLeft.default.ShotSpreadModifier * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                            }
                            bSpreadApplied = true;                            
                        }
                        else
                        {
                            // End:0xDE1
                            if(!bRateApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Rate")
                            {
                                J = 0;
                                J0xBB0:

                                // End:0xDD2 [Loop If]
                                if(J < Weap.FireInterval.Length)
                                {
                                    Weap.WeaponFireInterval[J] = Weap.default.WeaponFireInterval[J] * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                    Weap.FireInterval[J] = Weap.WeaponFireInterval[J];
                                    // End:0xDC4
                                    if(WeapLeft != none)
                                    {
                                        WeapLeft.WeaponFireInterval[J] = WeapLeft.default.WeaponFireInterval[J] * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                        WeapLeft.FireInterval[J] = WeapLeft.WeaponFireInterval[J];
                                    }
                                    J++;
                                    // [Loop Continue]
                                    goto J0xBB0;
                                }
                                bRateApplied = true;                                
                            }
                            else
                            {
                                // End:0xF6B
                                if(!bRecoilApplied && default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradeName == "Recoil")
                                {
                                    Weap.RecoilDelta = Weap.default.RecoilDelta * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                    // End:0xF5F
                                    if(WeapLeft != none)
                                    {
                                        WeapLeft.RecoilDelta = WeapLeft.default.RecoilDelta * (float(1) - default.SkillUpgradesPerPath[PerkPath].SkillUpgradesPerLevel[I].UpgradePerc);
                                    }
                                    bRecoilApplied = true;
                                }
                            }
                        }
                    }
                    // End:0xFA8
                    if((bReloadApplied && bSpreadApplied) || bRateApplied && bRecoilApplied)
                    {
                        // [Explicit Break]
                        goto J0xFB6;
                    }
                    I--;
                    // [Loop Continue]
                    goto J0x1B8;
                }
            }
        }
    }
    J0xFB6:

    //return;    
}

defaultproperties
{
    SkillUpgradesPerPath[0]=(SkillUpgradesPerLevel=SkillUpgradesPerLevel[0]=(UpgradeName="",UpgradePerc=0.0000000)
    SkillUpgradesPerLevel[1]=(UpgradeName="Reload",UpgradePerc=0.1000000)
    SkillUpgradesPerLevel[2]=(UpgradeName="Spread",UpgradePerc=0.1000000)
    SkillUpgradesPerLevel[3]=(UpgradeName="Reload",UpgradePerc=0.2500000)
    SkillUpgradesPerLevel[4]=(UpgradeName="Spread",UpgradePerc=0.2500000))
    SkillUpgradesPerPath[1]=(SkillUpgradesPerLevel=SkillUpgradesPerLevel[0]=(UpgradeName="",UpgradePerc=0.0000000)
    SkillUpgradesPerLevel[1]=(UpgradeName="Rate",UpgradePerc=0.1000000)
    SkillUpgradesPerLevel[2]=(UpgradeName="Recoil",UpgradePerc=0.2000000)
    SkillUpgradesPerLevel[3]=(UpgradeName="Rate",UpgradePerc=0.2000000)
    SkillUpgradesPerLevel[4]=(UpgradeName="Recoil",UpgradePerc=0.4000000))
    PerkName="Path of Warrior"
}