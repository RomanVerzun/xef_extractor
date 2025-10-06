(* ======================================== *)
(* FUNCTION BLOCK: Transp_DriftTimer *)
(* VERSION: 0.05 *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;

(* PRIVATE VARIABLES *)
  TON_1_1 : Transp_TON_case;
  TON_1_2 : Transp_TON_case;
  TON_2_1 : Transp_TON_case;
  TON_2_2 : Transp_TON_case;
  Time_ms : INT;
  Stop : Transp_Stop;


(* -------- PROGRAM: DriftTimer -------- *)
Time_ms := 3000; (* 3 секунди *)
IF PROJECT.transp[iterator].DI_BeltDrift[0].DriftBelt THEN
	TON_1_1 (Iterator := Iterator,
           IN := TRUE,
           PT := INT_TO_TIME(Time_ms),
           Q => PROJECT.transp[iterator].DI_BeltDrift[0].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[0].TON_ElapsedTime); 
ELSE 
	TON_1_1 (Iterator := Iterator,
           IN := FALSE,
           PT := INT_TO_TIME(0),
           Q => PROJECT.transp[iterator].DI_BeltDrift[0].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[0].TON_ElapsedTime);
END_IF;


IF PROJECT.transp[iterator].DI_BeltDrift[1].DriftBelt THEN
	TON_1_2 (Iterator := Iterator,
           IN := TRUE,
           PT := INT_TO_TIME(Time_ms),
           Q => PROJECT.transp[iterator].DI_BeltDrift[1].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[1].TON_ElapsedTime); 
ELSE 
	TON_1_2 (Iterator := Iterator,
           IN := FALSE,
           PT := INT_TO_TIME(0),
           Q => PROJECT.transp[iterator].DI_BeltDrift[1].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[1].TON_ElapsedTime);
END_IF;


IF PROJECT.transp[iterator].DI_BeltDrift[2].DriftBelt THEN
	TON_2_1 (Iterator := Iterator,
           IN := TRUE,
           PT := INT_TO_TIME(Time_ms),
           Q => PROJECT.transp[iterator].DI_BeltDrift[2].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[2].TON_ElapsedTime); 
ELSE 
	TON_2_1 (Iterator := Iterator,
           IN := FALSE,
           PT := INT_TO_TIME(0),
           Q => PROJECT.transp[iterator].DI_BeltDrift[2].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[2].TON_ElapsedTime);
END_IF;

IF PROJECT.transp[iterator].DI_BeltDrift[3].DriftBelt THEN
	TON_2_2 (Iterator := Iterator,
           IN := TRUE,
           PT := INT_TO_TIME(Time_ms),
           Q => PROJECT.transp[iterator].DI_BeltDrift[3].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[3].TON_ElapsedTime); 
ELSE 
	TON_2_2 (Iterator := Iterator,
           IN := FALSE,
           PT := INT_TO_TIME(0),
           Q => PROJECT.transp[iterator].DI_BeltDrift[3].TON_Q,
           ET => PROJECT.transp[iterator].DI_BeltDrift[3].TON_ElapsedTime);
END_IF;

IF PROJECT.transp[iterator].DI_BeltDrift[0].TON_Q OR
	PROJECT.transp[iterator].DI_BeltDrift[1].TON_Q OR
	PROJECT.transp[iterator].DI_BeltDrift[2].TON_Q OR
	PROJECT.transp[iterator].DI_BeltDrift[3].TON_Q THEN

(*Error*)
	PROJECT.transp[iterator].errno := PROJECT.Errors_t.Err_BeltDrift;

	PROJECT.transp[iterator].DI_BeltDrift[0].ErrorBelt := 
		PROJECT.transp[iterator].DI_BeltDrift[0].ErrorBelt OR PROJECT.transp[iterator].DI_BeltDrift[0].TON_Q;

	PROJECT.transp[iterator].DI_BeltDrift[1].ErrorBelt := 
		PROJECT.transp[iterator].DI_BeltDrift[1].ErrorBelt OR PROJECT.transp[iterator].DI_BeltDrift[1].TON_Q;

	PROJECT.transp[iterator].DI_BeltDrift[2].ErrorBelt := 
		PROJECT.transp[iterator].DI_BeltDrift[2].ErrorBelt OR PROJECT.transp[iterator].DI_BeltDrift[2].TON_Q;

	PROJECT.transp[iterator].DI_BeltDrift[3].ErrorBelt := 
		PROJECT.transp[iterator].DI_BeltDrift[3].ErrorBelt OR PROJECT.transp[iterator].DI_BeltDrift[3].TON_Q;


(*stop func*)

	stop( Iterator := Iterator );
(*alarm on*)

END_IF;
