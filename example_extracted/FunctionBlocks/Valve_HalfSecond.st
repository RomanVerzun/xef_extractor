(* ======================================== *)
(* FUNCTION BLOCK: Valve_HalfSecond *)
(* VERSION: 0.21 *)
(* Open for Half second *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  IS_Open : BOOL;
  Iterator : INT;
  Enable_Timer : BOOL;
  Enable_move : BOOL;

(* PRIVATE VARIABLES *)
  WorkTime_ms : DINT;
  TON : Valve_TON_case;
  Open_Valve : Valve_Open;
  Close_Valve : Valve_Close;
  Stop_Valve : Valve_Stop;


(* -------- PROGRAM: HalfSecond -------- *)
WorkTime_ms := 500; (* 500 ms *)

TON (Iterator := Iterator,
     IN := Enable_Timer,
     PT := DINT_TO_TIME(WorkTime_ms),
     Q => PROJECT.Valve[iterator].TON_Q,
     ET => PROJECT.Valve[iterator].TON_Elapsed_Time);

PROJECT.Valve[iterator].Half_sec_Timer := True;

IF IS_Open and Enable_move Then
	PROJECT.Valve[iterator].TON_Elapsed_Time := t#0s;
	Open_Valve(Iterator := iterator);
ELSIF Not IS_Open and Enable_move then
	PROJECT.Valve[iterator].TON_Elapsed_Time := t#0s;
	Close_Valve(Iterator := iterator);
END_IF;
	
IF PROJECT.Valve[iterator].Half_sec_Timer AND PROJECT.Valve[iterator].TON_Q THEN
	Stop_Valve(Iterator := iterator);
	TON (
	IN := FALSE,
	PT := INT_TO_TIME(0),
	Q => PROJECT.Valve[iterator].TON_Q,
     	ET => PROJECT.Valve[iterator].TON_Elapsed_Time);
	PROJECT.Valve[iterator].Half_sec_Timer := False;
END_IF;
