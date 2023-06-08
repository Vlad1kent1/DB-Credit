INSERT INTO Client (account_number, name, tax_code, legal_address, actual_address, boss_name, rating)
VALUES (1, 'John Doe', '1234567890', '123 Main St', '456 Elm St', 'Jane Doe', 4.2),
(2, 'Jane Smith', '0987654321', '789 Oak St', '321 Maple St', 'John Smith', 3.8),
(3, 'Bob Johnson', '1357924680', '456 Birch St', '987 Pine St', 'Karen Johnson', 4.5);

INSERT INTO Credit_contract (contract_number, start_date, amount, term, interest_rate, repayment_schedule_type, collateral, account_number)
VALUES (1001, '2023-01-01', 5000, 12, 0.05, 'Monthly', 0, 1),
(1002, '2023-02-15', 10000, 24, 0.07, 'Biweekly', 2000, 1),
(1003, '2023-03-01', 7500, 18, 0.06, 'Weekly', 0, 2),
(1004, '2023-04-15', 15000, 36, 0.09, 'Monthly', 5000, 3);

INSERT INTO Repayment_schedules (contract_number, date_payment, repayment_amount, charge_amount)
VALUES (1001, '2023-01-15', 425.00, 75.00),
(1001, '2023-02-15', 425.00, 75.00),
(1001, '2023-03-15', 425.00, 75.00),
(1002, '2023-02-28', 825.00, 175.00),
(1002, '2023-03-14', 825.00, 175.00),
(1003, '2023-03-05', 437.50, 62.50),
(1003, '2023-03-12', 437.50, 62.50);

INSERT INTO Payment (payment_id, payment_amount, payment_date, account_number)
VALUES (1, 500, '2022-02-01', 1),
(2, 1000, '2022-03-01', 2),
(3, 750, '2022-04-01', 3),
(4, 1500, '2022-05-01', 1);

INSERT INTO Money_accounting (accounting_id, payment_id, contract_number)
VALUES (1, 1, 1001),
(2, 2, 1003),
(3, 3, 1004),
(4, 4, 1002);

INSERT INTO Rating (rating_id, account_number)
VALUES (1, 1),
(2, 2),
(3, 3);