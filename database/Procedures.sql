USE HomeSync
GO
CREATE PROCEDURE UserRegister
	@usertype VARCHAR(20), 
	@email VARCHAR(50), 
	@first_name VARCHAR(20),
	@last_name VARCHAR(20), 
	@birth_date DATE, 
	@password VARCHAR(10),
	@user_id INT OUTPUT
	AS
	BEGIN
		INSERT INTO Users(first_name, last_name, password, email, type, birthdate) 
		VALUES(@first_name, @last_name, @password, @email, @usertype, @birth_date)
		SELECT @user_id = user_id
		FROM Users
		WHERE email = @email AND password = @password
		IF(@usertype = 'Admin')
			INSERT INTO Admin(admin_id) VALUES(@user_id)
		ELSE
			INSERT INTO Guest(guest_id) VALUES(@user_id)
END
GO
CREATE PROCEDURE UserLogin
	@email VARCHAR(50), 
	@password VARCHAR(10),
	@success BIT OUTPUT,
	@user_id INT OUTPUT
	AS
	BEGIN
		SET @success = 0;
		SELECT @user_id = user_id FROM Users WHERE @email = email AND @password = password
		IF(@user_id IS NOT NULL)
			SET @success = 1
END
GO
CREATE PROCEDURE ViewProfile
	@user_id INT
	AS
	BEGIN
		SELECT *
		FROM Users
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE ViewRooms
	@age INT,
	@user_id INT
	AS
	BEGIN
		IF(@user_id IS NOT NULL AND @age IS NOT NULL)
			SELECT r.*
			FROM Users u INNER JOIN Room r ON u.room = r.room_id
			WHERE user_id = @user_id
			ORDER BY u.age
		ELSE IF(@age IS NULL)
			SELECT r.*
			FROM Users u INNER JOIN Room r ON u.room = r.room_id
			WHERE user_id = @user_id
		ELSE IF(@user_id IS NULL)
			SELECT *
			FROM Room
END
GO
CREATE PROCEDURE ViewMyTask
	@user_id INT
	AS 
	BEGIN
		UPDATE Tasks
		SET status = 'done'
		WHERE due_date <= CONVERT(DATETIME, CURRENT_TIMESTAMP)
		SELECT * 
		FROM TASKS
		WHERE creator = @user_id
END
GO
CREATE PROCEDURE FinishMyTask
	@user_id INT,
	@title VARCHAR(50)
	AS 
	BEGIN
		UPDATE Tasks
		SET status = 'done'
		WHERE creator = @user_id AND name = @title
END
GO
CREATE PROCEDURE ViewTask
	@user_id INT,
	@creator INT
	AS
	BEGIN
		SELECT t.*
		FROM Tasks t INNER JOIN Assigned_to a ON t.task_id = a.task_id
		WHERE a.user_id = @user_id AND a.admin_id = @creator
		ORDER BY creation_date DESC
END
GO
CREATE PROCEDURE ViewMyDeviceCharge
	@device_id INT,  
	@charge INT OUTPUT, 
	@location INT OUTPUT 
	AS 
	BEGIN
		SELECT @charge = battery_status ,@location = room
		FROM Device
		WHERE device_id = @device_id
END
GO
CREATE PROCEDURE AssignRoom
	@user_id INT,
	@room_id INT
	AS
	BEGIN
		UPDATE Users
		SET room = @room_id
		WHERE user_id = @user_id
END
GO 
CREATE PROCEDURE CreateEvent
	@user_id INT, 
	@name VARCHAR(50), 
	@description VARCHAR(200), 
	@location VARCHAR(40),
	@reminder_date DATETIME,
	@other_user_id INT
	AS
	BEGIN
		INSERT INTO Calender(user_assigned_to, name, description, location, reminder_date)
		VALUES(@user_id, @name, @description, @location, @reminder_date)
		INSERT INTO Calender(user_assigned_to, name, description, location, reminder_date)
		VALUES(@other_user_id, @name, @description, @location, @reminder_date)
END
GO
CREATE PROCEDURE AssignUser
	 @user_id INT, 
	 @event_id INT
	 AS
	 BEGIN
		UPDATE Calender
		SET user_assigned_to = @user_id
		WHERE event_id = @event_id
		SELECT * 
		FROM Calender
		WHERE user_assigned_to = @user_id AND event_id = @event_id
