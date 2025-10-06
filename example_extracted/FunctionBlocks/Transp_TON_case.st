(* ======================================== *)
(* FUNCTION BLOCK: Transp_TON_case *)
(* VERSION: 0.01 *)
(* TON's for Transport *)
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
  TON_2 : TON;
  TON_3 : TON;
  TON_4 : TON;
  TON_5 : TON;
  TON_6 : TON;
  TON_7 : TON;
  TON_8 : TON;
  TON_9 : TON;


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

2: TON_2 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

3: TON_3 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

4: TON_4 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

5: TON_5 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

6: TON_6 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

7: TON_7 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

8: TON_8 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

9: TON_9 (IN := IN,
         PT := PT,
         Q => Q,
         ET => ET);

END_CASE;
