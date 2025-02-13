CREATE TABLE car_log(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    CarId INT,
    ActionMade VARCHAR(50)
);

DELIMITER //
CREATE TRIGGER after_car_insert
AFTER INSERT ON car
FOR EACH ROW
BEGIN
	INSERT INTO car_log(CarId, ActionMade)
	VALUES (NEW.AutomobileId, 'Inserted new car');
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER after_car_delete
AFTER DELETE ON car
FOR EACH ROW
BEGIN
	INSERT INTO car_log(CarId, ActionMade)
	VALUES (OLD.AutomobileId, 'Deleted car');
END //

DELIMITER ;

DROP TRIGGER after_car_delete;

INSERT INTO `Car` (`CarRegistrationNumber`, `Brand`, `Model`, `Fuel`, `Year`, `EngineSize`) VALUES
('ABC123', 'Toyota', 'Corolla', 'Petrol', 2018, 1600),
('DEF456', 'Honda', 'Civic', 'Petrol', 2019, 1800),
('GHI789', 'Ford', 'Focus', 'Diesel', 2020, 2000),
('JKL012', 'BMW', 'X5', 'Petrol', 2021, 3000);

select * FROM car_log;

DELETE FROM car WHERE AutomobileId = 40;

SELECT * FROM car_log;
