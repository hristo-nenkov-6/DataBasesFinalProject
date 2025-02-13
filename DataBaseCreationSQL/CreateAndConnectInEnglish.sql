CREATE SCHEMA IF NOT EXISTS `InsuranceCompany`;
USE `InsuranceCompany`;

CREATE TABLE IF NOT EXISTS `Car` (
  `AutomobileId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CarRegistrationNumber` VARCHAR(255) NOT NULL,
  `Brand` VARCHAR(255) NOT NULL,
  `Model` VARCHAR(255) NOT NULL,
  `Fuel` VARCHAR(255) NOT NULL,
  `Year` YEAR NOT NULL,
  `EngineSize` INT NOT NULL,
  PRIMARY KEY (`AutomobileId`)
);

CREATE TABLE IF NOT EXISTS `InsuranceCompany` (
  `InsuranceCompanyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Address` VARCHAR(255) NOT NULL,
  `City` VARCHAR(255) NOT NULL,
  `CEOPhoneNumber` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`InsuranceCompanyId`)
);

CREATE TABLE IF NOT EXISTS `Office` (
  `OfficeId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `InsuranceCompanyId` BIGINT UNSIGNED NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  `City` VARCHAR(255) NOT NULL,
  `OfficePhoneNumber` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`OfficeId`),
  CONSTRAINT `InsuranceOffice_InsuranceCompanyId_Foreign`
    FOREIGN KEY (`InsuranceCompanyId`) REFERENCES `InsuranceCompany`(`InsuranceCompanyId`)
);

CREATE TABLE IF NOT EXISTS `InsuranceAgent` (
  `AgentId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `OfficeId` BIGINT UNSIGNED NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`AgentId`),
  CONSTRAINT `InsuranceAgent_OfficeId_Foreign`
    FOREIGN KEY (`OfficeId`) REFERENCES `Office`(`OfficeId`)
);

CREATE TABLE IF NOT EXISTS `CarPolicy` (
  `PolicyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `InsuranceType` ENUM('Crash', 'Theft', 'Fire') NOT NULL,
  `MaximumCoverage` DOUBLE NOT NULL,
  `MaximumCoverageAmountPerVictim` DECIMAL(8, 2) NOT NULL,
  PRIMARY KEY (`PolicyId`)
);

CREATE TABLE IF NOT EXISTS `CarPolicyAgent` (
  `PolicyId` BIGINT UNSIGNED NOT NULL,
  `AgentId` BIGINT UNSIGNED NOT NULL,
  CONSTRAINT `CarPolicyAgent_AgentId_Foreign`
    FOREIGN KEY (`AgentId`) REFERENCES `InsuranceAgent`(`AgentId`),
  CONSTRAINT `CarPolicyAgent_PolicyId_Foreign`
    FOREIGN KEY (`PolicyId`) REFERENCES `CarPolicy`(`PolicyId`)
);

CREATE TABLE IF NOT EXISTS `Client` (
  `ClientId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Gender` ENUM('Male', 'Female', 'Other') NOT NULL,
  `FirstName` VARCHAR(255) NOT NULL,
  `MiddleName` VARCHAR(255) NULL DEFAULT NULL,
  `LastName` VARCHAR(255) NOT NULL,
  `NationalIdentificationNumber` VARCHAR(255) NOT NULL,
  `PhoneNumber` VARCHAR(255) NOT NULL,
  `PersonalIDAddress` VARCHAR(255) NOT NULL,
  `CurrentAddress` VARCHAR(255) NOT NULL,
  `Education` VARCHAR(255) NULL DEFAULT NULL,
  `Workplace` VARCHAR(255) NULL DEFAULT NULL,
  `Income` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ClientId`)
);

CREATE TABLE IF NOT EXISTS `Driver` (
  `DriverId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `DriversLicenseNumber` VARCHAR(255) NOT NULL,
  `Gender` ENUM('Male', 'Female', 'Other') NOT NULL,
  `FirstName` VARCHAR(255) NOT NULL,
  `MiddleName` VARCHAR(255) NULL DEFAULT NULL,
  `LastName` VARCHAR(255) NOT NULL,
  `PlaceOfIssue` VARCHAR(255) NOT NULL,
  `LicenseIssueDate` DATE NOT NULL,
  PRIMARY KEY (`DriverId`)
);

CREATE TABLE IF NOT EXISTS `CarPolicyClient` (
  `PolicyId` BIGINT UNSIGNED NOT NULL,
  `ClientId` BIGINT UNSIGNED NOT NULL,
  `AutomobileId` BIGINT UNSIGNED NOT NULL,
  `DriverId` BIGINT UNSIGNED NOT NULL,
  CONSTRAINT `CarPolicyClient_AutomobileId_Foreign`
    FOREIGN KEY (`AutomobileId`) REFERENCES `Car`(`AutomobileId`),
  CONSTRAINT `CarPolicyClient_ClientId_Foreign`
    FOREIGN KEY (`ClientId`) REFERENCES `Client`(`ClientId`),
  CONSTRAINT `CarPolicyClient_DriverId_Foreign`
    FOREIGN KEY (`DriverId`) REFERENCES `Driver`(`DriverId`),
  CONSTRAINT `CarPolicyClient_PolicyId_Foreign`
    FOREIGN KEY (`PolicyId`) REFERENCES `CarPolicy`(`PolicyId`)
);

CREATE TABLE IF NOT EXISTS `AgentClient` (
  `AgentId` BIGINT UNSIGNED NOT NULL,
  `ClientId` BIGINT UNSIGNED NOT NULL,
  CONSTRAINT `AgentClient_AgentId_Foreign`
    FOREIGN KEY (`AgentId`) REFERENCES `InsuranceAgent`(`AgentId`),
  CONSTRAINT `AgentClient_ClientId_Foreign`
    FOREIGN KEY (`ClientId`) REFERENCES `Client`(`ClientId`)
);

CREATE TABLE IF NOT EXISTS `GeneralPractitioner` (
  `GPId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  `PhoneNumber` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`GPId`)
);

