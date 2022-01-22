USE CompanieIT
GO



--Creați un trigger care nu va permite modificarea numelui unui dapartament
CREATE OR ALTER TRIGGER trigger1
ON Departamente
FOR UPDATE
AS
  BEGIN
    IF UPDATE(nume_dep)
		ROLLBACK
        RAISERROR ('Error, cannot update', 10, 5)
  END
GO


--Va returna o eroare
/*
UPDATE Departamente
SET nume_dep = 'Nume'
WHERE IdDepartament = 1
*/



/* Creați un trigger care afișează un mesaj in momentul in care datele unui
angajat sunt modificate și un mesaj atunci cind un angajat este sters */
CREATE OR ALTER TRIGGER trigger2
ON Angajati
AFTER UPDATE, DELETE
AS
  BEGIN
	  IF UPDATE(nume) OR UPDATE(prenume) OR UPDATE(CNP) OR UPDATE(strada)
		OR UPDATE(nr_str) OR UPDATE(gen) OR UPDATE(data_nast) OR UPDATE(salariu)
		OR UPDATE(IdDepartament) OR UPDATE(staj)
		BEGIN
			PRINT 'Datele s-au modificat'
		END

	  IF (SELECT COUNT(*) FROM deleted) > 0
			PRINT 'Au fost sterse date' 

  END
GO


UPDATE Angajati SET nume = 'Chirtoaca' WHERE nume = 'Rata'
DELETE FROM Angajati WHERE nume = 'Covali'
INSERT INTO Angajati VALUES (12, 'Covali', 'Eugenia', 123, 'str.Independentei', '32/1', 'f', '13.06.1997', 8000, 4, 3)
GO

/* Creați un trigger care nu va permite introducerea a doua departamente cu acelas nume */
CREATE OR ALTER TRIGGER trigger3
    ON Departamente
    INSTEAD OF INSERT
    AS
    BEGIN
        DECLARE @NumeDep nvarchar(50)
        DECLARE cursor_ins CURSOR FOR SELECT * FROM inserted

        OPEN cursor_ins
        FETCH NEXT FROM cursor_ins INTO @NumeDep
        WHILE @@FETCH_STATUS = 0
            BEGIN
                IF (SELECT COUNT(*) FROM Departamente WHERE nume_dep = @NumeDep) = 0
                    INSERT INTO Departamente SELECT * FROM inserted 
                ELSE
                    RAISERROR ('Deja exista un departament cu acest nume', 17, 1)


                FETCH NEXT FROM cursor_ins INTO @NumeDep
            END

        CLOSE cursor_ins
        DEALLOCATE cursor_ins
    END
GO
