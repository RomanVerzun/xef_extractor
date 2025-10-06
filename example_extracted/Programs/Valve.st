(* ======================================== *)
(* PROGRAM: Valve *)
(* TYPE: section *)
(* TASK: MAST *)
(* SECTION ORDER: 1 *)
(* ======================================== *)

FOR Valve_iterator := 0 TO Valve_count DO
	Process_Valve (Iterator := Valve_iterator);
END_FOR;