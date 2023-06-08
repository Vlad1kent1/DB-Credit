CREATE PROCEDURE GetClientContracts
    @account_number INT
AS
BEGIN
    SELECT * FROM Credit_contract 
    WHERE account_number = @account_number;
END;