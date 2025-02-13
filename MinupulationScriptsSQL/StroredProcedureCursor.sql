DELIMITER //
CREATE PROCEDURE UpdateExpertCity()
BEGIN
	DECLARE Expert_Id BIGINT;
    DECLARE Phone_Number VARCHAR(255);
    DECLARE _Address VARCHAR(255);
    DECLARE _City VARCHAR(255);
    DECLARE _Done BOOLEAN DEFAULT FALSE;
    
    DECLARE Expert_Cursor CURSOR FOR
		SELECT ExpertId, PhoneNumber, Address, SUBSTRING_INDEX(TRIM(Address), ',', -1) 
		FROM expert;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET _Done = TRUE;
    
    OPEN Expert_Cursor;
    
    UPDATE_LOOP: LOOP
		FETCH Expert_Cursor 
        INTO Expert_Id, Phone_Number, _Address, _City;
        
        IF _Done THEN
			LEAVE UPDATE_LOOP;
		END IF;
        
        UPDATE Expert 
        SET City = _City
        WHERE ExpertId = Expert_Id AND
        City IS NULL;
        
	END LOOP;
    
    CLOSE Expert_Cursor;
    
END //
DELIMITER ;
CALL UpdateExpertCity();
SELECT * FROM Expert;
