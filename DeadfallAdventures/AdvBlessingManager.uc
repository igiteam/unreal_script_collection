class AdvBlessingManager extends Actor
    notplaceable
    hidecategories(Navigation);

var AdvPlayerControllerMP OwningPlayer;
var int BlessingCost;
var array< class<AdvBlessing_Base> > AllBlessings;
var array<int> BlessingSelectChance;
var string SpecialMessageKey_Mummy;
var string SpecialMessageKey_FullyBlessed;
var Texture2D DefaultBlessingIcon;
var Texture2D DefaultBlessingIconSmall;
var SoundCue BlessingGrantedSound;

event PostBeginPlay()
{
    // End:0x11
    if(AllBlessings.Length != 7)
    {
    }
    super.PostBeginPlay();
    //return;    
}

function bool ExchangeTreasures()
{
    local int TreasuresAmount;
    local AdvBlessing_Base Blessing;
    local AdvPRI PRI;
    local array< class<AdvBlessing_Base> > AvailableBlessings;
    local array<int> AvailableBlessingsSelectChance;
    local int ChanceSum, Chance, RandomNumber, Index;

    PRI = AdvPRI(OwningPlayer.PlayerReplicationInfo);
    // End:0xC9
    if(OwningPlayer.MyAdvPlayerPawnMP.bIsMummy)
    {
        OwningPlayer.SetBlessingMessage(Class'ADVGame'.static.ConvertToLocalizedString("AdvBlessings", SpecialMessageKey_Mummy, "ADVGame"));
        return false;
    }
    TreasuresAmount = PRI.EnemyMultiplayerTreasuresColected;
    // End:0x5A5
    if(TreasuresAmount >= BlessingCost)
    {
        // End:0x187
        if(AdvGameTeamTreasureHuntBase(WorldInfo.Game) != none)
        {
            AdvGameTeamTreasureHuntBase(WorldInfo.Game).ScoreTreasureExchange(PRI, TreasuresAmount);            
        }
        else
        {
            // End:0x203
            if(AdvGameTreasureHuntBase(WorldInfo.Game) != none)
            {
                AdvGameTreasureHuntBase(WorldInfo.Game).ScoreTreasureExchange(PRI, TreasuresAmount);
            }
        }
        AvailableBlessings = AllBlessings;
        AvailableBlessingsSelectChance = BlessingSelectChance;
        // End:0x2B5
        foreach OwningPlayer.ActiveBlessings(Blessing)
        {
            Index = AvailableBlessings.Find(Blessing.Class);            
            AvailableBlessings.Remove(Index, 1);            
            AvailableBlessingsSelectChance.Remove(Index, 1);                        
        }        
        // End:0x35C
        if(AdvGameMP_Base(WorldInfo.Game).IsMummyInGame(OwningPlayer))
        {
            Index = AvailableBlessings.Find(Class'AdvBlessing_Mummy');            
            // End:0x35C
            if(Index != -1)
            {
                AvailableBlessings.Remove(Index, 1);                
                AvailableBlessingsSelectChance.Remove(Index, 1);                
            }
        }
        // End:0x388
        foreach AvailableBlessingsSelectChance(Chance)
        {
            ChanceSum += Chance;            
        }        
        // End:0x541
        if(AvailableBlessings.Length != 0)
        {
            RandomNumber = Rand(ChanceSum);
            ChanceSum = 0;
            Index = 0;
            J0x3C4:

            // End:0x422 [Loop If]
            if(Index < AvailableBlessings.Length)
            {
                ChanceSum += AvailableBlessingsSelectChance[Index];
                // End:0x414
                if(RandomNumber < ChanceSum)
                {
                    // [Explicit Break]
                    goto J0x422;
                }
                Index++;
                // [Loop Continue]
                goto J0x3C4;
            }
            J0x422:

            Blessing = Spawn(AvailableBlessings[Index]);
            // End:0x486
            if(BlessingGrantedSound != none)
            {
                OwningPlayer.ClientPlaySound(BlessingGrantedSound);
            }
            OwningPlayer.AddBlessing(Blessing);
            Blessing.PreActivate();
            PRI.EnemyMultiplayerTreasuresColected -= BlessingCost;
            OwningPlayer.SetOracleParticles(PRI.EnemyMultiplayerTreasuresColected >= BlessingCost);            
        }
        else
        {
            OwningPlayer.SetBlessingMessage(Class'ADVGame'.static.ConvertToLocalizedString("AdvBlessings", SpecialMessageKey_FullyBlessed, "ADVGame"));
        }
        return true;        
    }
    else
    {
        OwningPlayer.SetNotEnoughBlessingMessage(BlessingCost);
        return false;
    }
    //return ReturnValue;    
}

function SetOwningPlayer(AdvPlayerControllerMP Player)
{
    OwningPlayer = Player;
    //return;    
}

defaultproperties
{
    BlessingCost=2
    AllBlessings[0]=Class'AdvBlessing_Health'
    AllBlessings[1]=Class'AdvBlessing_Stamina'
    AllBlessings[2]=Class'AdvBlessing_HealthRegeneration'
    AllBlessings[3]=Class'AdvBlessing_DamageReduction'
    AllBlessings[4]=Class'AdvBlessing_SecondChance'
    AllBlessings[5]=Class'AdvBlessing_Jocker'
    AllBlessings[6]=Class'AdvBlessing_Mummy'
    BlessingSelectChance[0]=5
    BlessingSelectChance[1]=5
    BlessingSelectChance[2]=5
    BlessingSelectChance[3]=5
    BlessingSelectChance[4]=5
    BlessingSelectChance[5]=5
    BlessingSelectChance[6]=1
    SpecialMessageKey_Mummy="MummyDisalbedExchangeMessage"
    SpecialMessageKey_FullyBlessed="FullyBlessedMessage"
    DefaultBlessingIconSmall=Texture2D'ui_advmultiplayer.Textures.t_chance32'
    BlessingGrantedSound=SoundCue'a_Accents.Cue.a_BlessingTH'
}