END
GO
CREATE PROCEDURE AddReminder
    @task_id INT,
    @reminder DATETIME
	AS
	BEGIN
		UPDATE Tasks
		SET reminder_date = @reminder
		WHERE task_id = @task_id
END
GO
CREATE PROCEDURE Uninvited
	@event_id INT, 
	@user_id INT
	AS
	BEGIN
		DELETE FROM Calender
		WHERE event_id = @event_id AND user_assigned_to = @user_id
END
GO 
CREATE PROCEDURE UpdateTaskDeadline 
	@deadline DATETIME, 
	@task_id INT
	AS
	BEGIN 
		UPDATE Tasks
		SET due_date = @deadline
		WHERE task_id = @task_id
END
GO 
CREATE PROCEDURE ViewEvent
	@user_id INT, 
	@event_id INT
	AS 
	BEGIN
		IF(EXISTS(SELECT * FROM Calender WHERE user_assigned_to = @user_id AND event_id = @event_id))
			SELECT *
			FROM Calender 
			WHERE user_assigned_to = @user_id AND event_id = @event_id
		ELSE
			SELECT *
			FROM Calender 
			WHERE user_assigned_to = @user_id
			ORDER BY reminder_date
END
GO
CREATE PROCEDURE ViewRecommendation
	AS
	BEGIN
		SELECT first_name, last_name 
		FROM Users
		WHERE user_id NOT IN (SELECT user_id FROM Recommendation)
END
GO 
CREATE PROCEDURE CreateNote
	@user_id INT, 
	@title VARCHAR(50), 
	@Content VARCHAR(500), 
	@creation_date DATETIME
	AS
	BEGIN 
		INSERT INTO Notes(user_id, title, content, creation_date) VALUES(@user_id, @title,@Content, @creation_date)
END
GO 
CREATE PROCEDURE ReceiveMoney
	@receiver_id INT, 
	@type VARCHAR(30), 
	@amount DECIMAL(13,2), 
	@description VARCHAR(10), 
	@date DATETIME
	AS
	BEGIN
		INSERT INTO Finance(user_id, type, amount, method, date, status) 
		VALUES(@receiver_id, @type, @amount, @description, @date, 'Incoming')
END
GO
CREATE PROCEDURE PlanPayment
	@sender_id INT, 
	@reciever_id INT, 
	@amount DECIMAL(13,2),
	@status VARCHAR(10),
	@deadline DATETIME
	AS
	BEGIN
		INSERT INTO Finance(user_id, type, amount,deadline, status) 
		VALUES(@sender_id, 'Outgoing', @amount, @deadline, @status)
		INSERT INTO Finance(user_id, type, amount,deadline, status) 
		VALUES(@reciever_id, 'Incoming', @amount, @deadline, @status)
END
GO
CREATE PROCEDURE SendMessage
	@sender_id INT, 
	@receiver_id INT, 
	@title VARCHAR(30), 
	@content VARCHAR(200), 
	@timesent TIME, 
	@timereceived TIME
	AS 
	BEGIN
		INSERT INTO Communication(sender_id, receiver_id, content, time_sent, time_received, title)
		VALUES (@sender_id, @receiver_id, @content, @timesent, @timereceived, @title)
END
GO
CREATE PROCEDURE NoteTitle
	@user_id INT, 
	@note_title VARCHAR(50)
	AS
	BEGIN
		UPDATE Notes
		SET title = @note_title
		WHERE user_id  = @user_id
END
GO 
CREATE PROCEDURE ShowMessages
	@user_id INT, 
	@sender_id INT
	AS
	BEGIN
		SELECT * 
		FROM Communication
		WHERE sender_id = @sender_id AND receiver_id = @user_id
END
GO
CREATE PROCEDURE ViewUsers
    @user_type VARCHAR(20)
	AS
	BEGIN
		IF(@user_type='Admin')
			BEGIN
				SELECT * FROM Admin a INNER JOIN Users U ON a.admin_id = u.user_id
			END
		ELSE IF(@user_type='Guest')
			BEGIN
				SELECT *
				FROM Guest g INNER JOIN Users U ON g.guest_id = u.user_id
			END
