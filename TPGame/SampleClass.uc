//=============================================================================
// This is a sample native class, to serve as a minimal
// example of a class shared between UnrealScript and C++.
// Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class SampleClass extends Actor
	config(Game)
	placeable
	native;

// Declare some variables.
var			int		MyInteger;
var	config	string	MyString;
var			bool	MyBool;
var			vector	MyVector;
var	native	pointer MyPointer{FString};

// Here is a "native function", a function that is
// callable from UnrealScript but implemented in C++.
native function int SampleNativeFunction( int i, string s, vector v );

// Here is an "event", a function that is callable
// from C++ but implemented in UnrealScript.
event SampleEvent(int i)
{
	;
}

// Called when gameplay begins.
function PostBeginPlay()
{
	SetTimer(1,true);
}

// Called every 1 second, due to SetTimer call.
function Timer()
{
	MyInteger = MyInteger + 1;
	MyBool = !MyBool;
	;
	;
	SampleNativeFunction(MyInteger,"Testing",Location);
	;
}

