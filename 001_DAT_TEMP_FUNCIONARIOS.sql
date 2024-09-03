--- Script ....: 001_DAT_TEMP_FUNCIONARIOS;
--- Autor......: José Vinicius 
--- Data ......: 30/07/2024
--- Descrição..: 
--- Documento..: 
--- meu comentario : para insert de outros registros mudar nome do script

SET DEFINE ON
SET SCAN ON
SET ECHO ON;
SET FEEDBACK ON;

/* Example of setting NLS_LANG and other settings */
/*
SET DEFINE ^ -- redefine como variavel
SET SCAN OFF;

No regedit a variável NLS_LANG 
 BRAZILIAN PORTUGUESE_BRAZIL.WE8MSWIN1252

Executar no DOS antes de chamar o sqlplus 

SET NLS_LANG = BRAZILIAN PORTUGUESE BRAZIL.WE8MSWIN1252

Na sessão do sqlplus 

Alter Session Set NLS_LANGUAGE = 'BRAZILIAN PORTUGUESE';
Alter Session Set NLS_TERRITORY = 'BRAZIL';

ou atualizar o atalho para cmd
       %windir%\system32\cmd.exe /k chcp 1252
*/

DEFINE USUARIO_OWNER=EQM_DEV_PROD;

SET SERVEROUTPUT ON
SET SERVEROUTPUT ON SIZE UNLIMITED;

BEGIN 
    DBMS_OUTPUT.PUT_LINE('ESQUEMA EXECUTOR =>"' || USER || '" ESQUEMA A SER ATUALIZADO => "' || '&USUARIO_OWNER' || '" DATA => ' || SYSDATE);   
END;
/

-- SETA O USUÁRIO DA SESSAO
ALTER SESSION SET CURRENT_SCHEMA=&USUARIO_OWNER;

DECLARE 
    V_CONT NUMBER;
    NOME_SCRIPT VARCHAR2(100);
    NUM_VERSAO  NUMBER;
    v_existe_log BOOLEAN;
BEGIN 
    DBMS_OUTPUT.ENABLE(NULL);  
    NOME_SCRIPT := '001_DAT_TEMP_FUNCIONARIOS';
    NUM_VERSAO := 998;

    v_existe_log := "&USUARIO_OWNER".FNC_SCRIPT_EXISTE_LOG(NOME_SCRIPT, NUM_VERSAO);

    DBMS_OUTPUT.PUT_LINE('v_existe_log: ' || CASE WHEN v_existe_log THEN 'TRUE' ELSE 'FALSE' END);

    IF v_existe_log THEN 
        -- DELETE FROM "&USUARIO_OWNER".TEMP_FUNCIONARIOS;

        INSERT INTO "&USUARIO_OWNER".TEMP_FUNCIONARIOS (
            NOME, FUNCAO, ENDERECO, CIDADE, SALARIO, CODG_FUNCIONARIO_PK
        ) 
        SELECT * FROM (
            SELECT 'John Doe' AS NOME, 
                   'Analyst' AS FUNCAO, 
                   '123 Maple Street' AS ENDERECO, 
                   'Springfield' AS CIDADE, 
                   5000 AS SALARIO, 
                   5 AS CODG_FUNCIONARIO_PK 
            FROM DUAL
            UNION ALL
            SELECT 'Jane Smith' AS NOME, 
                   'Manager' AS FUNCAO, 
                   '456 Oak Avenue' AS ENDERECO, 
                   'Riverside' AS CIDADE, 
                   8000 AS SALARIO, 
                   6 AS CODG_FUNCIONARIO_PK 
            FROM DUAL
            UNION ALL
            SELECT 'Alice Johnson' AS NOME, 
                   'Developer' AS FUNCAO, 
                   '789 Pine Road' AS ENDERECO, 
                   'Lakeside' AS CIDADE, 
                   7000 AS SALARIO, 
                   7 AS CODG_FUNCIONARIO_PK 
            FROM DUAL
            UNION ALL
            SELECT 'Bob Brown' AS NOME, 
                   'Architect' AS FUNCAO, 
                   '101 Elm Boulevard' AS ENDERECO, 
                   'Hillview' AS CIDADE, 
                   9500 AS SALARIO, 
                   8 AS CODG_FUNCIONARIO_PK 
            FROM DUAL
        ) V  
        WHERE NOT EXISTS (
            SELECT 1 
            FROM "&USUARIO_OWNER".TEMP_FUNCIONARIOS A
            WHERE A.CODG_FUNCIONARIO_PK = V.CODG_FUNCIONARIO_PK
        ); 

        DBMS_OUTPUT.PUT_LINE('Linhas inserida(s): ' || SQL%ROWCOUNT); 

        --   UPDATE "&USUARIO_OWNER".TEMP_FUNCIONARIOS SET;

        DBMS_OUTPUT.PUT_LINE('Linhas atualizada(s): ' || SQL%ROWCOUNT);
        COMMIT;   
    ELSE
        DBMS_OUTPUT.PUT_LINE('Script log check failed, insert not performed.');
    END IF;  -- EXISTE LOG

    "&USUARIO_OWNER".PCR_SCRIPT_LOG(NOME_SCRIPT, NUM_VERSAO, 'EXECUTADO COM SUCESSO', 'S');
EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        "&USUARIO_OWNER".PCR_SCRIPT_LOG(NOME_SCRIPT, NUM_VERSAO, SQLERRM, 'N');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END; 
/
SET SERVEROUTPUT OFF;