CREATE TABLE IF NOT EXISTS `LifeAndHealthInsurancePolicy` (
  `PolicyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `InsuranceType` ENUM('Life', 'Health') NOT NULL,
  `MaximumCoverageForAccident` DOUBLE NOT NULL,
  `MaximumCoverageForDeath` DOUBLE NOT NULL,
  `MedicalCardNumber` VARCHAR(255) NOT NULL,
  `Smoker` BOOLEAN NOT NULL,
  PRIMARY KEY (`PolicyId`)
);

CREATE TABLE IF NOT EXISTS LifeAndHealthInsurancePolicyClient (
    PolicyId BIGINT UNSIGNED NOT NULL,
    ClientId BIGINT UNSIGNED NOT NULL,
    GPId BIGINT UNSIGNED NOT NULL,
    ResponsibleForPatient BIGINT NULL,
    CONSTRAINT LifeAndHealthInsurancePolicyClient_GPId_Foreign
      FOREIGN KEY (GPId) REFERENCES GeneralPractitioner (GPId),
    CONSTRAINT LifeAndHealthInsurancePolicyClient_ClientId_Foreign
      FOREIGN KEY (ClientId) REFERENCES Client (ClientId),
    CONSTRAINT LifeAndHealthInsurancePolicyClient_PolicyId_Foreign
      FOREIGN KEY (PolicyId) REFERENCES LifeAndHealthInsurancePolicy (PolicyId)
);

CREATE TABLE IF NOT EXISTS LifeAndHealthInsurancePolicyAgent (
    PolicyId BIGINT UNSIGNED NOT NULL,
    AgentId BIGINT UNSIGNED NOT NULL,
    CONSTRAINT LifeAndHealthInsurancePolicyAgent_AgentId_Foreign
      FOREIGN KEY (AgentId) REFERENCES InsuranceAgent (AgentId),
    CONSTRAINT LifeAndHealthInsurancePolicyAgent_PolicyId_Foreign
      FOREIGN KEY (PolicyId) REFERENCES LifeAndHealthInsurancePolicy (PolicyId)
);

CREATE TABLE IF NOT EXISTS Invoice (
  InvoiceId BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PolicyId BIGINT UNSIGNED NOT NULL,
  PayerName VARCHAR(255) NOT NULL,
  AmountPaid DOUBLE NOT NULL,
  PaymentDate DATETIME NOT NULL,
  PRIMARY KEY (InvoiceId),
  CONSTRAINT Invoice_PolicyId_Foreign_Life
    FOREIGN KEY (PolicyId) REFERENCES LifeAndHealthInsurancePolicy (PolicyId),
  CONSTRAINT Invoice_PolicyId_Foreign_Auto
    FOREIGN KEY (PolicyId) REFERENCES CarPolicy (PolicyId)
);

CREATE TABLE IF NOT EXISTS Expert (
  ExpertId BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PhoneNumber VARCHAR(255) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  City VARCHAR(255) NOT NULL,
  PRIMARY KEY (ExpertId)
);

CREATE TABLE IF NOT EXISTS Payment (
  PaymentId BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  ClientId BIGINT UNSIGNED NOT NULL,
  InvoiceId BIGINT UNSIGNED NOT NULL,
  AmountPaid DOUBLE NOT NULL,
  PaymentDate DATETIME NOT NULL,
  PaymentMethod ENUM('Cash', 'Credit', 'BankTransfer') NOT NULL,
  PRIMARY KEY (PaymentId),
  CONSTRAINT Payment_ClientId_Foreign
    FOREIGN KEY (ClientId) REFERENCES Client (ClientId),
  CONSTRAINT Payment_InvoiceId_Foreign
    FOREIGN KEY (InvoiceId) REFERENCES Invoice (InvoiceId)
);

CREATE TABLE IF NOT EXISTS InsuranceClaim (
  ClaimId BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PolicyId BIGINT UNSIGNED NOT NULL,
  PolicyNumber VARCHAR(255) NOT NULL,
  AmountDeposited DOUBLE NOT NULL,
  ClaimDate DATETIME NOT NULL,
  ValidityMonths INT NOT NULL,
  ExpertId BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (ClaimId),
  CONSTRAINT InsuranceClaim_ExpertId_Foreign
    FOREIGN KEY (ExpertId) REFERENCES Expert (ExpertId),
  CONSTRAINT InsuranceClaim_PolicyId_Foreign_Auto
    FOREIGN KEY (PolicyId) REFERENCES CarPolicy (PolicyId),
  CONSTRAINT InsuranceClaim_PolicyId_Foreign_Life
    FOREIGN KEY (PolicyId) REFERENCES LifeAndHealthInsurancePolicy (PolicyId)
);
