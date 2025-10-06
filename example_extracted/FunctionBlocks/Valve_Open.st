(* ======================================== *)
(* FUNCTION BLOCK: Valve_Open *)
(* VERSION: 0.19 *)
(* Open Valve *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;


(* -------- PROGRAM: Open_valve -------- *)
IF (PROJECT.Valve[Iterator].errno <> PROJECT.Errors_t.NO_Err) OR 
	(PROJECT.Valve[Iterator].DO_Motor_Enable) THEN
	return;
end_if;

IF (PROJECT.Valve[Iterator].State = PROJECT.states_t.Close) OR
 	(PROJECT.Valve[Iterator].State = PROJECT.states_t.Middle) THEN
	PROJECT.Valve[Iterator].DO_Motor_Open := TRUE;
	PROJECT.Valve[Iterator].DO_Motor_Enable := TRUE;
(*	PROJECT.Valve[Iterator].DO_Motor_Close := FALSE; *)
	
ELSIF PROJECT.Valve[Iterator].State = PROJECT.states_t.Open THEN
	return;
ELSE
	PROJECT.Valve[Iterator].Errno := PROJECT.Errors_t.Err_EndSwitchConflict;
END_IF;
