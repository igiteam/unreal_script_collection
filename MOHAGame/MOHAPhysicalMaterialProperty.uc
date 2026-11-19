class MOHAPhysicalMaterialProperty extends PhysicalMaterialPropertyBase
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EImpactType
{
    IMPACT_TYPE_BULLET,             // 0
    IMPACT_TYPE_BULLET_DEATH,       // 1
    IMPACT_TYPE_FOOTSTEP,           // 2
    IMPACT_TYPE_FOOTSTEP_SPRINT,    // 3
    IMPACT_TYPE_FOOTSTEP_HALT,      // 4
    IMPACT_TYPE_FOOTSTEP_PIVOT,     // 5
    IMPACT_TYPE_FOOTSTEP_JUMP,      // 6
    IMPACT_TYPE_FOOTSTEP_LAND,      // 7
    IMPACT_TYPE_FOOTSTEP_UPSTAIR,   // 8
    IMPACT_TYPE_FOOTSTEP_DOWNSTAIR, // 9
    IMPACT_TYPE_FOOTSTEP_CROUCH,    // 10
    IMPACT_TYPE_FOOTSTEP_CRAWL,     // 11
    IMPACT_TYPE_FOOTSTEP_FOOTLADDER,// 12
    IMPACT_TYPE_FOOTSTEP_MOUNT_LADDER,// 13
    IMPACT_TYPE_BODYFALL_SMALL,     // 14
    IMPACT_TYPE_BODYFALL_MEDIUM,    // 15
    IMPACT_TYPE_BODYFALL_HARD,      // 16
    IMPACT_TYPE_THUMP_HAND,         // 17
    IMPACT_TYPE_THUMP_LEG,          // 18
    IMPACT_TYPE_THUMP_HELMET,       // 19
    IMPACT_TYPE_HELMET_BOUNCE,      // 20
    IMPACT_TYPE_SHELL_CASING_LARGE, // 21
    IMPACT_TYPE_SHELL_CASING_SMALL, // 22
    IMPACT_TYPE_SHELL_CASING_SHOTGUN,// 23
    IMPACT_TYPE_MELEE_PISTOL,       // 24
    IMPACT_TYPE_MELEE_RIFLE,        // 25
    IMPACT_TYPE_MELEE_BAYONET,      // 26
    IMPACT_TYPE_MELEE_FIST,         // 27
    IMPACT_TYPE_MAX                 // 28
};

struct MaterialImpactEffect
{
    var() ParticleSystem ParticleTemplate;
    var() SoundCue ImpactSound;
    var() MaterialInstance DecalMaterial;
    var() float DecalWidth;
    var() float DecalHeight;

    structdefaultproperties
    {
        ParticleTemplate=none
        ImpactSound=none
        DecalMaterial=none
        DecalWidth=0.0000000
        DecalHeight=0.0000000
    }
};

