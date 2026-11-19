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
    local EvilPlayerController PC;
    local EvilPawn EP;
    local EvilCreature EC;
    local EvilCreatureWalking ECW;
    local float CollisionRadius;
    local Vector Loc, hl, hn;
    local Rotator Rot;
    local bool playerHasTorch;

    // End:0x310
    if(self.bFearOfLight)
    {
        PC = EvilPlayerController(WorldInfo.GetALocalPlayerController());
        EP = PC.MyEvilPawn;
        playerHasTorch = ((EP.Weapon != none) && EP.Weapon.IsA('AdvInventoryItem_Torch')) || (EP.WeaponLeft != none) && EP.WeaponLeft.IsA('AdvInventoryItem_Torch');
        // End:0x245
        if(playerHasTorch)
        {
            PC.GetPlayerViewPoint(Loc, Rot);
            CollisionRadius = PC.MyEvilPawn.GetCollisionRadius();
            Loc.X += CollisionRadius;
            Loc.Y += CollisionRadius;
            Trace(hl, hn, Loc + (Normal(Vector(Rot)) * 1000000.0000000), Loc, true);
        }
        // End:0x30F
        foreach self.SpawnedCreatures(EC)
        {
            ECW = EvilCreatureWalking(EC);
            // End:0x30E
            if(ECW != none)
            {
                // End:0x2ED
                if(playerHasTorch)
                {
                    ECW.RunAwayFrom = hl;
                    ECW.bShouldRunAway = true;                    
                }
                else
                {
                    ECW.bShouldRunAway = false;
                }
            }            
        }        
    }
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
    local int I;
    local Pawn currentCreature;
    local AIController currentController;
    local class<Pawn> PawnClass;
    local class<AIController> ControllerClass;
    local array< class<Pawn> > PawnClasses;
    local array< class<AIController> > ControllerClasses;
    local EvilCreatureArea.ECreatureType CT;
    local int Random;

    // End:0x11
    if(!bEnabled)
    {
        return;
    }
    // End:0x23
    if(Volumes.Length < 1)
    {
        return;
    }
    // End:0x42
    if(self.SpawnCreatureTypes.Length < 1)
    {
        return;
    }
    // End:0x171
    foreach self.SpawnCreatureTypes(CT)
    {
        PawnClass = class<Pawn>(DynamicLoadObject(self.SpawnInfo[int(CT)].PawnClassName, Class'Core.Class'));
        // End:0xD5
        if(PawnClass == none)
        {
            continue;            
        }
        else
        {
            ControllerClass = class<AIController>(DynamicLoadObject(self.SpawnInfo[int(CT)].ControllerClassName, Class'Core.Class'));
            // End:0x144
            if(ControllerClass == none)
            {
                continue;                
            }
            else
            {
                PawnClasses.AddItem(PawnClass);
                ControllerClasses.AddItem(ControllerClass);                
            }
        }
    }    
    I = SpawnedCreatures.Length - 1;
    J0x189:

    // End:0x25C [Loop If]
    if(I >= 0)
    {
        // End:0x1F6
        if((SpawnedCreatures[I] == none) || SpawnedCreatures[I].Health <= 0)
        {
            SpawnedCreatures.Remove(I, 1);
        }
        // End:0x24E
        if(SpawnedCreatures[I].MyArea == none)
        {
            SpawnedCreatures[I].MyArea = self;
        }
        --I;
        // [Loop Continue]
        goto J0x189;
    }
    I = 0;
    J0x267:

    // End:0x3DD [Loop If]
    if(SpawnedCreatures.Length < CreatureCount)
    {
        Random = Rand(PawnClasses.Length);
        currentCreature = Spawn(PawnClasses[Random],,, GetSpawnLocation(PawnClasses[Random]),,, true);
        // End:0x3CF
        if(currentCreature != none)
        {
            currentController = Spawn(ControllerClasses[Random],,, currentCreature.Location,,, true);
            EvilCreature(currentCreature).MyArea = self;
            currentController.Possess(currentCreature, false);
            EvilCreature(currentCreature).GotoState('Run');
            SpawnedCreatures.InsertItem(0, currentCreature);            
        }
        I++;
        // [Loop Continue]
        goto J0x267;
    }
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
    SpawnCreatureTypes[0]=.ECT_Bird
    SpawnInfo[0]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="EvilGameContent.EvilCreature_Bird")
    SpawnInfo[1]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="EvilGameContent.EvilCreature_Worm")
    SpawnInfo[2]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="EvilGameContent.EvilCreature_Spider")
    SpawnInfo[3]=(ControllerClassName="EvilGame.EvilAI_Creature",PawnClassName="EvilGameContent.EvilCreature_Skarab")
}