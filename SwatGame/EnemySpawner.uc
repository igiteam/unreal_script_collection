class EnemySpawner extends Spawner
    native
    placeable;

// the Patrol List for the Enemy, defined by the designer in UnrealEd and 
// passed to the Enemy at spawning
var() editinline nocopy PatrolList EnemyPatrol;

var() bool SpawnAnInvestigator "Setting this to true will spawn investigating Enemies, setting it to false will spawn barricading Enemies";

// our overridden Idle Category
var() name IdleCategoryOverride;





















// Decompiled with UE Explorer.
defaultproperties
{
    ArchetypeClass=Class'EnemyArchetype'
    SpawnerSprites[0]=Texture'EditorSprites.Spawner_Enemy'
    SpawnerSprites[1]=Texture'EditorSprites.Spawner_Enemy_Slave'
    SpawnerSprites[2]=Texture'EditorSprites.Spawner_Enemy_SlaveOnly'
    SpawnerSprites[3]=Texture'EditorSprites.Spawner_Enemy_Custom'
    SpawnerSprites[4]=Texture'EditorSprites.Spawner_Enemy_Patrol'
    SpawnerSprites[5]=Texture'EditorSprites.Spawner_Enemy_Slave_Patrol'
    SpawnerSprites[6]=Texture'EditorSprites.Spawner_Enemy_SlaveOnly_Patrol'
    SpawnerSprites[7]=Texture'EditorSprites.Spawner_Enemy_Custom_Patrol'
    Texture=Texture'EditorSprites.Spawner_Enemy'
}