/*DROP TABLE Rating, Money_accounting, Repayment_schedules, Payment, Credit_contract, Client*/
/*DELETE FROM Rating
DELETE FROM Money_accounting
DELETE FROM Repayment_schedules
DELETE FROM Payment
DELETE FROM Credit_contract
DELETE FROM Client*/
--EXEC CalculateInterestForAllClients ;
--EXEC CalculateInterestForClient 123456;
--SELECT * FROM Repayment_schedules, Credit_contract;

INSERT INTO Credit_contract (contract_number, start_date, amount, term, interest_rate, repayment_schedule_type, collateral, account_number) 
VALUES (12345, '2023-05-23', 5000.0, 365, 0.1, 'monthly', 5000.0, 1);