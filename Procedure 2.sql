CREATE PROCEDURE CalculateInterestForAllClients
AS
BEGIN
    DECLARE @account_number INT;

    DECLARE client_cursor CURSOR FOR
    SELECT account_number
    FROM Client;

    OPEN client_cursor;

    FETCH NEXT FROM client_cursor INTO @account_number;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC CalculateInterest @account_number;

        FETCH NEXT FROM client_cursor INTO @account_number;
    END;

    CLOSE client_cursor;

    DEALLOCATE client_cursor;
END;