var(BulletImpact) MaterialImpactEffect BulletImpact;
var(BulletImpact) MaterialImpactEffect BulletImpact_NPC;
var(BulletImpact) MaterialImpactEffect BulletImpact_Death;
var(BulletImpact) MaterialImpactEffect BulletImpact_Death_NPC;
var(Movement_PC) MaterialImpactEffect StepWalk_PC;
var(Movement_PC) MaterialImpactEffect StepSprint_PC;
var(Movement_PC) MaterialImpactEffect StepStop_PC;
var(Movement_PC) MaterialImpactEffect StepPivot_PC;
var(Movement_PC) MaterialImpactEffect StepJump_PC;
var(Movement_PC) MaterialImpactEffect StepLand_PC;
var(Movement_PC) MaterialImpactEffect StepStairUp_PC;
var(Movement_PC) MaterialImpactEffect StepStairDown_PC;
var(Movement_PC) MaterialImpactEffect CrouchWalk_PC;
var(Movement_PC) MaterialImpactEffect Crawl_PC;
var(Movement_PC) MaterialImpactEffect ClimbLadderFeet_PC;
var(Movement_PC) MaterialImpactEffect MountLadder_PC;
var(Movement_NPC_US) MaterialImpactEffect StepWalk_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect StepSprint_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect StepStop_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect StepPivot_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect StepJump_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect StepLand_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect StepStairUp_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect StepStairDown_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect CrouchWalk_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect Crawl_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect ClimbLadderFeet_NPC_US;
var(Movement_NPC_US) MaterialImpactEffect MountLadder_NPC_US;
var(Movement_NPC_GE) MaterialImpactEffect StepWalk_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect StepSprint_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect StepStop_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect StepPivot_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect StepJump_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect StepLand_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect StepStairUp_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect StepStairDown_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect CrouchWalk_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect Crawl_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect ClimbLadderFeet_NPC_GE;
var(Movement_NPC_GE) MaterialImpactEffect MountLadder_NPC_GE;
var(BodyFall_PC) MaterialImpactEffect BodyFallSml_PC;
var(BodyFall_PC) MaterialImpactEffect BodyFallMed_PC;
var(BodyFall_PC) MaterialImpactEffect BodyFallHard_PC;
var(BodyFall_PC) MaterialImpactEffect HandThump_PC;
var(BodyFall_PC) MaterialImpactEffect LegThump_PC;
var(BodyFall_PC) MaterialImpactEffect HelmetThump_PC;
var(BodyFall_NPC) MaterialImpactEffect BodyFallSml_NPC;
var(BodyFall_NPC) MaterialImpactEffect BodyFallMed_NPC;
var(BodyFall_NPC) MaterialImpactEffect BodyFallHard_NPC;
var(BodyFall_NPC) MaterialImpactEffect HandThump_NPC;
var(BodyFall_NPC) MaterialImpactEffect LegThump_NPC;
var(BodyFall_NPC) MaterialImpactEffect HelmetThump_NPC;
var(Helmet) MaterialImpactEffect HelmetBounce_NPC;
var(ShellCasing) MaterialImpactEffect SmallShellCasingImpact;
var(ShellCasing) MaterialImpactEffect SmallShellCasingImpact_NPC;
var(ShellCasing) MaterialImpactEffect LargeShellCasingImpact;
var(ShellCasing) MaterialImpactEffect LargeShellCasingImpact_NPC;
var(ShellCasing) MaterialImpactEffect ShotgunShellCasingImpact;
var(ShellCasing) MaterialImpactEffect ShotgunShellCasingImpact_NPC;
var(ShellCasing) MaterialImpactEffect RifleMeleeImpact;
var(ShellCasing) MaterialImpactEffect RifleMeleeImpact_NPC;
var(ShellCasing) MaterialImpactEffect PistolMeleeImpact;
var(ShellCasing) MaterialImpactEffect PistolMeleeImpact_NPC;
var(ShellCasing) MaterialImpactEffect BayonetMeleeImpact;
var(ShellCasing) MaterialImpactEffect BayonetMeleeImpact_NPC;
var(ShellCasing) MaterialImpactEffect FistMeleeImpact;
var(ShellCasing) MaterialImpactEffect FistMeleeImpact_NPC;