END
GO
CREATE PROCEDURE RemoveEvent
    @event_id INT,
    @user_id INT
	AS
	BEGIN
		DELETE FROM Calender
		WHERE event_id = @event_id AND user_assigned_to = @user_id
END
GO
CREATE PROCEDURE CreateSchedule
    @creator_id INT,
	@room_id INT,
    @start_time TIME,
    @end_time TIME,
    @action VARCHAR(20)
	AS
	BEGIN
		INSERT INTO RoomSchedule (creator_id, action, room, start_time, end_time)
		VALUES (@creator_id, @action, @room_id, @start_time, @end_time)
END
GO
CREATE PROCEDURE AdminAddTask
	@creator_id INT,
	@user_id1 INT,
	@user_id2 INT,
	@title VARCHAR(50), 
	@description VARCHAR(100),
	@creation_date DATE,
	@due_date DATE
	AS
	BEGIN
		INSERT INTO Tasks(creator, name, description, creation_date, due_date)
		VALUES(@creator_id, @title, @description, @creation_date, @due_date)
		DECLARE @task_id INT
		SELECT @task_id = SCOPE_IDENTITY()
		INSERT INTO Assigned_to(task_id, user_id, admin_id)
		VALUES(@task_id, @user_id1, @creator_id)
		INSERT INTO Assigned_to(task_id, user_id, admin_id)
		VALUES(@task_id, @user_id2, @creator_id)
END
GO
CREATE PROCEDURE AssignTask
	@creator_id INT,
	@task_id INT,
	@user_id INT
	AS
	BEGIN
		INSERT INTO Assigned_to(task_id, user_id, admin_id)
		VALUES(@task_id, @user_id, @creator_id)
END
GO
CREATE PROCEDURE OutOfBattery
	AS
	BEGIN
		SELECT room
		FROM Device
		WHERE battery_status = '0'
		GROUP BY room
END
GO
CREATE PROCEDURE NeedCharge
	AS
	BEGIN
		SELECT room
		FROM Device
		WHERE battery_status <= 10
		GROUP BY room
		HAVING COUNT(*) >= 2
END
GO
CREATE PROCEDURE Charging
	AS
	BEGIN
		UPDATE Device
		SET battery_status = 'Charging'
		WHERE battery_status = 0
END
GO
CREATE PROCEDURE Penalize
	@user_id INT, 
	@amount DECIMAL(10,2)
	AS 
	BEGIN
		INSERT INTO Finance(user_id, type, amount, status, date)
		VALUES(@user_id, 'Penalty', @amount, 'penalty', GETDATE())
END
GO
CREATE PROCEDURE ViewMeeting
	@user_id INT,
	@room_id INT
	AS
	BEGIN
		SELECT *
		FROM RoomSchedule
		WHERE creator_id = @user_id AND room = @room_id
END
GO
CREATE PROCEDURE ViewRoom
	AS
	BEGIN
		SELECT * 
		FROM Room
		WHERE room_id NOT IN (SELECT room FROM Log)
END
GO
CREATE PROCEDURE LogActivityDuration
	@start_time TIME,
	@end_time TIME,
	@room_id INT, 
	@device_id INT, 
	@user_id INT, 
	@duration INT 
	AS 
	BEGIN
		INSERT INTO Log(start_time, end_time, room, device, user_id, duration)
		VALUES (@start_time, @end_time, @room_id, @device_id, @user_id, @duration)
END
GO
CREATE PROCEDURE MakePreferencesRoomTemp
	@room_id INT
	AS
	BEGIN
		DECLARE @age INT
		SELECT @age = age
		FROM Users
		WHERE room = @room_id
		IF(@age >= 50)
			BEGIN
				INSERT INTO Preferences(preference, device)
				SELECT 'low temp', device_id
				FROM Device
				WHERE room = @room_id
END
GO
CREATE PROCEDURE UpdateLogEntry
	@user_id INT,
	@activity VARCHAR(20)
	AS
	BEGIN
		UPDATE Log
		SET activity = @activity
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE AddDevice
	@device_id INT,
	@device_type VARCHAR(20),
	@room INT,
	@user_id INT
	AS
	BEGIN
		INSERT INTO Device(device_id, device_type, room, user_id)
		VALUES (@device_id, @device_type, @room, @user_id)
