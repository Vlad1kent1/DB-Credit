USE credits
CREATE TABLE Client (
  account_number INT PRIMARY KEY NOT NULL,
  name VARCHAR(100) NOT NULL,
  tax_code VARCHAR(20) NOT NULL,
  legal_address VARCHAR(100) NOT NULL,
  actual_address VARCHAR(100) NOT NULL,
  boss_name VARCHAR(100) NOT NULL,
  rating FLOAT NOT NULL
);

CREATE TABLE Credit_contract (
  contract_number INT PRIMARY KEY NOT NULL,
  start_date DATE NOT NULL,
  amount FLOAT NOT NULL,
  term INT NOT NULL,
  interest_rate FLOAT NOT NULL,
  repayment_schedule_type VARCHAR(50) NOT NULL,
  collateral FLOAT NOT NULL,
  account_number INT NOT NULL,
  FOREIGN KEY (account_number) REFERENCES Client(account_number)
);

CREATE TABLE Repayment_schedules (
  schedule_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  contract_number INT NOT NULL,
  date_payment DATE NOT NULL,
  repayment_amount FLOAT NOT NULL,
  charge_amount FLOAT NOT NULL,
  FOREIGN KEY (contract_number) REFERENCES Credit_contract(contract_number)
);

CREATE TABLE Payment (
  payment_id INT PRIMARY KEY NOT NULL,
  payment_amount FLOAT NOT NULL,
  payment_date DATE NOT NULL,
  account_number INT NOT NULL,
  FOREIGN KEY (account_number) REFERENCES Client(account_number)
);

CREATE TABLE Money_accounting (
  accounting_id INT PRIMARY KEY NOT NULL,
  payment_id INT NOT NULL,
  contract_number INT NOT NULL,
  FOREIGN KEY (payment_id) REFERENCES Payment(payment_id),
  FOREIGN KEY (contract_number) REFERENCES Credit_contract(contract_number)
);

CREATE TABLE Rating (
  rating_id INT PRIMARY KEY NOT NULL,
  account_number INT NOT NULL,
  FOREIGN KEY (account_number) REFERENCES Client(account_number)
);