static function MaterialImpactEffect ChoosePawnEffect(MOHAIncludeClass.EPawnType PawnType, MaterialImpactEffect PCEffect, MaterialImpactEffect USEffect, MaterialImpactEffect GEEffect)
{
    switch(PawnType)
    {
        // End:0x15
        case 0:
            return PCEffect;
            // End:0x3D
            break;
        // End:0x23
        case 1:
            return USEffect;
            // End:0x3D
            break;
        // End:0x31
        case 2:
            return GEEffect;
            // End:0x3D
            break;
        // End:0xFFFF
        default:
            return USEffect;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03D
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03D    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03D
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03D
}

static function MaterialImpactEffect GetDefaultEffect(MOHAPhysicalMaterialProperty.EImpactType ImpactType, MOHAIncludeClass.EPawnType PawnType)
{
    local MaterialImpactEffect DefaultEffect, DefaultUSNPCEffect, DefaultGENPCEffect;

    switch(ImpactType)
    {
        // End:0x169
        case 0:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Default';
            DefaultEffect.DecalMaterial = DecalMaterial'HUS_VFX_DecalImpact.ConcreteHIt01';
            DefaultEffect.DecalWidth = 20.0000000;
            DefaultEffect.DecalHeight = 20.0000000;
            DefaultEffect.ParticleTemplate = ParticleSystem'HUS_VFX_concreteHIt.plaster_part';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Default_NPC';
            DefaultUSNPCEffect.DecalMaterial = DecalMaterial'HUS_VFX_DecalImpact.ConcreteHIt01';
            DefaultUSNPCEffect.DecalWidth = 20.0000000;
            DefaultUSNPCEffect.DecalHeight = 20.0000000;
            DefaultUSNPCEffect.ParticleTemplate = ParticleSystem'HUS_VFX_concreteHIt.plaster_part';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Default_NPC';
            DefaultGENPCEffect.DecalMaterial = DecalMaterial'HUS_VFX_DecalImpact.ConcreteHIt01';
            DefaultGENPCEffect.DecalWidth = 20.0000000;
            DefaultGENPCEffect.DecalHeight = 20.0000000;
            DefaultGENPCEffect.ParticleTemplate = ParticleSystem'HUS_VFX_concreteHIt.plaster_part';
            return ChoosePawnEffect(PawnType, DefaultEffect, DefaultUSNPCEffect, DefaultGENPCEffect);
            // End:0x932
            break;
        // End:0x2CB
        case 1:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Default';
            DefaultEffect.DecalMaterial = DecalMaterial'HUS_VFX_DecalImpact.ConcreteHIt01';
            DefaultEffect.DecalWidth = 20.0000000;
            DefaultEffect.DecalHeight = 20.0000000;
            DefaultEffect.ParticleTemplate = ParticleSystem'HUS_VFX_bloodHit.plaster_part';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Default_NPC';
            DefaultUSNPCEffect.DecalMaterial = DecalMaterial'HUS_VFX_DecalImpact.ConcreteHIt01';
            DefaultUSNPCEffect.DecalWidth = 20.0000000;
            DefaultUSNPCEffect.DecalHeight = 20.0000000;
            DefaultUSNPCEffect.ParticleTemplate = ParticleSystem'HUS_VFX_bloodHit.plaster_part';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.Projimpact_Bullet_Default_NPC';
            DefaultGENPCEffect.DecalMaterial = DecalMaterial'HUS_VFX_DecalImpact.ConcreteHIt01';
            DefaultGENPCEffect.DecalWidth = 20.0000000;
            DefaultGENPCEffect.DecalHeight = 20.0000000;
            DefaultGENPCEffect.ParticleTemplate = ParticleSystem'HUS_VFX_bloodHit.plaster_part';
            return ChoosePawnEffect(PawnType, DefaultEffect, DefaultUSNPCEffect, DefaultGENPCEffect);
            // End:0x932
            break;
        // End:0x351
        case 2:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepWalk_PC_Default';
            DefaultEffect.ParticleTemplate = ParticleSystem'HUS_VFX_footStep.footstep_part';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepWalk_NPC_US_Default';
            DefaultUSNPCEffect.ParticleTemplate = ParticleSystem'HUS_VFX_footStep.footstep_part';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepWalk_NPC_GE_Default';
            DefaultGENPCEffect.ParticleTemplate = ParticleSystem'HUS_VFX_footStep.footstep_part';
            // End:0x932
            break;
        // End:0x398
        case 4:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepStop_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepStop_NPC_US_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepStop_NPC_GE_Default';
            // End:0x932
            break;
        // End:0x3DF
        case 3:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepSprint_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepSprint_NPC_US_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepSprint_NPC_GE_Default';
            // End:0x932
            break;
        // End:0x426
        case 10:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.CrouchWalk_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.CrouchWalk_NPC_US_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.CrouchWalk_NPC_GE_Default';
            // End:0x932
            break;
        // End:0x42E
        case 11:
            // End:0x932
            break;
        // End:0x475
        case 6:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepJump_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepJump_NPC_US_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.StepJump_NPC_GE_Default';
            // End:0x932
            break;
        // End:0x4BC
        case 7:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.JumpLand_PC_Concrete';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.JumpLand_NPC_US_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.JumpLand_NPC_GE_Default';
            // End:0x932
            break;
        // End:0x503
        case 12:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.ClimbLadder_PC_US_WoodSolid';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.ClimbLadder_NPC_US_WoodSolid';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.MountLadder_NPC_GE_WoodSolid';
            // End:0x932
            break;
        // End:0x54A
        case 13:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.MountLadder_PC_US_WoodSolid';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.MountLadder_NPC_US_WoodSolid';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Footsteps.ClimbLadder_NPC_GE_WoodSolid';
            // End:0x932
            break;
        // End:0x591
        case 14:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyfallSoft_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyfallSoft_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyfallSoft_NPC_Default';
            // End:0x932
            break;
        // End:0x5D8
        case 15:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyfallMedium_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyfallMedium_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyfallMedium_NPC_Default';
            // End:0x932
            break;
        // End:0x61F
        case 16:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyfallHard_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyFallHard_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.BodyFallHard_NPC_Default';
            // End:0x932
            break;
        // End:0x666
        case 17:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.HandThump_NPC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.HandThump_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.HandThump_NPC_Default';
            // End:0x932
            break;
        // End:0x6AD
        case 18:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.LegThump_NPC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.LegThump_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.LegThump_NPC_Default';
            // End:0x932
            break;
        // End:0x6F4
        case 19:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.HelmetThump_NPC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.HelmetThump_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bodyfalls.HelmetThump_NPC_Default';
            // End:0x932
            break;
        // End:0x73B
        case 20:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.foley.HelmetBounceHard_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.foley.HelmetBounceHard_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.foley.HelmetBounceHard_Default';
            // End:0x932
            break;
        // End:0x782
        case 22:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_PC_Small_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_NPC_Small_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_NPC_Small_Default';
            // End:0x932
            break;
        // End:0x7C9
        case 21:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_PC_Large_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_NPC_Large_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_NPC_Large_Default';
            // End:0x932
            break;
        // End:0x810
        case 23:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_PC_Shotgun_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_NPC_Shotgun_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Bullets.ShellDrop_NPC_Shotgun_Default';
            // End:0x932
            break;
        // End:0x857
        case 25:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            // End:0x932
            break;
        // End:0x89E
        case 24:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            // End:0x932
            break;
        // End:0x8E5
        case 26:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            // End:0x932
            break;
        // End:0x92C
        case 27:
            DefaultEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_PC_Default';
            DefaultUSNPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            DefaultGENPCEffect.ImpactSound = SoundCue'Aud_GCm_FakeWAV.Clothing_And_Gear.Mvmt_MeleeImpact_NPC_Default';
            // End:0x932
            break;
        // End:0xFFFF
        default:
            // End:0x932
            break;
            break;
    }
    return ChoosePawnEffect(PawnType, DefaultEffect, DefaultUSNPCEffect, DefaultGENPCEffect);
    //return ReturnValue;    
}

function MaterialImpactEffect GetImpactEffect(MOHAPhysicalMaterialProperty.EImpactType ImpactType, MOHAIncludeClass.EPawnType PawnType)
{
    switch(ImpactType)
    {
        // End:0x2E
        case 0:
            return ChoosePawnEffect(PawnType, BulletImpact, BulletImpact_NPC, BulletImpact_NPC);
            // End:0x44E
            break;
        // End:0x55
        case 1:
            return ChoosePawnEffect(PawnType, BulletImpact_Death, BulletImpact_Death_NPC, BulletImpact_Death_NPC);
            // End:0x44E
            break;
        // End:0x7C
        case 2:
            return ChoosePawnEffect(PawnType, StepWalk_PC, StepWalk_NPC_US, StepWalk_NPC_GE);
            // End:0x44E
            break;
        // End:0xA3
        case 3:
            return ChoosePawnEffect(PawnType, StepSprint_PC, StepSprint_NPC_US, StepSprint_NPC_GE);
            // End:0x44E
            break;
        // End:0xCA
        case 4:
            return ChoosePawnEffect(PawnType, StepStop_PC, StepStop_NPC_US, StepStop_NPC_GE);
            // End:0x44E
            break;
        // End:0xF1
        case 5:
            return ChoosePawnEffect(PawnType, StepPivot_PC, StepPivot_NPC_US, StepPivot_NPC_GE);
            // End:0x44E
            break;
        // End:0x118
        case 6:
            return ChoosePawnEffect(PawnType, StepJump_PC, StepJump_NPC_US, StepJump_NPC_GE);
            // End:0x44E
            break;
        // End:0x13F
        case 7:
            return ChoosePawnEffect(PawnType, StepLand_PC, StepLand_NPC_US, StepLand_NPC_GE);
            // End:0x44E
            break;
        // End:0x166
        case 8:
            return ChoosePawnEffect(PawnType, StepStairUp_PC, StepStairUp_NPC_US, StepStairUp_NPC_GE);
            // End:0x44E
            break;
        // End:0x18D
        case 9:
            return ChoosePawnEffect(PawnType, StepStairDown_PC, StepStairDown_NPC_US, StepStairDown_NPC_GE);
            // End:0x44E
            break;
        // End:0x1B4
        case 10:
            return ChoosePawnEffect(PawnType, CrouchWalk_PC, CrouchWalk_NPC_US, CrouchWalk_NPC_GE);
            // End:0x44E
            break;
        // End:0x1DB
        case 11:
            return ChoosePawnEffect(PawnType, Crawl_PC, Crawl_NPC_US, Crawl_NPC_GE);
            // End:0x44E
            break;
        // End:0x202
        case 12:
            return ChoosePawnEffect(PawnType, ClimbLadderFeet_PC, ClimbLadderFeet_NPC_US, ClimbLadderFeet_NPC_GE);
            // End:0x44E
            break;
        // End:0x229
        case 13:
            return ChoosePawnEffect(PawnType, MountLadder_PC, MountLadder_NPC_US, MountLadder_NPC_GE);
            // End:0x44E
            break;
        // End:0x250
        case 14:
            return ChoosePawnEffect(PawnType, BodyFallSml_PC, BodyFallSml_NPC, BodyFallSml_NPC);
            // End:0x44E
            break;
        // End:0x277
        case 15:
            return ChoosePawnEffect(PawnType, BodyFallMed_PC, BodyFallMed_NPC, BodyFallMed_NPC);
            // End:0x44E
            break;
        // End:0x29E
        case 16:
            return ChoosePawnEffect(PawnType, BodyFallHard_PC, BodyFallHard_NPC, BodyFallHard_NPC);
            // End:0x44E
            break;
        // End:0x2C5
        case 17:
            return ChoosePawnEffect(PawnType, HandThump_PC, HandThump_NPC, HandThump_NPC);
            // End:0x44E
            break;
        // End:0x2EC
        case 18:
            return ChoosePawnEffect(PawnType, LegThump_PC, LegThump_NPC, LegThump_NPC);
            // End:0x44E
            break;
        // End:0x313
        case 19:
            return ChoosePawnEffect(PawnType, HelmetThump_PC, HelmetThump_NPC, HelmetThump_NPC);
            // End:0x44E
            break;
        // End:0x33A
        case 22:
            return ChoosePawnEffect(PawnType, SmallShellCasingImpact, SmallShellCasingImpact_NPC, SmallShellCasingImpact_NPC);
            // End:0x44E
            break;
        // End:0x361
        case 21:
            return ChoosePawnEffect(PawnType, LargeShellCasingImpact, LargeShellCasingImpact_NPC, LargeShellCasingImpact_NPC);
            // End:0x44E
            break;
        // End:0x388
        case 23:
            return ChoosePawnEffect(PawnType, ShotgunShellCasingImpact, ShotgunShellCasingImpact_NPC, ShotgunShellCasingImpact_NPC);
            // End:0x44E
            break;
        // End:0x3AF
        case 24:
            return ChoosePawnEffect(PawnType, PistolMeleeImpact, PistolMeleeImpact_NPC, PistolMeleeImpact_NPC);
            // End:0x44E
            break;
        // End:0x3D6
        case 25:
            return ChoosePawnEffect(PawnType, RifleMeleeImpact, RifleMeleeImpact_NPC, RifleMeleeImpact_NPC);
            // End:0x44E
            break;
        // End:0x3FD
        case 26:
            return ChoosePawnEffect(PawnType, BayonetMeleeImpact, BayonetMeleeImpact_NPC, BayonetMeleeImpact_NPC);
            // End:0x44E
            break;
        // End:0x424
        case 27:
            return ChoosePawnEffect(PawnType, FistMeleeImpact, FistMeleeImpact_NPC, FistMeleeImpact_NPC);
            // End:0x44E
            break;
        // End:0x44B
        case 20:
            return ChoosePawnEffect(PawnType, HelmetBounce_NPC, HelmetBounce_NPC, HelmetBounce_NPC);
            // End:0x44E
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return ReturnValue;    
}

static function SoundCue GetImpactSound(PhysicalMaterial HitMaterial, MOHAPhysicalMaterialProperty.EImpactType ImpactType, MOHAIncludeClass.EPawnType PawnType)
{
    local MOHAPhysicalMaterialProperty PhysicalProperty;
    local MaterialImpactEffect ImpactEffect;

    // End:0x2A
    if(none == HitMaterial)
    {
        return GetDefaultEffect(ImpactType, PawnType).ImpactSound;
    }
    PhysicalProperty = MOHAPhysicalMaterialProperty(HitMaterial.GetPhysicalMaterialProperty(Class'MOHAPhysicalMaterialProperty'));
    // End:0x7B
    if(PhysicalProperty != none)
    {
        ImpactEffect = PhysicalProperty.GetImpactEffect(ImpactType, PawnType);
    }
    // End:0xB0
    if((PhysicalProperty != none) && ImpactEffect.ImpactSound != none)
    {
        return ImpactEffect.ImpactSound;        
    }
    else
    {
        // End:0xEA
        if(HitMaterial.Parent != none)
        {
            return GetImpactSound(HitMaterial.Parent, ImpactType, PawnType);            
        }
        else
        {
            return GetDefaultEffect(ImpactType, PawnType).ImpactSound;
        }
    }
    //return ReturnValue;    
}

static function MaterialInstance GetDecal(PhysicalMaterial HitMaterial, MOHAPhysicalMaterialProperty.EImpactType ImpactType, MOHAIncludeClass.EPawnType PawnType, out float DecalWidth, out float DecalHeight)
{
    local MOHAPhysicalMaterialProperty PhysicalProperty;
    local MaterialImpactEffect ImpactEffect;

    // End:0x5F
    if(none == HitMaterial)
    {
        ImpactEffect = GetDefaultEffect(ImpactType, PawnType);
        DecalWidth = ImpactEffect.DecalWidth;
        DecalHeight = ImpactEffect.DecalWidth;
        return ImpactEffect.DecalMaterial;
    }
    PhysicalProperty = MOHAPhysicalMaterialProperty(HitMaterial.GetPhysicalMaterialProperty(Class'MOHAPhysicalMaterialProperty'));
    // End:0xB0
    if(PhysicalProperty != none)
    {
        ImpactEffect = PhysicalProperty.GetImpactEffect(ImpactType, PawnType);
    }
    // End:0x10F
    if((PhysicalProperty != none) && ImpactEffect.DecalMaterial != none)
    {
        DecalWidth = ImpactEffect.DecalWidth;
        DecalHeight = ImpactEffect.DecalHeight;
        return ImpactEffect.DecalMaterial;        
    }
    else
    {
        // End:0x153
        if(HitMaterial.Parent != none)
        {
            return GetDecal(HitMaterial.Parent, ImpactType, PawnType, DecalWidth, DecalHeight);            
        }
        else
        {
            ImpactEffect = GetDefaultEffect(ImpactType, PawnType);
            DecalWidth = ImpactEffect.DecalWidth;
            DecalHeight = ImpactEffect.DecalWidth;
            return ImpactEffect.DecalMaterial;
        }
    }
    //return ReturnValue;    
}

static function ParticleSystem GetParticleSystem(PhysicalMaterial HitMaterial, MOHAPhysicalMaterialProperty.EImpactType ImpactType, MOHAIncludeClass.EPawnType PawnType)
{
    local MOHAPhysicalMaterialProperty PhysicalProperty;
    local MaterialImpactEffect ImpactEffect;

    // End:0x2A
    if(HitMaterial == none)
    {
        return GetDefaultEffect(ImpactType, PawnType).ParticleTemplate;
    }
    PhysicalProperty = MOHAPhysicalMaterialProperty(HitMaterial.GetPhysicalMaterialProperty(Class'MOHAPhysicalMaterialProperty'));
    // End:0x7B
    if(PhysicalProperty != none)
    {
        ImpactEffect = PhysicalProperty.GetImpactEffect(ImpactType, PawnType);
    }
    // End:0xB0
    if((PhysicalProperty != none) && ImpactEffect.ParticleTemplate != none)
    {
        return ImpactEffect.ParticleTemplate;        
    }
    else
    {
        // End:0xEA
        if(HitMaterial.Parent != none)
        {
            return GetParticleSystem(HitMaterial.Parent, ImpactType, PawnType);            
        }
        else
        {
            return GetDefaultEffect(ImpactType, PawnType).ParticleTemplate;
        }
    }
    //return ReturnValue;    
}
