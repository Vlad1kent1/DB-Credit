/* Рейтинг більше 4 та юридична або фактична адреса буде Київ */
SELECT * FROM Client
WHERE rating > 4 AND (legal_address LIKE '%Kyiv%' OR actual_address LIKE '%Kyiv%')
ORDER BY rating DESC;

/* Кредитні договори, які були укладені в даний період*/
SELECT c.name, cc.amount, cc.interest_rate, (cc.amount * cc.interest_rate / 100) AS interest_amount
FROM Client c
JOIN Credit_contract cc ON c.account_number = cc.account_number
WHERE cc.start_date >= '2022-01-01' AND cc.start_date <= '2022-12-31'
ORDER BY c.name ASC;

/* Рейтинг більше 4 та мають платежі в даний період*/
SELECT c.name, cc.amount, cc.term, r.repayment_amount
FROM Client c
JOIN Credit_contract cc ON c.account_number = cc.account_number
JOIN Repayment_schedules r ON cc.contract_number = r.contract_number
WHERE c.rating >= 4 AND (r.date_payment BETWEEN '2022-01-01' AND '2022-06-30' OR r.date_payment BETWEEN '2022-10-01' AND '2022-12-31')
ORDER BY c.name ASC;

/* Сума кредиту більше 5000*/
SELECT Client.name, Credit_contract.amount
FROM Client 
INNER JOIN Credit_contract ON Client.account_number = Credit_contract.account_number
WHERE Credit_contract.amount > 5000;

/* Сума кредиту від 5000 до 10000 та імя клієнта John, , застава становить 10 000, 15 000 або 20 000, існує принаймні один графік погашення для контракту, а відсоткова ставка є більшою, ніж відсоткова ставка за всіма іншими договорами для того самого клієнта.*/
SELECT Client.name, Credit_contract.amount
FROM Client INNER JOIN Credit_contract
ON Client.account_number = Credit_contract.account_number
WHERE Credit_contract.amount BETWEEN 5000 AND 10000
AND Credit_contract.collateral IN (10000, 15000, 20000)
AND EXISTS (SELECT * FROM Repayment_schedules WHERE contract_number = Credit_contract.contract_number)
AND Credit_contract.interest_rate > ALL (SELECT interest_rate FROM Credit_contract WHERE account_number = Client.account_number);

/* Загальна сума погашення перевищуж 5000*/
SELECT Client.name, SUM(Repayment_schedules.repayment_amount) AS total_repayment
FROM Client INNER JOIN Credit_contract
ON Client.account_number = Credit_contract.account_number
INNER JOIN Repayment_schedules
ON Credit_contract.contract_number = Repayment_schedules.contract_number
GROUP BY Client.name
HAVING SUM(Repayment_schedules.repayment_amount) > 5000;

/*Cума кредиту перевищує середню суму всіх кредитних договорів, а термін менше мінімального терміну для того самого клієнта.*/
SELECT Client.name, Credit_contract.amount
FROM Client INNER JOIN Credit_contract
ON Client.account_number = Credit_contract.account_number
WHERE Credit_contract.amount > (SELECT AVG(amount) FROM Credit_contract)
AND Credit_contract.term < (SELECT MIN(term) FROM Credit_contract WHERE account_number = Client.account_number);

/* Загальний платіж перевищує середній загальний платіж для всіх клієнтів */
SELECT Client.name, subquery.total_payment
FROM Client INNER JOIN
(SELECT account_number, SUM(payment_amount) AS total_payment
FROM Payment GROUP BY account_number) subquery
ON Client.account_number = subquery.account_number
WHERE subquery.total_payment > (SELECT AVG(total_payment) FROM
(SELECT SUM(payment_amount) AS total_payment FROM Payment GROUP BY account_number) AS subquery2);

/* Відображення загальної суми погашення та стягнення за кожним кредитним договором на основі графіка погашення.*/
SELECT cc.contract_number, cc.start_date, cc.amount,
       SUM(CASE WHEN rs.repayment_amount IS NOT NULL THEN rs.repayment_amount ELSE 0 END) AS total_repayment,
       SUM(CASE WHEN rs.charge_amount IS NOT NULL THEN rs.charge_amount ELSE 0 END) AS total_charge
FROM Credit_contract cc
LEFT JOIN Repayment_schedules rs ON cc.contract_number = rs.contract_number
GROUP BY cc.contract_number, cc.start_date, cc.amount
ORDER BY cc.contract_number;

/* Оновлює рейтинг клієнта з номером рахунку 12345 на 4.5.*/
UPDATE Client
SET rating = 4.5
WHERE account_number = 12345;

/* Оновлює річну ставку для всіх кредитних договорів, які належать клієнту з податковим кодом '1234567890' на 5.5.*/
UPDATE Credit_contract
SET interest_rate = 5.5
FROM Client
WHERE Credit_contract.account_number = Client.account_number
AND Client.tax_code = '1234567890';

/**/
INSERT INTO Client (account_number, name, tax_code, legal_address, actual_address, boss_name, rating)
VALUES (123, 'John Doe', '0987654321', '123 Main St', '456 Elm St', 'Jane Doe', 4.2);

/**/
INSERT INTO Repayment_schedules (schedule_id, contract_number, date_payment, repayment_amount, charge_amount)
SELECT 1, contract_number, '2023-05-01', 1000, 50
FROM Credit_contract
WHERE account_number = 12345;

/**/
DELETE FROM Payment;

/**/
DELETE FROM Client
WHERE tax_code = '1234567890';
