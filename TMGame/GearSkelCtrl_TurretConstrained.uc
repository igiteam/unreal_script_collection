/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class GearSkelCtrl_TurretConstrained extends TMSkelControl_TurretConstrained;

/** If TRUE, zero out any rotation component (yaw, pitch, roll) which is completely constrained. */
var(Constraint)	bool bZeroCompletelyConstrained;
