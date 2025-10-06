(* ======================================== *)
(* PROGRAM: DoErrorZeroValve *)
(* TYPE: section *)
(* TASK: MAST *)
(* SECTION ORDER: 2 *)
(* ======================================== *)

IF Do_Error = 2 THEN

	Emulate_Valve[0].End_Open := TRUE;
	Emulate_Valve[0].End_Close := TRUE;

ELSIF Do_Error = 3 THEN

	Valve[0].DO_Motor_Open := TRUE;
	Valve[0].DO_Motor_Close := TRUE;


ELSIF Do_Error = 12 THEN

	Emulate_Valve[0].End_Open := FALSE;
	Emulate_Valve[0].End_Close := FALSE;
	Do_Error := 0;

ELSIF Do_Error = 13 THEN

	Valve[0].DO_Motor_Open := FALSE;
	Valve[0].DO_Motor_Close := FALSE;
	Do_Error := 0;	

END_IF;