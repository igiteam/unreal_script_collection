// FHPlayer class
// Robert Lamb
// 4/12/2011
// All Players in our game inherit from this class
// This will help support different "kinds" of Players, if needed
// This will also help support multiple players, if that ever happens

class FHPlayer extends UTPawn;

var bool      bPlayerCanDodge;      // Player cannot dodge if false
var bool      bInvulnerable;        // Player is Invul if true
var float     StartTimeInSeconds;   // keeps track of when the game started, for scoring purposes
var float     SurvivalTimeInSeconds;// calculated when game is over
var float     PlayerScore;          // calculated when game is over
var bool      bIsDead;
var bool      bShowingInventory;    // toggle inventory

var Color junkColor;
var Vector junkVector;

var FHPlayerController pController;
var array <FHMonster> Monsters;

var array <FHSeqVar_InventoryCategory> playerInventory;

var Actor Checkpoint;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// System Overrides
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

            simulated function PostBeginPlay () // must be simulated because Super is simulated
                {
                Super.PostBeginPlay();
                InitializePlayer();
                }

            function bool Dodge(eDoubleClickDir DoubleClickMove)
                {
                if (!bPlayerCanDodge) return false;
                return PlayerDodge (DoubleClickMove);
                }

            event Bump (Actor Other, PrimitiveComponent otherComp, Vector hitNormal)
                {
                PlayerBumped (Other);
                }

            function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
                {
	            if (Super.Died(Killer, DamageType, HitLocation))
	                {
                    PlayerDied();   // might need the other params eventually
		            return true;
	                }
	            return false;
                }

            simulated function Tick (float deltaSeconds)
                {
                PlayerTick (deltaSeconds);
                }

function TakeDrowningDamage() {}

////////simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
////////{
////////local SkeletalMesh sm;
////////	super.SetCharacterClassFromInfo(Info);
////////	sm = SkeletalMesh'ClarkePackage.Clarke56';

////////	//SetCharacterMeshInfo(Info.default.CharacterMesh, TeamMaterialHead, TeamMaterialBody);
////////	SetCharacterMeshInfo(sm, TeamMaterialHead, TeamMaterialBody);
////////}

//////////////////////////////////////////////////////////////////////////////
// Player Functionality
// save the player controller so we have access to post processing stuffs
function    SetController(FHPlayerController fhpc)
{
	pController = fhpc;
}

function      PlayerBumped     (Actor Other) {}
function bool PlayerDodge      (eDoubleClickDir DoubleClickMove) { return Super.Dodge (DoubleClickMove); }
function      PlayerTick       (float deltaSeconds) 
	{
	if (bShowingInventory)
		{
		FHPlayerController(Controller).DrawInventory(playerInventory);
		}
	FHPlayerController(Controller).SetInventory(playerInventory);
	}

function InitializePlayer ()
    {
    FindAllMonsters ();

	StartTimeInSeconds = WorldInfo.TimeSeconds;
    }

function PlayerDied ()
    {
	bIsDead = true;
    CalculateScore (false);
    }

function PlayerWon ()
    {
    CalculateScore (true);
    }

function float CalculateSurvivalTime ()
    {
	SurvivalTimeInSeconds = WorldInfo.TimeSeconds - StartTimeInSeconds ;
    return SurvivalTimeInSeconds;
    }

function float CalculateScore (bool bLevelCompleted)
    {
        // Note: Score calculation is a work in progress and expected to evolve
        // At the time of this coding (4/21/11) the blog has the following scoring equation:
        // Score = SurvivalTimeInSeconds * 5 + NumberOfEscapes * 10000.
        // Personally, I think there will need to be modifiers based on the actual level,
        // ie, some levels will be easier/harder to survive or escape than others.
        // Escapes seems to be defined as escaping from the maze, ie, level completion.
    CalculateSurvivalTime ();
    PlayerScore += 5 * SurvivalTimeInSeconds;
    if (bLevelCompleted) PlayerScore += 10000;
    return PlayerScore;
    }

function FindAllMonsters()
    {
	local FHMonster lMonster;

  	ForEach DynamicActors(class'FHMonster', lMonster)
	    {
        Monsters.AddItem (lMonster);
        lMonster.SetPlayer (self);
	    }
    LogInternal("FHPlayer found " $ Monsters.Length $ " Monsters ++++++++++++++++++++++++++++++++++   +++");
    }

function AddInventoryItem (FHSeqAct_AddInventoryItem item)
	{
	local FHSeqVar_InventoryCategory cat;
	local FHSeqVar_InventoryItem     newItem;

	foreach playerInventory(cat)
		{
		if (cat.categoryName == item.itemCategory)
			{
			newItem              = new class'FHSeqVar_InventoryItem';
			newItem.itemName     = item.itemName;
			newItem.itemCategory = item.itemCategory;
			newItem.itemQuantity = item.itemQuantity;
			cat.itemList.AddItem (newItem);
			LogInternal("added item");
			return;
			}
		}
	}

function AddInventoryCategory (FHSeqAct_InventorySetup cat)
	{
	local FHSeqVar_InventoryCategory newCategory;

	newCategory                  = new class'FHSeqVar_InventoryCategory';
	newCategory.categoryName     = cat.categoryName;
	newCategory.categoryQuantity = cat.categoryQuantity;
	newCategory.categoryColor    = cat.categoryColor;
	newCategory.categoryFont     = cat.categoryFont;
	playerInventory.AddItem (newCategory);

	LogInternal("added category");
	}

exec function ShowMyInventory ()
	{
	bShowingInventory = !bShowingInventory;
	}

// Invul() toggles Invulnerability, used for testing
exec function Invul ()
{
    bInvulnerable = !bInvulnerable;
    LogInternal("FHNormalPlayer.Invul() -- Invulnerabily is now " $ bInvulnerable);
}


// Decompiled with UE Explorer.
defaultproperties
{
    SurvivalTimeInSeconds=-1.0000000
    junkColor=(R=255,G=255,B=255,A=255)
    // Reference: DynamicLightEnvironmentComponent'Default__FHPlayer.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    SoundGroupClass=Class'FHPawnSounds'
    // Reference: ForceFeedbackWaveform'Default__FHPlayer.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    MaxMultiJump=0
    // Reference: UTAmbientSoundComponent'Default__FHPlayer.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__FHPlayer.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__FHPlayer.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__FHPlayer.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__FHPlayer.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__FHPlayer.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__FHPlayer.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    JumpZ=450.0000000
    // Reference: SkeletalMeshComponent'Default__FHPlayer.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHPlayer.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__FHPlayer.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UTGame.Default__UTPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__FHPlayer.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Arrow'
    // Archetype: ArrowComponent'UTGame.Default__UTPawn.Arrow'
    begin object name="Arrow"
        ReplacementPrimitive=none
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    CollisionComponent=CollisionCylinder
}