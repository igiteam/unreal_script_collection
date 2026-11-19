/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

interface AIObjectAvoidanceInterface;



function bool ShouldAvoid(TGAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function bool ShouldEvade(TGAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function bool ShouldRoadieRun(TGAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);


