CREATE SCHEMA IF NOT EXISTS `ЗастахователнаКомпания`;
USE `ЗастахователнаКомпания` ;

CREATE TABLE IF NOT EXISTS `Автомобил` (
  `AutomobileId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CarRegistationNumber` VARCHAR(255) NOT NULL,
  `Марка` VARCHAR(255) NOT NULL,
  `Модел` VARCHAR(255) NOT NULL,
  `Гориво` VARCHAR(255) NOT NULL,
  `Година на производство` YEAR NOT NULL,
  `Кубатура на двигателя` INT NOT NULL,
  PRIMARY KEY (`AutomobileId`)
  );

CREATE TABLE IF NOT EXISTS `Застахователна Компания` (
  `InsuranceCompanyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Адрес на ценрала` VARCHAR(255) NOT NULL,
  `Град` BIGINT NOT NULL,
  `Телефонен номер на централа` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`InsuranceCompanyId`)
  );

CREATE TABLE IF NOT EXISTS `Клон на застрахователна компания` (
  `OfficeId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `InsuranceCompanyId` BIGINT UNSIGNED NOT NULL,
  `Адрес` BIGINT NOT NULL,
  `Град` BIGINT NOT NULL,
  `Телефонен номер на офис` BIGINT NOT NULL,
  PRIMARY KEY (`OfficeId`),
  CONSTRAINT `Клон на застрахователна компания_insurancecompanyid_foreign`
	FOREIGN KEY (`InsuranceCompanyId`) REFERENCES `Застрахователна Компания`(`InsuranceCompanyId`)
    );

CREATE TABLE IF NOT EXISTS `Застрахователен Агент` (
  `AgentId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `OfficeId` BIGINT UNSIGNED NOT NULL,
  `Име на агент` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`AgentId`),
  CONSTRAINT `Застрахователен агент_officeid_foreign`
    FOREIGN KEY (`OfficeId`) REFERENCES `Клон на застрахователна компания` (`OfficeId`)
    );


CREATE TABLE IF NOT EXISTS `Полица (застраховка автомобил)` (
  `PolicyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Тип на автозастраховката` ENUM('Катастрофа', 'Кражба', 'Пожар') NOT NULL,
  `Максимална покриваща сума при вина на сключилия` DOUBLE NOT NULL,
  `Максимална покриваща сума при потърпевшо лице` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`PolicyId`)
  );

CREATE TABLE IF NOT EXISTS `автомобилна полица - агент` (
  `PolicyId` BIGINT UNSIGNED NOT NULL,
  `AgentId` BIGINT UNSIGNED NOT NULL,
  CONSTRAINT `Автомобилна полица _ Агент_agentid_foreign`
    FOREIGN KEY (`AgentId`) REFERENCES `Застрахователен Агент` (`AgentId`),
  CONSTRAINT `Автомобилна полица _ Агент_policyid_foreign`
    FOREIGN KEY (`PolicyId`) REFERENCES `Полица (застраховка автомобил)` (`PolicyId`)
    );

CREATE TABLE IF NOT EXISTS `Клиент (физическо лице)` (
  `ClientId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Пол` ENUM('Мъж', 'Жена', 'Друго') NOT NULL,
  `Име` VARCHAR(255) NOT NULL,
  `Презиме` VARCHAR(255) NULL DEFAULT NULL,
  `Фамилия` VARCHAR(255) NOT NULL,
  `ЕГН/ЛНЧ` VARCHAR(255) NOT NULL,
  `Телефонен номер` BIGINT NOT NULL,
  `Адрес по лична карта` VARCHAR(255) NOT NULL,
  `Настоящ адрес` VARCHAR(255) NOT NULL,
  `Образование` VARCHAR(255) NULL DEFAULT NULL,
  `Месторабота` VARCHAR(255) NULL DEFAULT NULL,
  `Осигурителен доход` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ClientId`)
  );

CREATE TABLE IF NOT EXISTS `Шофьор` (
  `DriverId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `DriversLicenseNumber` VARCHAR(255) NOT NULL,
  `Пол` ENUM('Мъж', 'Жена', 'Друго') NOT NULL,
  `Име` VARCHAR(255) NOT NULL,
  `Презиме` VARCHAR(255) NULL DEFAULT NULL,
  `Фамилия` VARCHAR(255) NOT NULL,
  `Място на издаване на свидетелство за управление` BIGINT NOT NULL,
  `Дата на издаване на свидетелство за управление` BIGINT NOT NULL,
  PRIMARY KEY (`DriverId`)
  );

