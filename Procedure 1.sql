CREATE PROCEDURE CalculateInterest 
    @account_number INT
AS
BEGIN
    DECLARE @interest_rate FLOAT;
    DECLARE @monthly_interest_rate FLOAT;
	DECLARE @days_in_year INT;
	DECLARE @days_in_month INT;
    DECLARE @amount FLOAT;
    DECLARE @remaining_amount FLOAT;
    DECLARE @term INT;
    DECLARE @start_date DATE;
    DECLARE @penalty FLOAT;
    DECLARE @current_date DATE;

    SET @current_date = GETDATE();

    SELECT @interest_rate = interest_rate, @amount = amount, @term = term, @start_date = start_date 
    FROM Credit_contract
    WHERE account_number = @account_number;

    IF @interest_rate IS NOT NULL
    BEGIN
       SET @days_in_year = CASE WHEN YEAR(GETDATE()) % 4 = 0 THEN 366 ELSE 365 END;
        SET @days_in_month = DAY(EOMONTH(GETDATE()));
        SET @monthly_interest_rate = (@interest_rate / @days_in_year) * @days_in_month;
        SET @remaining_amount = @amount;

        WHILE @term > 0
        BEGIN
            SET @remaining_amount = @remaining_amount * (1 + @monthly_interest_rate);

            IF @current_date > DATEADD(MONTH, @term, @start_date)
            BEGIN
                SET @penalty = @remaining_amount * 0.01 * DATEDIFF(DAY, DATEADD(MONTH, @term, @start_date), @current_date);
                SET @remaining_amount = @remaining_amount + @penalty;
            END
            
            SET @term = @term - 1;
        END

        IF @current_date > DATEADD(DAY, 10, DATEADD(MONTH, @term, @start_date))
        BEGIN
            SET @penalty = @remaining_amount * 0.15;
            SET @remaining_amount = @remaining_amount + @penalty;
        END

        PRINT 'Client ' + CAST(@account_number AS VARCHAR) + ' owes ' + CAST(@remaining_amount AS VARCHAR);
    END
    ELSE
    BEGIN
        PRINT 'Client ' + CAST(@account_number AS VARCHAR) + ' does not have a credit.';
    END
END;