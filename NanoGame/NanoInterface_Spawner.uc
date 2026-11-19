/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_Spawner extends Interface
	native;

event HandleSpawn(NanoPawnBase NewSpawn, int SlotIdx);
event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation);
/**
 * Register a factory with this spawner so that notifications
 * can be sent in case of being disabled.
 */
event RegisterFactory(SeqAct_AIFactory Factory);
/**
 * Unregister a factory from this spawner.
 */
event UnRegisterFactory(SeqAct_AIFactory Factory);
	