CREATE TABLE IF NOT EXISTS `Автомобилна полица - клиент` (
  `PolicyId` BIGINT UNSIGNED NOT NULL,
  `ClientId` BIGINT UNSIGNED NOT NULL,
  `AutomobileId` BIGINT UNSIGNED NOT NULL,
  `DriverId` BIGINT UNSIGNED NOT NULL,
  CONSTRAINT `Автомобилна полица _ Клиент_automobileid_foreign`
    FOREIGN KEY (`AutomobileId`) REFERENCES `Автомобил` (`AutomobileId`),
  CONSTRAINT `Автомобилна полица _ Клиент_clientid_foreign`
    FOREIGN KEY (`ClientId`) REFERENCES `Клиент (физическо лице)` (`ClientId`),
  CONSTRAINT `Автомобилна полица _ Клиент_driverid_foreign`
    FOREIGN KEY (`DriverId`) REFERENCES `Шофьор` (`DriverId`),
  CONSTRAINT `Автомобилна полица _ Клиент_policyid_foreign`
    FOREIGN KEY (`PolicyId`) REFERENCES `Полица (застраховка автомобил)` (`PolicyId`)
    );

CREATE TABLE IF NOT EXISTS `Агент - Клиент (физическо лице)` (
  `AgentId` BIGINT UNSIGNED NOT NULL,
  `ClientId` BIGINT UNSIGNED NOT NULL,
  CONSTRAINT `Агент _ Клиент (Физическо лице)_agentid_foreign`
    FOREIGN KEY (`AgentId`) REFERENCES `Застрахователен Агент` (`AgentId`),
  CONSTRAINT `Агент _ Клиент (Физическо лице)_clientid_foreign`
    FOREIGN KEY (`ClientId`) REFERENCES `Клиент (физическо лице)` (`ClientId`)
    );
    
CREATE TABLE IF NOT EXISTS `Личен лекар`(
    `GPId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Име` VARCHAR(255) NOT NULL,
    `Адрес` VARCHAR(255) NOT NULL,
    `Телефонен номер` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`GPId`)
);

CREATE TABLE IF NOT EXISTS `Полица (Застраховка живот и здраве)`(
    `PolicyId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Тип на застраховката` ENUM('Живот', 'Здравна') NOT NULL,
    `Максимална застраховка при инцидент` DOUBLE NOT NULL,
    `Максимална застраховка при смърт` DOUBLE NOT NULL,
    `Номер на медицински картон в НЗОК` VARCHAR(255) NOT NULL,
    `Пушач` BOOLEAN NOT NULL,
    PRIMARY KEY (`PolicyId`)
);

CREATE TABLE IF NOT EXISTS `Полица живот и здраве - клиент`(
    `PolicyId` BIGINT UNSIGNED NOT NULL,
    `ClientId` BIGINT UNSIGNED NOT NULL,
    `GPId` BIGINT UNSIGNED NOT NULL,
    `Отговорник за болния` BIGINT NULL,
  CONSTRAINT `Полица живот и здраве _ Клиент_GPId_Foreign`
    FOREIGN KEY (`GPId`) REFERENCES `Личен лекар` (`GPId`),
  CONSTRAINT `Полица живот и здраве _ Клиент_clientid_foreign`
    FOREIGN KEY (`ClientId`) REFERENCES `клиент (физическо лице)` (`ClientId`),
  CONSTRAINT `Полица живот и здраве _ Клиент_policyid_foreign`
    FOREIGN KEY (`PolicyId`) REFERENCES `Полица (Застраховка живот и здраве)` (`PolicyId`)
);

