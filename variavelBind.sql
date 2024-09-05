
---------------------------------------VARIAVEL BIND------------------------------------------------------------------

--essa variavel eh declarada fora do comando declare do oracle
-- e para referenciar ela  voce usa os ':' + a Variavel no bloco begin 
-- neste trecho voce atribui valor a ela.



SET SERVEROUTPUT ON

VARIABLE gMedia NUMBER

DECLARE 
	vNumero1 NUMBER(11,2) := 6000;
	vNumero2 NUMBER(11,2) := 7000;
	
BEGIN
	:gMedia := (vNumero1 + vNumero2) /2;
	DBMS_OUTPUT.PUT_LINE('Media = '|| TO_CHAR(:gMedia)); --O TO_CHAR CONVERTE O VALOR PARA CHARACTER

EXCEPTION
	WHEN OTHERS
	THEN
	DBMS_OUTPUT.PUT_LINE('ERRO ORACLE '|| SQLCODE ||SQLERRM);
	
END;
