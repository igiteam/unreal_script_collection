/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

interface NanoInterface_Objective extends Interface
    dependson( NanoArchetypeTypes );

//// So our choices are to either have LOTS of interface functions here

/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent();


// try to get rid of this and use Owner.Location

/** Return location of objective, used by radar */
function vector GetObjectiveLocation();

