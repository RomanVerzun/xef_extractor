(* ======================================== *)
(* FUNCTION BLOCK: Valve_TON_case *)
(* VERSION: 0.01 *)
(* Use TON for Valve (multiple tons for Valves) *)
(* ======================================== *)

(* INPUT PARAMETERS *)
  Iterator : INT;
  IN : BOOL;
  PT : TIME;

(* OUTPUT PARAMETERS *)
  Q : BOOL;
  ET : TIME;

(* PRIVATE VARIABLES *)
  TON_0 : TON;
  TON_1 : TON;


(* -------- PROGRAM: Choose_TON -------- *)
CASE Iterator OF
0: TON_0 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET); 

1: TON_1 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET); 
 
END_CASE;