CREATE TABLE IF NOT EXISTS `Полица живот и здраве - Агент`(
    `PolicyId` BIGINT UNSIGNED NOT NULL,
    `AgentId` BIGINT UNSIGNED NOT NULL,
    CONSTRAINT `Полица живот и здраве _ Агент_agentid_foreign`
		FOREIGN KEY (`AgentId`) REFERENCES `застрахователен агент` (`AgentId`),
	CONSTRAINT `Полица живот и здраве _ Агент_policyid_foreign`
		FOREIGN KEY (`PolicyId`) REFERENCES `Полица (Застраховка живот и здраве)` (`PolicyId`)
);

CREATE TABLE IF NOT EXISTS `Извлечение` (
  `InvoiceId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PolicyId` BIGINT UNSIGNED NOT NULL,
  `Име на платилия` BIGINT NOT NULL,
  `Платена сума` BIGINT NOT NULL,
  `Дата на плащане` BIGINT NOT NULL,
  PRIMARY KEY (`InvoiceId`),
  CONSTRAINT `Извлечение_policyid_foreign_Life`
    FOREIGN KEY (`PolicyId`) REFERENCES `Полица (Застраховка живот и здраве)` (`PolicyId`),
  CONSTRAINT `Извлечение_policyid_foreign_Auto`
    FOREIGN KEY (`PolicyId`) REFERENCES `полица (застраховка автомобил)` (`PolicyId`));

CREATE TABLE IF NOT EXISTS `Оценителен експерт` (
  `ExpertId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Телефонен номер` BIGINT NOT NULL,
  `Адрес` BIGINT NOT NULL,
  `Град` BIGINT NOT NULL,
  PRIMARY KEY (`ExpertId`));

CREATE TABLE IF NOT EXISTS `Плащане` (
  `PaymentId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ClientId` BIGINT UNSIGNED NOT NULL,
  `InvoiceId` BIGINT UNSIGNED NOT NULL,
  `Платена сума` DOUBLE NOT NULL,
  `Дата на платената сума` DATETIME NOT NULL,
  `Начин на плащане` ENUM('В брой', 'С карта', 'Банков трансфер') NOT NULL,
  PRIMARY KEY (`PaymentId`),
  CONSTRAINT `Плащане_clientid_foreign`
    FOREIGN KEY (`ClientId`) REFERENCES `Клиент (физическо лице)` (`ClientId`),
  CONSTRAINT `Плащане_invoiceid_foreign`
    FOREIGN KEY (`InvoiceId`) REFERENCES `Извлечение` (`InvoiceId`));

CREATE TABLE IF NOT EXISTS `Сделка за застаховка` (
  `ClaimId` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PolicyId` BIGINT UNSIGNED NOT NULL,
  `Номер на полица` BIGINT NOT NULL,
  `Внесена сума` DOUBLE NOT NULL,
  `Дата на сключване` DATETIME NOT NULL,
  `Валидност (месеци))` BIGINT NOT NULL,
  `ExpertId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`ClaimId`),
  CONSTRAINT `Сделка за застаховка_expertid_foreign`
    FOREIGN KEY (`ExpertId`) REFERENCES `Оценителен експерт` (`ExpertId`),
  CONSTRAINT `Сделка за застаховка_policyid_foreignAuto`
    FOREIGN KEY (`PolicyId`) REFERENCES `Полица (застраховка автомобил)` (`PolicyId`),
  CONSTRAINT `Сделка за застаховка_policyid_foreignLife`
    FOREIGN KEY (`PolicyId`) REFERENCES `Полица (Застраховка живот и здраве)` (`PolicyId`));
