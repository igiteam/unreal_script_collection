class PKMapInfo extends UTMapInfo
    native
    editinlinenew;

var() int TotalCollectibles[EPKCollectibleTypes];

event CountCollectiblesStatistics()
{
    local Actor A;
    local PainItem_Treasure_Base TreasureBase;
    local EvilDynamicDestructibleObject dynDest;
    local PainPostDestructibleMethod_SpawnTreasureClass PPDM_ST;
    local PKSpawnPoint PKSPawn;
    local class<PKPawn> PKPawnClass;
    local array<SequenceObject> Factories;
    local array<Sequence> RootSequences;
    local Sequence Seq;
    local SeqAct_PKAIFactory AIFact;
    local int Idx, ToCount;
    local array<string> FactoryCollisions;

    TotalCollectibles[0] = 0;
    TotalCollectibles[1] = 0;
    TotalCollectibles[2] = 0;
    TotalCollectibles[3] = 0;
    TotalCollectibles[4] = 0;
    TotalCollectibles[5] = 0;
    TotalCollectibles[6] = 0;
    TotalCollectibles[7] = 0;
    // End:0x46D
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllActors(Class'Engine.Actor', A)
    {
        // End:0xDB
        if(PainVolume_SecretArea(A) != none)
        {
            TotalCollectibles[7]++;
            // End:0x46C
            continue;
        }
        // End:0x16E
        if(PainItem_Treasure_Base(A) != none)
        {
            TreasureBase = PainItem_Treasure_Base(A);
            // End:0x13F
            if(TreasureBase.bIsHolyItem)
            {
                TotalCollectibles[4]++;
            }
            TotalCollectibles[3] += TreasureBase.Value;
            // End:0x46C
            continue;
        }
        // End:0x197
        if(PainAmmoPickup_Base(A) != none)
        {
            TotalCollectibles[5]++;
            // End:0x46C
            continue;
        }
        // End:0x1C0
        if(PainItem_Armour_Base(A) != none)
        {
            TotalCollectibles[2]++;
            // End:0x46C
            continue;
        }
        // End:0x304
        if(EvilDynamicDestructibleObject(A) != none)
        {
            dynDest = EvilDynamicDestructibleObject(A);
            // End:0x301
            if(dynDest.DamageMods.Length > 0)
            {
                PPDM_ST = PainPostDestructibleMethod_SpawnTreasureClass(dynDest.DamageMods[0].PostDamageMethod);
                // End:0x2F3
                if(PPDM_ST != none)
                {
                    // End:0x2F3
                    if(PPDM_ST.default.TreasureClass != none)
                    {
                        TotalCollectibles[3] += (PPDM_ST.default.TreasureAmount * PPDM_ST.default.TreasureClass.default.Value);
                    }
                }
                TotalCollectibles[6]++;
            }
            // End:0x46C
            continue;
        }
        // End:0x46C
        if(PKSpawnPoint(A) != none)
        {
            PKSPawn = PKSpawnPoint(A);
            // End:0x46C
            if(!PKSPawn.NotCountable)
            {
                ToCount = ((PKSPawn.GroupCount == 0) ? PKSPawn.GroupCount : PKSPawn.GroupCount * PKSPawn.GroupSize);
                TotalCollectibles[0] += ToCount;
                PKPawnClass = class<PKPawn>(PKSPawn.PawnClassArray[0]);
                // End:0x46C
                if(PKPawnClass.default.bThrowSoul)
                {
                    TotalCollectibles[1] += ToCount;
                    // End:0x46C
                    continue;
                }
            }
        }        
    }    
    RootSequences = Class'Engine.WorldInfo'.static.GetWorldInfo().GetAllRootSequences();
    // End:0x6F8
    foreach RootSequences(Seq)
    {
        Seq.FindSeqObjectsByClass(Class'SeqAct_PKAIFactory', true, Factories);
        Idx = 0;
        J0x501:

        // End:0x6F7 [Loop If]
        if(Idx < Factories.Length)
        {
            AIFact = SeqAct_PKAIFactory(Factories[Idx]);
            // End:0x6E9
            if((AIFact != none) && SeqAct_PKAIFactoryFromSpawnPoint(AIFact) == none)
            {
                // End:0x6E9
                if(!AIFact.bNotCountable)
                {
                    // End:0x5B9
                    if(FactoryCollisions.Find(PathName(AIFact)) != -1)
                    {                        
                    }
                    else
                    {
                        FactoryCollisions.AddItem(PathName(AIFact));
                        ToCount = ((AIFact.SpawnGroupCount == 0) ? AIFact.SpawnCount : AIFact.SpawnGroupCount * AIFact.SpawnCount);
                        TotalCollectibles[0] += ToCount;
                        PKPawnClass = class<PKPawn>(AIFact.PawnClassArray[0]);
                        // End:0x6E9
                        if(PKPawnClass.default.bThrowSoul)
                        {
                            TotalCollectibles[1] += ToCount;                            
                        }
                    }
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x501;
        }        
    }    
    //return;    
}

static function PrintNotUsedFactories()
{
    //return;    
}
