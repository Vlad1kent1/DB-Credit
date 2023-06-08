----Додав поля UCR, DCR, ULC, DLC в усі таблиці:
--ALTER TABLE Client ADD UCR VARCHAR(100), DCR DATETIME, ULC VARCHAR(100), DLC DATETIME;
--ALTER TABLE Credit_contract ADD UCR VARCHAR(100), DCR DATETIME, ULC VARCHAR(100), DLC DATETIME;
--ALTER TABLE Repayment_schedules ADD UCR VARCHAR(100), DCR DATETIME, ULC VARCHAR(100), DLC DATETIME;
--ALTER TABLE Payment ADD UCR VARCHAR(100), DCR DATETIME, ULC VARCHAR(100), DLC DATETIME;
--ALTER TABLE Money_accounting ADD UCR VARCHAR(100), DCR DATETIME, ULC VARCHAR(100), DLC DATETIME;
--ALTER TABLE Rating ADD UCR VARCHAR(100), DCR DATETIME, ULC VARCHAR(100), DLC DATETIME;


--CREATE TRIGGER tr_Client_BI
--ON Client
--AFTER INSERT
--AS
--BEGIN
--    UPDATE Client
--    SET DCR = GETDATE()
--    WHERE account_number IN (SELECT account_number FROM inserted);
--END;

--CREATE TRIGGER tr_Client_BU
--ON Client
--AFTER UPDATE
--AS
--BEGIN
--    UPDATE Client
--    SET DLC = GETDATE()
--    WHERE account_number IN (SELECT account_number FROM inserted);
--END;

----Чотири випадки прияких не видається кредит
--CREATE TRIGGER CheckNewCredit
--ON Credit_contract
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @overdue_credit INT;
--    DECLARE @schedule_breach INT;
--    DECLARE @insufficient_balance INT;
--    DECLARE @bottom_quartile INT;

--    -- 1. якщо він мав коли-небудь прострочений кредит, тобто не розрахувався до закінчення строку дії договору;
--    SELECT @overdue_credit = COUNT(*)
--    FROM Repayment_schedules
--    JOIN Credit_contract ON Repayment_schedules.contract_number = Credit_contract.contract_number
--    WHERE account_number IN (SELECT account_number FROM inserted) AND date_payment > DATEADD(DAY, term, start_date);

--    IF @overdue_credit > 0 
--    BEGIN
--        THROW 50000, 'Cannot grant new credit: client had an overdue credit', 1;
--    END

--    -- 2. якщо він порушує графік планових платежів за ще діючим кредитом;
--    SELECT @schedule_breach = COUNT(*)
--    FROM Repayment_schedules
--    JOIN Credit_contract ON Repayment_schedules.contract_number = Credit_contract.contract_number
--    WHERE account_number IN (SELECT account_number FROM inserted) AND date_payment > GETDATE();

--    IF @schedule_breach > 0 
--    BEGIN
--        THROW 50000, 'Cannot grant new credit: client breaches the schedule of an active credit', 1;
--    END

--    -- 3. якщо він має діючий кредит, по якому сума залишку разом з нарахованими йому процентами менша, ніж сума кредиту, яку він хоче одержати;
--    SELECT @insufficient_balance = COUNT(*)
--    FROM Credit_contract
--    WHERE account_number IN (SELECT account_number FROM inserted) AND (amount + interest_rate * term / 365.0 * amount) < (SELECT amount FROM inserted);

--    IF @insufficient_balance > 0 
--    BEGIN
--        THROW 50000, 'Cannot grant new credit: insufficient balance in an active credit', 1;
--    END

--    -- 4. якщо за рейтингом він потрапляє у останню чверть рейтингового списку;
--    SELECT @bottom_quartile = COUNT(*)
--    FROM Client
--    WHERE rating <= (SELECT rating FROM Client WHERE account_number IN (SELECT account_number FROM inserted)) AND
--          rating IS NOT NULL;

--    IF @bottom_quartile > (SELECT COUNT(*) FROM Client WHERE rating IS NOT NULL) / 4 
--    BEGIN
--        THROW 50000, 'Cannot grant new credit: client is in the bottom quartile of the rating list', 1;
--    END
--END;

--CREATE TRIGGER UpdateClientRating
--ON Payment
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @total_credit FLOAT;
--    DECLARE @actual_paid_interest FLOAT;
--    DECLARE @actual_credit_term INT;
--    DECLARE @remaining_balance FLOAT;
--    DECLARE @contract_term INT;
--    DECLARE @days_ahead INT;
--    DECLARE @days_overdue INT;

--    SELECT @total_credit = SUM(amount)
--    FROM Credit_contract
--    JOIN inserted ON Credit_contract.account_number = inserted.account_number;

--    SELECT @actual_paid_interest = SUM(interest_rate * term / 365.0 * amount)
--    FROM Credit_contract
--    JOIN inserted ON Credit_contract.account_number = inserted.account_number;

--    SELECT @actual_credit_term = DATEDIFF(DAY, start_date, GETDATE())
--    FROM Credit_contract
--    JOIN inserted ON Credit_contract.account_number = inserted.account_number;

--    SELECT @remaining_balance = amount
--    FROM Credit_contract
--    JOIN inserted ON Credit_contract.account_number = inserted.account_number;

--    SELECT @contract_term = term
--    FROM Credit_contract
--    JOIN inserted ON Credit_contract.account_number = inserted.account_number;

--    SELECT @days_ahead = DATEDIFF(DAY, MIN(date_payment), GETDATE()),
--           @days_overdue = DATEDIFF(DAY, GETDATE(), MAX(date_payment))
--    FROM Repayment_schedules
--    JOIN Credit_contract ON Repayment_schedules.contract_number = Credit_contract.contract_number
--    WHERE account_number IN (SELECT account_number FROM inserted);

--    UPDATE Client
--    SET rating = (@total_credit + @actual_paid_interest) / @actual_credit_term - @remaining_balance / (@contract_term - @actual_credit_term) +
--                 EXP(-@days_ahead) - EXP(@days_overdue)
--    WHERE account_number IN (SELECT account_number FROM inserted);
--END;