END
GO
CREATE PROCEDURE Servailance
	@user_id INT
	AS
	BEGIN
		SELECT *
		FROM Servailance
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE RecommendTD
	@user_id INT
	AS
	BEGIN
		SELECT *
		FROM RecommendTD
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE ViewMyLogEntry
	@user_id INT
	AS
	BEGIN
		SELECT *
		FROM Log
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE UpdateFlight
	@user_id INT,
	@date_in DATE
	AS
	BEGIN
		UPDATE TravelItenerary
		SET incoming_flight_date = @date_in
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE AddItinerary
	@user_id INT,
	@flight_out DATE,
	@flight_in DATE
	AS
	BEGIN
		IF EXISTS (SELECT * FROM TravelItenerary WHERE user_id = @user_id)
			BEGIN
				UPDATE TravelItenerary
				SET outgoing_flight_date = @flight_out
				WHERE user_id = @user_id
END
GO
CREATE PROCEDURE ChangeFlight
	@user_id INT,
	@flight_out DATE
	AS
	BEGIN
		UPDATE TravelItenerary
		SET outgoing_flight_date = @flight_out
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE Purchase
	@user_id INT,
	@total_cost INT OUTPUT
	AS
	BEGIN
		SELECT @total_cost = SUM(price)
		FROM Inventory
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE Shopping
	@user_id INT,
	@total_price INT OUTPUT
	AS
	BEGIN
		SELECT @total_price = SUM(price)
		FROM Inventory
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE Sp_Inventory
	@item_id INT,
	@price INT,
	@item_name VARCHAR(20),
	@user_id INT
	AS
	BEGIN
		INSERT INTO Inventory(item_id, item_name, user_id, price)
		VALUES(@item_id, @item_name, @user_id, @price)
END
GO
CREATE PROCEDURE AveragePayement
	@SalaryAmount DECIMAL(13,2)
	AS
	BEGIN
		SELECT AVG(amount)
		FROM Finance f INNER JOIN Users U ON f.user_id = U.user_id
		WHERE amount >= @SalaryAmount
END
GO
CREATE PROCEDURE DeleteMsg
	AS
	BEGIN
		DELETE TOP(1)
		FROM Communication
END
GO
CREATE PROCEDURE GuestsAllowed
	@guest_allowed INT, 
	@user_id INT
	AS
	BEGIN
		UPDATE Admin
		SET guest_allowed = @guest_allowed
		WHERE admin_id = @user_id
END
GO
CREATE PROCEDURE AddGuest
	@user_id INT,
	@guest_id INT
	AS
	BEGIN
		INSERT INTO GuestOf (user_id, guest_id)
		VALUES (@user_id, @guest_id)
		UPDATE Admin
		SET guest_allowed = guest_allowed - 1
		WHERE admin_id = @user_id
END
GO
CREATE PROCEDURE GuestNumber
	@user_id INT, 
	@guest_count INT OUTPUT
	AS
	BEGIN
		SELECT @guest_count = COUNT(guest_id)
		FROM GuestOf
		WHERE user_id = @user_id
END
GO
CREATE PROCEDURE GuestRemove
	@user_id INT,
	@guest_id INT
	AS
	BEGIN
		DELETE
		FROM GuestOf
		WHERE user_id = @user_id AND guest_id = @guest_id
		UPDATE Admin
		SET guest_allowed = guest_allowed + 1
		WHERE admin_id = @user_id
END
GO
CREATE PROCEDURE Youngest
	@user_id INT
	AS
	BEGIN
		SELECT first_name, last_name
		FROM Users
		WHERE user_id = @user_id AND age = (SELECT MIN(age) FROM Users)
END
GO

GO
CREATE PROCEDURE AveragePayement
	@amount DECIMAL(10,2)

	AS 
	BEGIN
		SELECT user_id, first_name, last_name, AVG(a.salary) AS 'Average Salary'
		FROM Admin a INNER JOIN Users u ON a.admin_id = u.user_id
		GROUP BY user_id, first_name,last_name
		HAVING AVG(a.salary) > @amount
END

GO
CREATE PROCEDURE Purchase
	@sum INT OUTPUT

	AS
	BEGIN
		SET @sum = 0
		SELECT @sum = @sum + (price*quantity)
		FROM Inventory
END;

