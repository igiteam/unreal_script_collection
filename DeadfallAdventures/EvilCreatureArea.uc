class EvilCreatureArea extends Info
    hidecategories(Navigation,Movement,Collision);

enum ECreatureType
{
    ECT_Bird,                       // 0
    ECT_Worm,                       // 1
    ECT_Spider,                     // 2
    ECT_Skarab,                     // 3
    ECT_MAX                         // 4
};

struct CreatureTypeInfo
{
    var string ControllerClassName;
    var string PawnClassName;

    structdefaultproperties
    {
        ControllerClassName=""
        PawnClassName=""
    }
};

var() array<EvilCreatureSpot> Spots;
var() array<EvilCreatureRoamVolume> Volumes;
var() int CreatureCount;
var bool bEnabled;
var() bool bFearOfLight;
var array<EvilCreature> SpawnedCreatures;
var() array<EvilCreatureArea.ECreatureType> SpawnCreatureTypes;
var const array<CreatureTypeInfo> SpawnInfo;

simulated function Tick(float Delta)
{
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x50
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;
        SpawnCreatures();        
    }
    else
    {
        // End:0xA0
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;
            KillCreatures();            
        }
        else
        {
            // End:0x113
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
                // End:0x109
                if(bEnabled)
                {
                    SpawnCreatures();                    
                }
                else
                {
                    KillCreatures();
                }
            }
        }
    }
    //return;    
}

simulated function OnCreatureRunAwayFrom(SeqAct_CreatureRunAwayFrom inAction)
{
    local EvilCreature EC;
    local EvilCreatureWalking ECW;

    self.bFearOfLight = false;
    // End:0x13B
    foreach self.SpawnedCreatures(EC)
    {
        ECW = EvilCreatureWalking(EC);
        // End:0x13A
        if(ECW != none)
        {
            ECW.RunAwayFrom = inAction.RunAwayFrom.Location;
            // End:0x119
            if(inAction.bUseCustomDistance)
            {
                ECW.RunAwayFromDistance = inAction.CustomDistance;
            }
            ECW.bShouldRunAway = true;
        }        
    }    
    //return;    
}

function Vector GetSpawnLocation(class<Pawn> PawnClass)
{
    local Vector Loc, Extent;
    local int Index, Cnt;

    // End:0x219
    if(Spots.Length > 0)
    {
        Cnt = 0;
        Extent.X = PawnClass.default.CylinderComponent.CollisionRadius;
        Extent.Y = Extent.X;
        Extent.Z = PawnClass.default.CylinderComponent.CollisionHeight;
        J0xF4:

        Loc = VRand();
        Loc.Z = Abs(Loc.Z);
        Index = Rand(Spots.Length);
        Loc = Spots[Index].Location + ((Loc * FRand()) * Spots[Index].Radius);
        // End:0x1F0
        if(++Cnt > 10)
        {
            return Class'EvilCreature'.static.GetRandomRoamPoint(self);
        }
        // End:0xF4
        if(!(FindSpot(Extent, Loc)))
            goto J0xF4;
        return Loc;
    }
    return Class'EvilCreature'.static.GetRandomRoamPoint(self);
    //return ReturnValue;    
}

simulated function SpawnCreatures()
{
    //return;    
}

simulated function KillCreatures()
{
    local EvilCreature creature;

    // End:0x30
    foreach SpawnedCreatures(creature)
    {
        creature.Destroy();        
    }    
    SpawnedCreatures.Remove(0, SpawnedCreatures.Length);    
    //return;    
}

defaultproperties
{
    SpawnCreatureTypes[0]=134
    SpawnInfo[0]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="AdvGameContent.EvilCreature_Bird")
    SpawnInfo[1]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="AdvGameContent.EvilCreature_Worm")
    SpawnInfo[2]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="AdvGameContent.EvilCreature_Spider")
    SpawnInfo[3]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="AdvGameContent.EvilCreature_Skarab")
}