(* ======================================== *)
(* FUNCTION BLOCK: Valve_Close *)
(* VERSION: 0.12 *)
(* Close Valve *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;


(* -------- PROGRAM: Close_valve -------- *)
IF (PROJECT.Valve[Iterator].errno <> PROJECT.Errors_t.NO_Err) OR 
	(PROJECT.Valve[Iterator].DO_Motor_Enable) THEN
	return;
end_if;

IF (PROJECT.Valve[Iterator].State = PROJECT.states_t.Open) OR
	(PROJECT.Valve[Iterator].State = PROJECT.states_t.Middle) THEN
	PROJECT.Valve[Iterator].DO_Motor_Close := TRUE;
	PROJECT.Valve[Iterator].DO_Motor_Enable := TRUE;
(*	PROJECT.Valve[Iterator].DO_Motor_Open := FALSE; *)

ELSIF (PROJECT.Valve[Iterator].State = PROJECT.states_t.Close) THEN
	return;
ELSE
	PROJECT.Valve[Iterator].Errno := PROJECT.Errors_t.Err_EndSwitchConflict;
END_IF;
