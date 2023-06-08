-- Step 1: Create users
CREATE LOGIN ClientUser WITH PASSWORD = 'ClientPassword';
CREATE USER ClientUser FOR LOGIN ClientUser;

CREATE LOGIN ManagerUser WITH PASSWORD = 'ManagerPassword';
CREATE USER ManagerUser FOR LOGIN ManagerUser;

CREATE LOGIN AuditorUser WITH PASSWORD = 'AuditorPassword';
CREATE USER AuditorUser FOR LOGIN AuditorUser;

CREATE LOGIN CashierUser WITH PASSWORD = 'CashierPassword';
CREATE USER CashierUser FOR LOGIN CashierUser;

-- Typical tasks:
-- ClientUser: Submit payments, Check balance
-- ManagerUser: Approve credit contracts, Update client information
-- AuditorUser: Review credit contracts, Review payment history

-- Step 2: Grant privileges
GRANT SELECT, INSERT ON Payment TO ClientUser;
GRANT SELECT ON Credit_contract TO ClientUser;
GRANT EXECUTE ON GetClientContracts TO ClientUser;
GRANT SELECT, UPDATE ON Client TO ManagerUser;
GRANT INSERT ON Credit_contract TO ManagerUser;
GRANT SELECT ON Credit_contract TO AuditorUser;
GRANT SELECT ON Payment TO AuditorUser;
GRANT INSERT ON Payment TO CashierUser;
GRANT SELECT, UPDATE ON Credit_contract TO CashierUser;

-- Step 3: Create roles
CREATE ROLE ClientRole;
CREATE ROLE ManagerRole;
CREATE ROLE AuditorRole;
CREATE ROLE CashierRole;

-- Typical tasks:
-- ClientRole: Submit payments, Check balance
-- ManagerRole: Approve credit contracts, Update client information
-- AuditorRole: Review credit contracts, Review payment history

-- Step 4: Grant privileges to roles
GRANT SELECT, INSERT ON Payment TO ClientRole;
GRANT SELECT ON Credit_contract TO ClientRole;
GRANT SELECT, UPDATE ON Client TO ManagerRole;
GRANT INSERT ON Credit_contract TO ManagerRole;
GRANT SELECT ON Credit_contract TO AuditorRole;
GRANT SELECT ON Payment TO AuditorRole;
GRANT INSERT ON Payment TO CashierRole;
GRANT SELECT, UPDATE ON Credit_contract TO CashierRole;

-- Step 5: Assign roles to users
EXEC sp_addrolemember 'ClientRole', 'ClientUser';
EXEC sp_addrolemember 'ManagerRole', 'ManagerUser';
EXEC sp_addrolemember 'AuditorRole', 'AuditorUser';
EXEC sp_addrolemember 'CashierRole', 'CashierUser';

-- Step 6: Revoke a privilege from a user that is also assigned through a role
REVOKE SELECT ON Payment FROM ClientUser;

-- At this point, ClientUser should still have the SELECT privilege on Payment through ClientRole

-- Step 7: Revoke a role from a user
EXEC sp_droprolemember 'ClientRole', 'ClientUser';

-- At this point, ClientUser should not have the SELECT privilege on Payment since it was revoked in step 6 and the role was revoked in this step.
-- ClientUser should still have the SELECT privilege on Credit_contract, which was granted to the user directly.

-- Step 8: Drop role and user
DROP ROLE ClientRole;
DROP USER ClientUser;