GO
CREATE PROCEDURE NeedCharge
	AS
	BEGIN
		SELECT room, COUNT(*) AS 'Number of dead devices'
		FROM Device 
		WHERE battery_status <= 0
		GROUP BY room
		HAVING COUNT(*) > 2
END


GO
CREATE PROCEDURE Admins
	AS
	BEGIN
		SELECT u.user_id, COUNT(g.guest_id) AS 'Number of Guests'
		FROM (Guest g INNER JOIN Admin a ON g.guest_of = a.admin_id) INNER JOIN Users u ON a.admin_id = u.user_id
		GROUP BY u.user_id
		HAVING COUNT(*) > 2
END

GO
CREATE TRIGGER delete_Room ON Room
	AFTER DELETE

	AS
	BEGIN
		DECLARE @roomId INT
		SELECT @roomId = room_id FROM deleted

		IF(EXISTS(SELECT * FROM Users WHERE room = @roomId))
			UPDATE Users
			SET room = NULL
			WHERE room = @roomId

		IF(EXISTS(SELECT * FROM Device WHERE room = @roomId))
			UPDATE Device
			SET room = NULL
			WHERE room = @roomId

		IF(EXISTS(SELECT * FROM RoomSchedule WHERE room = @roomId))
			DELETE FROM RoomSchedule WHERE room = @roomId

		IF(EXISTS(SELECT * FROM Log WHERE room_id = @roomId))
			DELETE FROM Log WHERE room_id = @roomId

		IF(EXISTS(SELECT * FROM Camera WHERE room_id = @roomId))
			DELETE FROM Camera WHERE room_id = @roomId
END

GO 
CREATE TRIGGER delete_User ON Users
	AFTER DELETE

	AS
	BEGIN
		DECLARE @userId INT
		SELECT @userId = user_id FROM deleted

		IF(EXISTS(SELECT * FROM Guest WHERE guest_id = @userId)) BEGIN
			DELETE FROM Guest WHERE guest_id = @userId
		END
		ELSE IF(EXISTS(SELECT * FROM Admin WHERE admin_id = @userId)) BEGIN
			DELETE FROM Admin WHERE admin_id = @userId

			IF(EXISTS(SELECT * FROM Guest WHERE guest_of = @userId))
				UPDATE Guest
				SET guest_of = NULL
				WHERE guest_of = @userId

			IF(EXISTS(SELECT * FROM Tasks WHERE creator = @userId))
				DELETE FROM Tasks WHERE creator = @userId

			IF(EXISTS(SELECT * FROM Assigned_to WHERE admin_id = @userId))
				DELETE FROM Assigned_to WHERE admin_id = @userId
		END

		IF(EXISTS(SELECT * FROM Assigned_to WHERE user_id = @userId))
			DELETE FROM Assigned_to WHERE user_id = @userId

		IF(EXISTS(SELECT * FROM Calender WHERE user_assigned_to = @userId))
			DELETE FROM Calender WHERE user_assigned_to = @userId

		IF(EXISTS(SELECT * FROM Notes WHERE user_id = @userId))
			DELETE FROM Notes WHERE user_id = @userId

		IF(EXISTS(SELECT * FROM User_trip WHERE user_id = @userId))
			DELETE FROM User_trip WHERE user_id = @userId

		IF(EXISTS(SELECT * FROM Finance WHERE user_id = @userId))
			DELETE FROM Finance WHERE user_id = @userId

		IF(EXISTS(SELECT * FROM Health WHERE user_id = @userId))
			DELETE FROM Health WHERE user_id = @userId

		IF(EXISTS(SELECT * FROM Communication WHERE sender_id = @userId OR receiver_id = @userId))
			DELETE FROM Communication WHERE sender_id = @userId OR receiver_id = @userId

		IF(EXISTS(SELECT * FROM RoomSchedule WHERE creator_id = @userId))
			DELETE FROM RoomSchedule WHERE creator_id = @userId

		IF(EXISTS(SELECT * FROM Log WHERE user_id = @userId))
			DELETE FROM Log WHERE user_id = @userId

		IF(EXISTS(SELECT * FROM Preferences WHERE user_id = @userId))
			DELETE FROM Preferences WHERE user_id = @userId

		IF(EXISTS(SELECT * FROM Recommendation WHERE user_id = @userId))
			DELETE FROM Recommendation WHERE user_id = @userId
END
